# AGENTS.md — ELMO

Instructions for coding agents working in the ELMO repository. Read by Claude
Code (via a `CLAUDE.md` symlink), Codex, and OpenCode. Keep it lean.

## What this repo is

**ELMO** — an OWL ontology managed with the **Ontology Development Kit (ODK)**
and **ROBOT**, in the standard OBO-style ODK layout. The human-edited source is
the edit file; release artifacts, imports, and the build system are generated
by ODK.

ELMO supplies the **node vocabulary** used inside loom's annotation workbench:
when an annotator marks a causal claim, they decompose each entity into an ELMO
node as **entity + attribute + direction**. ELMO describes the *things a causal
edge connects*; CAMO (a separate LinkML schema) describes the *edge* itself.
The two are **independent artifacts** — ELMO neither imports nor is imported by
CAMO — that meet only inside loom at annotation time. Downstream, loom's local
ontology index and OLS fallback consume ELMO terms, so released term IDs and
labels are a **published contract**.

## The loop (non-negotiable)

Everything runs through the ODK wrapper so it executes in the ODK container:

```bash
sh run.sh make test
```

Green means: `robot report` is clean (no ERROR violations), the ontology is
logically **consistent under the reasoner**, and every SPARQL QC query in
`src/sparql/*-violation.sparql` returns **zero rows**. Never hand back a failing
state. Fix the ontology, not the checks.

## Commands

<!-- All via run.sh. CONFIRM exact target names against this repo's Makefile;
     they vary a little by ODK version. -->

| Task                | Command                                       |
| ------------------- | --------------------------------------------- |
| Validate / QC       | `sh run.sh make test`                         |
| ROBOT report        | `sh run.sh make robot_report`                 |
| Reason / consistency| `sh run.sh make reason`                       |
| Refresh imports     | `sh run.sh make refresh-imports`              |
| Build release       | `sh run.sh make prepare_release`              |
| Update ODK scaffold | `sh run.sh make update_repo`                  |

## Authoring conventions (ODK / ROBOT ontology)

- **Edit only `src/ontology/elmo-edit.owl`.** <!-- CONFIRM: .owl vs .obo -->
  Everything else under `src/ontology/` — release artifacts, `imports/`,
  generated `components/` — is produced by ODK. Regenerate; never hand-edit.
- **Model nodes as entity + attribute + direction.** That decomposition is
  ELMO's reason for existing and the pattern loom relies on; new terms extend
  it rather than introducing a parallel shape. Keep entity, attribute, and
  direction cleanly separable so loom can render them as distinct fields.
- **New terms take IDs from ELMO's registered range** in `elmo-idranges.owl`.
  Never invent an out-of-range ID, and never reuse or recycle an obsoleted one.
- **Obsolete, don't delete.** Mark `owl:deprecated true` with `replaced_by` /
  `consider`. loom's ontology index and existing annotations may reference the
  term — a hard delete orphans real data.
- **Add terms in bulk via ROBOT templates in `src/templates/`**, not one-off in
  Protégé, so additions are reproducible and reviewable in the diff.
- **Manage imports through the ODK config (`elmo-odk.yaml`) + import seeds, then
  refresh.** Do not paste axioms from an external ontology into the edit file.
- **Every class needs a label and a definition** (with a definition source).
- **Pipeline / repo changes go through `elmo-odk.yaml` + `make update_repo`.**
  Do not hand-edit the generated `Makefile`.

## Hard "do not"

- Do **not** hand-edit generated files: release artifacts (`elmo.owl` / `.obo` /
  `.json`), `imports/`, generated `components/`, or the ODK `Makefile`.
- Do **not** delete or repurpose a released term ID — obsolete it instead.
  loom keys annotations on these IDs.
- Do **not** edit `elmo-idranges.owl` or mint IDs outside your assigned range.
- Do **not** merge with a failing `sh run.sh make test` (report, inconsistency,
  or a SPARQL violation query returning rows).

## Maintaining this file

Human-owned. Do not rewrite it wholesale or append notes mid-task. Propose
durable conventions in your response and let a human fold them in.
