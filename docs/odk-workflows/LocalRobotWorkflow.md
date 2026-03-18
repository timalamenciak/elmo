# Running QC checks and building a release locally

This page documents how to run ELMO's quality-control checks and build a release
artefact from the command line, **without Docker**.
The standard ODK release workflow uses Docker (`./run.sh make …`);
use that approach when you want to produce an officially-versioned release.
The commands below use a local `robot.jar` and are useful for fast iteration
during editing — running checks in seconds rather than spinning up a container.

---

## Prerequisites

| Requirement | Notes |
|-------------|-------|
| **Java 11+** | Java 22 is confirmed to work; run `java -version` to check |
| **robot.jar** | Located at `C:/Users/Tim Alamenciak/Documents/TReK/Racoon/ROBOT/robot.jar`; version 1.9.7 |
| **Python 3** | Required for editing TSV templates; run `python --version` to check |
| **Git Bash** (Windows) | All commands below assume a Bash-compatible shell |

All commands must be run from the **`src/ontology/`** directory unless noted otherwise:

```bash
cd path/to/elmo/src/ontology
```

For convenience, set a shell alias so you don't have to type the full jar path:

```bash
alias robot='java -jar "C:/Users/Tim Alamenciak/Documents/TReK/Racoon/ROBOT/robot.jar"'
```

The remaining examples on this page use `robot` for brevity.

---

## 1. Rebuild components from ROBOT templates

Run this whenever you have edited a `.tsv` template file and need to regenerate
the corresponding OWL component before checking or releasing.

### Interventions component

```bash
robot template \
  --prefix 'ELMO: https://w3id.org/elmo/elmo_' \
  --template ../templates/interventions.tsv \
  --output components/interventions.owl
```

### Ecosystems component

```bash
robot template \
  --prefix 'ELMO: https://w3id.org/elmo/elmo_' \
  --template ../templates/ecosystems.tsv \
  --output components/ecosystems.owl
```

### CAS component

`cas.owl` is maintained by hand in Functional Syntax — no rebuild step is needed.
Edit `components/cas.owl` directly.

---

## 2. Pre-processing step

Several checks operate on a pre-processed version of the edit file.
Regenerate it after any change:

```bash
robot convert \
  --catalog catalog-v001.xml \
  --input elmo-edit.owl \
  --format ofn \
  --output tmp/elmo-preprocess.owl
```

This step is also the first thing `make reason` does, so it will be run
automatically if you use the `make` targets below.

---

## 3. Quality-control checks

### 3.1 Reasoning (unsatisfiable class check)

Runs ELK over the full ontology (all components + imports) and fails if any
class becomes unsatisfiable.

=== "make target"

    ```bash
    make -f elmo.Makefile reason
    ```

=== "raw ROBOT command"

    ```bash
    robot reason \
      --catalog catalog-v001.xml \
      --input tmp/elmo-preprocess.owl \
      --reasoner ELK \
      --equivalent-classes-allowed all \
      --exclude-tautologies structural \
      --output test.owl && rm test.owl
    ```

**Expected output:** no output on success (exit code 0). Any `ERROR` line means
an unsatisfiable class was found; use the explain target (§ 3.5) to investigate.

---

### 3.2 OBO-format quality report

Runs the ROBOT `report` command over the merged ontology and writes a TSV to
`reports/elmo-edit.owl-obo-report.tsv`.

=== "make target"

    ```bash
    make -f elmo.Makefile report
    ```

=== "raw ROBOT command"

    ```bash
    robot merge \
      --catalog catalog-v001.xml \
      --input elmo-edit.owl \
      report \
      --output reports/elmo-edit.owl-obo-report.tsv
    ```

**Interpreting the output**

The report prints a summary line like:

```
ERROR:      14
WARN:       37
INFO:       65
```

| Category | Expected count | Notes |
|----------|---------------|-------|
| ERROR on ELMO terms | 0 | Any error here needs to be fixed |
| WARN on ELMO terms | ≤ 3 | Two pre-existing `duplicate_exact_synonym` on ecosystem types 3620108/3620109; one expected `duplicate_label_synonym` on merged term 3620037 |
| ERROR on imported terms | 14 | All `multiple_labels` on GO/IAO/oboInOwl — artefact of slim import labels; safe to ignore |
| WARN on imported terms | 33 `missing_definition` + 1 `annotation_whitespace` | Artefacts of import slimming; safe to ignore |

---

### 3.3 SPARQL validation checks

Checks five structural rules against the pre-processed ontology:

=== "make target"

    ```bash
    make -f elmo.Makefile verify
    ```

    This runs the three diagnostic queries
    (`missing-definitions`, `missing-labels`, `none-definitions`)
    and writes CSV results to `reports/`.

=== "raw ROBOT command"

    ```bash
    # Structural integrity checks (5/5 should PASS)
    robot verify \
      --catalog catalog-v001.xml \
      -i tmp/elmo-preprocess.owl \
      --queries \
        ../sparql/owldef-self-reference-violation.sparql \
        ../sparql/iri-range-violation.sparql \
        ../sparql/label-with-iri-violation.sparql \
        ../sparql/multiple-replaced_by-violation.sparql \
        ../sparql/dc-properties-violation.sparql \
      -O reports/

    # Diagnostic queries (produce CSV reports, do not fail the build)
    robot merge \
      --catalog catalog-v001.xml \
      --input elmo-edit.owl \
      query --format csv \
        --query ../sparql/missing-definitions.sparql reports/missing-definitions.csv \
        --query ../sparql/missing-labels.sparql      reports/missing-labels.csv \
        --query ../sparql/none-definitions.sparql    reports/none-definitions.csv
    ```

**Expected output:** all five structural checks should print `PASS … 0 violation(s)`.
The diagnostic query results in `reports/` should be empty (header row only) for a clean
ontology — the only exception is `missing-definitions.csv`, which will always list
the root metadata node `ELMO_0000000`.

---

### 3.4 DOSDP pattern validation

Validates the design-pattern TSVs against their YAML schemas:

```bash
dosdp validate -i elmo-edit.owl \
  --infile ../patterns/definitions.tsv \
  --template ../patterns/definitions.yaml
```

---

### 3.5 Explain an unsatisfiable class

If reasoning fails and you need to understand *why* a class is unsatisfiable:

=== "make target"

    ```bash
    make -f elmo.Makefile explain CLASS="https://w3id.org/elmo/elmo_3620001"
    ```

    The explanation is written to `reports/explanation.md`.

=== "raw ROBOT command"

    ```bash
    robot explain \
      --catalog catalog-v001.xml \
      --input tmp/elmo-preprocess.owl \
      --reasoner ELK \
      --axiom "SubClassOf(<https://w3id.org/elmo/elmo_3620001> owl:Nothing)" \
      --explanation reports/explanation.md
    ```

---

## 4. Running all checks together

To replicate the full CI suite as closely as possible without Docker, run the
checks in this order:

```bash
# From src/ontology/

# 1. Rebuild any templates you have changed
robot template --prefix 'ELMO: https://w3id.org/elmo/elmo_' \
  --template ../templates/interventions.tsv --output components/interventions.owl
robot template --prefix 'ELMO: https://w3id.org/elmo/elmo_' \
  --template ../templates/ecosystems.tsv   --output components/ecosystems.owl

# 2. Pre-process
robot convert --catalog catalog-v001.xml \
  --input elmo-edit.owl --format ofn --output tmp/elmo-preprocess.owl

# 3. Reason
robot reason --catalog catalog-v001.xml \
  --input tmp/elmo-preprocess.owl --reasoner ELK \
  --equivalent-classes-allowed all --exclude-tautologies structural \
  --output test.owl && rm test.owl

# 4. Structural SPARQL checks
robot verify --catalog catalog-v001.xml \
  -i tmp/elmo-preprocess.owl \
  --queries \
    ../sparql/owldef-self-reference-violation.sparql \
    ../sparql/iri-range-violation.sparql \
    ../sparql/label-with-iri-violation.sparql \
    ../sparql/multiple-replaced_by-violation.sparql \
    ../sparql/dc-properties-violation.sparql \
  -O reports/

# 5. Quality report
robot merge --catalog catalog-v001.xml --input elmo-edit.owl \
  report --output reports/elmo-edit.owl-obo-report.tsv
```

---

## 5. Building a release (without Docker)

!!! warning "Prefer Docker for official releases"
    The ODK Docker workflow (`./run.sh make prepare_release -B`) is the canonical
    method for producing versioned release artefacts because it pins tool versions
    and runs the full pipeline including pattern compilation. Use the steps below
    only when Docker is unavailable or for quick local testing of release outputs.

### 5.1 Prepare a release branch

```bash
git checkout main && git pull
git checkout -b release-$(date +%Y-%m-%d)
```

### 5.2 Rebuild all components

```bash
robot template --prefix 'ELMO: https://w3id.org/elmo/elmo_' \
  --template ../templates/interventions.tsv --output components/interventions.owl
robot template --prefix 'ELMO: https://w3id.org/elmo/elmo_' \
  --template ../templates/ecosystems.tsv   --output components/ecosystems.owl
```

### 5.3 Run all QC checks

Follow the steps in [§ 4](#4-running-all-checks-together) and confirm everything
passes before proceeding.

### 5.4 Build the base release file

The **base** release includes only ELMO-authored axioms (no imports merged in):

```bash
robot merge \
    --catalog catalog-v001.xml \
    --input elmo-edit.owl \
  annotate \
    --ontology-iri "https://w3id.org/elmo/elmo" \
    --version-iri "https://w3id.org/elmo/elmo/releases/$(date +%Y-%m-%d)/elmo-base.owl" \
    --annotation owl:versionInfo "$(date +%Y-%m-%d)" \
  convert --format owl --output ../../elmo-base.owl

# OBO and JSON variants
robot convert --input ../../elmo-base.owl --format obo  --output ../../elmo-base.obo
robot convert --input ../../elmo-base.owl --format json --output ../../elmo-base.json
```

### 5.5 Build the full release file

The **full** release adds inferred axioms from the reasoner:

```bash
robot merge \
    --catalog catalog-v001.xml \
    --input elmo-edit.owl \
  reason \
    --reasoner ELK \
    --equivalent-classes-allowed all \
    --exclude-tautologies structural \
  annotate \
    --ontology-iri "https://w3id.org/elmo/elmo" \
    --version-iri "https://w3id.org/elmo/elmo/releases/$(date +%Y-%m-%d)/elmo-full.owl" \
    --annotation owl:versionInfo "$(date +%Y-%m-%d)" \
  convert --format owl --output ../../elmo-full.owl

robot convert --input ../../elmo-full.owl --format obo  --output ../../elmo-full.obo
robot convert --input ../../elmo-full.owl --format json --output ../../elmo-full.json
```

### 5.6 Commit, push and open a pull request

```bash
cd ../..   # back to repo root
git add elmo-base.owl elmo-base.obo elmo-base.json \
        elmo-full.owl elmo-full.obo elmo-full.json \
        src/ontology/components/
git commit -m "Release $(date +%Y-%m-%d)"
git push -u origin release-$(date +%Y-%m-%d)
```

Then open a pull request on GitHub and follow the review steps described in the
[Release Workflow](ReleaseWorkflow.md).

### 5.7 Tag the release on GitHub

Once the PR is merged to `main`, create a GitHub release as described in
[Release Workflow § Create a GitHub release](ReleaseWorkflow.md#create-a-github-release).
Use the date as the tag, prefixed with `v` — e.g. `v2026-03-18`.

---

## 6. SPARQL query reference

All queries live in `src/sparql/`.

| File | Purpose | Used in |
|------|---------|---------|
| `owldef-self-reference-violation.sparql` | Flags definitions that reference their own class | `make verify` / CI |
| `iri-range-violation.sparql` | Flags annotation values that should be IRIs but are literals | `make verify` / CI |
| `label-with-iri-violation.sparql` | Flags labels that contain raw IRIs | `make verify` / CI |
| `multiple-replaced_by-violation.sparql` | Flags deprecated terms with more than one `replaced_by` | `make verify` / CI |
| `dc-properties-violation.sparql` | Flags missing required Dublin Core properties | `make verify` / CI |
| `missing-definitions.sparql` | Lists ELMO classes without `IAO:0000115` | `make verify` (diagnostic) |
| `missing-labels.sparql` | Lists ELMO classes without `rdfs:label` | `make verify` (diagnostic) |
| `none-definitions.sparql` | Lists ELMO classes whose definition is literally "None" | `make verify` (diagnostic) |
| `basic-report.sparql` | General class statistics | SPARQL exports |
| `class-count-by-prefix.sparql` | Counts classes grouped by IRI prefix | SPARQL exports |
| `synonyms.sparql` | Exports all synonym annotations | SPARQL exports |
| `obsoletes.sparql` | Lists deprecated/obsolete terms | SPARQL exports |
| `edges.sparql` | Exports parent-child edges | SPARQL exports |

Run any query ad hoc with:

```bash
robot merge --catalog catalog-v001.xml --input elmo-edit.owl \
  query --format csv \
  --query ../sparql/QUERYNAME.sparql results.csv
```

---

## 7. Quick-reference card

```
# Rebuild a template component
robot template --prefix 'ELMO: ...' --template ../templates/FOO.tsv --output components/FOO.owl

# Pre-process
robot convert --catalog catalog-v001.xml --input elmo-edit.owl --format ofn --output tmp/elmo-preprocess.owl

# Reason
robot reason --catalog catalog-v001.xml --input tmp/elmo-preprocess.owl --reasoner ELK \
  --equivalent-classes-allowed all --exclude-tautologies structural --output test.owl && rm test.owl

# Structural checks
robot verify --catalog catalog-v001.xml -i tmp/elmo-preprocess.owl \
  --queries ../sparql/owldef-self-reference-violation.sparql \
            ../sparql/iri-range-violation.sparql \
            ../sparql/label-with-iri-violation.sparql \
            ../sparql/multiple-replaced_by-violation.sparql \
            ../sparql/dc-properties-violation.sparql \
  -O reports/

# Quality report
robot merge --catalog catalog-v001.xml --input elmo-edit.owl \
  report --output reports/elmo-edit.owl-obo-report.tsv

# Explain an unsatisfiable class
robot explain --catalog catalog-v001.xml --input tmp/elmo-preprocess.owl --reasoner ELK \
  --axiom "SubClassOf(<IRI> owl:Nothing)" --explanation reports/explanation.md
```

Or use the `make` shortcuts defined in `src/ontology/elmo.Makefile`:

```bash
make -f elmo.Makefile reason
make -f elmo.Makefile report
make -f elmo.Makefile verify
make -f elmo.Makefile explain CLASS="https://w3id.org/elmo/elmo_XXXXXXX"
```
