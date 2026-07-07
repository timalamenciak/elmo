# Quick local QC loop: ELK reasoning, SPARQL verification, and an OBO
# quality report.
#
# Runs entirely locally via ROBOT -- no Docker or make required, and much
# faster than a full Docker test run. Use this after editing a TSV template
# and running build-components.ps1, to catch problems before a full release.
#
# Override the ROBOT jar location with $env:ROBOT_JAR if yours isn't at the
# default path below:
#   $env:ROBOT_JAR = "C:\path\to\robot.jar"; .\helper_scripts\check.ps1
$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$OntologyDir = Join-Path $ScriptDir "..\src\ontology"
$RobotJar = if ($env:ROBOT_JAR) { $env:ROBOT_JAR } else { "C:\Users\Tim Alamenciak\Documents\TReK\Racoon\ROBOT\robot.jar" }
function robot { java -jar $RobotJar @args }

Set-Location $OntologyDir
New-Item -ItemType Directory -Force -Path tmp, reports | Out-Null

Write-Host "== Preprocessing (converting to functional syntax for the reasoner) =="
robot convert --input elmo-edit.owl --format ofn --output tmp\elmo-preprocess.owl
Write-Host ""

Write-Host "== Reasoning (ELK) -- checking for unsatisfiable classes =="
robot reason `
  --catalog catalog-v001.xml `
  --input tmp\elmo-preprocess.owl `
  --reasoner ELK `
  --equivalent-classes-allowed all `
  --exclude-tautologies structural `
  --output tmp\reason-test.owl
Remove-Item -Force tmp\reason-test.owl
Write-Host "No unsatisfiable classes found."
Write-Host ""

Write-Host "== SPARQL verification -- missing labels/definitions, IRI issues =="
$VerifyFailed = $false
try {
    robot merge `
      --catalog catalog-v001.xml `
      --input elmo-edit.owl `
      verify `
      --queries ..\sparql\missing-definitions.sparql `
                ..\sparql\missing-labels.sparql `
                ..\sparql\none-definitions.sparql `
      --output-dir reports
} catch {
    $VerifyFailed = $true
}
Write-Host ""

Write-Host "== OBO quality report =="
$ReportFailed = $false
try {
    robot merge `
      --catalog catalog-v001.xml `
      --input elmo-edit.owl `
      report `
      --output reports\elmo-edit.owl-obo-report.tsv
} catch {
    $ReportFailed = $true
}

Write-Host ""
if ($VerifyFailed) {
    Write-Host "Verification reported FAIL above -- ELMO:0000000 (the root node) is a"
    Write-Host "known, permanent exception with no real definition; anything else"
    Write-Host "listed is worth investigating."
}
if ($ReportFailed) {
    Write-Host "The report above includes ERROR-level violations. As of the last full"
    Write-Host "audit, all such errors were on IMPORTED terms (BFO/ENVO/RO/GO/IAO),"
    Write-Host "not ELMO's own terms -- check reports\elmo-edit.owl-obo-report.tsv"
    Write-Host "and confirm any ERROR rows are on non-ELMO: entities."
}
Write-Host "All checks complete. See src\ontology\reports\ for the full report and"
Write-Host "verification output. If a class is unsatisfiable, use explain.ps1 to see why."

if ($VerifyFailed -or $ReportFailed) {
    exit 1
}
