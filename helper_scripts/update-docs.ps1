# Regenerate the local HTML documentation -- docs/elmo.html (via
# owl2mkdocs.py) and docs/lode.html (via PyLODE) -- from the current
# elmo.owl in the repo root.
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

Set-Location $OntologyDir

Write-Host "== Regenerating docs/elmo.html =="
python scripts\owl2mkdocs.py "$RepoRoot\elmo.owl"
Write-Host ""

Write-Host "== Regenerating docs/lode.html (PyLODE) =="
$pylodeCheck = python -c "import pylode" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "PyLODE is not installed locally. Install it with: pip install pylode"
    exit 1
}
python -m pylode -o "$RepoRoot\docs\lode.html" "$RepoRoot\elmo.owl"
