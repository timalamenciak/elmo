# ELMO Ontology Changelog

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
