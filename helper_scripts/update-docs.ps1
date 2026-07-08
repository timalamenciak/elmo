# Regenerate the local HTML documentation -- docs/elmo.html (via
# owl2mkdocs.py) and docs/lode.html (via PyLODE) -- from a freshly merged
# local ontology assembled from src/ontology/elmo-edit.owl and its imports.
#
# This only updates files in your working tree; it does NOT publish
# anything. To publish the mkdocs site to GitHub Pages, run the Docker-based
# update_docs target instead (requires GitHub credentials):
#   cd src\ontology; sh run.sh make update_docs
# See docs/odk-workflows/ManageDocumentation.md for details.
$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Join-Path $ScriptDir ".."
$OntologyDir = Join-Path $RepoRoot "src\ontology"
$RobotJar = if ($env:ROBOT_JAR) { $env:ROBOT_JAR } else { "C:\Users\Tim Alamenciak\Documents\TReK\Racoon\ROBOT\robot.jar" }
function robot { java -jar $RobotJar @args }
$DocsOntology = Join-Path $OntologyDir "tmp\elmo-docs-merged.owl"

Set-Location $OntologyDir
New-Item -ItemType Directory -Force -Path tmp | Out-Null

Write-Host "== Preparing merged ontology for docs =="
robot merge --catalog catalog-v001.xml --input elmo-edit.owl --output $DocsOntology
Write-Host ""

Write-Host "== Regenerating docs/elmo.html =="
python scripts\owl2mkdocs.py $DocsOntology
Write-Host ""

Write-Host "== Regenerating docs/lode.html (PyLODE) =="
python -c "import importlib.util, sys; sys.exit(0 if importlib.util.find_spec('pylode') else 1)" > $null
if ($LASTEXITCODE -ne 0) {
    Write-Error "PyLODE is not installed for this Python. Install it with: python -m pip install pylode"
    exit 1
}
python -m pylode -o "$RepoRoot\docs\lode.html" $DocsOntology
