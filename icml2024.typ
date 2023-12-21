// Metrical size of page body.
#let body = (
  width: 6.75in,
  height: 9.0in,
)

// Default font sizes from original LaTeX style file.
#let font-defaults = (
  tiny:	        6pt,
  scriptsize:   7pt,
  footnotesize: 9pt,
  small:        9pt,
  normalsize:   10pt,
  large:        12pt,
  Large:        14pt,
  LARGE:        17pt,
  huge:         20pt,
  Huge:         25pt,
)

// We prefer to use Times New Roman when ever it is possible.
#let font-family = ("Times New Roman", "Nimbus Roman", "TeX Gyre Termes")

#let font = (
  Large: font-defaults.Large + 0.4pt,  // Actual font size.
  footnote: font-defaults.footnotesize,
  large: font-defaults.large,
  normal: font-defaults.normalsize,
  script: font-defaults.scriptsize,
)

#let footnote_prologue = [
  _Proceedings of the 41#super[st] International Conference on Machine
  Learning_, Vienna, Austria. PMLR 235, 2024. Copyright 2024 by the author(s).
]

#let footnote_epilogue = [
  Preliminary work. Under review by the International Conference on Machine
  Learning (ICML). Do not distribute.
]

#let footnote_body = [
  Anonymous Institution, Anonymous City, Anonymous Region, Anonymous Country.
  Correspondence to: Anonymous Authors \<anon.email\@domain.com\>. \

  // #footnote_prologue
  #footnote_epilogue
]

#let format_author_names(authors) = {
  // Formats the author's names in a list with commas and a
  // final "and".
  let author_names = authors.map(author => author.name)
  let author-string = if authors.len() == 2 {
    author_names.join(" and ")
  } else {
    author_names.join(", ", last: ", and ")
  }
  return author_names
}

/**
 * icml2024
 */
#let icml2024(
  title: [],
  authors: (),
  abstract: none,
  bibliography-file: none,
  accepted: false,
  body,
) = {
  let author_names = format_author_names(authors)
  set document(title: title, author: author_names)

  set page(
    paper: "us-letter",
    margin: (left: 0.75in, right: 8.5in - (0.75in + 6.75in + 0.03in), top: 1.0in),
    header: locate(loc => {
      let pageno = counter(page).at(loc).first()
      if pageno == 1 { return }
      set text(size: font.script)
      align(center)[title]
    }),
    footer-descent: 25pt - font.normal,
    footer: locate(loc => {
      let i = counter(page).at(loc).first()
      align(center, text(size: font.normal, [#i]))
    })
  )

  // Main body font is Times (Type-1) font.
  set columns(2, gutter: 0.25in)
  set par(justify: true, leading: 0.58em)
  set text(font: font-family, size: font.normal)

  set heading(numbering: "1.")
  show heading: it => {
    // Create the heading numbering.
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      // h(7pt, weak: true
    }

    set align(left)
    if it.level == 1 {
      text(size: font.large, weight: "bold")[
        #v(0.25in, weak: true)
        #number
        *#it.body*
        #v(0.15in, weak: true)
      ]
    } else if it.level == 2 {
      text(size: font.normal, weight: "bold")[
        #v(0.2in, weak: true)
        #number
        *#it.body*
        #v(0.13in, weak: true)
      ]
    } else if it.level == 3 {
      text(size: font.normal, weight: "regular")[
        #v(0.18in, weak: true)
        #number
        #smallcaps(it.body)
        #v(0.1in, weak: true)
      ]
    }
  }

  // Render title.
  text(size: font.Large, weight: "bold")[
    #v(0.5pt)
    #line(length: 100%)
    #v(1pt)
    #show par: set block(spacing: 18pt)
    #align(center)[#title]
    #v(1pt)
    #line(length: 100%)
  ]

  v(0.1in - 1pt)

  // Render authors.
  {
    set align(center)
    set text(weight: "bold")
    [Anonymous Authors]

    set super(typographic: false, size: font.script)
    set text(weight: "regular")
    [#footnote(footnote_body)]
  }

  v(0.2in)

  columns(2, gutter: 0.25in)[
    #set text(size: font.normal)
    #show par: set block(spacing: 11pt)
    // Render abstract.
    // ICML instruction tels that font size of `Abstract` must equal to 11 but
    // it does not like so.
    #text(size: font.large)[
      #align(center)[*Abstract*]
    ]
    #pad(left: 2em, right: 2em, abstract)
    #v(0.12in)

    // Display body.
    #set text(size: font.normal)
    #body

    // Display the bibliography, if any is given.
    #if bibliography-file != none {
      show bibliography: set text(size: font.normal)
      bibliography(style: "apa", title: "References", bibliography-file)
    }
  ]
}
