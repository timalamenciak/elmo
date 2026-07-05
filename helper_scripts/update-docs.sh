#!/usr/bin/env bash
# Regenerate the local HTML documentation -- docs/elmo.html (via
# owl2mkdocs.py) and docs/lode.html (via PyLODE) -- from the current
# elmo.owl in the repo root.
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

cd "$ONTOLOGY_DIR"

echo "== Regenerating docs/elmo.html =="
python scripts/owl2mkdocs.py "$REPO_ROOT/elmo.owl"
echo

echo "== Regenerating docs/lode.html (PyLODE) =="
if ! python -c "import pylode" >/dev/null 2>&1; then
  echo "PyLODE is not installed locally. Install it with: pip install pylode" >&2
  exit 1
fi
python -m pylode -o "$REPO_ROOT/docs/lode.html" "$REPO_ROOT/elmo.owl"
