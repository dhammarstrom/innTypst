# innTypst

Quarto/Typst formats in the visual style of the **University of Inland Norway**
(Universitetet i Innlandet, INN).

| Format | What it is | Lives in |
|:---|:---|:---|
| `innThesis-typst` | Master's and PhD thesis, as a Quarto **book**. Front matter, numbered chapters, appendices, bibliography, English/bokmål/nynorsk labels. | repository root |
| `innHandout-typst` | Single-document handout for teaching notes: green sidebar, margin notes, course footer. | `handout/` |

Each format is installed on its own — one `quarto add` gives you one format.
Run both commands in the same project if you want both, and then choose per
document with the `format:` key.

| To get | Start a new project from the template | Add to an existing project |
|:---|:---|:---|
| Thesis | `quarto use template dhammarstrom/innTypst` | `quarto add dhammarstrom/innTypst` |
| Handout | `quarto use template dhammarstrom/innTypst/handout` | `quarto add dhammarstrom/innTypst/handout` |

---

## Quick start (thesis)

```bash
quarto use template dhammarstrom/innTypst
cd <your-folder>
quarto render
```

That gives you a complete master's thesis skeleton that renders to
`_book/*.pdf`. Then:

1. Edit `_quarto.yml` — title, author, faculty, supervisors, and the list of
   chapters.
2. Replace the content of `index.qmd`, `frontmatter/`, `chapters/` and
   `appendices/` with your own.
3. Put your references in `references.bib`.

## Fonts

The template uses **Aptos**, INN's typeface, falling back to Segoe UI, Calibri
and finally a font bundled with Typst. Check what you have with:

```bash
quarto typst fonts
```

If `Aptos`, `Aptos Display` and `Aptos Mono` are missing, download them from
[Microsoft](https://www.microsoft.com/en-us/download/details.aspx?id=106087),
select all `.ttf` files, right-click and Install.

To use a different typeface, set `mainfont:` under the format in `_quarto.yml`.

---

## Structuring the thesis in `_quarto.yml`

Everything about the structure lives in `book.chapters` and `book.appendices`:

```yaml
book:
  title: "..."
  author: "..."
  chapters:
    - index.qmd                        # front matter starts here
    - frontmatter/sammendrag.qmd
    - frontmatter/acknowledgements.qmd
    - chapters/01-introduction.qmd     # main matter starts here
    - chapters/02-background.qmd
    - references.qmd                   # back matter
  appendices:
    - appendices/a-questionnaire.qmd
```

The three "matters" are worked out automatically:

* **Front matter** — everything listed *before the first numbered chapter*.
  Roman page numbers (i, ii, iii), no chapter numbers, no running head. Give
  these files an unnumbered heading: `# Abstract {.unnumbered}`.
* **Main matter** — from the first numbered chapter on. Page numbers restart at
  1, chapters are numbered and open on a right-hand page, and figures, tables
  and equations are numbered by chapter (1.1, 1.2, ...).
* **Appendices** — listed under `book.appendices`. Numbered A, B, C, with
  figures and tables following as A.1, A.2, ...

Quarto's first chapter must be `index.qmd` in the project root, so the first
front-matter page always lives there.

**Table of contents.** It is inserted at the end of the front matter, together
with the list of figures, list of tables and list of papers if those are
enabled. Move it with `thesis.toc-position: after-title`, or switch it off with
`none` and place `#inn-toc()` yourself in a raw Typst block.

**References.** The bibliography is rendered where you put the `#refs` div —
that is, wherever `references.qmd` sits in `book.chapters` — rather than at the
very end of the book. `references.qmd` needs only:

````markdown
# References {.unnumbered}

::: {#refs}
:::
````

**Parts.** A `part:` entry in `book.chapters` produces a part divider page.

---

## The `thesis:` block

All of it is optional; anything you leave out is left off the title page.

```yaml
thesis:
  type: master              # master | phd | phd-articles
  degree: "Master in Exercise Physiology"
  credits: "30"
  faculty: "Faculty of Health and Social Sciences"
  department: "Department of Public Health and Sport Sciences"
  programme: "Master's Programme in Exercise Physiology"
  place: "Lillehammer"
  year: "2026"

  supervisors:
    - name: "Professor Kari Nordmann"
      role: "Main supervisor"
      affiliation: "University of Inland Norway"

  # Layout
  two-sided: true           # mirrored margins, chapters open on a recto
  open-right: true
  running-head: true
  toc-position: before-chapters   # before-chapters | after-title | none

  # Title page
  logo: en                  # en | nb | nn | path/to/logo.png
  statement: "..."          # replaces the "Master's thesis — 30 credits" line
  institution: "..."        # replaces the default INN name for the language
  dedication: "For ..."
  heading-font: "Aptos Display"
```

### PhD

`type: phd` (monograph) or `type: phd-articles` (article-based) switches the
statement on the title page and turns on the colophon page:

```yaml
thesis:
  type: phd-articles
  colophon: true
  copyright: "Ola Nordmann"
  series: "Doctoral dissertations at the University of Inland Norway"
  series-number: "42"
  isbn-printed: "978-82-8380-000-0"
  isbn-digital: "978-82-8380-001-7"
  issn-printed: "2535-6151"
  issn-digital: "2535-6143"
  printed-by: "Flisa Trykkeri A/S"
  colophon-note: "The papers are included with permission from the publishers."
```

For an article-based dissertation, listing the papers produces a **List of
Papers** page in the front matter:

```yaml
  papers:
    - label: "I"
      authors: "Nordmann, O., & Nordmann, K."
      year: "2025"
      title: "Supervised endurance training in older adults"
      journal: "Medicine & Science in Sports & Exercise, 57(1), 44–55"
      status: "Published"
      doi: "10.1249/MSS.0000000000000000"
```

Use `citation: "..."` instead of the separate fields to write the reference out
yourself.

A ready-made configuration is in **`_quarto-phd.yml`** — swap it in with
`mv _quarto-phd.yml _quarto.yml`.

---

## Language

`lang:` selects the built-in labels, the hyphenation and the logo:

| `lang` | Labels | Logo |
|:---|:---|:---|
| `en` | Contents, Chapter, Appendix, References, ... | English |
| `nb` | Innhold, Kapittel, Vedlegg, Referanser, ... | Norwegian |
| `nn` | Innhald, Kapittel, Vedlegg, Referansar, ... | Norwegian |

A ready-made bokmål configuration is in **`_quarto-nb.yml`**, with matching
chapter files under `nb/`:

```bash
mv _quarto-nb.yml _quarto.yml
mv nb/sammendrag.qmd index.qmd
quarto render
```

Individual labels can be overridden without changing language:

```yaml
thesis:
  labels:
    contents: "Table of contents"
    list-of-papers: "Papers"
```

Quarto's own strings (the appendix divider, cross-reference prefixes) are set
with `language:`:

```yaml
language:
  section-title-appendices: "Vedlegg"    # Quarto's nb default is "Bilag"
```

---

## Handout format

`innHandout-typst` is the single-document format for course handouts and teaching
notes — INN green sidebar, logo, margin notes and a course footer. It is a
template in its own right, under `handout/`:

```bash
quarto use template dhammarstrom/innTypst/handout
cd <your-folder>
quarto render
```

`handout.qmd` is both the example and the documentation: its YAML header lists
every option (`typst-logo`, `course`, `course-link`, `page-numbering`,
`margin-notes`, `bibliography-heading`). The R chunks use base R's
`ToothGrowth` with **tidyverse** and **gt**, so nothing beyond those two
packages has to be installed.

Inside this repository, render it with:

```bash
quarto render handout/handout.qmd
```

`handout/_quarto.yml` exists only to mark that folder as a project of its own,
so the book project at the repository root does not swallow it. You can delete
it once the handout lives somewhere else.

---

## Repository layout

The root of the repository *is* the thesis template; the handout is a template
of its own in a subdirectory. Each format is defined exactly once. Any format
added later follows the handout's pattern: a folder holding its own
`_extensions/` and its own example document.

```
_extensions/innThesis/     the thesis format
_quarto.yml                the example thesis (English master's) -- edit this
_quarto-nb.yml             drop-in replacement: bokmål
_quarto-phd.yml            drop-in replacement: article-based PhD
index.qmd                  first front-matter page (Quarto requires it here)
frontmatter/  chapters/  appendices/  nb/  papers/  images/
references.bib

handout/                   the handout format and its example
  _extensions/innHandout/
  handout.qmd
```

### Inside the thesis extension

```
_extensions/innThesis/
  _extension.yml       format declaration and thesis defaults
  typst-template.typ   the INN palette, the label sets and inn-thesis()
  typst-show.typ       maps _quarto.yml onto inn-thesis(...)
  page.typ             paper size
  numbering.typ        chapter-aware figure/equation/theorem numbering
  biblio.typ           deliberately empty; see innThesis.lua
  innThesis.lua        turns Quarto's book structure into Typst calls
  inn-logo-*.png       the logos used on the title page
```

`innThesis.lua` is where Quarto's book model meets Typst: it converts `part:`
entries into part pages, marks the front-matter/main-matter boundary, starts the
appendices, and relocates the bibliography to the `#refs` div.

The thesis format requires Quarto ≥ 1.9.17 (Typst book support); the handout
requires ≥ 1.6.0. Both are tested against Quarto 1.9.27 (Typst 0.14) and
Quarto 1.10.18 (Typst 0.15).

## Licence

See [LICENSE.md](LICENSE.md). The INN logos are the property of the University
of Inland Norway and are included for use in INN theses and course material.
