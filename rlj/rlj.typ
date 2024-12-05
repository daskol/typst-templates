/**
 * rlj.typ
 *
 * Reinforcement Learning Journal/Conference (RLJ/RLC) template.
 */

#let std-bibliography = bibliography  // Due to argument shadowing.

#let font-face = (
  serif: ("Times New Roman", ),
)

#let font-size = (
  footnote: 8.0pt,
  small: 9.0pt,
  normal: 10.0pt,
  large: 12.0pt,
  Large: 14.4pt,
  LARGE: 17.28pt,
  Huge: 20.74pt,
  HUGE: 24.88pt,
)

#let h1(body) = {
  set text(size: font-size.large, weight: "bold")
  context {
    let shape = measure({
      text(
        size: font-size.normal,
        weight: "bold",
        top-edge: "bounds",
        bottom-edge: "baseline",
      )[x]
    })
    let ex = shape.height  // ex = 4.57pt

    let spacing = 12pt + font-size.Large / 2
    let above = 2.0 * ex + spacing

    let spacing = 12pt + 6pt
    let below = 1.5 * ex + spacing

    block(fill: aqua, above: above, below: below, body)
  }
}

#let h2(body) = {
  set text(size: font-size.normal, weight: "bold")
  context {
    let shape = measure(text(top-edge: "bounds", bottom-edge: "baseline")[x])
    let shape = measure({
      text(
        size: font-size.normal,
        weight: "regular",
        top-edge: "bounds",
        bottom-edge: "baseline",
      )[x]
    })
    let ex = shape.height  // ex = 4.47pt

    let spacing = 12pt + font-size.large / 2
    let above = 1.8 * ex + spacing - 0.1pt

    // let shape = measure({
    //   text(
    //     size: font-size.normal,
    //     weight: "regular",
    //     top-edge: "bounds",
    //     bottom-edge: "baseline",
    //   )[x]
    // })
    // let ex = shape.height  // ex = 4.47pt
    let spacing = 12pt + 6pt
    let below = 0.8 * ex + spacing - 0.1pt

    block(fill: aqua, above: above, below: below, body)
  }
}

#let h3(body) = {
  let spacing = 12pt + 6pt
  set text(size: font-size.normal, weight: "regular")
  context {
    let shape = measure(text(top-edge: "bounds", bottom-edge: "baseline")[x])
    let ex = shape.height // ex = 4.47pt
    let above = 1.8 * ex + spacing - 1.5pt
    let below = 0.5 * ex + spacing
    block(fill: aqua, above: above, below: below, {
      set text(size: font-size.normal, weight: "bold")
      body
    })
  }
}

#let h4(body) = {
  set text(size: font-size.normal, weight: "regular")
  let spacing = 12pt + 6pt
  let above = spacing + 5pt
  let below = spacing
  block(fill: aqua, above: above, below: below, body)
}

#let appendix(body) = {
  set heading(numbering: "A.1")
  body
}

#let rule-appendix = appendix

#let summary-box(title: [Summary], body) = {
  set par(first-line-indent: 1em)
  let inset = (x: 12pt, top: 12pt + 6pt, bottom: 12pt)
  block(width: 100%, inset: inset, radius: 2mm, fill: rgb("#f1f4f7"), {
    align(center, {
      set text(size: font-size.Large, weight: "bold")
      title
    })
    v(0.025in + 4pt)
    body
  })
}

#let contrib-box(contribs) = {
  show: summary-box.with(title: [Contribution(s)])
  let items = contribs.map(it => {
    it.contribution
    let caveat = it.at("caveat", default: [None])
    [\ *Context:* #caveat]
  })
  enum(tight: false, ..items)
}

#let make-cover(title, authors, keywords, summary, contribs) = {
  v(12pt + 1pt - 0.35pt)  // Fixed.
  block({
    text(size: font-size.LARGE, weight: "bold", title)
  })
  v(6pt)
  block(width: 100%, {
    set text(size: font-size.large)
    set align(center)
    [*Anonymous authors*\ Paper under double-blind review]
  })
  v(4pt)
  block(width: 100%, {
    set align(center)
    [*Keywords:* ] + keywords.join([, ])
  })
  v(4pt)

  summary-box(summary)
  contrib-box(contribs)
  pagebreak()
}

#let make-abstract(abstract) = context {
  set text(size: font-size.normal, weight: "regular")
  let shape = measure(text(top-edge: "bounds", bottom-edge: "baseline")[x])
  let ex = shape.height  // ex = 4.47pt
  let spacing = 12pt + 6pt

  // block(above: 0.05in + spacing, below: ex + spacing, {
  block(above: 0.05in, below: ex + spacing, {
    align(center, {
      set text(size: font-size.large, weight: "bold")
      [Abstract]
    })
    // Default spacing before and after `quote` in LaTeX is 10pt.
    pad(x: 0.5in, top: 10pt - 1.5 * ex, bottom: 10pt, abstract)
  })
}

#let make-title(title, authors, affls, abstract, accepted: false) = {
  let spacing = 12pt + 6pt
  v(0.15in)  // Fixed.
  v(font-size.LARGE + 2pt - 0.35pt)  // Spacing.
  block(below: 0.3in, {
    align(center, {
      set text(size: 16pt, weight: "bold")
      title
    })
    if accepted == none or accepted {
      v(0.2in)
      text(size: font-size.large, weight: "bold")[author]
      v(-0.06in)
      [`emails@example.org`]
      v(0.1in)
      [affilations]
    } else {
      v(0.25in)
      [*Anonymous authors*\ Paper under double-blind review\ ]
    }
  })
  v(1.5 * spacing)

  make-abstract(abstract)
}

/**
 * rlj - Template for Reinforcement Learning Journal (and Conference).
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
#let rlj(
  title: [],
  authors: (),
  keywords: (),
  date: auto,
  abstract: [],
  bibliography: none,
  appendix: none,
  accepted: false,
  summary: [],
  contributions: (),
  running-title: none,
  aux: (:),
  body,
) = {
  // Deconstruct authors for convenience.
  let (authors, affls) = if authors.len() == 2 {
    authors
  } else {
    ((), ())
  }
  if accepted != none and not accepted {
    authors = ((name: "Anonymous Author"), )
  }

  let running-title = if accepted == none or running-title == none {
    []
  } else {
    running-title
  }

  let running-title-notice = if accepted == none {
    []
  } else if accepted {
    [Reinforcement Learning Journal 2025]
  } else {
    [Under review for RLC 2025, to be published in RLJ 2025]
  }

  set page(
    paper: "us-letter",
    margin: (
      left: 1.5in, right: 8.5in - 1.5in - 5.5in,
      top: 1in, bottom: 11in - 1in - 9in),
    footer: context {
      set align(center + top)
      let ix = counter(page).get().first()
      if ix > 1 {
        ix - 1
      }
    },
    footer-descent: 30pt + 1pt,
    header: {
      set par(spacing: 0pt)
      set align(left)
      text(top-edge: "ascender", bottom-edge: "descender", context {
        let ix = counter(page).get().first()
        if ix == 1 {
          grid(
            columns: (1fr, auto),
            running-title-notice,
            grid.vline(stroke: 0.35pt),
            grid.cell(inset: (y: 1pt), h(0.4em) + [*Cover Page*]))
        } else if calc.even(ix) {
          running-title
          v(1pt)
        } else {
          running-title-notice
          v(1pt)
        }
      })
      line(length: 100%, stroke: 0.35pt)
    },
    header-ascent: 24pt - 0.35pt / 2,
  )

  show text: set block(fill: aqua)
  set text(size: 10pt, font: font-face.serif, top-edge: "baseline")
  set par(justify: true, leading: 12pt, spacing: 12pt + 6pt)
  set par.line(
    numbering: n => text(fill: gray, [#n]),
    number-clearance: 11pt)

  // Footnote's `\baselineskip` is 9.5pt.
  set footnote.entry(
    clearance: 9pt,
    indent: 10pt,
    gap: 9.5pt,
    separator: line(length: 2in, stroke: 0.42pt)
  )
  show footnote.entry: it => {
    set text(size: font-size.footnote, top-edge: "baseline")
    set par(justify: true, leading: 9.5pt, spacing: 1.5 * 9.5pt)
    set par.line(numbering: none)
    it
  }

  let spacing = 1.5 * 12pt
  show list.where(tight: false): set list(spacing: spacing - 2pt)

  let spacing = 1.5 * 12pt
  show enum.where(tight: false): set enum(spacing: spacing - 2pt)


  set heading(numbering: "1.1")
  show heading.where(level: 1): h1
  show heading.where(level: 2): h2
  show heading.where(level: 3): h3
  show heading.where(level: 4): h4

  make-cover(title, authors, keywords, summary, contributions)
  make-title(title, authors, affls, abstract)
  body

  set std-bibliography(title: [References], style: "apa")
  if bibliography != none {
    bibliography
  }

  show: rule-appendix
}

/**
 * Auxiliary function for contribution representation (aka struct/type
 * constructor).
 */
#let contribution(caveat: none, contribution) = (
  caveat: caveat,
  contribution: contribution,
)

/**
 * Auxiliary routine to render links as monospaced text.
 */
#let url(uri) = link(uri, raw(uri))
