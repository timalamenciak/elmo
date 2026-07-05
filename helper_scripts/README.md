# Helper scripts

Thin wrappers around ELMO's ODK build system (`src/ontology/Makefile`,
`src/ontology/elmo.Makefile`), for the handful of things you do most often.
None of these invent new logic -- they just call the same `make` targets
documented in `docs/odk-workflows/`, with friendlier names and a couple of
sanity checks. If a script doesn't do what you need, the Makefiles and
`docs/odk-workflows/*.md` are the full reference.

Run them from anywhere in the repo, e.g. `./helper_scripts/check.sh`.

## Local scripts (fast, no Docker)

These run ROBOT directly via the jar path configured in
`src/ontology/elmo.Makefile` (`LOCAL_ROBOT`). Override it on the fly if your
`robot.jar` lives somewhere else:

```sh
make -f elmo.Makefile reason LOCAL_ROBOT="java -jar /path/to/robot.jar"
```

| Script | What it does |
| --- | --- |
| `build-components.sh` | Rebuilds `interventions.owl` and `ecosystems.owl` from their TSV templates in `src/templates/`. Run this after editing either TSV. |
| `check.sh` | Runs ELK reasoning, SPARQL verification (missing labels/definitions), and an OBO quality report. Run this after `build-components.sh` to catch problems before a release. |
| `explain.sh <IRI>` | Explains why a class is unsatisfiable, e.g. `./explain.sh "https://w3id.org/elmo/elmo_3620001"`. Use this when `check.sh` reports an unsatisfiable class. |
| `update-docs.sh` | Regenerates `docs/elmo.html` and `docs/lode.html` locally from `elmo.owl`. Doesn't publish anything. |

## Docker scripts (slower, need Docker Desktop running)

These call the real ODK pipeline via `src/ontology/run.sh`, inside the
`obolibrary/odkfull` container. Use them when you need the full, official
build -- not just a local sanity check.

| Script | What it does |
| --- | --- |
| `refresh-imports.sh` | Refreshes all imports and mirrors (RO, BFO, ENVO, PATO, COB, ORCIDIO). To refresh just one, skip this script and run `sh run.sh make refresh-envo` (etc.) directly from `src/ontology`. |
| `release.sh` | Runs the full release pipeline: refresh imports, rebuild components/patterns, reason, and write base/simple/full release artifacts (OWL/OBO/JSON) to the repo root. Set `SKIP_IMPORTS=1` to skip re-downloading imports on a re-run. Does **not** commit, push, or cut a GitHub release for you -- review the diff first. |

## A typical day-to-day loop

1. Edit `src/templates/interventions.tsv` or `ecosystems.tsv`.
2. `./helper_scripts/build-components.sh`
3. `./helper_scripts/check.sh` -- fix anything it flags (use `explain.sh` for unsatisfiable classes).
4. Repeat 1-3 until happy.
5. `./helper_scripts/update-docs.sh` if you want to preview the docs locally.
6. When ready to cut an actual release: `./helper_scripts/release.sh`, review the diff, commit, push, and tag a release on GitHub.

You only need `refresh-imports.sh` occasionally (e.g. after an upstream
ontology like ENVO or RO has released new terms you want).
