#!/usr/bin/env bash
# Run the full official ODK release pipeline: refreshes imports, rebuilds
# components/patterns, reasons over the merged ontology, and writes
# base/simple/full release artifacts (OWL/OBO/JSON) to the repo root.
# Requires Docker Desktop running.
#
# Equivalent to running, from src/ontology:
#   sh run.sh make prepare_release
#
# Set SKIP_IMPORTS=1 to skip re-downloading imports (faster re-runs once
# you've already refreshed them recently):
#   SKIP_IMPORTS=1 helper_scripts/release.sh
#
# This script does NOT commit, push, or cut a GitHub release for you --
# review the changed release files first.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ONTOLOGY_DIR="$SCRIPT_DIR/../src/ontology"

if ! docker info >/dev/null 2>&1; then
  echo "Docker does not appear to be running. Start Docker Desktop and try again." >&2
  exit 1
fi

cd "$ONTOLOGY_DIR"
if [ "${SKIP_IMPORTS:-0}" = "1" ]; then
  sh run.sh make IMP=false prepare_release
else
  sh run.sh make prepare_release
fi

echo
echo "Release files are now in the repo root. Review the diff, then commit,"
echo "push, and cut a release on GitHub -- this script does not do that for you."
