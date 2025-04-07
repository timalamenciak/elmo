## Customize Makefile settings for elmo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile
$(IMPORTDIR)/orcidio_terms_combined.txt: $(SRCMERGED)
	$(ROBOT) query -f csv -i $< --query ../sparql/orcids.sparql $@.tmp &&\
	cat $@.tmp | sort | uniq >  $@