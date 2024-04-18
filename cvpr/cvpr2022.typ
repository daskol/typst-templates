/**
 * cvpr2022.typ
 *
 * This template continues work done by [@dasayan05][1] (see [issue][3]). It is
 * adopted from [dasayan05/typst-ai-conf-templates][2].
 *
 * [1]: https://github.com/dasayan05
 * [2]: https://github.com/dasayan05/typst-ai-conf-templates.
 * [3]: https://github.com/daskol/typst-templates/issues/8
 */

#let std-bibliography = bibliography  // Due to argument shadowing.

#let A4WIDTH = 8.5in
#let RULERWIDTH = 0.6in

#let conf-name = [CVPR]
#let conf-year = [2022]
#let notice = [CONFIDENTIAL REVIEW COPY. DO NOT DISTRIBUTE.]

#let eg = emph[e.g.]
#let etal = emph[et~al]

#let font-family = ("Times New Roman", "CMU Serif", "Latin Modern Roman",
                    "New Computer Modern", "Times", "Serif")

#let font-family-sans = ("Nimbus Sans", "CMU Sans Serif", "Latin Modern Sans",
                         "New Computer Modern Sans", "Sans")

#let font-family-mono = ("CMU Typewriter Text", "Latin Modern Mono",
                         "New Computer Modern Mono", "Mono")

#let font-size = (
  normal: 10pt,
  small: 9pt,
  footnote: 8pt,
  script: 7pt,
  tiny: 5pt,
  large: 12pt,
  Large: 14.4pt,
  LARGE: 17pt,
  huge: 20pt,
  Huge: 25pt,
)

#let pad_int(i, N: 3) = {
    let s = str(i)
    let n_pads = N - s.len()
    for _ in range(n_pads) {
        s = "0" + s
    }
    [#s]
}

/**
 * cvpr2022 - Template for Computer Vision and Pattern Recognition Conference
 * (CVPR) 2022.
 *
 * Args:
 *   title: Paper title.
 *   authors: Tuple of author objects and affilation dictionary.
 *   keywords: Publication keywords (used in PDF metadata).
 *   date: Creation date (used in PDF metadata).
 *   abstract: Paper abstract.
 *   bibliography: Bibliography content. If it is not specified then there is
 *   not reference section.
 *   appendix: Content to append after bibliography section.
 *   accepted: Valid values are `none`, `false`, and `true`. Missing value
 *   (`none`) is designed to prepare arxiv publication. Default is `false`.
 *   id: Submission identifier.
 */
#let cvpr2022(
  title: [],
  authors: (),
  keywords: (),
  date: auto,
  abstract: [],
  bibliography: none,
  appendix: none,
  accepted: false,
  id: none,
  body,
) = {
  // TODO(@daskol): Get rid of this later.
  let anonymous = true
  if accepted == none or accepted {
    anonymous = false
  }

  if anonymous {
    authors = ([
      Anonymous CVPR submission \
      \
      Paper ID #id
    ], )
  }

  // If there is not submission id then use a placeholder.
  if id == none {
    id = "*****"
  }

  let author = ""  // TODO(@daskol): Fix this.
  set document(
    title: title,
    author: author,
    keywords: keywords,
    date: date)

  set page(
    paper: "us-letter",
    margin: (left: 0.8125in, right: 0.8125in, top: 1in, bottom: 1.125in),
    header-ascent: 27.9pt,
    header: {
      set align(center)
      set text(font: font-family-sans, size: font-size.footnote, weight: "bold", fill: rgb(50%, 50%, 100%))
      strong[#conf-name #conf-year Submission \##id. #notice]
    },
    footer-descent: 23.4pt, // Visually perfect.
    footer: locate(loc => {
      let ix = counter(page).at(loc).first()
      return align(center, text(size: font-size.normal, [#ix]))
    }),
  )

  set text(font: font-family, size: font-size.normal)
  set par(justify: true, first-line-indent: 0.166666in, leading: 0.55em)
  show raw: set text(font: font-family-mono)

  set heading(numbering: "1.1.")
  show heading: it => {
      set text(size: font-size.large)
      it
      v(5pt)
  }

  block(width: 100%, spacing: 0pt, {
    set align(center)
    set text(size: font-size.Large, weight: "bold")
    v(0.5in - 0.6pt)  // Visually perfect.
    title
  })
  v(30pt, weak: true)
  block(width: 100%, spacing: 0pt, {
    set align(center)
    set text(size: font-size.large)
    let c = () // TODO(@daskol)
    for value in range(authors.len()) {
      c.push(1fr)
    }
    grid(columns: c, ..authors)
  })
  v(34.5pt, weak: true)

  // NOTE It seems that there is a typo in formatting instructions and actual
  // gutter is 3/8 in not 5/16 in.
  columns(2, gutter: 0.3125in, {
    align(center, text(size: font-size.large)[*Abstract*])
    emph[#abstract\ \ ]
    body

    if bibliography != none {
      set std-bibliography(title: [References], style: "ieee")
      bibliography
    }
  })

  if appendix != none {
    set heading(numbering: "A.1")
    counter(heading).update(0)
    appendix
  }
}
