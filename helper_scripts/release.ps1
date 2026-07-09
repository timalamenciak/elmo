# Run the full official ODK release pipeline: refreshes imports, rebuilds
# components/patterns, reasons over the merged ontology, and writes
# base/simple/full release artifacts (OWL/OBO/JSON) to the repo root.
# Requires Docker Desktop running.
#
# Equivalent to running in the ODK container, from src/ontology:
#   sh run.sh make prepare_release
#
# Set $env:SKIP_IMPORTS = "1" to skip re-downloading imports (faster re-runs
# once you've already refreshed them recently):
#   $env:SKIP_IMPORTS = "1"; .\helper_scripts\release.ps1
#
# This script does NOT commit, push, or cut a GitHub release for you --
# review the changed release files first.
$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..")).Path

# Docker needs forward-slash paths for volume mounts on Windows.
$DockerRepoRoot = $RepoRoot.Replace('\', '/')

$MakeArgs = @(
    if ($env:SKIP_IMPORTS -eq "1") {
        "IMP=false"
    }
    "-B"
    "prepare_release"
)

$ReleaseAssets = @(
    "elmo.json"
    "elmo.obo"
    "elmo.owl"
    "elmo-base.json"
    "elmo-base.obo"
    "elmo-base.owl"
    "elmo-full.json"
    "elmo-full.obo"
    "elmo-full.owl"
    "elmo-simple.json"
    "elmo-simple.obo"
    "elmo-simple.owl"
    "patterns\definitions.owl"
    "patterns\pattern.owl"
)

$DockerArgs = @(
    "run"
    "--rm"
    "-v"
    "${DockerRepoRoot}:/work"
    "-w"
    "/work/src/ontology"
    "-e"
    "ROBOT_JAVA_ARGS=-Xmx8G"
    "-e"
    "JAVA_OPTS=-Xmx8G"
    "obolibrary/odkfull:latest"
    "make"
) + $MakeArgs

$BackupDir = Join-Path ([System.IO.Path]::GetTempPath()) ("elmo-release-assets-" + [guid]::NewGuid().ToString("N"))
$BackedUpAssets = @()

try {
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null

    foreach ($RelativePath in $ReleaseAssets) {
        $SourcePath = Join-Path $RepoRoot $RelativePath
        if (Test-Path -LiteralPath $SourcePath) {
            $BackupPath = Join-Path $BackupDir $RelativePath
            New-Item -ItemType Directory -Path (Split-Path -Parent $BackupPath) -Force | Out-Null
            Move-Item -LiteralPath $SourcePath -Destination $BackupPath -Force
            $BackedUpAssets += [pscustomobject]@{
                RelativePath = $RelativePath
                BackupPath = $BackupPath
            }
        }
    }

    & docker @DockerArgs
    $ExitCode = $LASTEXITCODE

    if ($ExitCode -ne 0) {
        foreach ($Asset in $BackedUpAssets) {
            $TargetPath = Join-Path $RepoRoot $Asset.RelativePath
            Remove-Item -LiteralPath $TargetPath -Force -ErrorAction SilentlyContinue
            New-Item -ItemType Directory -Path (Split-Path -Parent $TargetPath) -Force | Out-Null
            Move-Item -LiteralPath $Asset.BackupPath -Destination $TargetPath -Force
        }
        exit $ExitCode
    }
} finally {
    Remove-Item -LiteralPath $BackupDir -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Release files are now in the repo root. Review the diff, then commit,"
Write-Host "push, and cut a release on GitHub -- this script does not do that for you."
