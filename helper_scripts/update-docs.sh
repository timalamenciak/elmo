#!/usr/bin/env bash
# Regenerate the local HTML documentation -- docs/elmo.html (via
# owl2mkdocs.py) and docs/lode.html (via PyLODE) -- from a freshly merged
# local ontology assembled from src/ontology/elmo-edit.owl and its imports.
#
# This only updates files in your working tree; it does NOT publish
# anything. To publish the mkdocs site to GitHub Pages, run the Docker-based
# `update_docs` target instead (requires GitHub credentials):
#   cd src/ontology && sh run.sh make update_docs
# See docs/odk-workflows/ManageDocumentation.md for details.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR/.."
ONTOLOGY_DIR="$REPO_ROOT/src/ontology"
ROBOT_JAR="${ROBOT_JAR:-C:/Users/Tim Alamenciak/Documents/TReK/Racoon/ROBOT/robot.jar}"
robot() { java -jar "$ROBOT_JAR" "$@"; }
DOCS_ONTOLOGY="$ONTOLOGY_DIR/tmp/elmo-docs-merged.owl"

cd "$ONTOLOGY_DIR"
mkdir -p tmp

echo "== Preparing merged ontology for docs =="
robot merge --catalog catalog-v001.xml --input elmo-edit.owl --output "$DOCS_ONTOLOGY"
echo

echo "== Regenerating docs/elmo.html =="
python scripts/owl2mkdocs.py "$DOCS_ONTOLOGY"
echo

echo "== Regenerating docs/lode.html (PyLODE) =="
if ! python -c "import importlib.util, sys; sys.exit(0 if importlib.util.find_spec('pylode') else 1)" >/dev/null; then
  echo "PyLODE is not installed for this Python. Install it with: python -m pip install pylode" >&2
  exit 1
fi
python -m pylode -o "$REPO_ROOT/docs/lode.html" "$DOCS_ONTOLOGY"
