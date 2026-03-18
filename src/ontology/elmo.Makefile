## Customize Makefile settings for elmo
##
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

# ----------------------------------------
# Local ROBOT (outside Docker)
# Override LOCAL_ROBOT on the command line if your robot.jar is elsewhere:
#   make reason LOCAL_ROBOT="java -jar /path/to/robot.jar"
# ----------------------------------------
LOCAL_ROBOT ?= java -jar "C:/Users/Tim Alamenciak/Documents/TReK/Racoon/ROBOT/robot.jar"
LOCAL_ROBOT_CATALOG = --catalog $(CATALOG)

# ----------------------------------------
# ROBOT integration targets
# ----------------------------------------

## Run ELK reasoning and check for unsatisfiable classes
.PHONY: reason
reason: $(EDIT_PREPROCESSED)
	$(LOCAL_ROBOT) reason \
		$(LOCAL_ROBOT_CATALOG) \
		--input $< \
		--reasoner ELK \
		--equivalent-classes-allowed all \
		--exclude-tautologies structural \
		--output test.owl && rm test.owl
	@echo "Reasoning complete — no unsatisfiable classes found."

## Generate OBO-style quality report for the merged ontology
.PHONY: report
report: $(SRC)
	$(LOCAL_ROBOT) merge \
		$(LOCAL_ROBOT_CATALOG) \
		--input $(SRC) \
		report \
		--output $(REPORTDIR)/elmo-edit.owl-obo-report.tsv
	@echo "Report written to $(REPORTDIR)/elmo-edit.owl-obo-report.tsv"

## Explain why a class is unsatisfiable.  Usage: make explain CLASS=<IRI>
##   e.g. make explain CLASS="https://w3id.org/elmo/elmo_3620001"
.PHONY: explain
explain: $(EDIT_PREPROCESSED)
ifndef CLASS
	$(error Usage: make explain CLASS=<full IRI>)
endif
	$(LOCAL_ROBOT) explain \
		$(LOCAL_ROBOT_CATALOG) \
		--input $< \
		--reasoner ELK \
		--axiom "SubClassOf(<$(CLASS)> owl:Nothing)" \
		--explanation $(REPORTDIR)/explanation.md
	@echo "Explanation written to $(REPORTDIR)/explanation.md"

## Run SPARQL-based verification checks (missing definitions, labels, none-defs)
.PHONY: verify
verify: $(SRC)
	$(LOCAL_ROBOT) merge \
		$(LOCAL_ROBOT_CATALOG) \
		--input $(SRC) \
		verify \
		--queries $(SPARQLDIR)/missing-definitions.sparql \
		          $(SPARQLDIR)/missing-labels.sparql \
		          $(SPARQLDIR)/none-definitions.sparql \
		--output-dir $(REPORTDIR)
	@echo "Verification complete."

.PHONY:update_lode
update_lode:
	pip install pylode --break-system-packages
	python -m pylode -o /work/elmo/docs/lode.html /work/elmo/elmo.owl

.PHONY:update_html
update_html:
	python scripts/owl2mkdocs.py /work/elmo/elmo.owl