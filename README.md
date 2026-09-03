# innTypst

Quarto/Typst formats in the visual style of the **University of Inland Norway**
(Universitetet i Innlandet, INN).

| Format | What it is | Lives in |
|:---|:---|:---|
| `innThesis-typst` | Master's and PhD thesis, as a Quarto **book**. Front matter, numbered chapters, appendices, bibliography, English/bokmål/nynorsk labels. PhD dissertations follow the university's layout rules and title-page template. | repository root |
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

Writing a PhD dissertation? Swap in one of the ready-made configurations
first — see [PhD dissertations](#phd-dissertations) below.

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

**Table of contents.** By default it is inserted at the end of the front
matter, together with the list of figures, list of tables and list of papers
if those are enabled. To put it somewhere else, give a file a heading with the
`.inn-front-lists` class:

```markdown
# Table of contents {.unnumbered .inn-front-lists}
```

That file then *is* the table of contents (the heading text becomes its
title), followed by the other lists. `frontmatter/contents.qmd` is such a
file. The same can be done inside another file with an empty
`::: {#inn-front-lists}` div. Alternatively, `thesis.toc-position:
after-title` puts the lists straight after the title page, and `none` switches
them off so you can place `#inn-toc()` yourself in a raw Typst block.

**Opening on the next page.** Every level-1 heading opens on a right-hand page
when `two-sided` and `open-right` are on. A heading with the `.inn-next-page`
class opens on the next page whichever side that is — the university wants the
second summary of a PhD dissertation on page ii, straight after the first.
A heading with the `.inn-center` class is centred, as the university's
article-based template centres its "Dissertation articles" heading.

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
  running-head: true        # default: on for a master's, off for a PhD
  page-number-position: outside   # outside | center | none
                                  # default: outside for a master's, center for a PhD
  toc-position: before-chapters   # before-chapters | after-title | none

  # Title page
  logo: en                  # en | nb | nn | path/to/logo.png
  statement: "..."          # replaces the "Master's thesis — 30 credits" line
  institution: "..."        # replaces the default INN name for the language
  dedication: "For ..."
  heading-font: "Aptos Display"
  accent: green             # green | black | "#rrggbb"
                            # default: green for a master's, black for a PhD
```

---

## PhD dissertations

`type: phd` (monograph) or `type: phd-articles` (article-based) switches the
format to what the university's
[layout rules for PhD dissertations](https://www.inn.no/forskning/doktorgradsutdanning/ph.d.-handboka-vitenskapelige/avslutning/innlevering-av-avhandling/oppsett-av-ph.d.-avhandling/)
and its Word title-page templates prescribe:

* **Title page** as in the university's template: author, title,
  "PhD Dissertation" / "Ph.d.-avhandling", year, faculty, and the horizontal
  INN logo at the foot. Supervisors are *not* on the title page — the PhD
  regulations (§ 10-1) want them named in the preface.
* **Colophon** on the verso of the title page, line for line as in the
  template: printer, place of publication, copyright, the legal notice, the
  dissertation's number in its PhD programme (in both Norwegian and English),
  and the ISBN/ISSN lines. The university asks that this page is never
  removed.
* **Black throughout**, like the Word templates: headings, rules, links, the
  page number and the numerals on the paper separator sheets lose the green
  accent of the master's format (`thesis.accent` brings it back or sets another colour).
  Level-1 headings follow the templates' "Heading 1": 18 pt bold, the chapter
  number in a hanging indent, 18 pt of space above and below, no rule.
* **Page layout**: 2.5 cm margins on all sides, page number centred at the
  foot, no running head, every new part opening on a right-hand page. Set
  `fontsize: 11pt` and `linestretch: 1.5` (as the example configurations do)
  for the prescribed 11 pt with 1.5 line spacing. Block quotes are set
  slightly smaller, indented and single-spaced.
* **Table of contents** limited to three levels (`toc-depth: 3`), separate
  lists of figures and tables (`lof`, `lot`).

Two complete configurations are ready to swap in:

```bash
mv _quarto-phd.yml _quarto.yml                 # English, article-based
```

```bash
mv _quarto-phd-nb.yml _quarto.yml              # bokmål, article-based
mv nb/sammendrag.qmd index.qmd
```

For a monograph, set `type: phd` and drop `thesis.papers` and the papers
chapter. For nynorsk, set `lang: nn`.

### Order of the parts

The university prescribes the order below, with the page numbers shown. The
example configurations follow it; every part opens on a right-hand page except
the second summary.

| Part | File | Page |
|:---|:---|:---|
| Title page and colophon | generated | — |
| Summary in the language of the thesis | `index.qmd` | i |
| Summary in the other language (`.inn-next-page`) | `frontmatter/sammendrag.qmd` | ii |
| Preface, naming the supervisors | `frontmatter/preface.qmd` | iii |
| Table of contents (`.inn-front-lists`), then lists of figures, tables and papers | `frontmatter/contents.qmd` | v |
| Abbreviations (optional) | `frontmatter/abbreviations.qmd` | |
| Chapters of the synthesis or monograph | `chapters/*.qmd` | 1 |
| References | `references.qmd` | |
| Separator sheets for the papers (article-based) | `papers/papers.qmd` | |
| Appendices | `appendices/*.qmd` | |

Both summaries must fit on one page each. In an article-based dissertation the
preface is written in the same language as the synthesis.

### Colophon fields

```yaml
thesis:
  type: phd-articles
  faculty: "Faculty of Health and Social Sciences"
  year: "2026"

  programme: "Health and Welfare"        # the PhD programme, in the thesis language
  programme-nb: "helse og velferd"       # its name for the Norwegian line
  # programme-en: "..."                  # (for a Norwegian thesis: the English line)
  series-number: "42"                    # the dissertation's number in the programme
  isbn-printed: "978-82-8380-000-0"
  isbn-digital: "978-82-8380-001-7"
  issn-printed: "2535-6151"
  issn-digital: "2535-6143"
  printed-by: "Flisa Trykkeri A/S"       # default
  place-of-publication: "Elverum"        # default
  copyright: "Ola Nordmann"              # default: "The author" / "Forfatteren"
  colophon-note: "The papers are included with permission from the publishers."
  colophon: true                         # on by default for a PhD
```

Only the programme name has to be filled in by you; the number in the series
is assigned by the faculty and the ISBN/ISSN by the library. Their lines are
printed blank until you add them, as in the Word template. The copyright
holder, the legal notice and the labels follow the language of the thesis.

The university's PhD programmes, as named on its website:

| `programme` (en) | `programme-nb` |
|:---|:---|
| Applied Ecology and Biotechnology | anvendt økologi og bioteknologi |
| Artistic Research in Film and Related Audiovisual Art Forms | kunstnerisk utviklingsarbeid i film og beslektede audiovisuelle kunstformer |
| Child and Youth Participation and Competence Development | barn og unges deltakelse og kompetanseutvikling |
| Educational Sciences | utdanningsvitenskapelige fag |
| Health and Welfare | helse og velferd |
| Innovation in Services in the Public and Private Sectors | innovasjon i tjenesteyting i offentlig og privat sektor |

### The papers

For an article-based dissertation, listing the papers produces a **List of
Papers** page in the front matter — the university asks that the reader is
told what kind of manuscript each paper is and where and when it was
published, which is what `status` and `journal` are for:

```yaml
  papers:
    - label: "I"
      authors: "Nordmann, O., & Nordmann, K."
      year: "2025"
      title: "Supervised endurance training in older adults"
      journal: "Medicine & Science in Sports & Exercise, 57(1), 44–55"
      status: "Published"
      doi: "10.1249/MSS.0000000000000000"
    - label: "II"
      citation: "Nordmann, O. (2026). ... Manuscript submitted for publication."
```

Use `citation: "..."` instead of the separate fields to write the reference out
yourself.

The same list produces the numbered **separator sheets** of the university's
template — one otherwise empty right-hand page per paper, with the paper's
numeral in a grey box at the top of the right-hand margin, running off the edge
of the page, and no page number — wherever you put an empty `#inn-papers` div.
`papers/papers.qmd` holds it, after the references and before the appendices:

````markdown
# Dissertation articles {.unnumbered}

::: {#inn-papers}
:::
````

The papers themselves are normally added to the finished PDF afterwards, in
their published form, behind the matching separator sheet. Since their length
is unknown to the layout, page numbering stops at the first separator sheet:
the sheets and everything behind them (normally the appendices) carry no page
number, and the table of contents lists those parts without one.

### Submitting

The university wants one PDF in A4 with a meaningful file name
(`book.output-file: "lastname_firstname_phd"`), five bound copies, and prints
the dissertation at 17 × 24 cm — about 81 % of A4 — from the A4 file you
deliver. Pages up to and including the references must be numbered; the
papers and appendices need not be (and in an article-based dissertation are
not, see above), and blank versos carry no page number.

---

## Language

`lang:` selects the built-in labels, the hyphenation and the logo:

| `lang` | Labels | Logo |
|:---|:---|:---|
| `en` | Table of contents, Chapter, Appendix, References, ... | English |
| `nb` | Innholdsfortegnelse, Kapittel, Vedlegg, Referanser, ... | Norwegian |
| `nn` | Innhaldsliste, Kapittel, Vedlegg, Referansar, ... | Norwegian |

A ready-made bokmål configuration for a master's thesis is in
**`_quarto-nb.yml`**, with matching chapter files under `nb/`:

```bash
mv _quarto-nb.yml _quarto.yml
mv nb/sammendrag.qmd index.qmd
quarto render
```

Individual labels can be overridden without changing language:

```yaml
thesis:
  labels:
    contents: "Contents"
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
_quarto-nb.yml             drop-in replacement: bokmål master's
_quarto-phd.yml            drop-in replacement: English article-based PhD
_quarto-phd-nb.yml         drop-in replacement: bokmål article-based PhD
index.qmd                  first front-matter page (Quarto requires it here)
frontmatter/               sammendrag, acknowledgements, preface, contents, abbreviations
chapters/  appendices/     the English example
nb/                        the Norwegian example
papers/                    separator sheets for an article-based PhD
images/  references.bib

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
  inn-logo-*.png       the stacked logos used on the master's title page
  inn-logo-wide-*.png  the horizontal logos used on the PhD title page
```

`innThesis.lua` is where Quarto's book model meets Typst: it converts `part:`
entries into part pages, marks the front-matter/main-matter boundary, starts the
appendices, relocates the bibliography to the `#refs` div, and turns the
`.inn-front-lists` / `.inn-next-page` / `.inn-center` heading classes and the
`#inn-papers` div into the corresponding Typst calls.

The thesis format requires Quarto ≥ 1.9.17 (Typst book support); the handout
requires ≥ 1.6.0. Both are tested against Quarto 1.9.27 (Typst 0.14) and
Quarto 1.10.18 (Typst 0.15).

## Licence

See [LICENSE.md](LICENSE.md). The INN logos are the property of the University
of Inland Norway and are included for use in INN theses and course material.
