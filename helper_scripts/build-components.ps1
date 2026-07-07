# Rebuild the interventions, ecosystems, and variables OWL components from
# their TSV templates (src/templates/*.tsv).
#
# Runs entirely locally via ROBOT -- no Docker or make required. Mirrors the
# ROBOT pipeline defined in src/ontology/elmo.Makefile. Run this after editing
# any TSV, before checking your work (see check.ps1) or regenerating docs
# (see update-docs.ps1).
#
# Override the ROBOT jar location with $env:ROBOT_JAR if yours isn't at the
# default path below:
#   $env:ROBOT_JAR = "C:\path\to\robot.jar"; .\helper_scripts\build-components.ps1
$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$OntologyDir = Join-Path $ScriptDir "..\src\ontology"
$RobotJar = if ($env:ROBOT_JAR) { $env:ROBOT_JAR } else { "C:\Users\Tim Alamenciak\Documents\TReK\Racoon\ROBOT\robot.jar" }
function robot { java -jar $RobotJar @args }

$OntBase = "https://w3id.org/elmo/elmo"
$Today = Get-Date -Format "yyyy-MM-dd"

Set-Location $OntologyDir

Write-Host "== Rebuilding interventions.owl =="
robot template `
  --catalog catalog-v001.xml `
  --prefix "ELMO: https://w3id.org/elmo/elmo_" `
  --prefix "skos: http://www.w3.org/2004/02/skos/core#" `
  --prefix "ELMOP: https://w3id.org/elmo/property/" `
  --input elmo-edit.owl `
  --template ..\templates\interventions.tsv `
  annotate --ontology-iri "$OntBase/components/interventions.owl" `
           -V "$OntBase/releases/$Today/components/interventions.owl" `
           --annotation owl:versionInfo $Today `
  convert -f ofn --output components\interventions.owl.tmp.owl
Move-Item -Force components\interventions.owl.tmp.owl components\interventions.owl
Write-Host "interventions.owl rebuilt."
Write-Host ""

Write-Host "== Rebuilding ecosystems.owl =="
robot template `
  --catalog catalog-v001.xml `
  --prefix "ELMO: https://w3id.org/elmo/elmo_" `
  --input elmo-edit.owl `
  --template ..\templates\ecosystems.tsv `
  annotate --ontology-iri "$OntBase/components/ecosystems.owl" `
           -V "$OntBase/releases/$Today/components/ecosystems.owl" `
           --annotation owl:versionInfo $Today `
  convert -f ofn --output components\ecosystems.owl.tmp.owl
Move-Item -Force components\ecosystems.owl.tmp.owl components\ecosystems.owl
Write-Host "ecosystems.owl rebuilt."
Write-Host ""

Write-Host "== Rebuilding variables.owl =="
robot template `
  --catalog catalog-v001.xml `
  --prefix "ELMO: https://w3id.org/elmo/elmo_" `
  --prefix "skos: http://www.w3.org/2004/02/skos/core#" `
  --input elmo-edit.owl `
  --template ..\templates\variables.tsv `
  annotate --ontology-iri "$OntBase/components/variables.owl" `
           -V "$OntBase/releases/$Today/components/variables.owl" `
           --annotation owl:versionInfo $Today `
  convert -f ofn --output components\variables.owl.tmp.owl
Move-Item -Force components\variables.owl.tmp.owl components\variables.owl
Write-Host "variables.owl rebuilt."
