#!/usr/bin/env python3
"""
Generate a hierarchical, searchable MkDocs-compatible HTML page from an ELMO OWL file.

Every ELMO class gets a stable anchor: id="elmo_<local id>". Term PURLs
(https://w3id.org/elmo/elmo_XXXXXXX) resolve to this page via that URL
fragment, so the anchor id must always be derived directly from the class
IRI's local name -- never from a cosmetic CURIE prefix binding, which could
change independently of the anchor contract.

Usage: python owl2mkdocs.py <ontology-file> [--output PATH]

Note that this only works with ELMO - the namespace/prefix constants below
would need to change to work with a different ontology.
"""

import argparse
import sys
from pathlib import Path

from rdflib import Graph, Namespace, URIRef, BNode, RDF, RDFS, OWL
from jinja2 import Environment, FileSystemLoader, select_autoescape

ELMO = Namespace("https://w3id.org/elmo/elmo_")
IAO = Namespace("http://purl.obolibrary.org/obo/IAO_")
OBOINOWL = Namespace("http://www.geneontology.org/formats/oboInOwl#")
SKOS = Namespace("http://www.w3.org/2004/02/skos/core#")
ELMOP = Namespace("https://w3id.org/elmo/property/")
OBO_PURL = "http://purl.obolibrary.org/obo/"

DEFINITION = IAO["0000115"]
EDITOR_NOTE = IAO["0000116"]
OBSOLESCENCE_REASON = IAO["0000231"]
REPLACED_BY = IAO["0100001"]

HAS_EXACT_SYNONYM = OBOINOWL.hasExactSynonym
HAS_BROAD_SYNONYM = OBOINOWL.hasBroadSynonym
HAS_NARROW_SYNONYM = OBOINOWL.hasNarrowSynonym
HAS_RELATED_SYNONYM = OBOINOWL.hasRelatedSynonym
HAS_DB_XREF = OBOINOWL.hasDbXref
BROAD_MATCH = SKOS.broadMatch
HAS_CAS_CODE = ELMOP.hasCASCode

NO_PARENT_KEY = "__no_parent__"


def find_repo_root(start: Path) -> Path:
    """Walk up from a directory until we find the repo root (marked by mkdocs.yaml)."""
    for candidate in (start, *start.parents):
        if (candidate / "mkdocs.yaml").exists():
            return candidate
    raise FileNotFoundError(
        f"Could not locate repo root (no mkdocs.yaml found above {start})"
    )


def guess_curie(g: Graph, uri: URIRef) -> str:
    """Best-effort human-readable CURIE for a (possibly external/imported) URI."""
    s = str(uri)
    if s.startswith(OBO_PURL):
        local = s[len(OBO_PURL):]
        return local.replace("_", ":", 1)
    try:
        return g.namespace_manager.curie(uri)
    except Exception:
        return s


def resolve_term(g: Graph, uri):
    """Return display info for any class URI, ELMO-internal or external/imported."""
    if uri is None or isinstance(uri, BNode):
        return None
    label = g.value(uri, RDFS.label)
    is_internal = str(uri).startswith(str(ELMO))
    if is_internal:
        local = str(uri)[len(str(ELMO)):]
        anchor_id = f"elmo_{local}"
        curie = f"ELMO:{local}"
        href = f"#{anchor_id}"
    else:
        anchor_id = None
        curie = guess_curie(g, uri)
        href = str(uri)
    return {
        "uri": str(uri),
        "label": str(label) if label else curie,
        "curie": curie,
        "href": href,
        "anchor_id": anchor_id,
        "is_internal": is_internal,
    }


def build_axiom_xref_index(g: Graph):
    """Map (subject, annotated_property) -> [hasDbXref values] via reified owl:Axiom
    annotations, so we can surface e.g. a definition's source citation."""
    index = {}
    for axiom in g.subjects(RDF.type, OWL.Axiom):
        src = g.value(axiom, OWL.annotatedSource)
        prop = g.value(axiom, OWL.annotatedProperty)
        if src is None or prop is None:
            continue
        xrefs = list(g.objects(axiom, HAS_DB_XREF))
        if xrefs:
            index.setdefault((src, prop), []).extend(xrefs)
    return index


def xref_display(values):
    return [{"text": str(v), "is_link": isinstance(v, URIRef)} for v in values]


def build_terms(g: Graph):
    axiom_xrefs = build_axiom_xref_index(g)

    class_subjects = [
        s for s in g.subjects(RDF.type, OWL.Class) if str(s).startswith(str(ELMO))
    ]

    terms = {}
    multi_parent_count = 0

    for s in class_subjects:
        local = str(s)[len(str(ELMO)):]
        anchor_id = f"elmo_{local}"

        label = g.value(s, RDFS.label, default=None)
        label = str(label) if label else "MISSING LABEL"

        deprecated_flag = g.value(s, OWL.deprecated)
        deprecated = bool(deprecated_flag) and str(deprecated_flag).lower() == "true"

        replaced_by_uri = g.value(s, REPLACED_BY)

        parents_raw = [
            p for p in g.objects(s, RDFS.subClassOf)
            if isinstance(p, URIRef) and p != s
        ]
        if len(parents_raw) > 1:
            multi_parent_count += 1

        internal_parents = [p for p in parents_raw if str(p).startswith(str(ELMO))]
        external_parents = [p for p in parents_raw if not str(p).startswith(str(ELMO))]
        ordered_parents = internal_parents + external_parents
        primary_parent_uri = ordered_parents[0] if ordered_parents else None
        additional_parent_uris = ordered_parents[1:]

        definition = g.value(s, DEFINITION)
        comment = g.value(s, RDFS.comment)

        terms[anchor_id] = {
            "anchor_id": anchor_id,
            "curie": f"ELMO:{local}",
            "uri": str(s),
            "label": label,
            "deprecated": deprecated,
            "obsolescence_reason": g.value(s, OBSOLESCENCE_REASON),
            "replaced_by": resolve_term(g, replaced_by_uri),
            "primary_parent_uri": primary_parent_uri,
            "additional_parents": [resolve_term(g, p) for p in additional_parent_uris],
            "children": [],
            "definition": str(definition) if definition else None,
            "definition_source": xref_display(axiom_xrefs.get((s, DEFINITION), [])),
            "comment": str(comment) if comment else None,
            "comment_source": xref_display(axiom_xrefs.get((s, RDFS.comment), [])),
            "editor_note": g.value(s, EDITOR_NOTE),
            "synonyms": {
                "exact": [str(x) for x in g.objects(s, HAS_EXACT_SYNONYM)],
                "broad": [str(x) for x in g.objects(s, HAS_BROAD_SYNONYM)],
                "narrow": [str(x) for x in g.objects(s, HAS_NARROW_SYNONYM)],
                "related": [str(x) for x in g.objects(s, HAS_RELATED_SYNONYM)],
            },
            "cas_codes": [str(x) for x in g.objects(s, HAS_CAS_CODE)],
            "cas_matches": [resolve_term(g, x) for x in g.objects(s, BROAD_MATCH)],
        }

    return terms, multi_parent_count


def link_primary_parent(g: Graph, terms):
    """Resolve each term's primary_parent to a full display dict (label, curie,
    href) via resolve_term(), falling back to 'no parent' if the parent is a
    deprecated ELMO term (dangling reference) or genuinely absent.

    term["primary_parent"] is only used for INTERNAL tree placement when its
    anchor_id is set; external parents still get a resolved dict here (for
    display in the term's own breadcrumb) but are treated as tree roots by
    build_tree(), which checks anchor_id rather than mere presence."""
    for term in terms.values():
        parent_uri = term["primary_parent_uri"]
        if parent_uri is None:
            term["primary_parent"] = None
            continue
        if str(parent_uri).startswith(str(ELMO)):
            parent_anchor = f"elmo_{str(parent_uri)[len(str(ELMO)):]}"
            if terms.get(parent_anchor, {}).get("deprecated"):
                term["primary_parent_uri"] = None
                term["primary_parent"] = None
                continue
        term["primary_parent"] = resolve_term(g, parent_uri)


def build_search_blob(term):
    parts = [term["label"], term["curie"]]
    for group in term["synonyms"].values():
        parts.extend(group)
    return " ".join(parts).lower()


def build_tree(g: Graph, terms):
    """Build a forest over ACTIVE (non-deprecated) terms only, grouped into root
    branches by each root's external (or missing) parent attachment point."""
    active = {k: t for k, t in terms.items() if not t["deprecated"]}

    children_map = {}
    for anchor_id, term in active.items():
        parent = term["primary_parent"]
        parent_key = parent["anchor_id"] if parent else None
        children_map.setdefault(parent_key, []).append(anchor_id)

    for anchor_id, term in active.items():
        child_ids = sorted(children_map.get(anchor_id, []), key=lambda a: active[a]["label"].lower())
        term["children"] = [
            {"anchor_id": c, "label": active[c]["label"], "curie": active[c]["curie"]}
            for c in child_ids
        ]

    # Root groups: terms with no active INTERNAL parent (primary_parent may
    # still be set for an external parent -- that's what we group roots by),
    # grouped by external parent URI (or a synthetic "no parent" bucket).
    root_groups = {}
    for anchor_id, term in active.items():
        if term["primary_parent"] and term["primary_parent"]["anchor_id"]:
            continue
        parent_uri = term["primary_parent_uri"]
        if parent_uri is not None:
            key = str(parent_uri)
            heading = term["primary_parent"]
        else:
            key = NO_PARENT_KEY
            heading = {"label": "(no asserted parent)", "href": None, "curie": None, "is_internal": False}
        root_groups.setdefault(key, {"heading": heading, "root_ids": []})
        root_groups[key]["root_ids"].append(anchor_id)

    def build_node(anchor_id, visited):
        if anchor_id in visited:
            return {"term": active[anchor_id], "children": []}
        visited = visited | {anchor_id}
        term = active[anchor_id]
        child_ids = sorted(
            children_map.get(anchor_id, []), key=lambda a: active[a]["label"].lower()
        )
        return {
            "term": term,
            "children": [build_node(c, visited) for c in child_ids],
        }

    roots = []
    for group in root_groups.values():
        root_ids = sorted(group["root_ids"], key=lambda a: active[a]["label"].lower())
        roots.append({
            "heading": group["heading"],
            "nodes": [build_node(r, frozenset()) for r in root_ids],
        })
    roots.sort(key=lambda r: (r["heading"]["label"] or "").lower())

    return roots


def flatten_main_sequence(roots):
    sequence = []
    for group_index, root in enumerate(roots):
        sequence.append({"kind": "heading", "heading": root["heading"], "group": group_index})

        def walk(node, depth):
            sequence.append({"kind": "term", "term": node["term"], "depth": depth, "group": group_index})
            for child in node["children"]:
                walk(child, depth + 1)

        for node in root["nodes"]:
            walk(node, 1)
    return sequence


def build_az_index(terms):
    active = sorted(
        (t for t in terms.values() if not t["deprecated"]),
        key=lambda t: t["label"].lower(),
    )
    groups = {}
    for term in active:
        letter = term["label"][:1].upper() if term["label"] else "#"
        if not letter.isalpha():
            letter = "#"
        groups.setdefault(letter, []).append(term)
    return sorted(groups.items())


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("ontology", help="Path to the merged ontology file (e.g. elmo.owl)")
    parser.add_argument("--output", help="Output HTML path (default: <repo_root>/docs/elmo.html)")
    args = parser.parse_args()

    script_dir = Path(__file__).resolve().parent
    repo_root = find_repo_root(script_dir)
    output_path = Path(args.output) if args.output else repo_root / "docs" / "elmo.html"

    g = Graph()
    g.parse(args.ontology)
    g.namespace_manager.bind("ELMO", ELMO, override=True)

    terms, multi_parent_count = build_terms(g)
    link_primary_parent(g, terms)
    for term in terms.values():
        term["search_blob"] = build_search_blob(term)

    roots = build_tree(g, terms)
    main_sequence = flatten_main_sequence(roots)
    az_index = build_az_index(terms)
    deprecated_terms = sorted(
        (t for t in terms.values() if t["deprecated"]),
        key=lambda t: t["label"].lower(),
    )

    file_loader = FileSystemLoader(str(script_dir))
    env = Environment(loader=file_loader, autoescape=select_autoescape(["html"]))
    template = env.get_template("onto_jinja.html")

    output = template.render(
        roots=roots,
        main_sequence=main_sequence,
        az_index=az_index,
        deprecated_terms=deprecated_terms,
    )

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(output)

    print(f"Output has been written to {output_path}")
    print(
        f"Terms: {len(terms)} total, {len(deprecated_terms)} deprecated, "
        f"{multi_parent_count} with multiple asserted parents, {len(roots)} root groups."
    )


if __name__ == "__main__":
    main()
