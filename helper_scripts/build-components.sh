#!/usr/bin/env bash
# Rebuild the interventions and ecosystems OWL components from their TSV
# templates (src/templates/interventions.tsv, src/templates/ecosystems.tsv).
#
# Runs entirely locally via ROBOT -- no Docker or `make` required (neither is
# assumed to be installed). Mirrors the ROBOT pipeline defined in
# src/ontology/elmo.Makefile (template -> annotate ontology/version IRI ->
# convert to functional syntax), just without needing `make` itself. Run this
# after editing either TSV, before checking your work (see check.sh) or
# regenerating docs (see update-docs.sh).
#
# Override the ROBOT jar location with the ROBOT_JAR environment variable if
# yours isn't at the default path below:
#   ROBOT_JAR=/path/to/robot.jar ./build-components.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ONTOLOGY_DIR="$SCRIPT_DIR/../src/ontology"
ROBOT_JAR="${ROBOT_JAR:-C:/Users/Tim Alamenciak/Documents/TReK/Racoon/ROBOT/robot.jar}"
robot() { java -jar "$ROBOT_JAR" "$@"; }

ONTBASE="https://w3id.org/elmo/elmo"
TODAY="$(date +%Y-%m-%d)"

cd "$ONTOLOGY_DIR"

echo "== Rebuilding interventions.owl =="
robot template \
  --catalog catalog-v001.xml \
  --prefix 'ELMO: https://w3id.org/elmo/elmo_' \
  --prefix 'skos: http://www.w3.org/2004/02/skos/core#' \
  --prefix 'ELMOP: https://w3id.org/elmo/property/' \
  --input elmo-edit.owl \
  --template ../templates/interventions.tsv \
  annotate --ontology-iri "$ONTBASE/components/interventions.owl" \
           -V "$ONTBASE/releases/$TODAY/components/interventions.owl" \
           --annotation owl:versionInfo "$TODAY" \
  convert -f ofn --output components/interventions.owl.tmp.owl
mv components/interventions.owl.tmp.owl components/interventions.owl
echo "interventions.owl rebuilt."
echo

echo "== Rebuilding ecosystems.owl =="
robot template \
  --catalog catalog-v001.xml \
  --prefix 'ELMO: https://w3id.org/elmo/elmo_' \
  --input elmo-edit.owl \
  --template ../templates/ecosystems.tsv \
  annotate --ontology-iri "$ONTBASE/components/ecosystems.owl" \
           -V "$ONTBASE/releases/$TODAY/components/ecosystems.owl" \
           --annotation owl:versionInfo "$TODAY" \
  convert -f ofn --output components/ecosystems.owl.tmp.owl
mv components/ecosystems.owl.tmp.owl components/ecosystems.owl
echo "ecosystems.owl rebuilt."
