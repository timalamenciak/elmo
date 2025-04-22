## Customize Makefile settings for elmo
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile

.PHONY:update_lode
update_lode: 
	pip install pylode --break-system-packages
	python -m pylode -o /work/elmo/docs/lode.html /work/elmo/elmo.owl