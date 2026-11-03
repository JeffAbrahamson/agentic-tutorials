PANDOC ?= pandoc
PDF_ENGINE ?= xelatex

.PHONY: all clean
all: docker-secrets.pdf

docker-secrets.pdf: tutorial.md pdf-header.tex code-breaks.lua span-markers.lua title-block.lua Makefile
	mkdir -p .build
	$(PANDOC) tutorial.md --standalone --toc --toc-depth=2 \
	  --shift-heading-level-by=-1 --pdf-engine=$(PDF_ENGINE) \
	  --lua-filter=title-block.lua \
	  --include-in-header=pdf-header.tex --lua-filter=code-breaks.lua --lua-filter=span-markers.lua \
	  --highlight-style=tango --resource-path=. \
	  --metadata=lang:en-GB \
	  --variable=documentclass:article \
	  --variable=fontsize:12pt \
	  --variable=mainfont:'Latin Modern Roman' \
	  --variable=monofont:'Latin Modern Mono' \
	  --variable=geometry:'paperwidth=160mm,paperheight=230mm,margin=15mm' \
	  --variable=colorlinks:true --variable=linkcolor:blue \
	  --variable=urlcolor:blue --output=.build/docker-secrets.pdf
	cp .build/docker-secrets.pdf $@

clean:
	rm -rf .build
