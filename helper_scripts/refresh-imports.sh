#!/usr/bin/env bash
# Refresh all ODK imports and mirrors (RO, BFO, ENVO, PATO, COB, ORCIDIO) via
# the official Docker-based ODK pipeline. Requires Docker Desktop running.
#
# To refresh just one import instead of all of them, run this directly
# (faster, no need to touch this script):
#   cd src/ontology && sh run.sh make refresh-envo
#   (or refresh-ro, refresh-bfo, refresh-pato, refresh-cob, refresh-orcidio)
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ONTOLOGY_DIR="$SCRIPT_DIR/../src/ontology"

if ! docker info >/dev/null 2>&1; then
  echo "Docker does not appear to be running. Start Docker Desktop and try again." >&2
  exit 1
fi

cd "$ONTOLOGY_DIR"
sh run.sh make refresh-imports
