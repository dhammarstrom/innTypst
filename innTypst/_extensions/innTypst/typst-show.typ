#show: innTypst.with(
$if(title)$
  title: "$title$",
$endif$
$if(typst-logo)$
  typst-logo: (
    path: "$typst-logo.path$",
    caption: [$typst-logo.caption$]
  ), 
$endif$
$if(course)$
  course: "$course$",
$endif$
$if(course-link)$
  course_link: "$course-link$",
$endif$
$if(page-numbering)$
  page_numbering: "$page-numbering$",
$else$
  page_numbering: "1",  // Default to numbered pages
$endif$
$if(bibliography-heading)$
  bibliography_heading: "$bibliography-heading$",
$endif$
$if(margin-notes)$
  margin_notes: (
    $for(margin-notes)$
    "$it.title$": (
      content: [$it.content$],
      position: $it.position$,
    ),
    $endfor$
  ),
$endif$
)