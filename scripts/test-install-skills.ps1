#requires -Version 7
<#
.SYNOPSIS
    Smoke test for install-skills.ps1: install into a temp dir, check the result.

.DESCRIPTION
    1. Installs every tier (-All) into a temporary directory and asserts the flat
       layout: exactly one <dir>/<name>/SKILL.md per leaf skill in the repo, nothing
       else at the top level, and no reports/ folder carried along.
    2. Installs a bare run (Core only) and asserts no Domain skill leaks in.
    3. Copies skills/ and the installer into a scratch repo, duplicates one skill
       under a second category, and asserts the install throws on the collision.
    4. Runs -AllAgents with HOME pointed at a fake home in the temp directory and
       asserts it writes the three shared folders, skips absent CLIs, and removes old
       copies from the folders it no longer writes without touching anything else.
    5. Ownership: a hand-made same-named skill survives without -Force and is replaced
       with it; a previous install (marked, or an unmarked copy of a shipped SKILL.md)
       is replaced silently.
    6. A retired folder that is a link to ~/.claude/skills: -AllAgents must not delete
       the copy it just installed through it.
    7. Windows only: a locked file leaves the old copy whole, the other skill still
       installs, and the run exits non-zero.
    8. -Ref in a scratch git repo: untracked files never ship, build litter never
       ships even from the working tree, and the marker names the commit.
    9. -All with -AllAgents is rejected.
   10. Tool skills: one fetched from a local git repo named in a -ToolList installs
       with a bare run and its marker names that repo and commit; one that can't be
       fetched makes the run exit non-zero without stopping the others.
   11. -Status: current, differs (an edited install), missing, and orphan (a marked
       folder the repo no longer ships), and it changes nothing.

    Every run that isn't about tool skills passes an empty -ToolList, so the test never
    reaches the network.

    Touches nothing outside the temp directory, so it never writes to ~/.claude.
    Exits 1 on the first failed assertion. CI runs it in validate.yml, on Linux and Windows.

.EXAMPLE
    pwsh -NoProfile -File scripts/test-install-skills.ps1
#>
$ErrorActionPreference = 'Stop'

$RepoRoot   = Split-Path -Parent $PSScriptRoot
$Installer  = Join-Path $PSScriptRoot 'install-skills.ps1'
$Targets    = Join-Path $PSScriptRoot 'install-targets.json'
$SkillsRoot = Join-Path $RepoRoot 'skills'
$Tmp        = Join-Path ([IO.Path]::GetTempPath()) "install-skills-test-$([guid]::NewGuid().ToString('N'))"
$Marker     = '.installed-from-agent-skills'

function Assert([bool] $Condition, [string] $Message) {
    if (-not $Condition) { throw "FAIL: $Message" }
    Write-Host "ok   $Message"
}

function Get-LeafNames([string] $Root) {
    Get-ChildItem -Path $Root -Recurse -File -Filter 'SKILL.md' |
        ForEach-Object { $_.Directory.Name } | Sort-Object
}

try {
    New-Item -ItemType Directory -Path $Tmp | Out-Null
    $pwsh = (Get-Process -Id $PID).Path
    $NoTools = Join-Path $Tmp 'no-tools.json'
    Set-Content -LiteralPath $NoTools -Value '{ "skills": [] }'

    # 1. Every tier, flat layout.
    $all = Join-Path $Tmp 'all'
    & $Installer -All -Destination $all -ToolList $NoTools *> $null
    $expected  = @(Get-LeafNames $SkillsRoot)
    $installed = @(Get-ChildItem -Path $all -Directory | Select-Object -ExpandProperty Name | Sort-Object)
    Assert ($expected.Count -gt 0) "repo has skills to install ($($expected.Count))"
    Assert (-not (Compare-Object $expected $installed)) 'one top-level folder per leaf skill, no more, no less'
    Assert (-not (Get-ChildItem -Path $all -File)) 'no loose files at the top level'
    $missing = $installed | Where-Object { -not (Test-Path (Join-Path $all "$_/SKILL.md")) }
    Assert (-not $missing) "every <dir>/<name>/SKILL.md exists$(if ($missing) { ": missing $($missing -join ', ')" })"
    $nested = Get-ChildItem -Path $all -Recurse -File -Filter 'SKILL.md' |
        Where-Object { $_.Directory.Parent.FullName -ne (Get-Item $all).FullName }
    Assert (-not $nested) 'no SKILL.md nested deeper than <dir>/<name>/'

    # 2. A bare run installs Core only.
    $core = Join-Path $Tmp 'core'
    & $Installer -Destination $core -ToolList $NoTools *> $null
    $coreExpected  = @(Get-LeafNames (Join-Path $SkillsRoot 'core'))
    $coreInstalled = @(Get-ChildItem -Path $core -Directory | Select-Object -ExpandProperty Name | Sort-Object)
    Assert (-not (Compare-Object $coreExpected $coreInstalled)) "a bare run installs exactly the Core tier ($($coreExpected.Count))"
    $one = $coreExpected[0]
    Assert (Test-Path (Join-Path $core "$one/$Marker")) "an install writes the $Marker marker"

    # 3. Scratch repo with a duplicated name: install must throw, and reports/ never ships.
    $scratch = Join-Path $Tmp 'repo'
    New-Item -ItemType Directory -Path (Join-Path $scratch 'scripts') | Out-Null
    Copy-Item -Path $SkillsRoot -Destination $scratch -Recurse
    Copy-Item -Path $Installer, $Targets -Destination (Join-Path $scratch 'scripts')
    $scratchInstaller = Join-Path $scratch 'scripts/install-skills.ps1'

    $victim = Get-ChildItem -Path (Join-Path $scratch 'skills/core') -Recurse -File -Filter 'SKILL.md' |
        Select-Object -First 1 -ExpandProperty Directory
    New-Item -ItemType Directory -Path (Join-Path $victim.FullName 'reports') | Out-Null
    Set-Content -Path (Join-Path $victim.FullName 'reports/run.txt') -Value 'local output'

    $reportsOut = Join-Path $Tmp 'reports'
    & $scratchInstaller -Skill $victim.Name -Destination $reportsOut *> $null
    Assert (Test-Path (Join-Path $reportsOut "$($victim.Name)/SKILL.md")) "-Skill installs one named skill ($($victim.Name))"
    Assert (-not (Get-ChildItem -Path $reportsOut -Recurse -Directory -Filter 'reports')) 'reports/ run output is not installed'

    $twin = Join-Path $scratch "skills/core/Zz-Collision/$($victim.Name)"
    New-Item -ItemType Directory -Path $twin -Force | Out-Null
    Copy-Item -Path (Join-Path $victim.FullName 'SKILL.md') -Destination $twin
    $collisionOut = Join-Path $Tmp 'collision'
    $threw = $null
    try { & $scratchInstaller -Destination $collisionOut *> $null } catch { $threw = $_.Exception.Message }
    Assert ($threw -match 'Duplicate skill name') "a duplicated name ($($victim.Name)) throws"
    Assert (-not (Test-Path $collisionOut)) 'a collision installs nothing'

    # 4. -AllAgents against a fake home: writes the three shared folders, skips absent CLIs,
    #    removes old copies from the retired folders and leaves anything else there alone.
    $fakeHome = Join-Path $Tmp 'home'
    foreach ($d in '.claude', '.codex', '.gemini/antigravity-cli/skills', '.config/opencode/skills/my-own-skill') {
        New-Item -ItemType Directory -Path (Join-Path $fakeHome $d) -Force | Out-Null
    }
    # The copy an earlier -AllAgents run left in a retired folder: a real, marked install.
    & $Installer -Skill $one -Destination (Join-Path $fakeHome '.config/opencode/skills') *> $null
    $saved = $env:HOME, $env:USERPROFILE
    try {
        $env:HOME = $fakeHome; $env:USERPROFILE = $fakeHome   # $HOME follows HOME on Linux, USERPROFILE on Windows
        & $pwsh -NoProfile -File $Installer -AllAgents -ToolList $NoTools *> $null
        Assert ($LASTEXITCODE -eq 0) '-AllAgents exits cleanly'
    } finally { $env:HOME, $env:USERPROFILE = $saved }
    foreach ($d in '.claude/skills', '.agents/skills', '.gemini/config/skills') {
        $got = @(Get-ChildItem -Path (Join-Path $fakeHome $d) -Directory -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Name | Sort-Object)
        Assert (-not (Compare-Object $coreExpected $got)) "-AllAgents installs the Core tier to ~/$d"
    }
    Assert (-not (Test-Path (Join-Path $fakeHome '.kilo'))) '-AllAgents creates nothing for a CLI that is absent'
    Assert (-not (Get-ChildItem -Path (Join-Path $fakeHome '.gemini/antigravity-cli/skills'))) '-AllAgents no longer writes ~/.gemini/antigravity-cli/skills'
    Assert (-not (Test-Path (Join-Path $fakeHome ".config/opencode/skills/$one"))) "-AllAgents removes an old copy ($one) from a retired folder"
    Assert (Test-Path (Join-Path $fakeHome '.config/opencode/skills/my-own-skill')) '-AllAgents leaves a skill it did not install alone'
    Assert (-not (Get-ChildItem -Path $fakeHome -Recurse -Directory -Force -Filter '.agent-skills-staging')) 'no staging folder is left behind'

    # 5. Ownership. A hand-made folder with a library skill's name is the user's own.
    $own  = Join-Path $Tmp 'own'
    $mine = Join-Path $own $one
    New-Item -ItemType Directory -Path $mine -Force | Out-Null
    Set-Content (Join-Path $mine 'SKILL.md') "---`nname: $one`ndescription: my own version`n---`n"
    Set-Content (Join-Path $mine 'my-notes.md') 'keep me'
    & $pwsh -NoProfile -File $Installer -Skill $one -Destination $own *> $null
    Assert ($LASTEXITCODE -eq 0 -and (Test-Path (Join-Path $mine 'my-notes.md'))) 'a hand-made same-named skill survives an install without -Force'
    & $pwsh -NoProfile -File $Installer -Skill $one -Destination $own -Force *> $null
    Assert (-not (Test-Path (Join-Path $mine 'my-notes.md')) -and (Test-Path (Join-Path $mine $Marker))) '-Force replaces it'
    Set-Content (Join-Path $mine 'stale.md') 'from an older install'
    & $pwsh -NoProfile -File $Installer -Skill $one -Destination $own *> $null
    Assert (-not (Test-Path (Join-Path $mine 'stale.md'))) 'a marked previous install is replaced silently, as a clean mirror'
    $inGit = [bool](Get-Command git -ErrorAction SilentlyContinue) -and [bool](git -C $RepoRoot rev-parse --git-dir 2>$null)
    if ($inGit) {
        Remove-Item (Join-Path $mine $Marker) -Force   # dot-files are hidden on Linux
        Set-Content (Join-Path $mine 'stale.md') 'from a pre-marker install'
        & $pwsh -NoProfile -File $Installer -Skill $one -Destination $own *> $null
        Assert (-not (Test-Path (Join-Path $mine 'stale.md'))) 'an unmarked copy of a shipped SKILL.md counts as a previous install'
    } else { Write-Host 'skip unmarked-previous-install case (not a git clone)' }

    # 6. A retired folder linked to a live destination. Deleting through it would empty ~/.claude/skills.
    $linkHome = Join-Path $Tmp 'linkhome'
    New-Item -ItemType Directory -Path (Join-Path $linkHome '.claude/skills'), (Join-Path $linkHome '.config/opencode') -Force | Out-Null
    $linkType = if ($IsWindows) { 'Junction' } else { 'SymbolicLink' }
    $link = Join-Path $linkHome '.config/opencode/skills'
    New-Item -ItemType $linkType -Path $link -Target (Join-Path $linkHome '.claude/skills') | Out-Null
    try {
        $env:HOME = $linkHome; $env:USERPROFILE = $linkHome
        & $pwsh -NoProfile -File $Installer -AllAgents -Skill $one *> $null
    } finally { $env:HOME, $env:USERPROFILE = $saved }
    Assert (Test-Path (Join-Path $linkHome ".claude/skills/$one/SKILL.md")) '-AllAgents never deletes through a linked retired folder'
    (Get-Item $link -Force).Delete()   # the link only, never its target

    # 7. Windows: a file held open in the installed copy. The swap must fail cleanly.
    if ($IsWindows) {
        $lockDest = Join-Path $Tmp 'locked'
        $multi = (Get-ChildItem -Path (Join-Path $SkillsRoot 'core') -Recurse -File -Filter 'SKILL.md' |
            Where-Object { (Get-ChildItem $_.Directory.FullName -Recurse -File).Count -gt 1 } |
            Select-Object -First 1).Directory.Name
        $other = $coreExpected | Where-Object { $_ -ne $multi } | Select-Object -First 1
        & $Installer -Skill $multi -Destination $lockDest *> $null
        $before = (Get-ChildItem (Join-Path $lockDest $multi) -Recurse -File -Force).Count
        $held = Get-ChildItem (Join-Path $lockDest $multi) -Recurse -File | Where-Object Name -ne 'SKILL.md' | Select-Object -First 1
        $fs = [IO.File]::Open($held.FullName, 'Open', 'Read', 'Read')
        try {
            # -Command, not -File: -File passes "a,b" as one string, so -Skill would get one name.
            & $pwsh -NoProfile -Command "& '$Installer' -Skill '$multi','$other' -Destination '$lockDest'; exit `$LASTEXITCODE" *> $null
            $code = $LASTEXITCODE
        } finally { $fs.Dispose() }
        Assert ($code -ne 0) 'a failed skill makes the run exit non-zero'
        Assert ((Get-ChildItem (Join-Path $lockDest $multi) -Recurse -File -Force).Count -eq $before) "a locked file leaves the old copy of $multi whole"
        Assert (Test-Path (Join-Path $lockDest "$other/SKILL.md")) "the other skill ($other) still installs"
        Assert (-not (Get-ChildItem $lockDest -Force | Where-Object Name -like '.*')) 'nothing half-built is left inside the destination'
    } else { Write-Host 'skip locked-file case (Windows only)' }

    # 8. -Ref in a scratch git repo: only what the commit tracks ships.
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $gitRepo = Join-Path $Tmp 'gitrepo'
        New-Item -ItemType Directory -Path (Join-Path $gitRepo 'scripts'), (Join-Path $gitRepo 'skills') -Force | Out-Null
        Copy-Item -Path (Join-Path $SkillsRoot 'core') -Destination (Join-Path $gitRepo 'skills') -Recurse
        Copy-Item -Path $Installer, $Targets -Destination (Join-Path $gitRepo 'scripts')
        git -C $gitRepo init -q 2>$null
        git -C $gitRepo add -A 2>$null
        git -C $gitRepo -c user.name=test -c user.email=test@example.com commit -q -m init 2>$null
        $sha = (git -C $gitRepo rev-parse HEAD).Trim()
        $leafDir = (Get-ChildItem (Join-Path $gitRepo 'skills/core') -Recurse -File -Filter 'SKILL.md' |
            Where-Object { $_.Directory.Name -eq $one }).Directory.FullName
        Set-Content (Join-Path $leafDir 'canary.txt') 'untracked'
        New-Item -ItemType Directory -Path (Join-Path $leafDir '__pycache__') -Force | Out-Null
        Set-Content (Join-Path $leafDir '__pycache__/x.cpython-312.pyc') 'litter'
        $gi = Join-Path $gitRepo 'scripts/install-skills.ps1'
        $refOut = Join-Path $Tmp 'ref'
        & $pwsh -NoProfile -File $gi -Skill $one -Ref HEAD -Destination $refOut *> $null
        Assert ($LASTEXITCODE -eq 0 -and (Test-Path (Join-Path $refOut "$one/SKILL.md"))) '-Ref HEAD installs from the commit'
        Assert (-not (Test-Path (Join-Path $refOut "$one/canary.txt"))) '-Ref never ships an untracked file'
        $markerText = Get-Content -Raw (Join-Path $refOut "$one/$Marker")
        Assert ($markerText -match "commit: $sha" -and $markerText -match 'ref: HEAD') 'the marker names the ref and the commit'
        $wtOut = Join-Path $Tmp 'worktree'
        & $pwsh -NoProfile -File $gi -Skill $one -Destination $wtOut *> $null
        Assert (Test-Path (Join-Path $wtOut "$one/canary.txt")) 'a working-tree install ships local files (why a sync should pass -Ref)'
        Assert (-not (Get-ChildItem (Join-Path $wtOut $one) -Recurse -Force | Where-Object { $_.Name -eq '__pycache__' -or $_.Extension -eq '.pyc' })) 'build litter (__pycache__, *.pyc) never ships'
        $noRef = Join-Path $Tmp 'noref'
        & $pwsh -NoProfile -File $gi -Skill $one -Ref no-such-ref -Destination $noRef *> $null
        Assert ($LASTEXITCODE -ne 0 -and -not (Test-Path (Join-Path $noRef $one))) 'an unknown -Ref fails and installs nothing'
    } else { Write-Host 'skip -Ref case (no git)' }

    # 9. -All would put every Domain skill in user scope.
    $threw = $null
    try { & $Installer -All -AllAgents *> $null } catch { $threw = $_.Exception.Message }
    Assert ($threw -match 'never belongs in user scope') '-All with -AllAgents is rejected'

    # 10. Tool skills from a repo named in the tool list (a local repo here, so no network).
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $toolRepo = Join-Path $Tmp 'tool-repo'
        New-Item -ItemType Directory -Path (Join-Path $toolRepo 'skills/demo-tool/references'), (Join-Path $toolRepo 'src') -Force | Out-Null
        Set-Content (Join-Path $toolRepo 'skills/demo-tool/SKILL.md') "---`nname: demo-tool`ndescription: Use when testing tool skills.`n---`n"
        Set-Content (Join-Path $toolRepo 'skills/demo-tool/references/notes.md') 'notes'
        Set-Content (Join-Path $toolRepo 'src/app.txt') 'not part of the skill'
        git -C $toolRepo init -q -b main 2>$null
        git -C $toolRepo add -A 2>$null
        git -C $toolRepo -c user.name=test -c user.email=test@example.com commit -q -m init 2>$null
        $toolSha = (git -C $toolRepo rev-parse HEAD).Trim()
        $toolUrl = ([Uri](Resolve-Path $toolRepo).Path).AbsoluteUri
        $toolList = Join-Path $Tmp 'tools.json'
        @{ skills = @(
            @{ name = 'demo-tool'; repo = 'example/demo-tool'; path = 'skills/demo-tool'; ref = 'main'; url = $toolUrl }
            @{ name = 'gone-tool'; repo = 'example/gone'; path = 'skills/gone-tool'; ref = 'main'; url = "$toolUrl-missing" }
        ) } | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $toolList
        $toolOut = Join-Path $Tmp 'tools'
        $toolLog = & $pwsh -NoProfile -Command "& '$Installer' -Skill '$one','demo-tool','gone-tool' -Destination '$toolOut' -ToolList '$toolList'; exit `$LASTEXITCODE" *>&1 | Out-String
        $code = $LASTEXITCODE
        Assert (Test-Path (Join-Path $toolOut 'demo-tool/references/notes.md')) "a tool skill installs from its repo, whole folder$(if (-not (Test-Path (Join-Path $toolOut 'demo-tool'))) { " (url $toolUrl; installer said:`n$toolLog)" })"
        Assert (-not (Test-Path (Join-Path $toolOut 'demo-tool/src'))) 'only the skill folder ships, not the rest of the tool repo'
        $toolMarker = Get-Content -Raw (Join-Path $toolOut "demo-tool/$Marker")
        Assert ($toolMarker -match 'source: example/demo-tool' -and $toolMarker -match "commit: $toolSha") "a tool skill's marker names its repo and commit"
        Assert ((Test-Path (Join-Path $toolOut "$one/SKILL.md")) -and $code -ne 0) 'a tool skill that cannot be fetched fails the run but not the other installs'
        $dupList = Join-Path $Tmp 'dup-tools.json'
        @{ skills = @(@{ name = $one; repo = 'example/x'; path = "skills/$one"; ref = 'main' }) } | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $dupList
        $threw = $null
        try { & $Installer -List -ToolList $dupList *> $null } catch { $threw = $_.Exception.Message }
        Assert ($threw -match 'Duplicate skill name') 'a tool skill named like a repo skill throws'
    } else { Write-Host 'skip tool-skill case (no git)' }

    # 11. -Status against the Core install from step 2. It must report, never change.
    $other2 = $coreExpected | Where-Object { $_ -ne $one } | Select-Object -First 1
    Add-Content (Join-Path $core "$one/SKILL.md") 'edited in place'
    Remove-Item (Join-Path $core $other2) -Recurse -Force
    New-Item -ItemType Directory -Path (Join-Path $core 'retired-skill') | Out-Null
    Set-Content (Join-Path $core "retired-skill/$Marker") 'source: ai-automation-tools/agent-skills'
    $third = $coreExpected | Where-Object { $_ -notin $one, $other2 } | Select-Object -First 1
    $statusText = & $Installer -Status -Destination $core -ToolList $NoTools *>&1 | Out-String -Width 400
    Assert ($statusText -match "$third\s+current") '-Status reports an untouched install as current'
    Assert ($statusText -match "$one\s+differs") '-Status reports an edited install as differs'
    Assert ($statusText -match "$other2\s+missing") '-Status reports a missing install'
    Assert ($statusText -match 'retired-skill\s+orphan') '-Status reports a marked folder the repo no longer ships as an orphan'
    Assert (-not (Test-Path (Join-Path $core $other2)) -and (Get-Content -Raw (Join-Path $core "$one/SKILL.md")) -match 'edited in place') '-Status changes nothing'

    Write-Host 'All installer checks passed.' -ForegroundColor Green
}
catch {
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
finally {
    if (Test-Path $Tmp) { Remove-Item $Tmp -Recurse -Force -ErrorAction SilentlyContinue }
}
