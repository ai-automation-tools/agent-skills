#requires -Version 7
<#
.SYNOPSIS
    Install (copy) this repo's Agent Skills into your Claude Code skills directory.

.DESCRIPTION
    Finds every leaf skill folder under Skills/ (a folder that directly contains a
    SKILL.md) and mirrors the WHOLE leaf — SKILL.md plus any scripts/, references/,
    prompts/, evals/ — into the destination skills directory as <destination>/<name>/.

    The leaf folder is the portable unit (per CLAUDE.md); bulky demo assets live
    separately under Resources/Skill-Data/ and are intentionally NOT installed.

    Each install is a clean mirror: the target <name>/ folder is removed and
    recopied, so files you deleted in the repo disappear from the install too.
    Per-skill reports/ output (gitignored local run output) is never copied.

.PARAMETER Destination
    Where to install. Defaults to "$HOME/.claude/skills".

.PARAMETER Skill
    Install only the named skill(s) (match the leaf folder / frontmatter name).
    Omit to install every skill in the repo.

.PARAMETER List
    List the skills that would be installed and exit (no copying).

.EXAMPLE
    pwsh scripts/install-skills.ps1
    Install every skill into ~/.claude/skills.

.EXAMPLE
    pwsh scripts/install-skills.ps1 -Skill readme-builder-mfs,readme-header-mfs
    Re-install just those two skills.

.EXAMPLE
    pwsh scripts/install-skills.ps1 -WhatIf
    Show what would be copied without changing anything.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]   $Destination = (Join-Path $HOME '.claude/skills'),
    [string[]] $Skill,
    [switch]   $List
)

$ErrorActionPreference = 'Stop'

# Repo root = parent of this scripts/ folder, no matter where it's invoked from.
$RepoRoot   = Split-Path -Parent $PSScriptRoot
$SkillsRoot = Join-Path $RepoRoot 'Skills'

if (-not (Test-Path $SkillsRoot)) {
    throw "Skills/ folder not found at '$SkillsRoot'. Run this from within the repo."
}

# A leaf skill = any folder directly containing a SKILL.md.
$leaves = Get-ChildItem -Path $SkillsRoot -Recurse -File -Filter 'SKILL.md' |
    ForEach-Object { $_.Directory } |
    Sort-Object FullName

if ($Skill) {
    $leaves = $leaves | Where-Object { $_.Name -in $Skill }
    $missing = $Skill | Where-Object { $_ -notin ($leaves.Name) }
    if ($missing) { Write-Warning "No skill folder matched: $($missing -join ', ')" }
}

if (-not $leaves) { Write-Warning 'No skills found to install.'; return }

if ($List) {
    Write-Host "Skills found under $SkillsRoot :" -ForegroundColor Cyan
    $leaves | ForEach-Object {
        $rel = $_.FullName.Substring($RepoRoot.Length).TrimStart('\','/')
        "  - {0,-22} ({1})" -f $_.Name, $rel
    }
    return
}

if (-not (Test-Path $Destination)) {
    if ($PSCmdlet.ShouldProcess($Destination, 'Create skills directory')) {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }
}

Write-Host "Installing $($leaves.Count) skill(s) -> $Destination" -ForegroundColor Cyan
$results = foreach ($leaf in $leaves) {
    $name   = $leaf.Name
    $target = Join-Path $Destination $name

    if ($PSCmdlet.ShouldProcess($target, "Mirror skill '$name'")) {
        if (Test-Path $target) { Remove-Item $target -Recurse -Force }
        Copy-Item -Path $leaf.FullName -Destination $Destination -Recurse -Force

        # Never ship local run output.
        Get-ChildItem -Path $target -Recurse -Directory -Filter 'reports' -ErrorAction SilentlyContinue |
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

        $fileCount = (Get-ChildItem -Path $target -Recurse -File).Count
        [pscustomobject]@{ Skill = $name; Files = $fileCount; Target = $target }
    }
}

if ($results) {
    $results | Format-Table -AutoSize
    Write-Host "Done. Restart any open Claude Code session to reload the skill catalog." -ForegroundColor Green
}
