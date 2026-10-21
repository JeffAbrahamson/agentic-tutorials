PANDOC ?= pandoc
PDF_ENGINE ?= xelatex

.PHONY: all clean
all: opentofu.pdf

opentofu.pdf: tutorial.md pdf-header.tex Makefile
	mkdir -p .build
	$(PANDOC) tutorial.md --standalone --toc --toc-depth=1 \
	  --number-sections --pdf-engine=$(PDF_ENGINE) \
	  --include-in-header=pdf-header.tex --highlight-style=tango \
	  --resource-path=. --metadata=lang:en-GB \
	  --variable=documentclass:article --variable=fontsize:12pt \
	  --variable=mainfont:'Latin Modern Roman' \
	  --variable=monofont:'Latin Modern Mono' \
	  --variable=geometry:'paperwidth=160mm,paperheight=230mm,margin=15mm' \
	  --variable=colorlinks:true --variable=linkcolor:blue \
	  --variable=urlcolor:blue --output=.build/opentofu.pdf
	cp .build/opentofu.pdf $@

clean:
	rm -rf .build
