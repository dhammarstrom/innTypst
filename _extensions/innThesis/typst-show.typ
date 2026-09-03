// Starts the document. Everything here comes from _quarto.yml: the standard
// Quarto keys (title, author, lang, toc, ...) and the `thesis:` block.
#show: inn-thesis.with(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(by-author)$
  authors: ($for(by-author)$[$it.name.literal$],$endfor$),
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
$if(region)$
  region: "$region$",
$endif$
$if(mainfont)$
  font: ("$mainfont$", "Aptos", "Segoe UI", "Calibri", "Libertinus Serif"),
$endif$
$if(thesis.heading-font)$
  heading-font: ("$thesis.heading-font$",),
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$endif$
$if(linestretch)$
  linestretch: $linestretch$,
$endif$
$if(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
$endif$
  toc: $if(toc)$true$else$false$endif$,
  toc-depth: $if(toc-depth)$$toc-depth$$else$3$endif$,
  lof: $if(lof)$true$else$false$endif$,
  lot: $if(lot)$true$else$false$endif$,
$-- --------------------------------------------------------------- thesis: ---
$if(thesis.type)$
  thesis-type: "$thesis.type$",
$endif$
$if(thesis.degree)$
  degree: [$thesis.degree$],
$endif$
$if(thesis.credits)$
  credits: "$thesis.credits$",
$endif$
$if(thesis.faculty)$
  faculty: [$thesis.faculty$],
$endif$
$if(thesis.department)$
  department: [$thesis.department$],
$endif$
$if(thesis.programme)$
  programme: [$thesis.programme$],
$endif$
$if(thesis.programme-nb)$
  programme-nb: [$thesis.programme-nb$],
$endif$
$if(thesis.programme-en)$
  programme-en: [$thesis.programme-en$],
$endif$
$if(thesis.institution)$
  institution: [$thesis.institution$],
$endif$
$if(thesis.place)$
  place: [$thesis.place$],
$endif$
$if(thesis.place-of-publication)$
  place-of-publication: [$thesis.place-of-publication$],
$endif$
$if(thesis.year)$
  year: [$thesis.year$],
$endif$
$if(thesis.logo)$
  logo: "$thesis.logo$",
$endif$
$if(thesis.statement)$
  statement: [$thesis.statement$],
$endif$
$if(thesis.supervisors)$
  supervisors: (
$for(thesis.supervisors)$
    (
      name: [$it.name$],
$if(it.role)$
      role: [$it.role$],
$endif$
$if(it.affiliation)$
      affiliation: [$it.affiliation$],
$endif$
    ),
$endfor$
  ),
$endif$
$if(thesis.papers)$
  papers: (
$for(thesis.papers)$
    (
$if(it.label)$
      label: [$it.label$],
$endif$
$if(it.citation)$
      citation: [$it.citation$],
$endif$
$if(it.authors)$
      authors: [$it.authors$],
$endif$
$if(it.year)$
      year: [$it.year$],
$endif$
$if(it.title)$
      title: [$it.title$],
$endif$
$if(it.journal)$
      journal: [$it.journal$],
$endif$
$if(it.status)$
      status: [$it.status$],
$endif$
$if(it.doi)$
      doi: "$it.doi$",
$endif$
    ),
$endfor$
  ),
$endif$
$if(thesis.list-of-papers)$
  list-of-papers: $thesis.list-of-papers$,
$endif$
$if(thesis.dedication)$
  dedication: [$thesis.dedication$],
$endif$
$if(thesis.colophon)$
  colophon: $thesis.colophon$,
$endif$
$if(thesis.colophon-note)$
  colophon-note: [$thesis.colophon-note$],
$endif$
$if(thesis.copyright)$
  copyright: [$thesis.copyright$],
$endif$
$if(thesis.series-number)$
  series-number: [$thesis.series-number$],
$endif$
$if(thesis.isbn-printed)$
  isbn-printed: [$thesis.isbn-printed$],
$endif$
$if(thesis.isbn-digital)$
  isbn-digital: [$thesis.isbn-digital$],
$endif$
$if(thesis.issn-printed)$
  issn-printed: [$thesis.issn-printed$],
$endif$
$if(thesis.issn-digital)$
  issn-digital: [$thesis.issn-digital$],
$endif$
$if(thesis.printed-by)$
  printed-by: [$thesis.printed-by$],
$endif$
$if(thesis.two-sided)$
  two-sided: $thesis.two-sided$,
$endif$
$if(thesis.open-right)$
  open-right: $thesis.open-right$,
$endif$
$if(thesis.running-head)$
  running-head: $thesis.running-head$,
$endif$
$if(thesis.page-number-position)$
  page-number-position: "$thesis.page-number-position$",
$endif$
$if(thesis.accent)$
  accent: "$thesis.accent$",
$endif$
$if(thesis.labels)$
  labels: ($for(thesis.labels/pairs)$"$it.key$": [$it.value$],$endfor$),
$endif$
)
