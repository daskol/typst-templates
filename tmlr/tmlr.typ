#let std-bibliography = bibliography

#let tmlr(
  title: [],
  authors: (),
  keywords: (),
  date: auto,
  abstract: none,
  bibliography: none,
  header: none,
  accepted: false,
  body,
) = {
  set document(
    title: title,
    author: authors.at(0).map(it => it.name),
    keywords: keywords,
    date: date)

  header = "Under review as submission to TMLR"
  set page(
    paper: "us-letter",
    header: locate(loc => {
      header
      line(length: 100%, stroke: (thickness: 1pt))
    }))

  set heading(numbering: "1.1")

  [#title]
  [\ *Abstract* \ ]
  [#abstract]
  body

  if bibliography != none {
    bibliography
  }
}
