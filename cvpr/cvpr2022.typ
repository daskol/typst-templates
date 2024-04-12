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

#let pad_int(i, N: 3) = {
    let s = str(i)
    let n_pads = N - s.len()
    for _ in range(n_pads) {
        s = "0" + s
    }
    [#s]
}

#let manuscript(title: [Paper Title], authors: (), anonymous: true, id: 1234, abstract: [], content) = [
    #let RULERWIDTH = 0.6in
    #set page(
        paper: "a4",
        margin: (
          left: 0.8in - RULERWIDTH,
          right: 0.9in - RULERWIDTH,
          top: 1.0625in,
          bottom: 1.0625in
        ),
        header: [
            #set align(center)
            #set text(
                rgb(50%, 50%, 100%),
                font: "Times",
                size: 8pt,
                weight: "bold"
            )
            CVPR 2022 Submission \##id. CONFIDENTIAL REVIEW COPY. DO NOT DISTRIBUTE.
        ]
    )
    #let A4WIDTH = 8.5in
    #set par(
        justify: true,
        first-line-indent: 0.166666in,
        leading: 0.55em
    )

    #set text(
        font: "Times",
        size: 10pt,
        spacing: 100%
    )
    #show raw: set text(font: "CMU Typewriter Text")

    #set heading(numbering: "1.1.")
    #show heading: h => [
        #set text(size: 12pt)
        #h #v(5pt)
    ]

    #if anonymous {
        authors = ([
            Anonymous CVPR submission \
            \
            Paper ID #id
        ], )
    }

    #grid(columns: (RULERWIDTH, auto, RULERWIDTH),
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
          #align(center)[
              #v(0.5in)
              #text(size: 14pt)[*#title*]
          ]\
          #align(center)[
              #set text(size: 11pt)
              #let c = ()
              #for value in range(authors.len()) {
                  c.push(1fr)
              }
              #grid(
                  columns: c,
                  ..authors
              )
          ]\ \
          #columns(2, gutter: 0.3125in, [
              #align(center)[
                  #text(size: 12pt)[*Abstract*]
              ]

              #emph[#abstract] \ \
              #content
          ])
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
      ]
    )
]
