<#
.SYNOPSIS
    Scaffolds a new Project Hub — Mode A (sibling hub) or Mode B (standalone copy).
    See ../SKILL.md and ../references/ for what these modes mean and when to pick each.

.DESCRIPTION
    Mode A (default): creates Project-Hub-<Name> next to the existing hubs under
    HubDesignRoot, writes its hub.config.json, and copies the generic Start-Hub.ps1 shim.
    Does NOT touch Hub/hub.mjs or Hub/index.html — the new hub shares that engine.

    Mode B (-Standalone): copies the whole Hub/ engine (hub.mjs, index.html,
    Start-Hub.ps1, package.json, hub.test.mjs) into -TargetDir, plus a hub.config.json
    beside it. Use only when the target project can't depend on HubDesignRoot's path —
    see SKILL.md's mode-decision table. This script does NOT edit the copy's ROOTS /
    USER_RUNTIMES constants in hub.mjs; that edit is environment-specific and manual by
    design (see references/config-schema.md).

    Neither mode starts the server or runs tests — run `npm test` in Hub/ (Mode A) or in
    the copy (Mode B), then start it yourself, per SKILL.md's execution checklist.

.PARAMETER Name
    Workspace name. Becomes hub.config.json "name", the folder suffix
    (Project-Hub-<Name>) in Mode A, and the default title.

.PARAMETER Dir
    Absolute path to the workspace/project this hub should scan (hub.config.json "dir").
    Must exist — this script checks.

.PARAMETER Port
    Port for this hub. Must be 1024-65535 and not already used by a sibling
    hub.config.json under HubDesignRoot. Pick whatever port-block convention your
    existing hubs use (if any).

.PARAMETER Title
    Optional browser-tab title. Defaults to "Project Hub — <Name>".

.PARAMETER Glyph
    1-2 character favicon glyph. Defaults to the first letter of -Name, uppercased.

.PARAMETER Ink
    Favicon accent hex. Defaults to a mid green — pick one distinct from your other hubs'.

.PARAMETER Line
    Favicon line hex (darker shade of -Ink). Defaults to a matching darker green.

.PARAMETER RepoScopeGroups
    Optional string array for hub.config.json's repoScope.groups (a Repos/<group>/ tier).
    Mutually exclusive with -RepoScopePathPrefix.

.PARAMETER RepoScopePathPrefix
    Optional string for hub.config.json's repoScope.pathPrefix (a flat Repos/ folder).
    Mutually exclusive with -RepoScopeGroups.

.PARAMETER HubDesignRoot
    Path to the folder that holds the shared Hub/ engine and its sibling
    Project-Hub-* config folders (Mode A) or that the engine is copied out of (Mode B).
    Required — no default, since this path is specific to each install.

.PARAMETER Standalone
    Switch. Selects Mode B: copies the Hub/ engine into -TargetDir instead of adding a
    sibling folder under HubDesignRoot.

.PARAMETER TargetDir
    Mode B only: where to copy the Hub/ engine + write its hub.config.json.

.EXAMPLE
    .\scaffold-hub.ps1 -Name "MyNewProject" -Dir "C:\Work\MyNewProject" -Port 4276 `
        -HubDesignRoot "C:\Tools\HTML-Project-Design"

.EXAMPLE
    .\scaffold-hub.ps1 -Name "ClientSite" -Dir "C:\Work\ClientSite" -Port 4300 `
        -HubDesignRoot "C:\Tools\HTML-Project-Design" `
        -RepoScopePathPrefix "Repos" -Glyph "C" -Ink "#e0a458" -Line "#6d5424"

.EXAMPLE
    .\scaffold-hub.ps1 -Standalone -Name "PortableConsole" -Dir "C:\Work\OtherRepo" `
        -Port 4400 -HubDesignRoot "C:\Tools\HTML-Project-Design" `
        -TargetDir "C:\Work\OtherRepo\tools\project-console"
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string] $Name,
    [Parameter(Mandatory)] [string] $Dir,
    [Parameter(Mandatory)] [ValidateRange(1024, 65535)] [int] $Port,
    [string] $Title,
    [string] $Glyph,
    [string] $Ink = '#5fd6a1',
    [string] $Line = '#2f6b52',
    [string[]] $RepoScopeGroups,
    [string] $RepoScopePathPrefix,
    [Parameter(Mandatory)] [string] $HubDesignRoot,
    [switch] $Standalone,
    [string] $TargetDir
)

$ErrorActionPreference = 'Stop'

if ($RepoScopeGroups -and $RepoScopePathPrefix) {
    throw 'Set -RepoScopeGroups or -RepoScopePathPrefix, not both (hub.config.json rejects both set together).'
}
if (-not (Test-Path -LiteralPath $Dir -PathType Container)) {
    throw "Dir does not exist: $Dir (hub.config.json's `"dir`" must point at a real folder)."
}
if (-not $Title) { $Title = "Project Hub — $Name" }
if (-not $Glyph) { $Glyph = $Name.Substring(0, 1).ToUpperInvariant() }

$hubEngine = Join-Path $HubDesignRoot 'Hub'
if (-not (Test-Path -LiteralPath (Join-Path $hubEngine 'hub.mjs'))) {
    throw "Shared engine not found at $hubEngine — is -HubDesignRoot correct?"
}

# Normalize to forward slashes for the JSON config, per the house convention.
$dirNormalized = ($Dir -replace '\\', '/').TrimEnd('/')

$configObj = [ordered]@{
    name  = $Name
    dir   = $dirNormalized
    port  = $Port
    title = $Title
    favicon = [ordered]@{ glyph = $Glyph; ink = $Ink; line = $Line }
}
if ($RepoScopeGroups) {
    $configObj.repoScope = [ordered]@{ groups = $RepoScopeGroups }
} elseif ($RepoScopePathPrefix) {
    $configObj.repoScope = [ordered]@{ pathPrefix = $RepoScopePathPrefix }
}

if ($Standalone) {
    if (-not $TargetDir) { throw '-TargetDir is required with -Standalone (Mode B).' }
    New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null

    foreach ($file in 'hub.mjs', 'index.html', 'Start-Hub.ps1', 'package.json', 'hub.test.mjs') {
        $src = Join-Path $hubEngine $file
        if (Test-Path -LiteralPath $src) {
            Copy-Item -LiteralPath $src -Destination (Join-Path $TargetDir $file) -Force
        }
    }

    $configObj | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $TargetDir 'hub.config.json') -Encoding utf8NoBOM

    Write-Host "Standalone hub scaffolded at $TargetDir"
    Write-Host 'Next: edit its hub.mjs ROOTS / USER_RUNTIMES constants for this environment (see ../references/config-schema.md), then:'
    Write-Host "  cd `"$TargetDir`""
    Write-Host '  npm test'
    Write-Host '  node hub.mjs --config hub.config.json'
} else {
    # Mode A: check port uniqueness against every sibling hub.config.json before writing.
    $siblingConfigs = Get-ChildItem -Path $HubDesignRoot -Directory -Filter 'Project-Hub*' |
        ForEach-Object { Join-Path $_.FullName 'hub.config.json' } |
        Where-Object { Test-Path -LiteralPath $_ }

    foreach ($cfgPath in $siblingConfigs) {
        $existing = Get-Content -LiteralPath $cfgPath -Raw | ConvertFrom-Json
        if ($existing.port -eq $Port) {
            throw "Port $Port is already used by $cfgPath (name: $($existing.name)). Pick another."
        }
    }

    $newFolder = Join-Path $HubDesignRoot "Project-Hub-$Name"
    if (Test-Path -LiteralPath $newFolder) {
        throw "$newFolder already exists — pick a different -Name or remove it first."
    }
    New-Item -ItemType Directory -Path $newFolder | Out-Null

    $configObj | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $newFolder 'hub.config.json') -Encoding utf8NoBOM

    # The shim is identical across every hub folder — copy one verbatim, never author a new one.
    $anySibling = Get-ChildItem -Path $HubDesignRoot -Directory -Filter 'Project-Hub*' |
        Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'Start-Hub.ps1') } |
        Select-Object -First 1
    if ($anySibling) {
        Copy-Item -LiteralPath (Join-Path $anySibling.FullName 'Start-Hub.ps1') -Destination (Join-Path $newFolder 'Start-Hub.ps1') -Force
    } else {
        Copy-Item -LiteralPath (Join-Path $hubEngine 'Start-Hub.ps1') -Destination (Join-Path $newFolder 'Start-Hub.ps1') -Force
    }

    Write-Host "Hub scaffolded at $newFolder"
    Write-Host 'Next:'
    Write-Host "  cd `"$hubEngine`"; npm test"
    Write-Host "  cd `"$newFolder`"; .\Start-Hub.ps1"
    Write-Host "Then update $HubDesignRoot's README (or wherever the hub family is tracked) with the new hub (see ../SKILL.md step 7)."
}
