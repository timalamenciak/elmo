# Refresh all ODK imports and mirrors (RO, BFO, ENVO, PATO, COB, ORCIDIO)
# via the official Docker-based ODK pipeline. Requires Docker Desktop running.
#
# To refresh just one import instead of all of them, call docker run directly:
#   $RepoRoot = (Resolve-Path .).Path.Replace('\','/')
#   docker run --rm -v "${RepoRoot}:/work" -w /work/src/ontology -e ROBOT_JAVA_ARGS=-Xmx8G -e JAVA_OPTS=-Xmx8G obolibrary/odkfull:latest make refresh-envo
#   (or refresh-ro, refresh-bfo, refresh-pato, refresh-cob, refresh-orcidio)
$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..")).Path

# Docker needs forward-slash paths for volume mounts on Windows
$DockerRepoRoot = $RepoRoot.Replace('\', '/')

docker run --rm `
    -v "${DockerRepoRoot}:/work" `
    -w /work/src/ontology `
    -e "ROBOT_JAVA_ARGS=-Xmx8G" `
    -e "JAVA_OPTS=-Xmx8G" `
    obolibrary/odkfull:latest `
    make refresh-imports
