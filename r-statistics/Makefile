RMDS = $(wildcard chap*.Rmd)
MDS = $(RMDS:.Rmd=.md)

USERID = $(shell id -u)

all: $(MDS)

%.md: %.Rmd
	docker-compose run --rm -u $(USERID) r Rscript -e "rmarkdown::render('$^', quiet = TRUE)"

clean:
	rm -f chap*.md chap*.html

.PHONY: all clean
