# ELMO Ontology Changelog

## 2026-06-18 — P3: Redundancy Resolution, New Terms, Semantic Precision

Changes applied to `src/templates/interventions.tsv`. Adds 15 new terms (ELMO:3621037–3621051), deprecates 1 redundant term, reclassifies 1 term, and updates 5 definitions for semantic precision.

---

### Section 4 — Redundancy resolution

#### 4.1 — Deprecated: `local bylaw process` (ELMO:3620810)

- **Deprecated in favour of:** `municipal legislation process` (ELMO:3621034)
- **Reason:** Both terms describe local-government conservation legislation. `local bylaw process` was defined as "An area policy process in which some pro-conservation bylaw is established by a local authority," which substantially overlaps with `municipal legislation process` ("A legislation process in which a local or municipal government passes bylaws or regulations with pro-conservation goals"). The latter is broader, more precisely placed in the hierarchy (direct child of `legislation process`), and was added as a Delphi survey addition. ELMO:3620810 is deprecated with `owl:deprecated true`, `IAO:0100001` → ELMO:3621034, and `IAO:0000231` → `IAO:0000227` (terms merged).

#### 4.2 — Clarified: `plug planting process` (ELMO:3620602)

- **Definition updated** to clarify that the defining feature is the *plug-tray propagule form* (whether grown from seed, cutting, or division), not the growth stage. This makes the term distinct from `seedling planting process` (ELMO:3620605), which is defined by growth stage (young plant raised from seed), not by container type.

---

### Section 6 — New terms (ELMO:3621037–3621049)

Thirteen new terms added to fill coverage gaps identified in the ontology review.

| CURIE | Label | Parent |
|---|---|---|
| ELMO:3621037 | `prescribed fire process` | `mechanical ecosystem management process` |
| ELMO:3621038 | `assisted natural regeneration process` | `biological ecosystem management process` |
| ELMO:3621039 | `invasive species management process` | `ENVO:01001170` (active ecosystem management process) |
| ELMO:3621040 | `coral gardening process` | `biological ecosystem management process` |
| ELMO:3621041 | `aerial seeding process` | `seeding process` |
| ELMO:3621042 | `herbaceous planting process` | `planting process` |
| ELMO:3621043 | `fire regime alteration process` | `plan specification change process` |
| ELMO:3621044 | `rodenticide application process` | `chemical application process` |
| ELMO:3621045 | `wildlife disease management process` | `biological ecosystem management process` |
| ELMO:3621046 | `ecological monitoring process` | `ecosystem-oriented social process` |
| ELMO:3621047 | `habitat connectivity enhancement process` | `mechanical ecosystem management process` |
| ELMO:3621048 | `acoustic deterrent process` | `mechanical fauna deterrent process` |
| ELMO:3621049 | `visual deterrent process` | `mechanical fauna deterrent process` |

**Notes:**
- ELMO:3621039 (`invasive species management process`) is parented directly under ENVO:01001170 rather than under any one method branch (biological/chemical/mechanical) because invasive species management is defined by its *target* (non-native invasive species), not its method. Its definition explicitly notes that biological, chemical, and mechanical approaches all apply.
- ELMO:3621037 (`prescribed fire process`) has exact synonyms `controlled burning process` and `prescribed burning process`.
- ELMO:3621047 (`habitat connectivity enhancement process`) has exact synonym `habitat corridor creation process`.

---

### Section 7 — Semantic precision

#### 7.1 — `biological fauna control process` (ELMO:3620623) — definition scope

- **Old definition:** "A biological ecosystem management process in which a human uses biological means to reduce or increase a population of fauna."
- **New definition:** Narrowed to reflect that remaining children (fauna sterilization, egg destruction, nest establishment deterrence) are exclusively population-reduction processes following removal of individual-welfare terms in P1.

#### 7.2 — `nest establishment deterrence process` (ELMO:3620635) — definition genus error

- **Old definition:** "A **biological ecosystem management process** in which a human implements measures to deter fauna from establishing nest sites in a given area."
- **New definition:** "A **biological fauna control process** in which a human implements measures to deter fauna from establishing nest sites in a given area."
- **Reason:** OBO Foundry requires the genus in a definition to be the *immediate* parent class. The immediate parent is `biological fauna control process`, not the grandparent `biological ecosystem management process`.

#### 7.3 — `plan specification change process` (ELMO:3620849) — reclassification

- **Old parent:** `ecosystem-oriented social process`
- **New parent:** `ENVO:01001170` (active ecosystem management process — same level as biological/chemical/mechanical branches)
- **Definition updated** from "A ecosystem-oriented social process in which a human alters the way in which some planned process is undertaken" to: "An active ecosystem management process in which a human modifies the parameters of an ongoing management regime — such as its timing, frequency, intensity, or spatial extent — in order to improve ecological outcomes."
- **Reason:** Regime modification processes (mowing timing, fire regime, dam regime, etc.) are operational management decisions, not social processes. The social process branch covers policy, legislation, and outreach; regime alterations are better placed alongside biological/chemical/mechanical management.

#### 7.4 — `fishing with modified line-setting procedure` (ELMO:3621005) — overspecific definition

- **Old definition:** "A fishing process in which a human attaches bait to lines in a way that deters seabird scavenging (i.e. underwater)"
- **New definition:** Broadened to cover all line-setting modifications for bycatch reduction (depth, bait attachment method, deployment timing) across non-target taxa (seabirds, sea turtles), not just seabird scavenging by the specific mechanism of underwater baiting.

#### 7.5 — Chemical process symmetry: two new terms (ELMO:3621050–3621051)

The chemical application branch (`chemical application process`, ELMO:3620501) lacked coverage for two widely-used pesticide classes used in ecosystem restoration.

| CURIE | Label | Parent |
|---|---|---|
| ELMO:3621050 | `molluscicide application process` | `chemical application process` |
| ELMO:3621051 | `piscicide application process` | `chemical application process` |

`molluscicide application process` covers applications targeting invasive snails and mussels. `piscicide application process` covers applications targeting fish populations prior to native fish reintroduction (e.g., lake renovation).

#### 7.6 — `seabed amendment process` (ELMO:3620636)

Definition was substantially improved in the P2 review (Section 2.4). No further changes required.

---

*Changes applied by: Tim Alamenciak (https://orcid.org/0000-0002-1296-2528)*
*Review date: 2026-06-18*

---

## 2026-06-12 — Naming Convention Standardisation & Definition Quality Rewrites

Changes applied to `src/templates/interventions.tsv`. All label renames preserve the previous label as an exact synonym for backward compatibility.

---

### Section 3 — Label renames: OBO Foundry noun-phrase convention

OBO Foundry requires class labels to be singular noun phrases. The following terms used imperative verb phrases or verbless gerund phrases. All have been renamed to noun phrases ending in "process". Old labels are retained as `oboInOwl:hasExactSynonym`. Child rows whose `SC %` (parent) column referenced a renamed label were updated automatically (18 cascade updates).

#### 3.1 Regulation and prohibition terms (16 terms)

| CURIE | Old label | New label |
|---|---|---|
| ELMO:3620831 | `regulate grazing` | `grazing regulation process` |
| ELMO:3620832 | `prohibit grazing` | `grazing prohibition process` |
| ELMO:3620833 | `regulate fishing` | `fishing regulation process` |
| ELMO:3620834 | `prohibit fishing` | `fishing prohibition process` |
| ELMO:3620835 | `regulate chemical usage` | `chemical usage regulation process` |
| ELMO:3620836 | `prohibit chemical usage` | `chemical usage prohibition process` |
| ELMO:3620837 | `regulate hunting` | `hunting regulation process` |
| ELMO:3620838 | `prohibit hunting` | `hunting prohibition process` |
| ELMO:3620839 | `regulate recreational activities` | `recreational activity regulation process` |
| ELMO:3620840 | `prohibit recreational activities` | `recreational activity prohibition process` |
| ELMO:3620841 | `limit public access` | `public access limitation process` |
| ELMO:3620842 | `prohibit public access` | `public access prohibition process` |
| ELMO:3620843 | `regulate dredging` | `dredging regulation process` |
| ELMO:3620844 | `prohibit dredging` | `dredging prohibition process` |
| ELMO:3620845 | `regulate aquaculture` | `aquaculture regulation process` |
| ELMO:3620846 | `prohibit aquaculture` | `aquaculture prohibition process` |

#### 3.2 Regime alteration terms (12 terms)

| CURIE | Old label | New label |
|---|---|---|
| ELMO:3620850 | `alter mowing timing` | `mowing timing alteration process` |
| ELMO:3620851 | `alter mowing regime` | `mowing regime alteration process` |
| ELMO:3620852 | `alter mowing height` | `mowing height alteration process` |
| ELMO:3620853 | `alter tilling regime` | `tilling regime alteration process` |
| ELMO:3620854 | `alter chemical regime` | `chemical regime alteration process` |
| ELMO:3620855 | `alter insecticide regime` | `insecticide regime alteration process` |
| ELMO:3620856 | `alter fertilizer regime` | `fertilizer regime alteration process` |
| ELMO:3620857 | `alter lighting regime` | `lighting regime alteration process` |
| ELMO:3620858 | `alter grazing regime` | `grazing regime alteration process` |
| ELMO:3620859 | `alter dam regime` | `dam regime alteration process` |
| ELMO:3620860 | `alter herbicide regime` | `herbicide regime alteration process` |
| ELMO:3620861 | `cease herbicide usage` | `herbicide cessation process` |

#### 3.3 Modified usage and farming terms (12 terms)

| CURIE | Old label | New label |
|---|---|---|
| ELMO:3620644 | `intentional grazing` | `intentional grazing process` |
| ELMO:3621000 | `fishing with equipment modified for conservation` | `conservation-modified fishing process` |
| ELMO:3621001 | `fishing with net modified for conservation` | `conservation-modified net fishing process` |
| ELMO:3621002 | `fishing with hook modified for conservation` | `conservation-modified hook fishing process` |
| ELMO:3621003 | `fishing with added acoustic devices for conservation` | `acoustic bycatch deterrent fishing process` |
| ELMO:3621009 | `farming with intercropping` | `intercropping process` |
| ELMO:3621012 | `no-till farming` | `no-till farming process` |
| ELMO:3621013 | `organic farming regime` | `organic farming process` |
| ELMO:3621014 | `crop rotation` | `crop rotation process` |
| ELMO:3621015 | `set aside farmland for conservation` | `farmland set-aside process` |
| ELMO:3621020 | `leave woody debris` | `coarse woody debris retention process` |
| ELMO:3621022 | `regulate wind turbine speed` | `wind turbine speed regulation process` |

---

### Section 2.2 — Definition rewrites: regulation and prohibition hierarchy (16 terms)

All 16 `regulate/prohibit` (now `regulation/prohibition`) terms previously had circular definitions that restated the term label without adding semantic content (e.g. "An environmental usage regulation process in which some authority regulates grazing in a given area"). Each definition has been rewritten to describe what the regulatory action involves, the kinds of conditions or restrictions imposed, and the ecological purpose served. The new definitions follow Aristotelian genus-differentia form with the immediate parent class as genus.

Affected CURIEs: ELMO:3620831–ELMO:3620846.

---

### Section 2.3 — `mulch addition process` (ELMO:3620638)

- **Old definition:** "A soil amendment process in which a human adds mulch (i.e. woody debris)."
- **New definition:** "A soil amendment process in which a human applies a layer of organic material such as wood chips, shredded bark, straw, or leaf litter to the soil surface to retain moisture, suppress competing vegetation, regulate soil temperature, or add organic matter as it decomposes."
- **Reason:** The parenthetical `(i.e. woody debris)` incorrectly restricted mulch to one material type. "i.e." was wrong; the field accepts many organic mulch materials.

---

### Section 2.4 — `seabed amendment process` (ELMO:3620636)

- **Old definition:** "A biological ecosystem management process in which a human adds material to a seabed to facilitate nesting."
- **New definition:** "A biological ecosystem management process in which a human adds material to the bed of a water body to improve habitat conditions for benthic fauna. Examples include adding gravel or coarse substrate to provide spawning habitat for fish, adding shell hash or crushed oyster shell to facilitate bivalve reef establishment, or adding coarse sand to support nesting by benthic invertebrates."
- **Reason:** Previous definition was too narrow (nesting only) and did not distinguish this from artificial reef creation. Expanded to cover the full scope of benthic substrate enhancement.

---

### Section 2.5 — `buffer strip retention process` (ELMO:3620042)

- **Definition updated** to clarify that retention is an *active* management decision (deliberate exclusion from clearing), not passive omission.
- **Editors note updated** to replace the unresolved "consider whether..." uncertainty with a committed statement that passive non-intervention is not in scope, and to cross-reference legal protection process (ELMO:3620802) for formally protected buffers.

---

### Section 2.6 — `mowing process` (ELMO:3621036)

- **Old parent:** `mechanical vegetation removal process`
- **New parent:** `cutting removal process`
- **Reason:** Mowing is a type of cutting; it should be a child of `cutting removal process` (ELMO:3620024) rather than a sibling of it. Being siblings while `cutting removal process` was also listed as a broad synonym was contradictory.
- `cutting removal process` removed from the `broad synonym` column; the relationship is now expressed structurally via subsumption.

---

### Note: Section 2.7 deferred

Systematic reformatting of ecosystem definitions for ELMO:3620100–ELMO:3620131 (approximately 32 terms with IUCN paragraph-length definitions that predate the ontology's IAO:0000115 formatting standard) has been deferred as a separate dedicated milestone. Later ecosystem terms (ELMO:3620277 onwards) already follow the correct short-form genus-differentia format and do not require changes.

---

*Changes applied by: Tim Alamenciak (https://orcid.org/0000-0002-1296-2528)*
*Review date: 2026-06-12*

---

## 2026-06-12 — Structural Review: P1 Fixes

Changes applied to `src/templates/interventions.tsv` based on a systematic ontology design review. All changes are structural corrections to existing terms; no new terms were added.

---

### Reclassifications

#### ELMO:3620049 — `tilling process`
- **Old parent:** `soil decompaction process`
- **New parent:** `earthworks process`
- **Reason:** Tilling is a physical earthworks operation used for many purposes (weed control, seedbed preparation, organic matter incorporation). Classifying it under soil decompaction incorrectly implies decompaction is its defining function.

#### ELMO:3620050 — `ploughing process`
- **Old parent:** `soil decompaction process`
- **New parent:** `tilling process`
- **Reason:** Ploughing is a type of tillage. Classifying it under soil decompaction was incorrect; ploughing can increase compaction (plough pan formation) and is not defined by decompaction.

#### ELMO:3620605 — `seedling planting process`
- **Old parent:** `tree planting process`
- **New parent:** `planting process`
- **Old definition:** A planting process in which a human plants trees that have been grown in plug trays.
- **New definition:** A planting process in which a human plants seedlings — young plants raised from seed in a greenhouse or nursery — of any growth form, including trees, shrubs, forbs, or grasses.
- **Reason:** "Seedling" is a growth stage, not a life form. The previous placement and definition restricted the class to trees, which excludes shrub, forb, and grass seedlings. Also reduces overlap with `plug planting process` (ELMO:3620602).

#### ELMO:3620625 — `egg relocation and release process`
- **Old parent:** `captive breeding and release process`
- **New parent:** `biological ecosystem management process`
- **Reason:** `captive breeding and release process` is defined as a process in which a human *facilitates the breeding* of fauna. Egg relocation involves moving existing wild eggs — no breeding is facilitated. The parent classification was semantically incorrect.

#### ELMO:3620626 — `egg incubation and release process`
- **Old parent:** `egg relocation and release process`
- **New parent:** `biological ecosystem management process`
- **Reason:** Follows from the reclassification of ELMO:3620625. Both egg-handling processes are now direct children of `biological ecosystem management process`, pending creation of a dedicated grouping class.

#### ELMO:3620632 — `soil transfer process`
- **Old parent:** `biological ecosystem management process`
- **New parent:** `mechanical ecosystem management process`
- **Reason:** Physically moving soil is a mechanical action. Any biological benefit (seedbank, soil biota transfer) is an outcome, not the nature of the act. Biological purpose is already captured by narrower terms such as `wetland seedbank transfer process` (ELMO:3621032).

#### ELMO:3620645 — `mycorrhizae addition process`
- **Old parent:** `biological ecosystem management process`
- **New parent:** `microbial inoculation process` (ELMO:3621033)
- **Reason:** `microbial inoculation process` was added in the 2026-03-18 Delphi revision specifically as the broader parent of mycorrhizae addition. The definition of ELMO:3621033 names ELMO:3620645 as a narrower term, but the hierarchy was not updated at the time. This edit resolves the inconsistency.

#### ELMO:3620647 — `fauna rescue, rehabilitation and release process`
- **Old parent:** `biological fauna control process`
- **New parent:** `biological ecosystem management process`
- **Reason:** `biological fauna control process` is defined as controlling (reducing or increasing) a population. Rescuing and rehabilitating individual animals does not constitute population control. Reclassified pending creation of a dedicated `fauna welfare and establishment process` grouping class.

#### ELMO:3620648 — `fauna reintroduction process`
- **Old parent:** `biological fauna control process`
- **New parent:** `biological ecosystem management process`
- **Reason:** Reintroduction is an establishment/restoration action into areas from which a species is absent. It is not population control. The previous classification under `biological fauna control process` was semantically inapt.

#### ELMO:3620649 — `fauna medical care process`
- **Old parent:** `biological fauna control process`
- **New parent:** `biological ecosystem management process`
- **Reason:** Medical care for individual animals is not a population control process. Reclassified alongside ELMO:3620647 and ELMO:3620648 pending a dedicated grouping class.

#### ELMO:3620816 — `human-assisted road crossing process`
- **Old parent:** `ecosystem-oriented social process`
- **New parent:** `mechanical fauna control process`
- **Reason:** Physically escorting fauna across a road is a mechanical intervention on fauna, not a social process. Its previous placement under social processes was inconsistent with mechanically analogous terms such as `fauna passage creation process` (ELMO:3620059).

#### ELMO:3620821 — `citizen science process`
- **Old parent:** `awareness-raising process`
- **New parent:** `ecosystem-oriented social process`
- **Reason:** The primary output of citizen science is ecological data, not awareness. Awareness may be an incidental effect but is not the defining purpose. Reclassified as a direct child of `ecosystem-oriented social process` pending creation of an `ecological monitoring process` grouping class.

---

### Definition Corrections

#### ELMO:3620500 — `chemical ecosystem management process`
- **Correction:** Fixed typo "applys" → "applies" in definition.

---

### Deprecation Standards

The following four terms were previously deprecated only via editors notes. OBO Foundry deprecation annotations (`owl:deprecated`, `IAO:0100001` term replaced by, `IAO:0000231` has_obsolescence_reason) have now been added. Three new columns were added to the interventions template to support these annotations.

| CURIE | Label | Replaced by | Reason code |
|---|---|---|---|
| ELMO:3620025 | `spading removal process` | ELMO:3620022 (`grubbing process`) | IAO:0000227 (terms merged) |
| ELMO:3620037 | `tile drain removal process` | ELMO:3620036 (`tile drain decommissioning process`) | IAO:0000227 (terms merged) |
| ELMO:3620505 | `glyphosate application process` | ELMO:3620504 (`herbicide application process`) | IAO:0000227 (terms merged) |
| ELMO:3620610 | `tree seeding process` | ELMO:3620609 (`seeding process`) | IAO:0000227 (terms merged) |

---

*Changes applied by: Tim Alamenciak (https://orcid.org/0000-0002-1296-2528)*
*Review date: 2026-06-12*

---

## 2026-03-18 — Delphi Survey Revisions

Changes applied to `src/templates/interventions.tsv` based on structured feedback from a Delphi survey of conservation practitioners.

---

### Renamed Terms

| CURIE | Old label | New label | Reason |
|-------|-----------|-----------|--------|
| ELMO:3620022 | `grubbing and spading removal process` | `grubbing process` | Root wrench removal and spading removal are the same physical operation; label simplified to match consolidated definition |
| ELMO:3620036 | `tile drain crushing process` | `tile drain decommissioning process` | Broader term that encompasses both crushing in situ and physical excavation/removal; the two former subtypes are now exact synonyms |
| ELMO:3620039 | `perch creation process` | `perch and roost creation process` | Expanded to reflect that the same structures serve both perching and roosting functions |
| ELMO:3620074 | `new plant protection process` | `plant protection process` | Removed "new" qualifier; protection of existing plants is equally in scope |
| ELMO:3620620 | `seed soaking process` | `seed soak treatment process` | Aligned naming convention with sibling seed treatment terms |
| ELMO:3620814 | `enforcement process` | `enforcement and compliance process` | Added "compliance" to reflect the monitoring and verification component of this activity |

---

### Merged Terms

#### ELMO:3620022 — `grubbing process`
- **Merged from:** ELMO:3620022 (grubbing/root wrench) and ELMO:3620025 (spading removal process)
- **New definition:** A mechanical vegetation removal process in which vegetation is uprooted by severing subsoil roots and prying or pulling the plant from the ground, using hand tools such as a spade, mattock, or root wrench.
- **New related synonyms:** `root wrench removal`, `spading removal`, `uprooting`
- **ELMO:3620025 status:** Retained as a stub with editors note: *"This term has been merged into grubbing process (ELMO:3620022). See that term for the consolidated definition."*

#### ELMO:3620036 — `tile drain decommissioning process`
- **Merged from:** ELMO:3620036 (tile drain crushing process) and ELMO:3620037 (tile drain removal process)
- **New definition:** A mechanical hydrological alteration process in which a human decommissions subterranean tile drains by collapsing them in situ or by excavating and removing them, in order to reduce artificial drainage and raise the water table.
- **New exact synonyms:** `tile drain crushing process`, `tile drain removal process`, `drain removal process`
- **ELMO:3620037 status:** Retained as a stub with editors note: *"This term has been merged into tile drain decommissioning process (ELMO:3620036). See that term for the consolidated definition."*

---

### Reclassified Terms

| CURIE | Label | Old parent | New parent | Reason |
|-------|-------|------------|------------|--------|
| ELMO:3620027 | `leaf litter removal process` | `mechanical vegetation removal process` | `mechanical ecosystem management process` | Leaf litter removal manages the substrate/ground layer rather than removing standing vegetation; the action targets accumulated organic material, not living plants |
| ELMO:3620646 | `peatland rewetting process` | `biological ecosystem management process` | `mechanical hydrological alteration process` | Rewetting is fundamentally a physical hydrological intervention (blocking drains, installing dams); biological recovery follows as a consequence but is not the direct action |

---

### Definition Updates

#### ELMO:3620023 — `cut and cover removal process`
- **Change:** Added related synonym `solarization`
- **Reason:** Solarization (using plastic sheeting) is a widely used equivalent technique; the synonym improves findability

#### ELMO:3620024 — `cutting removal process`
- **Old definition:** A mechanical vegetation removal process in which a human cuts plant material above ground level and removes it from the site.
- **New definition:** A mechanical vegetation removal process in which a human cuts plant material above ground level. Cut material may be removed from the site or left in place depending on management objectives.
- **Reason:** Cutting does not always involve removal; leaving material for habitat value or mulch is common practice

#### ELMO:3620026 — `canopy thinning process`
- **Change:** Definition broadened to include wildfire risk reduction and wildlife habitat objectives alongside competition reduction
- **Reason:** Multiple goals motivate canopy thinning; the previous definition was too narrow

#### ELMO:3620034 — `dam construction process`
- **Old phrasing:** "constructs some dam"
- **New phrasing:** "constructs a dam or barrier across a watercourse for ecological restoration purposes"
- **Reason:** Grammar correction; "barrier" added to reflect that not all structures are traditional dams (e.g. beaver dam analogues)
- **Exact synonym added:** `beaver dam analogue`

#### ELMO:3620035 — `dam removal process`
- **Old phrasing:** "removes some dam"
- **New phrasing:** "removes a dam or barrier with the goal of altering the hydroperiod of surrounding land"
- **Reason:** Grammar correction consistent with ELMO:3620034

#### ELMO:3620038 — `nest site creation process`
- **Change:** Definition expanded from bird-focused to include bats, small mammals, and other cavity-nesting fauna; examples added (nest boxes, artificial burrows, log piles)
- **Reason:** The process is equally applicable to non-avian cavity-nesters

#### ELMO:3620040 — `buffer strip creation process` and ELMO:3620041 — `riparian buffer strip creation process`
- **Old wording:** "cultivates strips of vegetation … along rivers"
- **New wording:** "establishes strips of vegetation … along watercourses"
- **Reason:** "Cultivates" implies agricultural intent; "establishes" is more appropriate for restoration. "Rivers" replaced with "watercourses" to include streams, ditches, and drains

#### ELMO:3620042 — `buffer strip retention process`
- **Old wording:** "retains strips of flora"
- **New wording:** "leaves strips of vegetation untouched"
- **Reason:** "Flora" is unnecessarily technical; "vegetation" is consistent with sibling terms
- **Editors note added:** Retention of an existing vegetated buffer constitutes an active management decision and is distinct from passive non-intervention

#### ELMO:3620054 — `shoreline reinforcement process`
- **Change:** Definition updated to explicitly include both inorganic materials (rock riprap, geotextile mesh) and organic materials (timber, living plant roots via bioengineering)
- **Reason:** Previous definition implied only hard engineering; soft/hybrid approaches are equally in scope

#### ELMO:3620060 — `topsoil removal process`
- **Change:** Definition expanded to explain ecological rationale: removing nutrient-rich topsoil reduces competitive dominance of ruderal species and creates conditions suitable for low-nutrient-adapted target communities; use as donor topsoil elsewhere noted
- **Reason:** Purpose was unclear in the previous definition

#### ELMO:3620065 — `irrigation process`
- **Old definition:** A mechanical ecosystem management process in which a human installs semi-permanent irrigation lines to supply water to plants at a restoration site.
- **New definition:** A mechanical ecosystem management process in which water is supplied artificially to plants at a restoration site. Methods may include drip irrigation, sprinklers, temporary hoses, or semi-permanent infrastructure depending on scale and site conditions.
- **Reason:** The previous definition over-specified one delivery method; many irrigation approaches are used in restoration

#### ELMO:3620074 — `plant protection process`
- **Old definition (as `new plant protection process`):** Narrowly scoped to protection of newly planted material
- **New definition:** A mechanical ecosystem management process in which a human installs barriers or protective structures around plants to protect them from herbivory, physical damage, or environmental stress. Includes tree guards, wire cages, and windbreaks.
- **Reason:** Protection applies to all plants on a restoration site, not only new plantings

#### ELMO:3620502 — `fertilizer application process`
- **Old definition:** Described fertilizer narrowly as nitrogen-based
- **New definition:** A chemical application process in which a human applies fertilizer or nutrient amendments to a given area with the goal of increasing soil nutrient availability, including macro-nutrients (N, P, K) and micro-nutrients.
- **Reason:** Fertilizers supply a range of nutrients; restricting to nitrogen was incorrect

#### ELMO:3620503 — `lime application process` *(critical bug fix)*
- **Old definition:** "…in order to **reduce** the pH and reduce acidity"
- **New definition:** "…in order to **raise** the pH and reduce acidity, thereby improving conditions for plant establishment"
- **Reason:** Factual error — lime (calcium carbonate/calcium oxide) raises soil pH, making it less acidic. The previous definition was the opposite of correct.
- **Editors note added:** *"Corrected: the previous definition incorrectly stated that lime reduces pH. Lime raises pH, making soil less acidic."*

#### ELMO:3620612 — `drill seeding process`
- **Old definition:** Vague description of mechanical seeding
- **New definition:** A seeding process in which a human uses a drill seeder to place seeds into the soil at a fixed spacing and depth, typically using machinery for larger areas.
- **Reason:** Clarified the precision characteristics (fixed spacing, controlled depth) that distinguish drill seeding from broadcast methods

#### ELMO:3620613 — `broadcast seeding process`
- **Old definition:** Vague description of surface seeding
- **New definition:** A seeding process in which a human scatters seeds across a surface at variable density, either by hand or using a mechanical spreader, without soil incorporation.
- **Reason:** Distinguishing characteristic (no soil incorporation, variable density) was absent

#### ELMO:3620615 — `hydroseeding process`
- **Old definition:** Described the slurry as inherently containing fertiliser and mulch
- **New definition:** A seeding process in which a human applies seed mixed in a water-based slurry, often including a tackifier or binder and sometimes colouring agent; additional amendments such as fertiliser or mulch may be included but are not inherent to the process.
- **Reason:** Nutrient additions are optional, not definitional; the previous definition was overly prescriptive

#### ELMO:3620628 — `supplemental water process`
- **Old definition:** Scoped to drought stress for plants
- **New definition:** A biological ecosystem management process in which a human provides supplemental water sources for wild fauna in areas where natural water availability is insufficient or intermittent. Includes wildlife water troughs, artificial pools, and drip stations.
- **Reason:** This process is primarily used for fauna water provision (especially in semi-arid restoration), not plant irrigation (which is covered by ELMO:3620065)

#### ELMO:3620631 — `moss layer transfer process`
- **Old definition:** Included blocking drainage ditches as part of the process
- **New definition:** A plant material transfer process in which a human collects material from the moss layer of a donor peatland and spreads it on a prepared receptor site to initiate Sphagnum establishment.
- **Reason:** Hydrological preparation steps (blocking ditches) are a separate preceding intervention and should not be conflated with the transfer itself
- **Editors note added:** Hydrological restoration steps that may precede or accompany moss transfer should be represented as separate processes (e.g. ditch plugging process, ELMO:3620072)

---

### Deprecated Terms

#### ELMO:3620505 — `glyphosate application process`
- **Status:** Deprecated via editors note
- **Reason:** A single herbicide active ingredient does not warrant a dedicated class; glyphosate application is an instance of herbicide application process (ELMO:3620504). Treating individual herbicide products as distinct ontology classes would require hundreds of parallel terms.
- **Editors note:** *"This term is deprecated. Glyphosate application is subsumed under herbicide application process (ELMO:3620504). Treating a single herbicide product as a distinct ontology class would require parallel terms for hundreds of active ingredients."*

#### ELMO:3620610 — `tree seeding process`
- **Status:** Deprecated via editors note
- **Reason:** Tree seeds are sown using identical techniques to other seeds (drill, broadcast, hydroseeding); a species-growth-form distinction does not create a meaningfully different process class.
- **Editors note:** *"This term is deprecated. Tree seeds are sown using the same techniques as other seeds. Use seeding process (ELMO:3620609) or an appropriate subtype."*

---

### Grammar and Wording Fixes

The phrase "a humans" (grammatical error in the definition template) was corrected to "humans" in the following terms:

| CURIE | Label |
|-------|-------|
| ELMO:3620801 | `legislation process` |
| ELMO:3620813 | `international agreement process` |
| ELMO:3620821 | `citizen science process` |
| ELMO:3620822 | `community engagement process` |
| ELMO:3620847 | `cultural ecosystem management process` |
| ELMO:3620848 | `cultural ecosystem usage process` |

#### ELMO:3620829 — `financial incentive process`
- **Old definition:** Scoped to individuals only
- **New definition:** An ecosystem-oriented social process in which financial incentives are offered to an individual, an organization, or a corporation in order to encourage pro-conservation management of land or resources.
- **Reason:** Financial instruments such as stewardship payments and carbon credits are commonly directed at landowners, corporations, and land trusts, not only private individuals

---

### New Terms

The following 13 terms were added (ELMO:3621024–3621036) based on processes identified as absent from the ontology by survey respondents.

| CURIE | Label | Parent | Synonyms |
|-------|-------|--------|----------|
| ELMO:3621024 | `tile drain installation process` | mechanical hydrological alteration process | — |
| ELMO:3621025 | `water control structure installation process` | mechanical hydrological alteration process | weir installation; sluice installation |
| ELMO:3621026 | `fungicide application process` | chemical application process | — |
| ELMO:3621027 | `soil acidification process` | chemical application process | soil pH amendment |
| ELMO:3621028 | `seed ball application process` | seeding process | seed pellet application; seedbomb application |
| ELMO:3621029 | `hay transfer process` | plant material transfer process | hay strewing; green hay transfer |
| ELMO:3621030 | `sod transfer process` | plant material transfer process | sod transplant process; turf transplant process |
| ELMO:3621031 | `forest floor litter transfer process` | plant material transfer process | — |
| ELMO:3621032 | `wetland seedbank transfer process` | plant material transfer process | wetland muck transfer |
| ELMO:3621033 | `microbial inoculation process` | biological ecosystem management process | rhizobial inoculation; soil inoculation; bioinoculant application |
| ELMO:3621034 | `municipal legislation process` | legislation process | local bylaw process |
| ELMO:3621035 | `cut and mulch process` | mechanical vegetation removal process | mulch mowing; chop and drop |
| ELMO:3621036 | `mowing process` | mechanical vegetation removal process | — |

**Notes on new terms:**
- ELMO:3621027 (`soil acidification process`) was added as a logical complement to ELMO:3620503 (`lime application process`), covering the opposite pH direction
- ELMO:3621033 (`microbial inoculation process`) is a broader sibling of ELMO:3620645 (`mycorrhizae addition process`), which is retained as a narrower term
- ELMO:3621034 (`municipal legislation process`) fills a jurisdictional gap alongside existing terms for provincial/state (ELMO:3620810–3620811) and national (ELMO:3620812) legislation

---

*Changes applied by: Tim Alamenciak (https://orcid.org/0000-0002-1296-2528)*
*Survey conducted: 2026-03*
