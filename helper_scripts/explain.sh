#!/usr/bin/env bash
# Explain why a class is unsatisfiable (i.e. why the reasoner concluded it's
# equivalent to owl:Nothing). Runs locally via ROBOT -- no Docker or `make`
# required.
#
# Usage: helper_scripts/explain.sh <class-IRI>
#   e.g. helper_scripts/explain.sh "https://w3id.org/elmo/elmo_3620001"
#
# Run check.sh first -- its "reason" step is what will tell you a class has
# become unsatisfiable in the first place.
#
# Override the ROBOT jar location with the ROBOT_JAR environment variable if
# yours isn't at the default path below:
#   ROBOT_JAR=/path/to/robot.jar ./explain.sh <IRI>
set -euo pipefail
if [ $# -ne 1 ]; then
  echo "Usage: $0 <class-IRI>" >&2
  echo 'e.g.   ./explain.sh "https://w3id.org/elmo/elmo_3620001"' >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ONTOLOGY_DIR="$SCRIPT_DIR/../src/ontology"
ROBOT_JAR="${ROBOT_JAR:-C:/Users/Tim Alamenciak/Documents/TReK/Racoon/ROBOT/robot.jar}"
robot() { java -jar "$ROBOT_JAR" "$@"; }

cd "$ONTOLOGY_DIR"
mkdir -p tmp reports

echo "== Preprocessing (converting to functional syntax for the reasoner) =="
robot convert --input elmo-edit.owl --format ofn --output tmp/elmo-preprocess.owl
echo

# ROBOT's `explain --axiom` parses Manchester syntax, which needs the class
# referred to by its quoted rdfs:label (a bare <IRI> or SubClassOf(<IRI> ...)
# functional-syntax axiom is NOT accepted here) -- so resolve the label first.
# elmo-edit.owl only *asserts* its own owl:imports -- the actual class
# declarations live in the imported components. ROBOT/OWLAPI follow those
# imports automatically when loading for reasoning, but rdflib does not, so
# merge everything into one throwaway RDF/XML file via ROBOT for the lookup.
robot merge --catalog catalog-v001.xml --input elmo-edit.owl \
  convert --format owl --output tmp/elmo-edit-merged.owl

LABEL="$(python - "$1" <<'PYEOF'
import sys
from rdflib import Graph, URIRef, RDFS

g = Graph()
g.parse("tmp/elmo-edit-merged.owl", format="xml")
label = g.value(URIRef(sys.argv[1]), RDFS.label)
if label is None:
    sys.exit(f"No label found for {sys.argv[1]} -- is this the right IRI?")
print(str(label))
PYEOF
)"

echo "== Explaining unsatisfiability of $1 ('$LABEL') =="
robot explain \
  --catalog catalog-v001.xml \
  --input tmp/elmo-preprocess.owl \
  --reasoner ELK \
  --axiom "'$LABEL' SubClassOf: owl:Nothing" \
  --explanation reports/explanation.md

echo "See src/ontology/reports/explanation.md"
