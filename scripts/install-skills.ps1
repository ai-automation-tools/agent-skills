#requires -Version 7
<#
.SYNOPSIS
    Install (copy) this repo's Agent Skills into an agent CLI's skills directory.

.DESCRIPTION
    Finds every leaf skill folder under skills/ (a folder that directly contains a
    SKILL.md) and mirrors the WHOLE leaf — SKILL.md plus any scripts/, references/,
    prompts/, evals/ — into the destination skills directory as <destination>/<name>/.

    The leaf folder is the portable unit (per AGENTS.md); bulky demo assets live
    separately under resources/skill-data/ and are intentionally NOT installed.

    Each install is a clean mirror: the target <name>/ folder is removed and
    recopied, so files you deleted in the repo disappear from the install too.
    Per-skill reports/ output (gitignored local run output) is never copied.

    Skills come in two tiers and they do NOT install to the same place:

      skills/core/<category>/<name>/   portable      -> user scope (~/.claude/skills)
      skills/domain/<domain>/<name>/   portable,     -> user scope, only with -Domain
                                       mirrored from the org's agent workspaces
      skills/projects/<repo>/<name>/   additional,   -> that repo's .claude/skills
                                       per org repo    (an OVERLAY — the repo keeps its own)

    A bare run installs the Core tier only, so a project skill can never leak into
    user scope by accident and clutter the catalog of every unrelated session.

    The agent CLIs read overlapping global skills directories, so three folders
    reach all of them. -AllAgents installs to each one whose CLIs exist here:

      ~/.claude/skills         Claude Code (opencode, and Kilo in Claude Code mode)
      ~/.agents/skills         Codex, Kimi, opencode, Kilo (shared; ~/.codex/skills is legacy)
      ~/.gemini/config/skills  Antigravity IDE and agy (the Antigravity CLI)

    A folder whose CLIs are all absent is skipped rather than created, so the switch
    never litters ~ with directories for tools you don't have.

    Until 2026-11-12 -AllAgents also wrote ~/.gemini/antigravity-cli/skills,
    ~/.config/opencode/skills and ~/.kilo/skills, which those CLIs read on top of the
    shared folders, so they listed every skill twice or three times. An -AllAgents
    run now removes the copies it left there: only folders named like a skill being
    installed, nothing else in those directories.

.PARAMETER Destination
    Where to install. Defaults to "$HOME/.claude/skills".

.PARAMETER AllAgents
    Install to the three global skills directories that cover every agent CLI
    present on this machine (Claude Code, Codex, Kimi, agy, Antigravity IDE,
    opencode, Kilo) instead of a single -Destination, and remove the copies older
    runs left in the folders it no longer writes.
    Core tier only - project skills are per-repo by definition, so -Project is
    rejected here.

.PARAMETER Core
    Install the Core tier (skills/core/**). This is the default when neither -Core
    nor -Project is given.

.PARAMETER Domain
    Install the Domain tier (skills/domain/**): field skills mirrored from the org's
    agent workspaces. User scope like Core, but never part of a bare run.

.PARAMETER Project
    Install the project skills for one org repo (skills/projects/<name>/**).
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
    Install every Core skill into every agent CLI's global skills directory found here.

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
    [Parameter(ParameterSetName = 'Domain')]  [switch] $Domain,
    [Parameter(ParameterSetName = 'Project')] [string] $Project,
    [Parameter(ParameterSetName = 'All')]     [switch] $All,
    [string[]] $Skill,
    [switch]   $AllAgents,
    [switch]   $List
)

$ErrorActionPreference = 'Stop'

# Repo root = parent of this scripts/ folder, no matter where it's invoked from.
$RepoRoot   = Split-Path -Parent $PSScriptRoot
$SkillsRoot = Join-Path $RepoRoot 'skills'

if (-not (Test-Path $SkillsRoot)) {
    throw "skills/ folder not found at '$SkillsRoot'. Run this from within the repo."
}

# Which tier are we installing? -List with no tier means "show everything".
$SearchRoot = switch ($PSCmdlet.ParameterSetName) {
    'Project' {
        $p = Join-Path $SkillsRoot "projects/$Project"
        if (-not (Test-Path $p)) {
            $known = (Get-ChildItem (Join-Path $SkillsRoot 'projects') -Directory |
                      Select-Object -ExpandProperty Name) -join ', '
            throw "No project '$Project' under skills/projects. Known projects: $known"
        }
        $p
    }
    'Domain'  { Join-Path $SkillsRoot 'domain' }
    'All'     { $SkillsRoot }
    default   { if ($List) { $SkillsRoot } else { Join-Path $SkillsRoot 'core' } }
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
            Path  = "skills/$rel"
        }
    } | Format-Table -AutoSize
    return
}

# Where this lands: one -Destination, or the shared folders every installed CLI reads.
# The CLIs overlap: opencode also reads ~/.claude/skills and ~/.agents/skills, Kilo
# reads ~/.agents/skills, agy reads ~/.gemini/config/skills. So three folders reach
# all of them, and writing each CLI's own folder too only listed skills twice.
# Paths re-checked 2026-11-11 against each CLI's own docs (table in docs/USING-SKILLS.md).
# ~/.codex/skills is Codex's LEGACY path: a copy there shows up twice, so it is never a target.
# Each folder is written when any CLI that reads it is present (its root folder exists);
# creating a folder for CLIs you don't have is litter.
$AgentSkillDirs = [ordered]@{
    'Claude Code'                 = @{ Dir = '.claude/skills';        Roots = '.claude' }
    'Codex, Kimi, opencode, Kilo' = @{ Dir = '.agents/skills';        Roots = '.agents', '.codex', '.kimi-code', '.config/opencode', '.kilo' }
    'Antigravity IDE, agy'        = @{ Dir = '.gemini/config/skills'; Roots = '.gemini/config', '.gemini/antigravity-cli' }
}
# Folders older -AllAgents runs wrote. Each CLI reads them on top of the shared folders
# above, so a copy left there is a duplicate that goes stale. -AllAgents removes them.
$RetiredSkillDirs = '.gemini/antigravity-cli/skills', '.config/opencode/skills', '.kilo/skills'

$destinations = [ordered]@{}
if ($AllAgents) {
    if ($PSCmdlet.ParameterSetName -eq 'Project') {
        throw "-AllAgents installs to user scope, and project skills belong in one repo's .claude/skills. Use -Project with -Destination instead."
    }
    if ($PSBoundParameters.ContainsKey('Destination')) {
        throw "-AllAgents picks its own destinations. Drop -Destination, or drop -AllAgents."
    }
    foreach ($t in $AgentSkillDirs.GetEnumerator()) {
        if ($t.Value.Roots | Where-Object { Test-Path (Join-Path $HOME $_) }) {
            $destinations[$t.Key] = Join-Path $HOME $t.Value.Dir
        } else {
            Write-Host ("Skipping {0} — none of {1} found on this machine." -f $t.Value.Dir, (($t.Value.Roots | ForEach-Object { "~/$_" }) -join ', ')) -ForegroundColor DarkGray
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

# Remove the duplicates older -AllAgents runs left in the retired folders. Only folders
# named like a skill this run installed: anything else there is the user's own.
if ($AllAgents) {
    foreach ($dir in $RetiredSkillDirs) {
        foreach ($leaf in $leaves) {
            $old = Join-Path (Join-Path $HOME $dir) $leaf.Name
            if ((Test-Path $old) -and $PSCmdlet.ShouldProcess($old, 'Remove copy from a folder -AllAgents no longer writes')) {
                Remove-Item $old -Recurse -Force
                Write-Host "Removed old copy $old" -ForegroundColor DarkYellow
            }
        }
    }
}

Write-Host "Done. Restart any open agent session to reload the skill catalog." -ForegroundColor Green
