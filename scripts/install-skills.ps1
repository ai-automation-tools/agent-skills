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

    Each install is a clean mirror: the new copy is built beside the destination and
    swapped in with renames, so files you deleted in the repo disappear from the
    install too, and a failure (a locked file, say) leaves the previous copy whole.
    Local run output and build litter (reports/, __pycache__/, .venv/, node_modules/,
    *.pyc) is never copied.

    Every installed folder gets a .installed-from-agent-skills marker naming the
    source (working tree or -Ref), the commit and the install time. A same-named
    folder at the destination is replaced only when it is a previous install: it
    carries the marker, or its SKILL.md matches a version this repo has shipped.
    Anything else is the user's own skill and is skipped with a warning unless -Force
    is given. A folder that is a link (junction or symlink) is never replaced or
    removed: the installer won't delete through a link.

    Skills come in two tiers, both installed to user scope:

      skills/core/<category>/<name>/   portable      -> user scope (~/.claude/skills)
      skills/domain/<domain>/<name>/   portable,     -> user scope, only with -Domain
                                       mirrored from the org's agent workspaces

    A bare run installs the Core tier only, so field skills never land in every
    session's catalog unasked. Skills for one org repo live in that repo (since
    2026-11-27; docs/CATALOG.md lists them), so there is nothing to install per repo.

    The agent CLIs read overlapping global skills directories, so three folders
    reach all of them. -AllAgents installs to each one whose CLIs exist here:

      ~/.claude/skills         Claude Code (opencode, and Kilo in Claude Code mode)
      ~/.agents/skills         Codex, Kimi, opencode, Kilo (shared; ~/.codex/skills is legacy)
      ~/.gemini/config/skills  Antigravity IDE and agy (the Antigravity CLI)

    The list lives in scripts/install-targets.json, so anything else that installs
    these skills (a scheduled sync, say) can read the same targets.

    A folder whose CLIs are all absent is skipped rather than created, so the switch
    never litters ~ with directories for tools you don't have.

    Until 2026-11-12 -AllAgents also wrote ~/.gemini/antigravity-cli/skills,
    ~/.config/opencode/skills and ~/.kilo/skills, which those CLIs read on top of the
    shared folders, so they listed every skill twice or three times. An -AllAgents
    run now removes the copies it left there: only previous installs named like a
    skill being installed, never through a link, nothing else in those directories.

.PARAMETER Destination
    Where to install. Defaults to "$HOME/.claude/skills".

.PARAMETER AllAgents
    Install to the three global skills directories that cover every agent CLI
    present on this machine (Claude Code, Codex, Kimi, agy, Antigravity IDE,
    opencode, Kilo) instead of a single -Destination, and remove the copies older
    runs left in the folders it no longer writes.
    -All is rejected here: it exists for tests and -List.

.PARAMETER Core
    Install the Core tier (skills/core/**). This is the default when no tier is given.

.PARAMETER Domain
    Install the Domain tier (skills/domain/**): field skills mirrored from the org's
    agent workspaces. User scope like Core, but never part of a bare run.

.PARAMETER All
    Every tier at once. For tests (scripts/test-install-skills.ps1) and -List only:
    it puts every Domain skill next to Core, so it needs an explicit -Destination and
    is rejected with -AllAgents.

.PARAMETER Skill
    Install only the named skill(s) (match the leaf folder / frontmatter name).
    Narrows whichever tier was selected.

.PARAMETER Ref
    Install the skills as committed at this git ref (for example origin/main) instead
    of the working tree: tracked files only, so local edits, unpushed commits on
    another branch and untracked files never ship. Fetch first; the installer
    doesn't. The marker records the resolved commit.

.PARAMETER Force
    Replace a same-named destination folder even when it isn't a previous install
    from this repo. Links are still never replaced.

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
    git fetch origin; pwsh scripts/install-skills.ps1 -AllAgents -Ref origin/main
    Install what main holds, whatever is checked out or edited locally. For scheduled syncs.

.EXAMPLE
    pwsh scripts/install-skills.ps1 -AllAgents -Skill repo-docs-builder
    Push one updated skill to every agent CLI at once.

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
    [Parameter(ParameterSetName = 'All')]     [switch] $All,
    [string[]] $Skill,
    [string]   $Ref,
    [switch]   $AllAgents,
    [switch]   $Force,
    [switch]   $List
)

$ErrorActionPreference = 'Stop'

# Repo root = parent of this scripts/ folder, no matter where it's invoked from.
$RepoRoot   = Split-Path -Parent $PSScriptRoot
$SkillsRoot = Join-Path $RepoRoot 'skills'
$MarkerName = '.installed-from-agent-skills'
# Never installed: local run output and build litter that may sit in a working tree.
$SkipDirs   = 'reports', '__pycache__', '.venv', 'venv', 'node_modules', '.pytest_cache', '.mypy_cache', '.ruff_cache'
$SkipFiles  = '*.pyc', '*.pyo', '.DS_Store', 'Thumbs.db'

if (-not (Test-Path $SkillsRoot)) {
    throw "skills/ folder not found at '$SkillsRoot'. Run this from within the repo."
}

if ($AllAgents -and $PSCmdlet.ParameterSetName -eq 'All') {
    throw "-All is for tests and -List; it never belongs in user scope. Use -AllAgents with -Core or -Domain."
}
if ($AllAgents -and $PSBoundParameters.ContainsKey('Destination')) {
    throw "-AllAgents picks its own destinations. Drop -Destination, or drop -AllAgents."
}

function Invoke-Git {
    $out = & git -C $RepoRoot @args 2>$null
    if ($LASTEXITCODE -ne 0) { return $null }
    $out
}
$HaveGit = [bool](Get-Command git -ErrorAction SilentlyContinue) -and [bool](Invoke-Git rev-parse --git-dir)

# Where the skills come from: the working tree, or the tracked files of one commit.
$SourceLabel = 'working tree'
$Commit      = if ($HaveGit) { Invoke-Git rev-parse HEAD } else { $null }
$Export      = $null
$StageRoots  = [Collections.Generic.HashSet[string]]::new()
$failures    = 0

try {
    if ($Ref) {
        if (-not $HaveGit) { throw "-Ref needs git and a clone of this repo; '$RepoRoot' isn't one." }
        $Commit = Invoke-Git rev-parse --verify --quiet "$Ref^{commit}"
        if (-not $Commit) { throw "No commit '$Ref' in $RepoRoot. Fetch it first (git fetch origin)." }
        $Export = Join-Path ([IO.Path]::GetTempPath()) "agent-skills-$($Commit.Substring(0, 12))-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
        New-Item -ItemType Directory -Path $Export | Out-Null
        # zip + Expand-Archive, not tar: which tar is on PATH varies (GNU tar reads C: as a host).
        $zipFile = "$Export.zip"
        & git -C $RepoRoot archive --format=zip -o $zipFile $Commit -- skills
        if ($LASTEXITCODE -ne 0) { throw "git archive $Ref failed." }
        Expand-Archive -LiteralPath $zipFile -DestinationPath $Export
        Remove-Item $zipFile -Force
        $SkillsRoot  = Join-Path $Export 'skills'
        $SourceLabel = $Ref
    }

    # Which tier are we installing? -List with no tier means "show everything".
    $SearchRoot = switch ($PSCmdlet.ParameterSetName) {
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
                ForEach-Object { $_.Substring($SkillsRoot.Length).TrimStart('\','/') }) -join ' , ')
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

    # ---------------------------------------------------------------- helpers

    function Get-RepoPath([IO.DirectoryInfo] $Leaf) {
        'skills/' + ($Leaf.FullName.Substring($SkillsRoot.Length).TrimStart('\','/') -replace '\\','/')
    }

    function Test-IsLink([string] $Path) {
        $item = Get-Item -LiteralPath $Path -Force -ErrorAction SilentlyContinue
        [bool]($item -and ($item.Attributes -band [IO.FileAttributes]::ReparsePoint))
    }

    # True when $Path or any folder between it and $Stop is a link: deleting there could
    # reach a folder this run just wrote (a junctioned retired folder, say).
    function Test-UnderLink([string] $Path, [string] $Stop) {
        $stopFull = [IO.Path]::GetFullPath($Stop).TrimEnd('\','/')
        $p = [IO.Path]::GetFullPath($Path).TrimEnd('\','/')
        while ($p -and $p.Length -gt $stopFull.Length) {
            if (Test-IsLink $p) { return $true }
            $p = Split-Path $p -Parent
        }
        $false
    }

    # Every SKILL.md blob this repo has ever shipped for a skill of this name, so a copy
    # installed before the marker existed (or by another tool from this repo) is still
    # recognised as a previous install rather than the user's own skill.
    $shippedCache = @{}
    function Get-ShippedBlobs([string] $Name) {
        if (-not $HaveGit) { return @() }
        if (-not $shippedCache.ContainsKey($Name)) {
            $raw = Invoke-Git log --all --format= --raw --no-abbrev -- "skills/*/$Name/SKILL.md"
            $shippedCache[$Name] = @($raw | ForEach-Object { ($_ -split '\s+')[2..3] } |
                Where-Object { $_ -match '^[0-9a-f]{40}$' -and $_ -notmatch '^0+$' } | Sort-Object -Unique)
        }
        $shippedCache[$Name]
    }

    # 'ours' = a previous install from this repo; 'link'; 'foreign' = someone else's folder.
    function Get-Ownership([string] $Folder, [string] $Name, [string] $RepoPath) {
        if (Test-IsLink $Folder) { return 'link' }
        if (Test-Path -LiteralPath (Join-Path $Folder $MarkerName)) { return 'ours' }
        $skillMd = Join-Path $Folder 'SKILL.md'
        if ((Test-Path -LiteralPath $skillMd) -and $HaveGit) {
            $blob = Invoke-Git hash-object "--path=$RepoPath/SKILL.md" -- $skillMd
            if ($blob -and ($blob -in (Get-ShippedBlobs $Name))) { return 'ours' }
        }
        'foreign'
    }

    function Copy-SkillTree([string] $From, [string] $To) {
        New-Item -ItemType Directory -Path $To -Force | Out-Null
        foreach ($f in Get-ChildItem -LiteralPath $From -Recurse -File -Force) {
            $rel = [IO.Path]::GetRelativePath($From, $f.FullName)
            $parts = $rel -split '[\\/]'
            if ($parts.Count -gt 1 -and ($parts[0..($parts.Count - 2)] | Where-Object { $_ -in $SkipDirs })) { continue }
            if ($SkipFiles | Where-Object { $f.Name -like $_ }) { continue }
            $dest = Join-Path $To $rel
            $dir = Split-Path $dest -Parent
            if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
            Copy-Item -LiteralPath $f.FullName -Destination $dest -Force
        }
    }

    # Build the new copy in a staging folder beside the destination (never inside it, where
    # a CLI would read a half-built skill), then swap with renames. Renaming a folder that
    # holds an open file fails on Windows, so a locked install stays as it was.
    function Install-Leaf([IO.DirectoryInfo] $Leaf, [string] $DestPath, [string] $Target) {
        $stageRoot = Join-Path (Split-Path ([IO.Path]::GetFullPath($DestPath)) -Parent) '.agent-skills-staging'
        [void]$StageRoots.Add($stageRoot)
        $id    = [guid]::NewGuid().ToString('N').Substring(0, 8)
        $stage = Join-Path $stageRoot "$($Leaf.Name).new-$id"
        $old   = Join-Path $stageRoot "$($Leaf.Name).old-$id"
        try {
            Copy-SkillTree $Leaf.FullName $stage
            @(
                'source: ai-automation-tools/agent-skills'
                "path: $(Get-RepoPath $Leaf)"
                "ref: $SourceLabel"
                "commit: $(if ($Commit) { $Commit } else { 'unknown (not a git clone)' })"
                "installed: $([DateTime]::UtcNow.ToString('yyyy-MM-ddTHH:mm:ssZ'))"
            ) | Set-Content -LiteralPath (Join-Path $stage $MarkerName) -Encoding utf8NoBOM
            if (Test-Path -LiteralPath $Target) { Move-Item -LiteralPath $Target -Destination $old }
            try {
                Move-Item -LiteralPath $stage -Destination $Target
            } catch {
                if (Test-Path -LiteralPath $old) { Move-Item -LiteralPath $old -Destination $Target }
                throw
            }
        } finally {
            foreach ($p in $stage, $old) {
                if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Recurse -Force -ErrorAction SilentlyContinue }
            }
        }
        (Get-ChildItem -LiteralPath $Target -Recurse -File -Force | Where-Object Name -ne $MarkerName).Count
    }

    # ---------------------------------------------------------------- destinations

    # Where this lands: one -Destination, or the shared folders every installed CLI reads.
    # The CLIs overlap: opencode also reads ~/.claude/skills and ~/.agents/skills, Kilo
    # reads ~/.agents/skills, agy reads ~/.gemini/config/skills. So three folders reach
    # all of them, and writing each CLI's own folder too only listed skills twice.
    # Paths re-checked 2026-11-11 against each CLI's own docs (table in docs/USING-SKILLS.md).
    # One list, in install-targets.json, so a scheduled sync can read the same targets.
    $targets = Get-Content -Raw (Join-Path $PSScriptRoot 'install-targets.json') | ConvertFrom-Json

    $destinations = [ordered]@{}
    if ($AllAgents) {
        foreach ($t in $targets.shared) {
            if ($t.roots | Where-Object { Test-Path (Join-Path $HOME $_) }) {
                $destinations[$t.label] = Join-Path $HOME $t.dir
            } else {
                Write-Host ("Skipping {0} — none of {1} found on this machine." -f $t.dir, (($t.roots | ForEach-Object { "~/$_" }) -join ', ')) -ForegroundColor DarkGray
            }
        }
        if (-not $destinations.Count) { throw "None of the known agent CLI folders exist under $HOME. Nothing to install to." }
    } else {
        $destinations[''] = $Destination
    }

    Write-Host "Source: $SourceLabel$(if ($Commit) { " at $($Commit.Substring(0, 12))" })" -ForegroundColor Cyan

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
            $state  = 'New'
            if (Test-Path -LiteralPath $target) {
                $owner = Get-Ownership $target $name (Get-RepoPath $leaf)
                if ($owner -eq 'link') {
                    Write-Warning "Skipped $target`: it is a link, and the installer never replaces or deletes through one. Remove the link yourself to install here."
                    [pscustomobject]@{ Skill = $name; State = 'Skipped (link)'; Files = 0; Target = $target }
                    continue
                }
                if ($owner -eq 'foreign' -and -not $Force) {
                    Write-Warning "Skipped $target`: a folder with this name exists and isn't a previous install from this repo (no $MarkerName marker, SKILL.md matches no shipped version). Rename one of them, or pass -Force to replace it."
                    [pscustomobject]@{ Skill = $name; State = 'Skipped (not ours)'; Files = 0; Target = $target }
                    continue
                }
                $state = if ($owner -eq 'ours') { 'Replaced' } else { 'Replaced (-Force)' }
            }

            if ($PSCmdlet.ShouldProcess($target, "Mirror skill '$name'")) {
                try {
                    $files = Install-Leaf $leaf $DestPath $target
                    [pscustomobject]@{ Skill = $name; State = $state; Files = $files; Target = $target }
                } catch {
                    $failures++
                    Write-Warning "Failed to install $name to $target (the previous copy, if any, is unchanged): $($_.Exception.Message)"
                    [pscustomobject]@{ Skill = $name; State = 'Failed'; Files = 0; Target = $target }
                }
            }
        }

        if ($results) { $results | Format-Table -AutoSize }
    }

    # Remove the duplicates older -AllAgents runs left in the retired folders: only previous
    # installs from this repo named like a skill this run installed, never through a link.
    if ($AllAgents) {
        foreach ($dir in $targets.retired) {
            foreach ($leaf in $leaves) {
                $old = Join-Path (Join-Path $HOME $dir) $leaf.Name
                if (-not (Test-Path -LiteralPath $old)) { continue }
                if (Test-UnderLink $old $HOME) {
                    Write-Warning "Left $old alone: it is, or sits under, a link, so removing it could delete a live install."
                    continue
                }
                if ((Get-Ownership $old $leaf.Name (Get-RepoPath $leaf)) -ne 'ours') {
                    Write-Warning "Left $old alone: it isn't a previous install from this repo."
                    continue
                }
                if ($PSCmdlet.ShouldProcess($old, 'Remove copy from a folder -AllAgents no longer writes')) {
                    try {
                        Remove-Item -LiteralPath $old -Recurse -Force
                        Write-Host "Removed old copy $old" -ForegroundColor DarkYellow
                    } catch {
                        $failures++
                        Write-Warning "Couldn't remove old copy $old`: $($_.Exception.Message)"
                    }
                }
            }
        }
    }
}
finally {
    if ($Export -and (Test-Path $Export)) { Remove-Item $Export -Recurse -Force -ErrorAction SilentlyContinue }
    foreach ($s in $StageRoots) {
        if ((Test-Path $s) -and -not (Get-ChildItem -LiteralPath $s -Force)) { Remove-Item -LiteralPath $s -Force -ErrorAction SilentlyContinue }
    }
}

if ($failures) {
    Write-Host "$failures step(s) failed; see the warnings above. Everything else installed." -ForegroundColor Red
    exit 1
}
Write-Host "Done. Restart any open agent session to reload the skill catalog." -ForegroundColor Green
