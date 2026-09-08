---
layout: ontology_detail
id: elmo
title: Ecological Management Ontology (ELMO)
jobs:
  - id: https://travis-ci.org/timalamenciak/elmo
    type: travis-ci
build:
  checkout: git clone https://github.com/timalamenciak/elmo.git
  system: git
  path: "."
contact:
  email: tim.alamenciak@gmail.com
  label: Tim Alamenciak
  github: https://github.com/timalamenciak
description: Ecological Management Ontology (ELMO) is an ontology that contains terms relevant to ecological management, including the restoration and conservation of biodiversity. ELMO captures ecological interventions (e.g. planting, seeding, controlled burns), ecosystem types (e.g. IUCN's Ecosystem Functional Groups), and some environmental variables that are commonly measured in the discipline (e.g. species richness, species diversity).
domain: restoration and conservation of biodiversity
homepage: https://github.com/timalamenciak/elmo
products:
  - id: elmo.owl
    name: "Ecological Management Ontology (ELMO) main release in OWL format"
  - id: elmo.obo
    name: "Ecological Management Ontology (ELMO) additional release in OBO format"
  - id: elmo.json
    name: "Ecological Management Ontology (ELMO) additional release in OBOJSon format"
  - id: elmo/elmo-base.owl
    name: "Ecological Management Ontology (ELMO) main release in OWL format"
  - id: elmo/elmo-base.obo
    name: "Ecological Management Ontology (ELMO) additional release in OBO format"
  - id: elmo/elmo-base.json
    name: "Ecological Management Ontology (ELMO) additional release in OBOJSon format"
dependencies:
- id: ro
- id: cob
- id: envo
- id: orcidio

tracker: https://github.com/timalamenciak/elmo/issues
license:
  url: http://creativecommons.org/licenses/by/3.0/
  label: CC-BY
activity_status: active
---

Enter a detailed description of your ontology here. You can use arbitrary markdown and HTML.
You can also embed images too.

