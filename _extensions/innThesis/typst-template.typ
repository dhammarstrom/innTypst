// =============================================================================
//  innThesis - a Typst book template for master's and PhD theses at
//  the University of Inland Norway (Universitetet i Innlandet, INN).
//
//  This file is a Quarto `typst-template.typ` partial: it only *defines*
//  things. The document is started by `typst-show.typ`, which calls
//  `inn-thesis(...)` with values taken from `_quarto.yml`.
// =============================================================================

// ----------------------------------------------------------------- palette --
// The green is the accent of a master's thesis. A PhD dissertation is black
// throughout, as the university's Word templates are (see `accent` below).
#let inn-green = rgb("#003F01") // INN dark green (headings, rules, links)
#let inn-green-mid = rgb("#0F5122") // logo green
#let inn-green-pale = rgb("#E9F5E7") // tint for part pages / callouts
#let inn-grey = rgb("#4D4D4D") // secondary text

// -------------------------------------------------------------------- i18n --
// Label sets for the three languages INN theses are normally written in.
// Selected with `lang:` in _quarto.yml (en / nb / nn). Any single label can be
// overridden from YAML via `thesis.labels.<key>`.
#let inn-i18n = (
  en: (
    contents: "Table of contents",
    list-of-figures: "List of Figures",
    list-of-tables: "List of Tables",
    list-of-papers: "List of Papers",
    abbreviations: "Abbreviations",
    chapter: "Chapter",
    part: "Part",
    appendix: "Appendix",
    appendices: "Appendices",
    references: "References",
    paper: "Paper",
    supervisor: "Supervisor",
    supervisors: "Supervisors",
    institution: "University of Inland Norway",
    master-thesis: "Master's thesis",
    phd-thesis: "PhD Dissertation",
    submitted-master: "Thesis submitted for the degree of",
    credits: "credits",
    // Colophon (kolofonside). The wording follows the university's Word
    // templates for PhD dissertations.
    phd-in: "PhD Dissertation in",
    number: "no.",
    printed-by: "Printed by",
    place-of-publication: "Place of publication",
    isbn-printed: "ISBN printed version",
    isbn-digital: "ISBN digital version",
    issn-printed: "ISSN printed version",
    issn-digital: "ISSN digital version",
    copyright-holder: "The author",
    copyright-notice: "This material is protected by copyright law. Without explicit authorisation, reproduction is only allowed in so far it is permitted by law or by agreement with a collecting society.",
  ),
  nb: (
    contents: "Innholdsfortegnelse",
    list-of-figures: "Figurliste",
    list-of-tables: "Tabelliste",
    list-of-papers: "Liste over artikler",
    abbreviations: "Forkortelser",
    chapter: "Kapittel",
    part: "Del",
    appendix: "Vedlegg",
    appendices: "Vedlegg",
    references: "Referanser",
    paper: "Artikkel",
    supervisor: "Veileder",
    supervisors: "Veiledere",
    institution: "Universitetet i Innlandet",
    master-thesis: "Masteroppgave",
    phd-thesis: "Ph.d.-avhandling",
    submitted-master: "Oppgave levert for graden",
    credits: "studiepoeng",
    phd-in: "Ph.d.-avhandling i",
    number: "nr.",
    printed-by: "Trykk",
    place-of-publication: "Utgivelsessted",
    isbn-printed: "ISBN trykt utgave",
    isbn-digital: "ISBN digital utgave",
    issn-printed: "ISSN trykt utgave",
    issn-digital: "ISSN digital utgave",
    copyright-holder: "Forfatteren",
    copyright-notice: "Det må ikke kopieres fra publikasjonen i strid med Åndsverkloven eller i strid med avtaler om kopiering inngått med Kopinor.",
  ),
  nn: (
    contents: "Innhaldsliste",
    list-of-figures: "Figurliste",
    list-of-tables: "Tabelliste",
    list-of-papers: "Liste over artiklar",
    abbreviations: "Forkortingar",
    chapter: "Kapittel",
    part: "Del",
    appendix: "Vedlegg",
    appendices: "Vedlegg",
    references: "Referansar",
    paper: "Artikkel",
    supervisor: "Rettleiar",
    supervisors: "Rettleiarar",
    institution: "Universitetet i Innlandet",
    master-thesis: "Masteroppgåve",
    phd-thesis: "Ph.d.-avhandling",
    submitted-master: "Oppgåve levert for graden",
    credits: "studiepoeng",
    phd-in: "Ph.d.-avhandling i",
    number: "nr.",
    printed-by: "Trykk",
    place-of-publication: "Utgjevarstad",
    isbn-printed: "ISBN trykt utgåve",
    isbn-digital: "ISBN digital utgåve",
    issn-printed: "ISSN trykt utgåve",
    issn-digital: "ISSN digital utgåve",
    copyright-holder: "Forfattaren",
    copyright-notice: "Det må ikkje kopierast frå publikasjonen i strid med Åndsverkloven eller i strid med avtaler om kopiering inngått med Kopinor.",
  ),
)

// Normalise whatever `lang:` gives us ("nb-NO", "no", "nn_NO", ...).
#let inn-lang-key(lang) = {
  let l = lower(if lang == none { "en" } else { lang })
  l = l.split("-").at(0)
  l = l.split("_").at(0)
  if l == "no" { "nb" } else if l in inn-i18n { l } else { "en" }
}

// ------------------------------------------------------ document-wide state --
#let inn-cfg = state("inn-cfg", (:))
#let inn-matter = state("inn-matter", "front")
// "auto": the next level-1 heading opens as the layout dictates (normally on a
// recto); "any": it opens on the next page whichever side that is. Set by
// innThesis.lua for headings carrying the `.inn-next-page` class, e.g. the
// second summary, which the university wants on page ii.
#let inn-next-opener = state("inn-next-opener", "auto")
// "auto": the next level-1 heading is set flush left; "center": centred. Set
// by innThesis.lua for headings carrying the `.inn-center` class, e.g. the
// "Dissertation articles" heading, which the university's template centres.
#let inn-next-align = state("inn-next-align", "auto")

// Look up a label, honouring user overrides in `thesis.labels`.
#let inn-t-str(cfg, key) = {
  let lang = cfg.at("lang-key", default: "en")
  let overrides = cfg.at("labels", default: (:))
  if key in overrides {
    overrides.at(key)
  } else {
    inn-i18n.at(lang).at(key, default: inn-i18n.en.at(key, default: key))
  }
}

// Contextual variant, usable anywhere in the body.
#let inn-t(key) = context inn-t-str(inn-cfg.get(), key)

// ------------------------------------------------------------- numbering ----
// Figure / table numbers are chapter-based (1.1, 1.2, ...) in the main matter,
// appendix-based (A.1) in the appendices, and plain (1, 2) in the front matter
// where there is no chapter counter yet.
#let inn-float-numbering(num) = {
  let chapter = counter(heading).get().first()
  if state("appendix-state", none).get() != none {
    numbering("A.1", chapter, num)
  } else if chapter == 0 {
    numbering("1", num)
  } else {
    numbering("1.1", chapter, num)
  }
}

#let inn-heading-numbering(..nums) = {
  let vals = nums.pos()
  if vals.len() == 1 { numbering("1", ..vals) } else { numbering("1.1", ..vals) }
}

#let inn-appendix-heading-numbering(..nums) = {
  let vals = nums.pos()
  if vals.len() == 1 { numbering("A", ..vals) } else { numbering("A.1", ..vals) }
}

// ---------------------------------------------------------- title elements --
#let inn-rule(width: 100%, thickness: 1.5pt, color: inn-green) = {
  line(length: width, stroke: thickness + color)
}

// `logo` is either a shorthand ("en" / "nb" / "nn") or a path to an image. The
// shorthand picks the stacked green logo, or -- with `wide: true` -- the
// horizontal black logo used at the foot of the university's PhD title page.
#let inn-logo-image(logo, width: 38mm, wide: false) = {
  if logo == none { return none }
  let suffix = if wide { "-wide" } else { "" }
  let path = if logo in ("en", "eng", "english") {
    "inn-logo" + suffix + "-en.png"
  } else if logo in ("nb", "no", "nor", "norwegian", "bokmal") {
    "inn-logo" + suffix + "-nb.png"
  } else if logo in ("nn", "nynorsk") {
    "inn-logo" + suffix + "-nn.png"
  } else {
    logo
  }
  image(path, width: width, alt: "University of Inland Norway")
}

// The line under the author name, e.g. "Master's thesis - 60 credits".
#let inn-statement(cfg) = {
  if cfg.at("statement", default: none) != none {
    return cfg.at("statement")
  }
  let kind = cfg.at("thesis-type", default: "master")
  let parts = ()
  if kind == "master" {
    parts.push([#inn-t-str(cfg, "master-thesis")])
  } else {
    parts.push([#inn-t-str(cfg, "phd-thesis")])
  }
  if cfg.at("credits", default: none) != none {
    parts.push([#cfg.at("credits") #inn-t-str(cfg, "credits")])
  }
  parts.join([ — ])
}

#let inn-title-page(cfg) = {
  set par(justify: false, leading: 0.65em)
  v(4mm)
  inn-logo-image(cfg.at("logo", default: none))
  v(14mm)

  // Faculty / department / programme, above the title.
  let above = ()
  for k in ("faculty", "department", "programme") {
    let value = cfg.at(k, default: none)
    if value != none { above.push(value) }
  }
  if above.len() > 0 {
    block(width: 100%, text(size: 11pt, fill: inn-grey, above.join(linebreak())))
    v(6mm)
  }

  inn-rule()
  v(6mm)

  block(
    width: 100%,
    text(size: 26pt, weight: "bold", fill: inn-green, cfg.at("title", default: [])),
  )
  let subtitle = cfg.at("subtitle", default: none)
  if subtitle != none {
    v(3mm)
    block(width: 100%, text(size: 15pt, fill: inn-grey, subtitle))
  }
  v(6mm)
  inn-rule(thickness: 0.75pt)
  v(10mm)

  let authors = cfg.at("authors", default: ())
  if authors.len() > 0 {
    block(width: 100%, text(size: 14pt, weight: "medium", authors.join(linebreak())))
    v(4mm)
  }

  block(width: 100%, text(size: 11pt, fill: inn-grey, inn-statement(cfg)))

  // "Thesis submitted for the degree of X".
  let degree = cfg.at("degree", default: none)
  if degree != none {
    v(2mm)
    block(
      width: 100%,
      text(size: 11pt, fill: inn-grey)[#inn-t-str(cfg, "submitted-master") #degree],
    )
  }

  v(1fr)

  // Supervisors.
  let sups = cfg.at("supervisors", default: ())
  if sups.len() > 0 {
    let head = if sups.len() == 1 {
      inn-t-str(cfg, "supervisor")
    } else {
      inn-t-str(cfg, "supervisors")
    }
    block(width: 100%)[
      #text(size: 10pt, weight: "bold", fill: inn-green, head)
      #v(1.5mm)
      #set text(size: 10pt, fill: inn-grey)
      #for s in sups {
        block(below: 3mm)[
          #s.at("name", default: [])
          #if s.at("role", default: none) != none [ — #s.at("role")]
          #if s.at("affiliation", default: none) != none [ \ #s.at("affiliation")]
        ]
      }
    ]
    v(8mm)
  }

  // Foot of the title page: place, date, institution.
  let foot = ()
  let place = cfg.at("place", default: none)
  let date = cfg.at("date", default: none)
  if place != none and date != none {
    foot.push([#place, #date])
  } else if place != none {
    foot.push(place)
  } else if date != none {
    foot.push(date)
  }
  foot.push(text(weight: "bold", fill: inn-green, cfg.at("institution", default: [])))
  block(width: 100%, text(size: 10.5pt, foot.join(linebreak())))
}

// PhD title page, laid out like the university's Word templates
// (forsidemal-*.docx / title-page-template-*.docx): everything centred, the
// author above the title, then "PhD Dissertation", the year and the faculty,
// and the horizontal INN logo at the foot of the page. Supervisors are not
// named here -- the PhD regulations (§ 10-1) want them in the preface.
#let inn-phd-title-page(cfg) = {
  set par(justify: false, leading: 0.65em)
  set align(center)
  v(14mm)
  let authors = cfg.at("authors", default: ())
  if authors.len() > 0 {
    block(width: 100%, text(size: 18pt, weight: "bold", authors.join(linebreak())))
  }
  v(10mm)
  block(width: 100%, text(size: 26pt, weight: "bold", cfg.at("title", default: [])))
  let subtitle = cfg.at("subtitle", default: none)
  if subtitle != none {
    v(4mm)
    block(width: 100%, text(size: 16pt, subtitle))
  }
  v(2fr)
  block(width: 100%, text(size: 14pt, inn-statement(cfg)))
  v(6mm)
  let year = cfg.at("year", default: none)
  if year == none { year = cfg.at("date", default: none) }
  if year != none {
    block(width: 100%, text(size: 14pt, year))
  }
  v(6mm)
  let faculty = cfg.at("faculty", default: none)
  if faculty != none {
    block(width: 100%, text(size: 12pt, faculty))
  }
  v(3fr)
  inn-logo-image(cfg.at("logo", default: none), wide: true, width: 52mm)
  v(2mm)
}

// Verso of the title page: the colophon ("kolofonside"). It follows the
// university's Word template line by line -- printer and place of
// publication, copyright, the legal notice, the dissertation's number in its
// PhD programme in both Norwegian and English, and the ISBN/ISSN lines. The
// ISBN/ISSN lines are printed even when empty, as in the template, so that
// they can be filled in once the numbers have been assigned. The university
// asks that this page is never removed.
#let inn-colophon(cfg) = {
  // The "Kolofon" style of the templates: 11 pt, 1.5 line spacing, 6 pt after
  // each paragraph, justified. The runs of empty paragraphs that push the
  // series and ISBN/ISSN lines down the page become stretchable space in the
  // same proportions (ten, three and three blank lines).
  set par(justify: true, leading: 0.62em, spacing: 1.2em)
  set text(size: 11pt)
  let lang = cfg.at("lang-key", default: "en")
  let or-default(key, fallback) = {
    let v = cfg.at(key, default: none)
    if v == none { fallback } else { v }
  }

  block[#inn-t-str(cfg, "printed-by"): #or-default("printed-by", [Flisa Trykkeri A/S])]
  block[#inn-t-str(cfg, "place-of-publication"): #or-default("place-of-publication", [Elverum])]

  let year = cfg.at("year", default: none)
  let holder = or-default("copyright", inn-t-str(cfg, "copyright-holder"))
  block[© #holder#if year != none [ #year]]
  block(inn-t-str(cfg, "copyright-notice"))
  v(10fr)

  // "PhD Dissertation in <programme> no. <n>" -- first in the language of the
  // thesis, then in the other one, exactly as the template has it.
  let n = cfg.at("series-number", default: none)
  let programme = cfg.at("programme", default: none)
  let programme-nb = or-default("programme-nb", programme)
  let programme-en = or-default("programme-en", programme)
  let series-line(labels, name) = {
    block[#labels.phd-in #name#if n != none [ #labels.number #n]]
  }
  let own = (phd-in: inn-t-str(cfg, "phd-in"), number: inn-t-str(cfg, "number"))
  let lines = if lang == "en" {
    ((own, programme-en), (inn-i18n.nb, programme-nb))
  } else {
    ((own, programme-nb), (inn-i18n.en, programme-en))
  }
  let any-programme = false
  for (labels, name) in lines {
    if name != none {
      any-programme = true
      series-line(labels, name)
    }
  }
  if any-programme { v(3fr) }

  for key in ("isbn-printed", "isbn-digital", "issn-printed", "issn-digital") {
    let value = cfg.at(key, default: none)
    block[#inn-t-str(cfg, key): #if value != none [#value]]
  }
  v(3fr)

  let note = cfg.at("colophon-note", default: none)
  if note != none {
    block(note)
  }
}

#let inn-dedication(cfg) = {
  let d = cfg.at("dedication", default: none)
  if d == none { return none }
  v(1fr)
  align(center, text(size: 12pt, style: "italic", d))
  v(2fr)
}

// -------------------------------------------------------------- front lists --
#let inn-front-heading(body) = {
  heading(level: 1, numbering: none, outlined: false, bookmarked: true, body)
}

#let inn-toc(title: none) = context {
  let cfg = inn-cfg.get()
  inn-front-heading(if title != none { title } else { inn-t-str(cfg, "contents") })
  outline(title: none, depth: cfg.at("toc-depth", default: 3), indent: 1.2em)
}

#let inn-lof() = context {
  let cfg = inn-cfg.get()
  inn-front-heading(inn-t-str(cfg, "list-of-figures"))
  outline(title: none, target: figure.where(kind: "quarto-float-fig"))
}

#let inn-lot() = context {
  let cfg = inn-cfg.get()
  inn-front-heading(inn-t-str(cfg, "list-of-tables"))
  outline(title: none, target: figure.where(kind: "quarto-float-tbl"))
}

// The reference for one entry of `thesis.papers`: either the `citation` the
// author wrote out, or one assembled from the separate fields.
#let inn-paper-reference(p) = {
  if p.at("citation", default: none) != none {
    return p.at("citation")
  }
  let authors = p.at("authors", default: none)
  let year = p.at("year", default: none)
  let title = p.at("title", default: none)
  let journal = p.at("journal", default: none)
  [
    #if authors != none [#authors ]
    #if year != none [(#year). ]
    #if title != none [#title. ]
    #if journal != none [#journal.]
  ]
}

// List of papers, for an article-based ("kappe") PhD dissertation. The
// university asks that the reader is told what kind of manuscript each paper
// is, and where and when it was published -- that is the `status` field.
#let inn-list-of-papers() = context {
  let cfg = inn-cfg.get()
  let papers = cfg.at("papers", default: ())
  if papers.len() == 0 { return none }
  inn-front-heading(inn-t-str(cfg, "list-of-papers"))
  set par(justify: false)
  for (i, p) in papers.enumerate() {
    let mark = p.at("label", default: numbering("1", i + 1))
    let reference = inn-paper-reference(p)
    block(below: 1.6em, width: 100%)[
      #text(weight: "bold", fill: cfg.accent)[#inn-t-str(cfg, "paper") #mark]
      #v(1.5mm, weak: true)
      #reference
      #if p.at("status", default: none) != none [ \ #text(style: "italic", fill: cfg.muted, p.at("status"))]
      #if p.at("doi", default: none) != none [ \ #link("https://doi.org/" + p.at("doi"))]
    ]
  }
}

// Emit whatever front lists the configuration asks for, in a fixed order.
// innThesis.lua calls this once: where the author put a heading with the
// `.inn-front-lists` class (its text becomes the title of the table of
// contents) or a `#inn-front-lists` div, otherwise at the front-matter/
// main-matter boundary or right after the title page, depending on
// `thesis.toc-position`.
#let inn-front-lists(title: none) = context {
  let cfg = inn-cfg.get()
  if cfg.at("toc", default: true) { inn-toc(title: title) }
  if cfg.at("lof", default: false) { inn-lof() }
  if cfg.at("lot", default: false) { inn-lot() }
  if cfg.at("papers", default: ()).len() > 0 and cfg.at("list-of-papers", default: true) {
    inn-list-of-papers()
  }
}

// Separator sheets for the included articles, as in the university's
// article-based template: one page per paper, opening on a recto, with a large
// number (72 pt, regular weight, as in the template). The paper's reference is
// printed underneath it.
#let inn-paper-separator(mark, reference: none, open-right: true, accent: inn-green, weight: "regular") = {
  // The same markers a chapter opener leaves, so that an empty verso in front
  // of the sheet is treated like one in front of a chapter.
  [#metadata(none)<inn-flow-end>]
  if open-right {
    pagebreak(weak: true, to: "odd")
  } else {
    pagebreak(weak: true)
  }
  [#metadata(none)<inn-opener>]
  block(width: 100%, height: 100%)[
    #set align(center)
    #set par(justify: false)
    #v(1fr)
    #text(size: 72pt, weight: weight, fill: accent, mark)
    #if reference != none {
      v(10mm)
      block(width: 80%, text(size: 11pt, reference))
    }
    #v(1.4fr)
  ]
}

// One separator sheet per entry in `thesis.papers`. innThesis.lua emits this
// where the author puts a `#inn-papers` div -- normally in a short
// "Dissertation articles" chapter after the references.
#let inn-papers() = context {
  let cfg = inn-cfg.get()
  let papers = cfg.at("papers", default: ())
  let open-right = cfg.at("two-sided", default: true) and cfg.at("open-right", default: true)
  let weight = if cfg.at("thesis-type", default: "master") == "master" { "bold" } else { "regular" }
  for (i, p) in papers.enumerate() {
    let mark = p.at("label", default: numbering("1", i + 1))
    inn-paper-separator(
      mark,
      reference: inn-paper-reference(p),
      open-right: open-right,
      accent: cfg.accent,
      weight: weight,
    )
  }
}

// Pages that open a chapter or a paper separator sheet.
#let inn-opener-pages() = {
  let headings = query(heading.where(level: 1)).map(h => h.location().page())
  let sheets = query(<inn-opener>).map(m => m.location().page())
  headings + sheets
}

// A recto-opening chapter (or separator sheet) can leave an empty verso
// behind. Such a page carries no folio and no running head. It is recognised
// by: the next page opens something, this page opens nothing, and no content
// ended here (openers drop an `<inn-flow-end>` marker on the page the
// previous text ran out on).
#let inn-is-filler-page() = {
  let p = here().page()
  let starts = inn-opener-pages()
  if not (p + 1 in starts) {
    false
  } else if p in starts {
    false
  } else {
    not (p in query(<inn-flow-end>).map(m => m.location().page()))
  }
}

// ------------------------------------------------------------ matter shifts --
// These are applied by innThesis.lua as `#show: ...` rules, so the `set` rules
// inside them govern the remainder of the document.
#let inn-mainmatter(doc) = {
  inn-matter.update("main")
  // `set page` always begins a new page, and `pagebreak(to:)` works on physical
  // page parity -- so land on a recto *first*, and only then restart the page
  // counter, or chapter 1 ends up numbered 2.
  set page(numbering: "1")
  context {
    let cfg = inn-cfg.get()
    if cfg.at("two-sided", default: true) and cfg.at("open-right", default: true) {
      pagebreak(weak: true, to: "odd")
    }
  }
  counter(page).update(1)
  doc
}

#let inn-appendices(title, doc) = {
  counter(heading).update(0)
  state("appendix-state", none).update(title)
  set heading(numbering: inn-appendix-heading-numbering)
  show heading.where(level: 1): set heading(supplement: context inn-t-str(inn-cfg.get(), "appendix"))
  doc
}

// ------------------------------------------------------------------ parts ---
#let inn-part(title) = {
  pagebreak(weak: true)
  counter("inn-part").step()
  block(width: 100%, height: 100%)[
    #v(1fr)
    #context {
      let cfg = inn-cfg.get()
      text(size: 13pt, fill: cfg.accent, weight: "bold")[
        #inn-t-str(cfg, "part") #counter("inn-part").display("I")
      ]
      v(4mm)
      inn-rule(width: 40%, color: cfg.accent)
    }
    #v(6mm)
    #text(size: 24pt, weight: "bold", title)
    #v(2fr)
  ]
  pagebreak(weak: true)
}

// ------------------------------------------------------------ bibliography ---
// innThesis.lua places the bibliography where the `#refs` div sits (i.e. where
// the author put the references chapter), falling back to the end of the book.
#let inn-bibliography(files, style: none, title: none) = {
  if style == none {
    bibliography(files, title: title)
  } else {
    bibliography(files, title: title, style: style)
  }
}

// =============================================================================
//  Main template function
// =============================================================================
#let inn-thesis(
  // --- supplied by Quarto ----------------------------------------------------
  title: none,
  subtitle: none,
  authors: (),
  date: none,
  lang: "en",
  region: none,
  font: ("Aptos", "Segoe UI", "Calibri", "Libertinus Serif"),
  heading-font: none,
  fontsize: 11pt,
  linestretch: 1.4,
  toc: true,
  toc-depth: 3,
  lof: false,
  lot: false,
  margin: none,
  // --- the `thesis:` block in _quarto.yml ------------------------------------
  thesis-type: "master",
  degree: none,
  credits: none,
  faculty: none,
  department: none,
  programme: none,
  programme-nb: none,
  programme-en: none,
  institution: none,
  place: none,
  place-of-publication: none,
  year: none,
  logo: auto,
  statement: none,
  supervisors: (),
  papers: (),
  list-of-papers: true,
  dedication: none,
  colophon: auto,
  colophon-note: none,
  copyright: none,
  series-number: none,
  isbn-printed: none,
  isbn-digital: none,
  issn-printed: none,
  issn-digital: none,
  printed-by: none,
  two-sided: true,
  open-right: true,
  running-head: auto,
  page-number-position: auto,
  accent: auto,
  labels: (:),
  body,
) = {
  let lang-key = inn-lang-key(lang)
  // PhD dissertations follow the university's layout rules (2.5 cm margins,
  // page number centred at the foot, no running head); master's theses keep
  // the book-style defaults. Everything can still be set explicitly.
  let is-phd = thesis-type != "master"
  let running-head = if running-head == auto { not is-phd } else { running-head }
  let page-number-position = if page-number-position == auto {
    if is-phd { "center" } else { "outside" }
  } else { page-number-position }
  // The colour of headings, rules, links and other accents. A master's thesis
  // uses INN green; a PhD dissertation is black throughout, like the
  // university's Word templates. `thesis.accent` overrides either.
  let accent = if accent == auto or accent == "auto" {
    if is-phd { black } else { inn-green }
  } else if accent == "green" {
    inn-green
  } else if accent == "black" {
    black
  } else if type(accent) == str {
    rgb(accent)
  } else {
    accent
  }
  let muted = if accent == black { black } else { inn-grey }
  let cfg = (
    lang-key: lang-key,
    accent: accent,
    muted: muted,
    labels: labels,
    title: title,
    subtitle: subtitle,
    authors: authors,
    date: date,
    thesis-type: thesis-type,
    degree: degree,
    credits: credits,
    faculty: faculty,
    department: department,
    programme: programme,
    programme-nb: programme-nb,
    programme-en: programme-en,
    institution: if institution != none {
      institution
    } else {
      inn-i18n.at(lang-key).institution
    },
    place: place,
    place-of-publication: place-of-publication,
    year: year,
    logo: if logo == auto {
      if lang-key == "en" { "en" } else { lang-key }
    } else { logo },
    statement: statement,
    supervisors: supervisors,
    papers: papers,
    list-of-papers: list-of-papers,
    dedication: dedication,
    copyright: copyright,
    colophon-note: colophon-note,
    series-number: series-number,
    isbn-printed: isbn-printed,
    isbn-digital: isbn-digital,
    issn-printed: issn-printed,
    issn-digital: issn-digital,
    printed-by: printed-by,
    toc: toc,
    toc-depth: toc-depth,
    lof: lof,
    lot: lot,
    two-sided: two-sided,
    open-right: open-right,
  )
  inn-cfg.update(cfg)

  // ---- document metadata ----------------------------------------------------
  set document(title: title)

  // ---- text and paragraphs --------------------------------------------------
  set text(
    font: font,
    size: fontsize,
    lang: lang-key,
    region: if region != none {
      region
    } else if lang-key == "en" { "GB" } else { "NO" },
  )
  set par(justify: true, leading: linestretch * 0.45em, spacing: linestretch * 0.9em)
  set enum(numbering: "1.a.i.")
  set list(marker: ([•], [--], [◦]))

  show link: set text(fill: accent)
  show raw: set text(size: 0.92em)

  // Block quotations: the university's guidance allows a slightly smaller
  // size, an indent and single line spacing.
  show quote.where(block: true): set text(size: 0.92em)
  show quote.where(block: true): set par(leading: 0.65em, spacing: 0.65em)
  show quote.where(block: true): set pad(x: 1.5em)

  // ---- page geometry --------------------------------------------------------
  let page-margin = if margin != none {
    margin
  } else if is-phd {
    (x: 2.5cm, y: 2.5cm)
  } else if two-sided {
    (inside: 3cm, outside: 2.5cm, top: 2.5cm, bottom: 2.5cm)
  } else {
    (x: 2.75cm, top: 2.5cm, bottom: 2.5cm)
  }
  set page(margin: page-margin, binding: if two-sided { auto } else { left })

  // ---- floats ---------------------------------------------------------------
  set figure(numbering: inn-float-numbering, gap: 1em)
  show figure: set align(center)
  show figure.caption: set text(size: 0.92em)
  set table(inset: 6pt, stroke: (0.5pt + inn-grey.lighten(50%)))
  show table.cell.where(y: 0): set text(weight: "bold")

  // ---- headings -------------------------------------------------------------
  set heading(numbering: inn-heading-numbering, hanging-indent: 0pt)
  show heading.where(level: 1): set heading(supplement: inn-t-str(cfg, "chapter"))
  show heading: set text(font: if heading-font != none { heading-font } else { font })

  show heading.where(level: 1): it => {
    // Chapter (and unnumbered front/back-matter) opener.
    [#metadata(none)<inn-flow-end>]
    context {
      if open-right and two-sided and inn-next-opener.get() != "any" {
        pagebreak(weak: true, to: "odd")
      } else {
        pagebreak(weak: true)
      }
    }
    inn-next-opener.update("auto")
    context {
      let alignment = if inn-next-align.get() == "center" { center } else { left }
      if is-phd {
        // "Heading 1" of the university's templates: 18 pt bold, black,
        // single-spaced, 18 pt of space above and below, and the number set
        // in a hanging indent of 1.1 cm in front of the text.
        block(width: 100%, above: 0pt, below: 18pt, inset: (top: 18pt))[
          #set align(alignment)
          #set par(justify: false, leading: 0.5em, hanging-indent: 1.1cm)
          #set text(size: 18pt, weight: "bold", fill: accent)
          #if it.numbering != none {
            box(width: 1.1cm, counter(heading).display(it.numbering))
          }
          #it.body
        ]
      } else {
        block(width: 100%, above: 0pt, below: 1.2em)[
          #set align(alignment)
          #set par(justify: false, leading: 0.5em)
          #if it.numbering != none {
            text(size: 1.1em, weight: "bold", fill: accent)[
              #it.supplement #counter(heading).display(it.numbering)
            ]
            v(2mm, weak: true)
          }
          #text(size: 1.85em, weight: "bold", fill: accent, it.body)
          #v(2mm, weak: true)
          #inn-rule(thickness: 1pt, color: accent)
        ]
      }
    }
    inn-next-align.update("auto")
  }

  show heading.where(level: 2): it => {
    set par(justify: false)
    block(above: 1.6em, below: 0.7em, text(size: 1.3em, weight: "bold", fill: accent, it))
  }
  show heading.where(level: 3): it => {
    set par(justify: false)
    block(above: 1.3em, below: 0.6em, text(size: 1.1em, weight: "bold", it))
  }
  show heading.where(level: 4): it => {
    set par(justify: false)
    block(above: 1.1em, below: 0.5em, text(size: 1em, weight: "bold", style: "italic", it))
  }

  // ---- table of contents styling -------------------------------------------
  show outline.entry: it => {
    // Chapter-level heading entries stand out; figure and table entries in the
    // lists of figures/tables keep the body weight.
    if it.level == 1 and it.element.func() == heading {
      v(0.7em, weak: true)
      strong(it)
    } else {
      it
    }
  }

  // ---- running head and page number ----------------------------------------
  let running-header = context {
    if not running-head { return none }
    if inn-matter.get() == "front" { return none }
    if inn-is-filler-page() { return none }
    let this-page = here().page()
    // No running head on pages that open a chapter or a separator sheet.
    if this-page in inn-opener-pages() {
      return none
    }
    let before = query(selector(heading.where(level: 1)).before(here()))
    if before.len() == 0 { return none }
    let ch = before.last()
    let label = if ch.numbering != none {
      [#ch.supplement #numbering(ch.numbering, ..counter(heading).at(ch.location())) — #ch.body]
    } else {
      ch.body
    }
    set text(size: 8.5pt, fill: inn-grey)
    block(
      width: 100%,
      stroke: (bottom: 0.5pt + inn-green.lighten(60%)),
      inset: (bottom: 3pt),
    )[
      #if two-sided and calc.even(this-page) {
        align(left, label)
      } else {
        align(right, label)
      }
    ]
  }

  let page-footer = context {
    if page-number-position == "none" { return none }
    if inn-is-filler-page() { return none }
    // A PhD dissertation numbers its pages in the body font and colour, as
    // the templates' footer does; a master's thesis uses a smaller grey folio.
    let num = counter(page).display()
    set text(size: if is-phd { fontsize } else { 9pt }, fill: muted)
    if page-number-position == "center" or not two-sided {
      align(center, num)
    } else if calc.even(here().page()) {
      align(left, num)
    } else {
      align(right, num)
    }
  }

  // ---- front pages ----------------------------------------------------------
  // The title page and colophon carry no page number and no running head.
  set page(numbering: none, header: none, footer: none)
  if is-phd { inn-phd-title-page(cfg) } else { inn-title-page(cfg) }

  let want-colophon = if colophon == auto { thesis-type != "master" } else { colophon }
  if want-colophon {
    pagebreak()
    inn-colophon(cfg)
  }
  if dedication != none {
    pagebreak()
    inn-dedication(cfg)
  }

  // ---- front matter: roman page numbers, restarting at i --------------------
  set page(
    numbering: "i",
    header: running-header,
    footer: page-footer,
  )
  if open-right and two-sided { pagebreak(weak: true, to: "odd") }
  counter(page).update(1)
  inn-matter.update("front")

  body
}

// An accent-coloured theorem box, replacing the plain default from numbering.typ.
#let theorem-render(prefix: none, title: "", full-title: auto, body) = context {
  let accent = inn-cfg.get().at("accent", default: inn-green)
  block(
    width: 100%,
    inset: (left: 1em, top: 0.4em, bottom: 0.4em),
    stroke: (left: 2pt + accent),
  )[
    #if full-title != "" and full-title != auto and full-title != none {
      text(fill: accent, weight: "bold", full-title)
      linebreak()
    }
    #body
  ]
}
