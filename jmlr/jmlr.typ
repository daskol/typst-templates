#let std-bibliography = bibliography  // Due to argument shadowing.

#let font-family = ("New Computer Modern", "Times New Roman", "Latin Modern Roman", "CMU Serif",
                    "New Computer Modern", "Serif")
#let font-family-mono = ("Latin Modern Mono", "New Computer Modern Mono",
                         "Mono")

#let font-size = (
  tiny: 6pt,
  script: 8pt,  // scriptsize
  footnote: 9pt, // footnotesize
  small: 10pt,
  normal: 11pt, // normalsize
  large: 12pt,
  Large: 14pt,
  LARGE: 17pt,
  huge: 20pt,
  Huge: 25pt,
)

#let make-title(title, authors, abstract) = {
  // Render title.
  v(-0.03in)  // Visually perfect.
  block(spacing: 0em, {
    set block(spacing: 0em)
    set par(leading: 10pt)  // Empirically found.
    text(size: 14pt, weight: "bold", title)
  })

  // make-authors(..authors)
  // let label = text(font: font-family-mono, weight: "bold", emph(review))
  // [*Reviewed on OpenReview:* #link(review, label)]

  // Render abstract.
  block(spacing: 0em, width: 100%, {
    set text(size: font-size.small)
    set par(leading: 0.51em)  // Original 0.55em (or 0.45em?).
    align(center,
      text(size: font-size.normal, weight: "bold", [*Abstract*]))
    v(22.2pt, weak: true)
    pad(left: 20pt, right: 20pt, abstract)
  })
  v(6.78pt, weak: true)
  // Render keywords.
  block(spacing: 0em, width: 100%, {
    set text(size: 10pt)
    set par(leading: 0.51em)  // Original 0.55em (or 0.45em?).
    pad(left: 20pt, right: 20pt)[*Keywords:* ...]
  })
  v(29.5pt, weak: true)  // Visually perfect.
}

/**
 * jmlr - Template for Journal of Machine Learning Research (JMLR).
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
 */
#let jmlr(
  title: [],
  authors: (),
  keywords: (),
  date: auto,
  abstract: [],
  bibliography: none,
  appendix: none,
  accepted: false,
  body,
) = {
  let author = ""  // TODO(@daskol): Fix this.
  set document(title: title, author: author, keywords: keywords, date: date)

  set page(
      paper: "us-letter",
      margin: (
        left: 1.25in,
        right: 1.25in,
        top: 1in,
        bottom: 1in,
      ),
  )

  set text(font: font-family, size: 11pt)
  set par(leading: 0.55em, first-line-indent: 17pt, hanging-indent: 0pt, justify: true)
  show par: set block(spacing: 0.55em)

  // Configure heading appearence and numbering.
  set heading(numbering: "1.1")
  show heading.where(level: 1): it => {
    set text(size: font-size.large)
    set block(above: 0.31in, below: 0.22in)
    it
  }
  /*
  show heading: it => {
    // Create the heading numbering.
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
    }

    // Render section with such names without numbering as level 3 heading.
    let unnumbered = (
      [Acknowledgments and Disclosure of Funding],
    )
    let level = it.level
    let prefix = [#number ]
    if unnumbered.any(name => name == it.body) {
      text(size: 12pt, weight: "bold", {
        v(0.3in, weak: true)
        it.body
        v(0.2in, weak: true)
      })
      return
    }

    // TODO(@daskol): Use styles + measure to estimate ex.
    set align(left)
    if level == 1 {
      text(size: 12pt, weight: "bold", {
        let ex = 10pt
        v(2.05 * ex, weak: true)  // Visually perfect.
        [#prefix*#it.body*]
        v(1.80 * ex, weak: true) // Visually perfect.
      })
    } else if level == 2 {
      text(size: 11pt, weight: "bold", {
        let ex = 6.78pt
        v(2.8 * ex, weak: true)  // Visually perfect.
        [#prefix*#it.body*]
        v(2.15 * ex, weak: true)  // Visually perfect. Original 1ex.
      })
    } else if level == 3 {
      text(size: 11pt, weight: "bold", {
        let ex = 6.78pt
        v(2.7 * ex, weak: true)  // Visually perfect.
        [#prefix*#it.body*]
        v(2.0 * ex, weak: true)  // Visually perfect. Original -0.7em.
      })
    }
  }
  */

  make-title(title, authors, abstract)
  parbreak()
  body

  if appendix != none {
    set heading(numbering: "A.1", supplement: [Appendix])
    counter(heading).update(0)
    pagebreak()
    appendix
  }

  if bibliography != none {
    set std-bibliography(title: [References])
    bibliography
  }
}
