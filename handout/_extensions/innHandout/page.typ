$-- Paper and columns only. Margins, page numbering, the green sidebar and the
$-- course footer are all set inside inn-handout() in typst-template.typ, which is
$-- also where `page-numbering: "none"` is translated into Typst's `none`.
$-- Quarto's default partial would emit `numbering: "none"`, which is not a
$-- valid Typst numbering pattern.
#set page(
  paper: $if(papersize)$"$papersize$"$else$"us-letter"$endif$,
  columns: $if(columns)$$columns$$else$1$endif$,
  numbering: none,
)
