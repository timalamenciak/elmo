# Helper scripts

Thin wrappers around ELMO's ODK build system (`src/ontology/Makefile`,
`src/ontology/elmo.Makefile`), for the handful of things you do most often.
None of these invent new logic -- they just call the same `make` targets
documented in `docs/odk-workflows/`, with friendlier names and a couple of
sanity checks. If a script doesn't do what you need, the Makefiles and
`docs/odk-workflows/*.md` are the full reference.

Each script comes in two flavours: a Bash version (`.sh`) for macOS/Linux and
a PowerShell version (`.ps1`) for Windows. Run the one that matches your shell,
e.g. `.\helper_scripts\check.ps1` in PowerShell or `./helper_scripts/check.sh`
in Bash/Git Bash.

## Local scripts (fast, no Docker)

These run ROBOT directly via the jar at the hardcoded default path. Override
it with the `ROBOT_JAR` environment variable if yours lives elsewhere:

```powershell
# PowerShell
$env:ROBOT_JAR = "C:\path\to\robot.jar"; .\helper_scripts\build-components.ps1
```
```sh
# Bash
ROBOT_JAR=/path/to/robot.jar ./helper_scripts/build-components.sh
```

| Script | What it does |
| --- | --- |
| `build-components.{sh,ps1}` | Rebuilds `interventions.owl`, `ecosystems.owl`, and `variables.owl` from their TSV templates in `src/templates/`. Run this after editing any TSV. |
| `check.{sh,ps1}` | Runs ELK reasoning, SPARQL verification (missing labels/definitions), and an OBO quality report. Run this after `build-components` to catch problems before a release. |
| `explain.{sh,ps1} <IRI>` | Explains why a class is unsatisfiable, e.g. `.\explain.ps1 "https://w3id.org/elmo/elmo_3620001"`. Use this when `check` reports an unsatisfiable class. |
| `update-docs.{sh,ps1}` | Regenerates `docs/elmo.html` and `docs/lode.html` locally from a freshly merged ontology. Doesn't publish anything. |

## Docker scripts (slower, need Docker Desktop running)

These call the real ODK pipeline via `src/ontology/run.sh`, inside the
`obolibrary/odkfull` container. Use them when you need the full, official
build -- not just a local sanity check.

| Script | What it does |
| --- | --- |
| `refresh-imports.{sh,ps1}` | Refreshes all imports and mirrors (RO, BFO, ENVO, PATO, COB, ORCIDIO). To refresh just one, see the comment at the top of `refresh-imports.ps1` for the equivalent single-import `docker run` command. |
| `release.{sh,ps1}` | Runs the full release pipeline: refresh imports, rebuild components/patterns, reason, and write base/simple/full release artifacts (OWL/OBO/JSON) to the repo root. Set `SKIP_IMPORTS=1` (Bash) or `$env:SKIP_IMPORTS="1"` (PowerShell) to skip re-downloading imports on a re-run. Does **not** commit, push, or cut a GitHub release for you -- review the diff first. |

## A typical day-to-day loop

1. Edit `src/templates/interventions.tsv`, `ecosystems.tsv`, or `variables.tsv`.
2. `.\helper_scripts\build-components.ps1`
3. `.\helper_scripts\check.ps1` -- fix anything it flags (use `explain.ps1` for unsatisfiable classes).
4. Repeat 1-3 until happy.
5. `.\helper_scripts\update-docs.ps1` if you want to preview the docs locally.
6. When ready to cut an actual release: `.\helper_scripts\release.ps1`, review the diff, commit, push, and tag a release on GitHub.

You only need `refresh-imports.ps1` occasionally (e.g. after an upstream
ontology like ENVO or RO has released new terms you want).
