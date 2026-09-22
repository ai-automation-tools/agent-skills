#requires -Version 7
<#
.SYNOPSIS
    Install (copy) this repo's Agent Skills into an agent CLI's skills directory.

.DESCRIPTION
    Finds every leaf skill folder under Skills/ (a folder that directly contains a
    SKILL.md) and mirrors the WHOLE leaf — SKILL.md plus any scripts/, references/,
    prompts/, evals/ — into the destination skills directory as <destination>/<name>/.

    The leaf folder is the portable unit (per CLAUDE.md); bulky demo assets live
    separately under Resources/Skill-Data/ and are intentionally NOT installed.

    Each install is a clean mirror: the target <name>/ folder is removed and
    recopied, so files you deleted in the repo disappear from the install too.
    Per-skill reports/ output (gitignored local run output) is never copied.

    Skills come in two tiers and they do NOT install to the same place:

      Skills/Core/<Category>/<name>/   portable      -> user scope (~/.claude/skills)
      Skills/Projects/<repo>/<name>/   additional,   -> that repo's .claude/skills
                                       per org repo    (an OVERLAY — the repo keeps its own)

    A bare run installs the Core tier only, so a project skill can never leak into
    user scope by accident and clutter the catalog of every unrelated session.

    Four agent CLIs read a global skills directory and they are NOT the same path.
    -AllAgents installs to every one that exists on this machine:

      Claude Code  ~/.claude/skills
      Codex        ~/.codex/skills
      agy          ~/.agents/skills          (Antigravity)
      opencode     ~/.config/opencode/skills

    A CLI whose root folder is absent is skipped rather than created, so the switch
    never litters ~ with directories for tools you don't have.

.PARAMETER Destination
    Where to install. Defaults to "$HOME/.claude/skills".

.PARAMETER AllAgents
    Install to the global skills directory of every agent CLI present on this
    machine (Claude Code, Codex, agy, opencode) instead of a single -Destination.
    Core tier only - project skills are per-repo by definition, so -Project is
    rejected here.

.PARAMETER Core
    Install the Core tier (Skills/Core/**). This is the default when neither -Core
    nor -Project is given.

.PARAMETER Project
    Install the project skills for one org repo (Skills/Projects/<name>/**).
    Point -Destination at that repo's .claude/skills — several org repos track
    that folder in git, so the install lands in a commit other contributors get.

.PARAMETER Skill
    Install only the named skill(s) (match the leaf folder / frontmatter name).
    Narrows whichever tier was selected.

.PARAMETER List
    List the skills that would be installed and exit (no copying).

.EXAMPLE
    pwsh scripts/install-skills.ps1
    Install every Core skill into ~/.claude/skills.

.EXAMPLE
    pwsh scripts/install-skills.ps1 -Core -Skill repo-docs-builder
    Re-install one Core skill.

.EXAMPLE
    pwsh scripts/install-skills.ps1 -AllAgents
    Install every Core skill into all four agent CLIs' global skills directories.

.EXAMPLE
    pwsh scripts/install-skills.ps1 -AllAgents -Skill repo-docs-builder
    Push one updated skill to every agent CLI at once.

.EXAMPLE
    pwsh scripts/install-skills.ps1 -Project cronsole -Destination D:/repos/cronsole/.claude/skills
    Publish cronsole's project skills into the cronsole clone.

.EXAMPLE
    pwsh scripts/install-skills.ps1 -List
    Show every skill in the repo with its tier, and exit.

.EXAMPLE
    pwsh scripts/install-skills.ps1 -WhatIf
    Show what would be copied without changing anything.
#>
[CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Core')]
param(
    [string]   $Destination = (Join-Path $HOME '.claude/skills'),
    [Parameter(ParameterSetName = 'Core')]    [switch] $Core,
    [Parameter(ParameterSetName = 'Project')] [string] $Project,
    [Parameter(ParameterSetName = 'All')]     [switch] $All,
    [string[]] $Skill,
    [switch]   $AllAgents,
    [switch]   $List
)

$ErrorActionPreference = 'Stop'

# Repo root = parent of this scripts/ folder, no matter where it's invoked from.
$RepoRoot   = Split-Path -Parent $PSScriptRoot
$SkillsRoot = Join-Path $RepoRoot 'Skills'

if (-not (Test-Path $SkillsRoot)) {
    throw "Skills/ folder not found at '$SkillsRoot'. Run this from within the repo."
}

# Which tier are we installing? -List with no tier means "show everything".
$SearchRoot = switch ($PSCmdlet.ParameterSetName) {
    'Project' {
        $p = Join-Path $SkillsRoot "Projects/$Project"
        if (-not (Test-Path $p)) {
            $known = (Get-ChildItem (Join-Path $SkillsRoot 'Projects') -Directory |
                      Select-Object -ExpandProperty Name) -join ', '
            throw "No project '$Project' under Skills/Projects. Known projects: $known"
        }
        $p
    }
    'All'     { $SkillsRoot }
    default   { if ($List) { $SkillsRoot } else { Join-Path $SkillsRoot 'Core' } }
}

# A leaf skill = any folder directly containing a SKILL.md.
$leaves = Get-ChildItem -Path $SearchRoot -Recurse -File -Filter 'SKILL.md' |
    ForEach-Object { $_.Directory } |
    Sort-Object FullName

# Names install flat, so a collision silently overwrites. Catch it here instead.
$dupes = $leaves | Group-Object Name | Where-Object Count -gt 1
if ($dupes) {
    $detail = $dupes | ForEach-Object {
        "  {0}: {1}" -f $_.Name, (($_.Group.FullName |
            ForEach-Object { $_.Substring($RepoRoot.Length).TrimStart('\','/') }) -join ' , ')
    }
    throw "Duplicate skill name(s) — they would overwrite each other on install:`n$($detail -join "`n")"
}

if ($Skill) {
    $leaves = $leaves | Where-Object { $_.Name -in $Skill }
    $missing = $Skill | Where-Object { $_ -notin ($leaves.Name) }
    if ($missing) { Write-Warning "No skill folder matched: $($missing -join ', ')" }
}

if (-not $leaves) { Write-Warning 'No skills found to install.'; return }

if ($List) {
    $leaves | ForEach-Object {
        $rel   = $_.FullName.Substring($SkillsRoot.Length).TrimStart('\','/') -replace '\\','/'
        $parts = $rel -split '/'
        [pscustomobject]@{
            Skill = $_.Name
            Tier  = $parts[0]
            Group = if ($parts.Count -ge 3) { $parts[1] } else { '-' }
            Path  = "Skills/$rel"
        }
    } | Format-Table -AutoSize
    return
}

# Where this lands: one -Destination, or every agent CLI that's actually installed.
# The four CLIs read four different global paths — keeping them in sync by hand is
# how one of them silently goes stale.
$AgentSkillDirs = [ordered]@{
    'Claude Code' = Join-Path $HOME '.claude/skills'
    'Codex'       = Join-Path $HOME '.codex/skills'
    'agy'         = Join-Path $HOME '.agents/skills'
    'opencode'    = Join-Path $HOME '.config/opencode/skills'
}

$destinations = [ordered]@{}
if ($AllAgents) {
    if ($PSCmdlet.ParameterSetName -eq 'Project') {
        throw "-AllAgents installs to user scope, and project skills belong in one repo's .claude/skills. Use -Project with -Destination instead."
    }
    if ($PSBoundParameters.ContainsKey('Destination')) {
        throw "-AllAgents picks its own destinations. Drop -Destination, or drop -AllAgents."
    }
    foreach ($cli in $AgentSkillDirs.GetEnumerator()) {
        # Test the CLI's root (~/.codex), not the skills folder — the folder may not
        # exist yet, but creating one for a CLI you don't have is litter.
        if (Test-Path (Split-Path -Parent $cli.Value)) {
            $destinations[$cli.Key] = $cli.Value
        } else {
            Write-Host ("Skipping {0} — {1} not found on this machine." -f $cli.Key, (Split-Path -Parent $cli.Value)) -ForegroundColor DarkGray
        }
    }
    if (-not $destinations.Count) { throw "None of the known agent CLI folders exist under $HOME. Nothing to install to." }
} else {
    $destinations[''] = $Destination
}

foreach ($dest in $destinations.GetEnumerator()) {
    $DestPath = $dest.Value
    $label    = if ($dest.Key) { "$($dest.Key)  " } else { '' }

    if (-not (Test-Path $DestPath)) {
        if ($PSCmdlet.ShouldProcess($DestPath, 'Create skills directory')) {
            New-Item -ItemType Directory -Path $DestPath -Force | Out-Null
        }
    }

    Write-Host "Installing $($leaves.Count) skill(s) -> $label$DestPath" -ForegroundColor Cyan
    $results = foreach ($leaf in $leaves) {
        $name   = $leaf.Name
        $target = Join-Path $DestPath $name

        # Project skills install as an OVERLAY on repos that already own skills, and installs are
        # flat — so say whether this landed on empty space or on top of something.
        $state = if (Test-Path $target) { 'Replaced' } else { 'New' }

        if ($PSCmdlet.ShouldProcess($target, "Mirror skill '$name'")) {
            if (Test-Path $target) { Remove-Item $target -Recurse -Force }
            Copy-Item -Path $leaf.FullName -Destination $DestPath -Recurse -Force

            # Never ship local run output.
            Get-ChildItem -Path $target -Recurse -Directory -Filter 'reports' -ErrorAction SilentlyContinue |
                Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

            $fileCount = (Get-ChildItem -Path $target -Recurse -File).Count
            [pscustomobject]@{ Skill = $name; State = $state; Files = $fileCount; Target = $target }
        }
    }

    if ($results) {
        $results | Format-Table -AutoSize

        # A first-ever 'Replaced' on a project install means we landed on a skill the repo owned.
        if ($PSCmdlet.ParameterSetName -eq 'Project') {
            $hit = $results | Where-Object State -eq 'Replaced'
            if ($hit) {
                Write-Warning ("Overwrote {0} existing skill folder(s) at the destination: {1}. " -f
                    $hit.Count, ($hit.Skill -join ', '))
                Write-Warning "If any of those were the repo's own skills rather than a previous install from here, restore them with git and rename the skill in this repo."
            }
        }
    }
}

Write-Host "Done. Restart any open agent session to reload the skill catalog." -ForegroundColor Green
