RMDS = $(wildcard chap*.Rmd)
MDS = $(RMDS:.Rmd=.md)

all: $(MDS)

%.md: %.Rmd
	Rscript -e "rmarkdown::render('$^', quiet = TRUE)"

clean:
	rm -f chap*.md chap*.html

.PHONY: all clean
