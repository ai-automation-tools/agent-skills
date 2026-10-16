#requires -Version 7
<#
.SYNOPSIS
    Smoke test for install-skills.ps1: install into a temp dir, check the result.

.DESCRIPTION
    1. Installs every tier (-All) into a temporary directory and asserts the flat
       layout: exactly one <dir>/<name>/SKILL.md per leaf skill in the repo, nothing
       else at the top level, and no reports/ folder carried along.
    2. Installs a bare run (Core only) and asserts no Domain or Projects skill leaks in.
    3. Copies Skills/ and the installer into a scratch repo, duplicates one skill
       under a second category, and asserts the install throws on the collision.

    Touches nothing outside the temp directory, so it never writes to ~/.claude.
    Exits 1 on the first failed assertion. CI runs it in validate.yml.

.EXAMPLE
    pwsh -NoProfile -File scripts/test-install-skills.ps1
#>
$ErrorActionPreference = 'Stop'

$RepoRoot   = Split-Path -Parent $PSScriptRoot
$Installer  = Join-Path $PSScriptRoot 'install-skills.ps1'
$SkillsRoot = Join-Path $RepoRoot 'Skills'
$Tmp        = Join-Path ([IO.Path]::GetTempPath()) "install-skills-test-$([guid]::NewGuid().ToString('N'))"

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

    # 1. Every tier, flat layout.
    $all = Join-Path $Tmp 'all'
    & $Installer -All -Destination $all *> $null
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
    & $Installer -Destination $core *> $null
    $coreExpected  = @(Get-LeafNames (Join-Path $SkillsRoot 'Core'))
    $coreInstalled = @(Get-ChildItem -Path $core -Directory | Select-Object -ExpandProperty Name | Sort-Object)
    Assert (-not (Compare-Object $coreExpected $coreInstalled)) "a bare run installs exactly the Core tier ($($coreExpected.Count))"

    # 3. Scratch repo with a duplicated name: install must throw, and reports/ never ships.
    $scratch = Join-Path $Tmp 'repo'
    New-Item -ItemType Directory -Path (Join-Path $scratch 'scripts') | Out-Null
    Copy-Item -Path $SkillsRoot -Destination $scratch -Recurse
    Copy-Item -Path $Installer -Destination (Join-Path $scratch 'scripts')
    $scratchInstaller = Join-Path $scratch 'scripts/install-skills.ps1'

    $victim = Get-ChildItem -Path (Join-Path $scratch 'Skills/Core') -Recurse -File -Filter 'SKILL.md' |
        Select-Object -First 1 -ExpandProperty Directory
    New-Item -ItemType Directory -Path (Join-Path $victim.FullName 'reports') | Out-Null
    Set-Content -Path (Join-Path $victim.FullName 'reports/run.txt') -Value 'local output'

    $reportsOut = Join-Path $Tmp 'reports'
    & $scratchInstaller -Skill $victim.Name -Destination $reportsOut *> $null
    Assert (Test-Path (Join-Path $reportsOut "$($victim.Name)/SKILL.md")) "-Skill installs one named skill ($($victim.Name))"
    Assert (-not (Get-ChildItem -Path $reportsOut -Recurse -Directory -Filter 'reports')) 'reports/ run output is not installed'

    $twin = Join-Path $scratch "Skills/Core/Zz-Collision/$($victim.Name)"
    New-Item -ItemType Directory -Path $twin -Force | Out-Null
    Copy-Item -Path (Join-Path $victim.FullName 'SKILL.md') -Destination $twin
    $collisionOut = Join-Path $Tmp 'collision'
    $threw = $null
    try { & $scratchInstaller -Destination $collisionOut *> $null } catch { $threw = $_.Exception.Message }
    Assert ($threw -match 'Duplicate skill name') "a duplicated name ($($victim.Name)) throws"
    Assert (-not (Test-Path $collisionOut)) 'a collision installs nothing'

    Write-Host 'All installer checks passed.' -ForegroundColor Green
}
catch {
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}
finally {
    if (Test-Path $Tmp) { Remove-Item $Tmp -Recurse -Force -ErrorAction SilentlyContinue }
}
