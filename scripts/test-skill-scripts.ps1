#requires -Version 7
<#
.SYNOPSIS
    Tests for the deterministic PowerShell helpers that ship inside skills.

.DESCRIPTION
    Builds fixture inputs in a temp directory and runs each helper against them:

    1. project-hub-scaffold/scripts/scaffold-hub.ps1 against a fake project-hub
       checkout: adds a workspace, writes its hub.config.json, refuses a duplicate
       name or directory, rejects bad parameter mixes, and lays down a standalone
       install with its server config and .gitignore.
    2. cronsole-windows-jobs/scripts/Invoke-ScheduledJob.ps1 against fixture jobs:
       an ok run, a warnOn match (attention), a non-zero exit (failed), the
       transcript, the JSON payload piped to the notifier, and -WhatIfChild.
    3. Windows only: Register-ScheduledJob.ps1 -WhatIf (never registers a task) and
       run-hidden.vbs passing a script's exit code back through cscript.

    The Python helper (recipe-validator) is covered by scripts/test-skill-scripts.py.
    Touches nothing outside the temp directory. Exits 1 on the first failed
    assertion. CI runs it in validate.yml.

.EXAMPLE
    pwsh -NoProfile -File scripts/test-skill-scripts.ps1
#>
$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent $PSScriptRoot
$Scaffold = Join-Path $RepoRoot 'skills/core/web/project-hub-scaffold/scripts/scaffold-hub.ps1'
$JobsDir  = Join-Path $RepoRoot 'skills/projects/cronsole/cronsole-windows-jobs/scripts'
$Tmp      = Join-Path ([IO.Path]::GetTempPath()) "skill-scripts-test-$([guid]::NewGuid().ToString('N'))"

function Assert([bool] $Condition, [string] $Message) {
    if (-not $Condition) { throw "FAIL: $Message" }
    Write-Host "ok   $Message"
}

# Runs a script block and returns the error message it threw, or $null.
function Get-Thrown([scriptblock] $Block) {
    try { & $Block *> $null; return $null } catch { return $_.Exception.Message }
}

function New-File([string] $Path, [string] $Value = '') {
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Path) | Out-Null
    Set-Content -LiteralPath $Path -Value $Value
}

try {
    New-Item -ItemType Directory -Path $Tmp | Out-Null

    # --- 1. scaffold-hub.ps1 -------------------------------------------------
    $hub = Join-Path $Tmp 'project-hub'
    New-File (Join-Path $hub 'hub/hub.mjs')
    New-File (Join-Path $hub 'project-hub/Start-Hub.ps1')
    $ws1 = Join-Path $Tmp 'workspace-one'; $ws2 = Join-Path $Tmp 'workspace-two'
    New-Item -ItemType Directory -Path $ws1, $ws2 | Out-Null

    $err = Get-Thrown { & $Scaffold -Name Docs -Dir $ws1 -HubDesignRoot $hub }
    Assert ($err -match 'Configure project-hub/hub.config.json first') 'scaffold: refuses a hub with no server config'

    New-File (Join-Path $hub 'project-hub/hub.config.json') '{}'
    & $Scaffold -Name Docs -Dir $ws1 -HubDesignRoot $hub -RepoScopePathPrefix 'docs\guides' *> $null
    $cfgFile = Join-Path $hub 'projects/Docs/hub.config.json'
    Assert (Test-Path $cfgFile) 'scaffold: writes projects/<Name>/hub.config.json'
    $cfg = Get-Content $cfgFile -Raw | ConvertFrom-Json
    $wsPath = (Resolve-Path $ws1).Path.Replace('\', '/')
    Assert ($cfg.name -eq 'Docs' -and $cfg.dir -eq $wsPath) 'scaffold: config holds the name and a forward-slash dir'
    Assert ($cfg.repoScope.pathPrefix -eq 'docs/guides/') 'scaffold: pathPrefix is normalized to forward slashes and a trailing /'
    Assert ([IO.File]::ReadAllBytes($cfgFile)[0] -ne 0xEF) 'scaffold: config is written without a BOM'

    $err = Get-Thrown { & $Scaffold -Name Docs -Dir $ws2 -HubDesignRoot $hub }
    Assert ($err -match 'Project destination already exists') 'scaffold: refuses a name that is already a project folder'
    $err = Get-Thrown { & $Scaffold -Name Other -Dir $ws1 -HubDesignRoot $hub }
    Assert ($err -match 'already mounted') 'scaffold: refuses a directory another workspace already mounts'
    $err = Get-Thrown { & $Scaffold -Name Both -Dir $ws2 -HubDesignRoot $hub -RepoScopeGroups a -RepoScopePathPrefix b }
    Assert ($err -match 'not both') 'scaffold: refuses groups and pathPrefix together'
    $err = Get-Thrown { & $Scaffold -Name PortOnly -Dir $ws2 -HubDesignRoot $hub -Port 5000 }
    Assert ($err -match 'applies only to -Standalone') 'scaffold: refuses standalone-only parameters without -Standalone'
    $err = Get-Thrown { & $Scaffold -Name '../escape' -Dir $ws2 -HubDesignRoot $hub }
    Assert ($null -ne $err -and -not (Test-Path (Join-Path $hub 'escape'))) 'scaffold: refuses a name that is not a plain identifier'
    $err = Get-Thrown { & $Scaffold -Name Gone -Dir (Join-Path $Tmp 'missing') -HubDesignRoot $hub }
    Assert ($err -match 'Workspace directory does not exist') 'scaffold: refuses a missing workspace directory'

    & $Scaffold -Name Groups -Dir $ws2 -HubDesignRoot $hub -RepoScopeGroups 'Tools', 'Apps' *> $null
    $groups = (Get-Content (Join-Path $hub 'projects/Groups/hub.config.json') -Raw | ConvertFrom-Json).repoScope.groups
    Assert (($groups -join ',') -eq 'Tools,Apps') 'scaffold: repoScope groups are written in order'

    # Standalone: every engine file must exist in the source.
    $engine = 'hub.mjs', 'index.html', 'navigation.mjs', 'open-native.mjs', 'pictures.mjs', 'pictures-client.mjs',
        'reports.mjs', 'webmarks.mjs', 'favorites.mjs', 'hub.test.mjs', 'pictures.test.mjs', 'reports.test.mjs',
        'webmarks.test.mjs', 'favorites.test.mjs', 'package.json', 'Start-Hub.ps1', 'Watch-Hubs.ps1', 'run-watchdog-hidden.vbs'
    $target = Join-Path $Tmp 'standalone'
    $err = Get-Thrown { & $Scaffold -Name Solo -Dir $ws1 -HubDesignRoot $hub -Standalone -TargetDir $target -Base $Tmp }
    Assert ($err -match 'Missing source: hub/') 'scaffold: standalone refuses a source missing engine files'
    foreach ($f in $engine) { New-File (Join-Path $hub "hub/$f") $f }
    foreach ($f in 'LICENSE', 'project-hub/hub.config.example.json', 'projects/_example/hub.config.json.example') { New-File (Join-Path $hub $f) }

    $err = Get-Thrown { & $Scaffold -Name Solo -Dir $ws1 -HubDesignRoot $hub -Standalone }
    Assert ($err -match 'requires -TargetDir and -Base') 'scaffold: standalone requires -TargetDir and -Base'
    & $Scaffold -Name Solo -Dir $ws1 -HubDesignRoot $hub -Standalone -TargetDir $target -Base $Tmp -Port 4999 -Title 'Test Hub' *> $null
    $copied = @($engine | Where-Object { Test-Path (Join-Path $target "hub/$_") })
    Assert ($copied.Count -eq $engine.Count) "scaffold: standalone copies all $($engine.Count) engine files"
    $server = Get-Content (Join-Path $target 'project-hub/hub.config.json') -Raw | ConvertFrom-Json
    Assert ($server.port -eq 4999 -and $server.title -eq 'Test Hub' -and $server.base -eq (Resolve-Path $Tmp).Path.Replace('\', '/').TrimEnd('/')) 'scaffold: standalone server config carries port, title and base'
    Assert (Test-Path (Join-Path $target 'projects/Solo/hub.config.json')) 'scaffold: standalone mounts the workspace'
    Assert ((Get-Content (Join-Path $target '.gitignore')) -contains 'hub.config.json') 'scaffold: standalone .gitignore keeps the local config out of git'
    $err = Get-Thrown { & $Scaffold -Name Again -Dir $ws2 -HubDesignRoot $hub -Standalone -TargetDir $target -Base $Tmp }
    Assert ($err -match 'Standalone destination already exists') 'scaffold: standalone refuses an existing destination'

    # --- 2. Invoke-ScheduledJob.ps1 -------------------------------------------
    # Run in a child pwsh: the wrapper ends with `exit <code>`, which would end this test.
    $runner   = Join-Path $JobsDir 'Invoke-ScheduledJob.ps1'
    $jobsRoot = Join-Path $Tmp 'jobs'
    $notifier = Join-Path $Tmp 'notify.ps1'
    New-File $notifier 'Set-Content -LiteralPath $args[0] -Value ([Console]::In.ReadToEnd())'

    function New-Job([string] $Name, [string] $Body, [hashtable] $Extra = @{}) {
        $dir = Join-Path $jobsRoot $Name
        $script = Join-Path $dir 'job.ps1'
        New-File $script $Body
        $payloadFile = Join-Path $dir 'payload.json'
        $cfg = @{ script = $script; shell = 'pwsh'
            notify = @{ command = 'pwsh'; arguments = "-NoProfile -File $notifier $payloadFile"; notifyOn = @('ok', 'attention', 'failed') } }
        foreach ($k in $Extra.Keys) { $cfg[$k] = $Extra[$k] }
        $cfg | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $dir 'job.json')
        return $payloadFile
    }
    function Invoke-Job([string] $Name, [string[]] $More = @()) {
        $out = & pwsh -NoProfile -File $runner -Job $Name -JobsRoot $jobsRoot @More 2>&1
        return [pscustomobject]@{ Code = $LASTEXITCODE; Output = ($out -join "`n") }
    }

    $okPayload = New-Job 'ok-job' "Write-Output 'Freed 12 GB'`nexit 0" @{ report = @('^Freed') }
    $r = Invoke-Job 'ok-job'
    $p = Get-Content $okPayload -Raw | ConvertFrom-Json
    Assert ($r.Code -eq 0 -and $p.status -eq 'ok') 'jobs: a clean exit is ok and exits 0'
    Assert ($p.report -contains 'Freed 12 GB') 'jobs: report patterns pick lines into the payload'
    $log = Get-ChildItem (Join-Path $jobsRoot 'ok-job/logs') -Filter '*.log' | Select-Object -First 1
    $logText = if ($log) { Get-Content $log.FullName -Raw } else { '' }
    Assert ($logText -match 'exit code:\s+0' -and $logText -match 'Freed 12 GB') 'jobs: the transcript holds the header and the output'
    Assert ($p.logFile -eq $log.FullName) 'jobs: the payload points at the transcript'

    $warnPayload = New-Job 'warn-job' "Write-Output 'WARNING: disk low'`nexit 0" @{ warnOn = @('^WARNING') }
    $r = Invoke-Job 'warn-job'
    $p = Get-Content $warnPayload -Raw | ConvertFrom-Json
    Assert ($r.Code -eq 0 -and $p.status -eq 'attention') 'jobs: a warnOn match on a clean exit is attention'
    Assert ($p.subject -like '`[CHECK`]*1 warning(s)' -and $p.warnings -contains 'WARNING: disk low') 'jobs: attention subject and warnings list'

    $failPayload = New-Job 'fail-job' "Write-Output 'WARNING: also this'`nexit 3" @{ warnOn = @('^WARNING') }
    $r = Invoke-Job 'fail-job'
    $p = Get-Content $failPayload -Raw | ConvertFrom-Json
    Assert ($r.Code -eq 3 -and $p.status -eq 'failed' -and $p.exitCode -eq 3) 'jobs: a non-zero exit is failed and passes the code through'
    Assert ($p.subject -like '`[FAIL`]*exit code 3') 'jobs: failed subject names the exit code'

    $quietPayload = Join-Path $jobsRoot 'quiet-job/payload.json'
    $null = New-Job 'quiet-job' 'exit 0' @{ notify = @{ command = 'pwsh'; arguments = "-NoProfile -File $notifier $quietPayload" } }
    $r = Invoke-Job 'quiet-job'
    Assert ($r.Code -eq 0 -and -not (Test-Path $quietPayload)) 'jobs: by default an ok run does not notify'

    $whatIfPayload = New-Job 'whatif-job' "New-Item -ItemType File -Path '$(Join-Path $Tmp 'ran.txt')'"
    $r = Invoke-Job 'whatif-job' @('-WhatIfChild')
    Assert ($r.Output -match 'Would run: pwsh' -and -not (Test-Path (Join-Path $Tmp 'ran.txt')) -and -not (Test-Path $whatIfPayload)) 'jobs: -WhatIfChild prints the command and runs nothing'

    $r = Invoke-Job 'no-such-job'
    Assert ($r.Code -ne 0 -and $r.Output -match 'No job.json') 'jobs: a missing job.json fails loudly'

    # --- 3. Windows-only helpers -----------------------------------------------
    if ($IsWindows) {
        $register = Join-Path $JobsDir 'Register-ScheduledJob.ps1'
        $regDir = Join-Path $jobsRoot 'reg-job'
        New-Item -ItemType Directory -Force -Path $regDir | Out-Null
        $regCfg = Join-Path $regDir 'job.json'

        @{ taskName = 'Test Job'; taskPath = '\SkillTests'; schedule = @{ dayOfWeek = 'Sunday'; at = '03:00' } } |
            ConvertTo-Json | Set-Content $regCfg
        $out = & $register -Job 'reg-job' -JobsRoot $jobsRoot -WhatIf 6>&1 | Out-String
        Assert ($out -match 'Would register: \\SkillTests\\Test Job' -and $out -match 'Invoke-ScheduledJob\.ps1') 'register: -WhatIf names the task and points it at the runner'
        Assert ($out -match 'runLevel: Limited') 'register: runLevel defaults to Limited'
        Assert ($null -eq (Get-ScheduledTask -TaskPath '\SkillTests\' -ErrorAction SilentlyContinue)) 'register: -WhatIf registers nothing'

        @{ taskName = 'Bad'; taskPath = '\Microsoft\Windows'; schedule = @{ daily = $true; at = '07:00' } } | ConvertTo-Json | Set-Content $regCfg
        $err = Get-Thrown { & $register -Job 'reg-job' -JobsRoot $jobsRoot -WhatIf }
        Assert ($err -match 'Refusing to register under \\Microsoft\\') 'register: refuses a task path under \Microsoft\'

        @{ taskName = 'Bad'; schedule = @{ monthly = $true } } | ConvertTo-Json | Set-Content $regCfg
        $err = Get-Thrown { & $register -Job 'reg-job' -JobsRoot $jobsRoot -WhatIf }
        Assert ($err -match 'schedule needs one of') 'register: refuses an unknown schedule shape'

        $exit7 = Join-Path $Tmp 'exit7.ps1'
        New-File $exit7 'exit 7'
        & cscript.exe //nologo (Join-Path $JobsDir 'run-hidden.vbs') $exit7 | Out-Null
        Assert ($LASTEXITCODE -eq 7) 'run-hidden.vbs: the script exit code reaches the caller'
    } else {
        Write-Host 'skip Register-ScheduledJob.ps1 and run-hidden.vbs (Windows only)'
    }

    Write-Host 'All skill-script checks passed.' -ForegroundColor Green
}
catch {
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
finally {
    if (Test-Path $Tmp) { Remove-Item $Tmp -Recurse -Force -ErrorAction SilentlyContinue }
}
