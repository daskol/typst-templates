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
      paper: "a4",
      margin: (
        left: 0.8in - RULERWIDTH,
        right: 0.9in - RULERWIDTH,
        top: 1.0625in,
        bottom: 1.0625in,
      ),
      header: {
        set align(center)
        set text(rgb(50%, 50%, 100%), font: "Times", size: 8pt)
        strong[#conf-name #conf-year Submission \##id. #notice]
      },
  )

  set text(font: "Times", size: 10pt)
  set par(justify: true, first-line-indent: 0.166666in, leading: 0.55em)
  show raw: set text(font: "CMU Typewriter Text")

  set heading(numbering: "1.1.")
  show heading: it => {
      set text(size: 12pt)
      it
      v(5pt)
  }

  if anonymous {
    authors = ([
      Anonymous CVPR submission \
      \
      Paper ID #id
    ], )
  }

  grid(
    columns: (RULERWIDTH, auto, RULERWIDTH),
    gutter: 0pt,
    [
      #if anonymous {
        set text(rgb(50%, 50%, 100%), weight: "bold")
        set par(leading: 0.6em)
        set align(left)
        for i in range(100) {
        locate(loc => [
          #pad_int(loc.page() * i) #linebreak()
        ])
        }
      }
    ],
    [
      #align(center, {
        v(0.5in)
        text(size: 14pt)[*#title*]
      })\
      #align(center, {
        set text(size: 11pt)
        let c = ()
        for value in range(authors.len()) {
          c.push(1fr)
        }
        grid(columns: c, ..authors)
      })\ \
      #columns(2, gutter: 0.3125in, {
        align(center, text(size: 12pt)[*Abstract*])
        emph[#abstract\ \ ]
        body
      })
    ],
    [
      #if anonymous {
        set text(rgb(50%, 50%, 100%), weight: "bold")
        set align(right)
        for i in range(100) {
          locate(loc => [
            #pad_int(loc.page() * i + 54) #linebreak()
          ])
        }
      }
    ],
  )

  if bibliography != none {
    set std-bibliography(title: [References], style: "ieee")
    bibliography
  }

  if appendix != none {
    set heading(numbering: "A.1")
    counter(heading).update(0)
    appendix
  }
}
