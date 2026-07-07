# Explain why a class is unsatisfiable (i.e. why the reasoner concluded it's
# equivalent to owl:Nothing). Runs locally via ROBOT -- no Docker or make
# required.
#
# Usage: .\helper_scripts\explain.ps1 <class-IRI>
#   e.g. .\helper_scripts\explain.ps1 "https://w3id.org/elmo/elmo_3620001"
#
# Run check.ps1 first -- its "reason" step is what will tell you a class has
# become unsatisfiable in the first place.
#
# Override the ROBOT jar location with $env:ROBOT_JAR if yours isn't at the
# default path below:
#   $env:ROBOT_JAR = "C:\path\to\robot.jar"; .\helper_scripts\explain.ps1 <IRI>
param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$ClassIRI
)
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

# Resolve the rdfs:label for the class IRI using rdflib (same approach as the
# bash version: merge first so imports are followed, then look up the label).
robot merge --catalog catalog-v001.xml --input elmo-edit.owl `
  convert --format owl --output tmp\elmo-edit-merged.owl

$PythonScript = @"
import sys
from rdflib import Graph, URIRef, RDFS

g = Graph()
g.parse("tmp/elmo-edit-merged.owl", format="xml")
label = g.value(URIRef(sys.argv[1]), RDFS.label)
if label is None:
    sys.exit(f"No label found for {sys.argv[1]} -- is this the right IRI?")
print(str(label))
"@

$Label = python -c $PythonScript $ClassIRI
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "== Explaining unsatisfiability of $ClassIRI ('$Label') =="
robot explain `
  --catalog catalog-v001.xml `
  --input tmp\elmo-preprocess.owl `
  --reasoner ELK `
  --axiom "'$Label' SubClassOf: owl:Nothing" `
  --explanation reports\explanation.md

Write-Host "See src\ontology\reports\explanation.md"
