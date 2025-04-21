## Customize Makefile settings for elmo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

.PHONY:update_lode
update_lode: 
	pip install pylode --break-system-packages
	python -m pylode -o /work/elmo/docs/lode.html /work/elmo/elmo.owl

$(COMPONENTSDIR)/interventions.owl: $(SRC) ../templates/interventions.tsv 
	$(ROBOT) template --template ../templates/interventions.tsv \
  annotate --ontology-iri $(ONTBASE)/$@ --output $(COMPONENTSDIR)/interventions.owl