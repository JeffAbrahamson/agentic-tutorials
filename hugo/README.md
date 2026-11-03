# Hugo beyond Markdown

Read [hugo.pdf](hugo.pdf) or [the tutorial's Markdown](tutorial.md). The two small, runnable sites under
`examples/` support its predictions and review exercises:

- `advocacy/` inherits a local theme and overrides one component in the
  project;
- `photo-front/` generates album pages from a checked-in API snapshot using a
  content adapter and project-owned templates.

The fixtures target Hugo 0.168.0. Build commands and expected evidence are in
the tutorial's [fixture guide](tutorial.md#12-fixture-guide).

## Build the PDF

You need GNU Make, Pandoc, XeLaTeX, and the Latin Modern Roman, Latin Modern Mono and DejaVu Sans Mono fonts. DejaVu supplies the box-drawing characters that Latin Modern Mono lacks. The TeX installation needs the packages used by Pandoc's default LaTeX template, plus `fvextra`, `microtype`, `ragged2e`, `etoolbox`, `needspace` and `newunicodechar`. On Debian/Ubuntu, the usual packages are `make`, `pandoc`, `texlive-xetex`, `texlive-latex-extra`, `texlive-fonts-recommended`, `fonts-lmodern` and `fonts-dejavu-core`.

From the repository root:

```sh
make -C hugo
```

This produces `hugo/hugo.pdf`, using the same 160 × 230 mm layout and fonts as the other tutorials. Temporary files go in the ignored `.build/` directory.
