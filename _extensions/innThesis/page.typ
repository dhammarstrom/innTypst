// Paper size and column count only. Margins, headers, footers and page
// numbering are all handled inside `inn-thesis()` (typst-template.typ), because
// they change between the title page, the front matter and the main matter.
#set page(
  paper: $if(papersize)$"$papersize$"$else$"a4"$endif$,
  columns: $if(columns)$$columns$$else$1$endif$,
  numbering: none,
)
