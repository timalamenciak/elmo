#!/usr/bin/env bash
# Quick local QC loop: ELK reasoning, SPARQL verification, and an OBO
# quality report.
#
# Runs entirely locally via ROBOT -- no Docker or `make` required (neither is
# assumed to be installed), and much faster than a full Docker `test` run.
# Use this after editing a TSV template and running build-components.sh, to
# catch problems before doing a full release.
#
# Override the ROBOT jar location with the ROBOT_JAR environment variable if
# yours isn't at the default path below:
#   ROBOT_JAR=/path/to/robot.jar ./check.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ONTOLOGY_DIR="$SCRIPT_DIR/../src/ontology"
ROBOT_JAR="${ROBOT_JAR:-C:/Users/Tim Alamenciak/Documents/TReK/Racoon/ROBOT/robot.jar}"
robot() { java -jar "$ROBOT_JAR" "$@"; }

cd "$ONTOLOGY_DIR"
mkdir -p tmp reports

echo "== Preprocessing (converting to functional syntax for the reasoner) =="
robot convert --input elmo-edit.owl --format ofn --output tmp/elmo-preprocess.owl
echo

echo "== Reasoning (ELK) -- checking for unsatisfiable classes =="
robot reason \
  --catalog catalog-v001.xml \
  --input tmp/elmo-preprocess.owl \
  --reasoner ELK \
  --equivalent-classes-allowed all \
  --exclude-tautologies structural \
  --output tmp/reason-test.owl
rm -f tmp/reason-test.owl
echo "No unsatisfiable classes found."
echo

echo "== SPARQL verification -- missing labels/definitions, IRI issues =="
verify_failed=0
robot merge \
  --catalog catalog-v001.xml \
  --input elmo-edit.owl \
  verify \
  --queries ../sparql/missing-definitions.sparql \
            ../sparql/missing-labels.sparql \
            ../sparql/none-definitions.sparql \
  --output-dir reports || verify_failed=1
echo

echo "== OBO quality report =="
report_failed=0
robot merge \
  --catalog catalog-v001.xml \
  --input elmo-edit.owl \
  report \
  --output reports/elmo-edit.owl-obo-report.tsv || report_failed=1

echo
if [ "$verify_failed" -ne 0 ]; then
  echo "Verification reported FAIL above -- ELMO:0000000 (the root node) is a"
  echo "known, permanent exception with no real definition; anything else"
  echo "listed is worth investigating."
fi
if [ "$report_failed" -ne 0 ]; then
  echo "The report above includes ERROR-level violations. As of the last full"
  echo "audit, all such errors were on IMPORTED terms (BFO/ENVO/RO/GO/IAO),"
  echo "not ELMO's own terms -- check reports/elmo-edit.owl-obo-report.tsv"
  echo "and confirm any ERROR rows are on non-ELMO: entities."
fi
echo "All checks complete. See src/ontology/reports/ for the full report and"
echo "verification output. If a class is unsatisfiable, use explain.sh to see why."

if [ "$verify_failed" -ne 0 ] || [ "$report_failed" -ne 0 ]; then
  exit 1
fi
