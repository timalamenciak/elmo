# Contributing to EcoLogical Management Ontology (ELMO)

:+1: First of all: thank you for taking the time to contribute!

The following is a set of guidelines for contributing to ELMO. These guidelines are not strict rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting set up](#setup)
    * [Prerequisites](#prerequisites)
    * [Cloning the repository](#cloning)
    * [Repository layout](#layout)
    * [Making a branch](#branching)
- [Guidelines for Contributions and Requests](#contributions)
    * [Reporting problems with the ontology](#reporting-bugs)
    * [Requesting new terms](#requesting-terms)
    * [Reviewing existing terms](#reviewing-terms)
    * [Adding new terms by yourself](#adding-terms)
- [Editing ROBOT templates](#robot-templates)
    * [What the templates are](#templates-what)
    * [Anatomy of a template file](#templates-anatomy)
    * [Adding or editing a row](#templates-editing)
    * [Rebuilding and checking your work](#templates-building)
    * [Common mistakes](#templates-mistakes)
- [Best practices](#best-practices)
    * [How to write a great issue](#great-issues)
    * [How to create a great pull request](#great-pulls)

<a id="code-of-conduct"></a>
## Code of Conduct

The Ecolink Model Ontology (ELMO) team strives to create a welcoming environment for editors, users and other contributors. Please carefully read our [Code of Conduct](CODE_OF_CONDUCT.md).

<a id="setup"></a>
## Getting set up

<a id="prerequisites"></a>
### Prerequisites

You need the following installed before you start. You do not need to understand all of them; you need them present.

| Tool | Why | Check it works |
| --- | --- | --- |
| [Git](https://git-scm.com/downloads) | Getting and versioning the files | `git --version` |
| [Docker](https://docs.docker.com/get-docker/) | Runs the ODK toolchain, which bundles ROBOT and everything else. Start Docker Desktop before building. | `docker --version` |
| A text editor | Editing templates. VS Code is fine. So is anything that saves plain text. | — |
| A spreadsheet program (optional) | Editing templates in a grid instead of raw text. See the warnings in [Common mistakes](#templates-mistakes). | — |
| [Protégé](https://protege.stanford.edu/) (optional) | Browsing the built ontology visually. Not required for template-based edits. | — |

You do **not** need to install ROBOT separately. The ODK Docker image includes it, and `run.sh` calls it for you.

<a id="cloning"></a>
### Cloning the repository

**If you are an official team member with write access**, clone directly:

```bash
git clone https://github.com/timalamenciak/elmo.git
cd elmo
```

**If you are not a team member**, make a fork first. Go to <https://github.com/timalamenciak/elmo>, click **Fork** in the top right, and create the fork under your own account. Then clone your fork and add the original repository as a second remote called `upstream`, so you can pull in other people's changes later:

```bash
git clone https://github.com/YOUR-USERNAME/elmo.git
cd elmo
git remote add upstream https://github.com/timalamenciak/elmo.git
git remote -v   # you should see 'origin' (your fork) and 'upstream' (the main repo)
```

If you have set up SSH keys with GitHub, use the SSH address instead (`git@github.com:timalamenciak/elmo.git`). If that sentence means nothing to you, use the HTTPS addresses above.

Before you start any new piece of work, get the latest changes:

```bash
git checkout main
git pull upstream main   # use 'origin' instead of 'upstream' if you cloned directly
```

<a id="layout"></a>
### Repository layout

The files you are most likely to touch:

```
elmo/
├── src/
│   ├── templates/              <- ROBOT templates. Most edits happen here.
│   └── ontology/
│       ├── elmo-edit.owl       <- The editors file. Only one. Do not confuse it with build products.
│       ├── elmo-odk.yaml       <- ODK configuration; declares which templates get built
│       ├── elmo-idranges.owl   <- Who is allowed to mint which term IDs
│       └── run.sh              <- Wrapper that runs the ODK toolchain in Docker
└── CONTRIBUTING.md
```

Everything in the repository root ending in `.owl`, `.obo` or `.json` that is not `elmo-edit.owl` is a **build product**. It is generated from the sources. Never edit it by hand; your changes will be silently overwritten on the next build.

<a id="branching"></a>
### Making a branch

Never commit to `main` directly. Make a branch named after the issue you are working on:

```bash
git checkout -b issue123-add-seeding-terms
```

The convention is `issue<NUMBER>-<short-description>`. One branch per issue, one pull request per branch.

<a id="contributions"></a>
## Guidelines for Contributions and Requests

<a id="reporting-bugs"></a>
### Reporting problems with the ontology

Please use our [Issue Tracker](https://github.com/timalamenciak/elmo/issues/) for reporting problems with the ontology. To learn how to write a good issue, [see here](#great-issues).

<a id="requesting-terms"></a>
### Requesting new terms

Before you write a new request, please consider the following:

- **Does the term already exist?** Check whether the term exists, either as a primary term or as a synonym. You can search using [OLS](http://www.ebi.ac.uk/ols/ontologies/elmo).
- **Can you provide a definition?** It should be very clear what the term means, and you should be able to provide a concise definition, ideally with a scientific reference.
- **Is the ontology in scope for the term?** A rule of thumb: if a similar term already exists, the new term is probably in scope. Naming that similar term in your request is very helpful.

#### Who can request a term?

Anyone. There is no guarantee that your term will be added automatically. Since this is a community resource, it is often necessary to do at least some of the work of adding the term yourself.

#### How to write a new term request

Request a new term via the GitHub [Issue Tracker](https://github.com/timalamenciak/elmo/issues/new/choose). Please always use an issue template if one is available. Curators process a lot of issues; a well-formed request saves everyone time. See the [best practices](#great-issues).

<a id="reviewing-terms"></a>
### Reviewing existing terms

A **term review** checks whether an existing ELMO term holds up against how the concept is actually used in restoration documents and literature. Reviews are how the ontology gets corrected, and they are as valuable as new term requests.

#### What a review involves

1. Pick a term, or a small coherent block of terms (a parent and its children works well).
2. Look at the term as it currently stands: its ID, label, definition, definition source, synonyms, and its parent in the hierarchy. Use [OLS](http://www.ebi.ac.uk/ols/ontologies/elmo) or open the built ontology in Protégé.
3. Find at least two independent sources that use the concept. Restoration reports, practitioner guidance and peer-reviewed literature all count, and a mix is better than three of the same kind.
4. Assess coverage and fidelity as described below.
5. Open one issue per term, using the **Term review** issue template.

#### Required issue format

Every review issue must contain three sections, with these exact headings. Issues missing a section will be sent back.

```markdown
## Coverage

Is this concept adequately represented in ELMO?

State one of: ADEQUATE / PARTIAL / MISSING / REDUNDANT

- ADEQUATE — the term exists and captures the concept as used in the sources.
- PARTIAL — the term exists but does not cover part of the concept (a common
  variant, a scale, an intent, or a step that sources treat as part of the same action).
- MISSING — a concept appearing in the sources has no term at all. Say what
  the nearest existing term is.
- REDUNDANT — this term overlaps another ELMO term so closely that they should
  be merged. Give the ID of the other term.

Then, in two or three sentences: what the sources treat as belonging to this
concept, and where ELMO's boundary sits differently.

## Fidelity

Are the label, definition and placement correct?

Quote the current definition verbatim, then state one of: ACCURATE / IMPRECISE / INCORRECT.

Give a **canonical citation**: the single published source that best defines
this concept, in full. Prefer, in this order:
  1. A standards or guidance document (e.g. SER standards, provincial or
     federal restoration guidance)
  2. A peer-reviewed synthesis, review or textbook
  3. A peer-reviewed primary article
Do not use a website, a blog post or a personal communication as the canonical
citation. If no canonical source exists, write "No canonical source found" and
say what you searched.

If the definition should change, propose the replacement wording here in full.
Definitions should follow the genus-differentia pattern: "A [parent term] that
[what distinguishes it]."

Also note here if the label is wrong or non-standard, if a synonym is missing,
or if the parent term is wrong.

## Comments

Anything that does not fit above. Downstream consequences of a change, terms
that would also need editing, disagreement in the sources, questions for the
curators, or a note that you are willing to make the edit yourself.
```

#### Worked example

```markdown
## Coverage

PARTIAL

Sources treat broadcast seeding, drill seeding and hydroseeding as variants of
a single action distinguished by delivery method. ELMO has a single `seeding`
term with no children, so the delivery method has nowhere to go. Practitioner
reports almost always specify the method, so this distinction is doing real
work in the source material.

## Fidelity

Current definition: "The act of putting seeds in soil."

IMPRECISE.

Canonical citation: Gann, G.D., McDonald, T., Walder, B., Aronson, J., Nelson,
C.R., Jonson, J., et al. (2019). International principles and standards for the
practice of ecological restoration. Second edition. Restoration Ecology, 27(S1),
S1–S46.

Proposed replacement: "A revegetation process in which seed of one or more
target species is applied to a site in order to establish vegetation cover."

The current wording implies soil incorporation, which excludes broadcast and
hydroseeding. The label itself is fine.

## Comments

If the three children are added, the definition of the parent should not
mention a delivery mechanism at all. Happy to write the ROBOT template rows for
this if the curators agree with the split.
```

<a id="adding-terms"></a>
### How to add a new term

If you have never edited an OBO ontology before, work through the [OBO Academy tutorial](https://oboacademy.github.io/obook/lesson/contributing-to-obo-ontologies) first.

There are two editing routes in ELMO:

- **ROBOT templates** (`src/templates/`) — the preferred route for adding or editing terms in bulk, and for anything a reviewer might want to read as a diff. Most contributions belong here. See [Editing ROBOT templates](#robot-templates).
- **The editors file** (`src/ontology/elmo-edit.owl`, opened in Protégé) — for logical axioms and structural changes that a template cannot express. **Careful:** there are many ontology files in this repository, but only one editors file.

Do not add the same term in both places.

<a id="robot-templates"></a>
## Editing ROBOT templates

<a id="templates-what"></a>
### What the templates are

A ROBOT template is a spreadsheet that ROBOT turns into OWL. One row is one term. One column is one piece of information about that term. This means you can add or correct terms without touching OWL syntax, and reviewers can see exactly what changed.

The templates live in `src/templates/` and are usually tab-separated (`.tsv`). They are wired into the build in `src/ontology/elmo-odk.yaml`; if you add a whole new template file you must register it there, and a curator should review that change.

<a id="templates-anatomy"></a>
### Anatomy of a template file

Every template has **two header rows**, then one row per term:

| Row | What it is |
| --- | --- |
| Row 1 | Human-readable column names. For people. ROBOT ignores it. |
| Row 2 | ROBOT template strings. These tell ROBOT what each column means. Do not edit these unless you know what you are doing. |
| Row 3+ | The terms. One per row. |

A minimal example:

```
ID	Label	Definition	Definition source	Parent
ID	LABEL	A IAO:0000115	>A oboInOwl:hasDbXref	SC %
ELMO:0000123	seeding	A revegetation process in which seed...	doi:10.1111/rec.13035	ELMO:0000045
```

The template strings you will meet most often:

| String | Meaning |
| --- | --- |
| `ID` | The term's identifier. Required. |
| `LABEL` | The term's primary name. Required. |
| `TYPE` | What kind of entity it is, usually `owl:Class`. |
| `A IAO:0000115` | Adds a textual definition. |
| `>A oboInOwl:hasDbXref` | Annotates the **previous** column. Placed after a definition column, it records the definition's source. The `>` is what makes it an axiom annotation; do not drop it. |
| `A oboInOwl:hasExactSynonym` | Adds an exact synonym. |
| `SC %` | Makes the term a subclass of whatever is in this cell. `%` is a placeholder for the cell value. |
| `SC 'part of' some %` | A more complex subclass expression using the cell value. |
| `SPLIT=\|` | Appended to a template string, lets one cell hold several values separated by `\|`. Useful for synonyms. |

Leave a cell blank and ROBOT simply generates nothing for it. Blank is fine; a placeholder like `TBD` or `n/a` is not, because it becomes a real annotation in the ontology.

<a id="templates-editing"></a>
### Adding or editing a row

1. **Get a fresh branch.** See [Making a branch](#branching).
2. **Find the right file.** Terms are grouped by area across the files in `src/templates/`. Put the term where its siblings are. If you cannot tell, ask in the issue before editing.
3. **Mint an ID for a new term.** IDs are sequential and never reused. Look at `src/ontology/elmo-idranges.owl` to find the range assigned to you, then take the next unused number in that range. If you have no assigned range, request one in your issue; do not borrow from someone else's. Editing an existing term does not need a new ID.
4. **Fill in the row.** At minimum: `ID`, `LABEL`, a definition, and a definition source. Definitions follow genus-differentia form: "A [parent] that [distinguishing feature]." Write one sentence. Do not begin with the term itself.
5. **Set the parent.** The `SC %` column takes the ID of the parent class, not its label.
6. **Save as TSV.** Keep the file tab-separated, UTF-8, with no quoting added.
7. **Check the diff before committing:**
   ```bash
   git diff src/templates/
   ```
   You should see only the lines you meant to change. If the whole file appears changed, your editor has rewritten the line endings or the delimiters; undo and see [Common mistakes](#templates-mistakes).
8. **Commit and push:**
   ```bash
   git add src/templates/
   git commit -m "Add seeding subclasses (#123)"
   git push origin issue123-add-seeding-terms
   ```
   Referencing the issue number in the commit message links the two on GitHub.
9. **Open a pull request** against `main`, and write `Fixes #123` in the description so the issue closes when the PR is merged.

<a id="templates-building"></a>
### Rebuilding and checking your work

Start Docker, then from `src/ontology/`:

```bash
cd src/ontology

# Regenerate the ontology components from the templates
sh run.sh make components

# Build the full ontology
sh run.sh make prepare_release
```

The first run pulls the ODK Docker image and will take a while. Later runs are faster.

Then check that you have not broken anything:

```bash
# Run the ontology quality control checks
sh run.sh make test
```

Read the output. Common failures are a duplicate ID, a parent that does not exist, a missing definition, or a definition that duplicates another term's. Fix the template row, rebuild, and run the checks again. Do not open a pull request with failing checks; if you cannot work out what a failure means, open the PR as a **draft** and say so in the description.

To look at the result, open `elmo.owl` in Protégé and find your term in the class hierarchy.

<a id="templates-mistakes"></a>
### Common mistakes

- **Editing a build product instead of a template.** If you edited a file in the repository root, your work will be overwritten. Only `src/templates/` and `src/ontology/elmo-edit.owl` are sources.
- **A spreadsheet program mangling the file.** Excel and Google Sheets will happily convert tabs to commas, add quotation marks, change encoding, or reformat something that looks like a date. If you edit in a spreadsheet, export back to tab-separated UTF-8 and check `git diff` before committing.
- **Deleting or reordering row 2.** Row 2 is the template definition. If it goes, nothing builds.
- **Putting a label where an ID belongs.** `SC %` and other logic columns need IDs.
- **Reusing an ID.** Never reuse a retired ID for a new concept. To retire a term, mark it obsolete rather than deleting the row; ask a curator how.
- **Bundling unrelated changes.** One issue, one branch, one pull request. A PR that adds twelve unrelated terms is much harder to review than four PRs of three.

<a id="best-practices"></a>
## Best Practices

<a id="great-issues"></a>
### How to write great issues

Please refer to the [OBO Academy term request guide](https://oboacademy.github.io/obook/howto/term-request/). For term reviews specifically, use the format in [Reviewing existing terms](#reviewing-terms).

<a id="great-pulls"></a>
### How to create a great pull/merge request

Please refer to the [OBO Academy best practices](https://oboacademy.github.io/obook/howto/github-create-pull-request/).