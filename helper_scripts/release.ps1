# Run the full official ODK release pipeline: refreshes imports, rebuilds
# components/patterns, reasons over the merged ontology, and writes
# base/simple/full release artifacts (OWL/OBO/JSON) to the repo root.
# Requires Docker Desktop running.
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

# Docker needs forward-slash paths for volume mounts on Windows
$DockerRepoRoot = $RepoRoot.Replace('\', '/')

$MakeTarget = if ($env:SKIP_IMPORTS -eq "1") { "IMP=false prepare_release" } else { "prepare_release" }

docker run --rm `
    -v "${DockerRepoRoot}:/work" `
    -w /work/src/ontology `
    -e "ROBOT_JAVA_ARGS=-Xmx8G" `
    -e "JAVA_OPTS=-Xmx8G" `
    obolibrary/odkfull:latest `
    make $MakeTarget

Write-Host ""
Write-Host "Release files are now in the repo root. Review the diff, then commit,"
Write-Host "push, and cut a release on GitHub -- this script does not do that for you."
