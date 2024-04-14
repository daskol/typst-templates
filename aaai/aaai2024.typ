#let std-bibliography = bibliography

#let aaai2024(
  title: [],
  authors: (),
  abstract: [],
  bibliography: none,
  body,
) = {
  set document(title: title)
  set page(
    paper: "us-letter",
    margin: (left: 0.75in, right: 0.75in, top: 0.75in, bottom: 1.25in))

  set text(font: ("Times New Roman", "Times"), size: 10pt)
  set par(leading: 0.55em, justify: true)

  align(center,
    text(size: 14pt, weight: "bold", title))

    columns(2, {
      align(center, text(size: 12pt, weight: "bold", [Abstract]))
      pad(left: 10pt, right: 10pt, abstract)
      body
    })

  if bibliography != none {
    bibliography
  }
}
