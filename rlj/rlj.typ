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

    let spacing = 9pt
    let above = 2.0 * ex + spacing

    let spacing = 6pt
    let below = 1.5 * ex + spacing

    block(above: above, below: below, body)
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

    let spacing = 7pt
    let above = 1.8 * ex + spacing

    let spacing = 7pt
    let below = 0.8 * ex + spacing

    block(above: above, below: below, body)
  }
}

#let h3(body) = {
  let spacing = 6pt
  set text(size: font-size.normal, weight: "regular")
  context {
    let shape = measure(text(top-edge: "bounds", bottom-edge: "baseline")[x])
    let ex = shape.height // ex = 4.47pt
    let above = 1.8 * ex + spacing
    let below = 0.5 * ex + spacing + 1pt
    block(above: above, below: below, {
      set text(size: font-size.normal, weight: "bold")
      body
    })
  }
}

#let h4(body) = {
  set text(size: font-size.normal, weight: "regular")
  let spacing = 7pt
  let above = spacing + 5pt
  let below = spacing
  block(above: above, below: below, body)
}

#let appendix(body) = {
  set heading(numbering: "A.1")
  body
}

#let rule-appendix = appendix

#let summary-box(title: [Summary], body) = {
  set par(first-line-indent: 1em)
  let inset = (x: 12pt, top: 9.3pt, bottom: 12pt)
  block(width: 100%, above: 0pt, below: 0pt, inset: inset, radius: 2mm, fill: rgb("#f1f4f7"), {
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
  v(-4pt)
  enum(tight: false, spacing: 5pt, ..items)
}

#let make-cover(title, authors, keywords, summary, contribs) = {
  v(2pt)
  block(width: 100%, below: 0pt, {
    set align(center)
    set text(size: font-size.LARGE, top-edge: 11pt)
    strong(title)
  })
  v(12.7pt)
  block(width: 100%, below: 0pt, {
    set align(center)
    set text(size: font-size.large, top-edge: 11pt)
    [*Anonymous authors*\ Paper under double-blind review]
  })
  v(11pt)
  block(width: 100%, below: 0pt, {
    set align(center)
    [*Keywords:* ] + keywords.join([, ])
  })
  v(22pt)

  summary-box(summary)
  v(20pt)
  contrib-box(contribs)
  pagebreak()
}

#let make-abstract(abstract) = context {
  set text(size: font-size.normal, weight: "regular")
  let shape = measure(text(top-edge: "bounds", bottom-edge: "baseline")[x])
  let ex = shape.height  // ex = 4.47pt

  // TODO
  // block(above: 0.05in, below: ex + 18pt, {
  block(above: 0.05in, below: 0pt, {
    align(center, {
      set text(size: font-size.large, weight: "bold")
      [Abstract]
    })
    // Default spacing before and after `quote` in LaTeX is 10pt.
    pad(x: 0.5in, top: 10pt - 1.5 * ex + 1.7pt, bottom: 10pt, abstract)
  })
}

#let make-title(title, authors, affls, abstract, accepted: false) = {
  v(0.15in)  // Fixed.
  block(above: 0pt, below: 0pt, {
    align(center, {
      set text(size: font-size.LARGE, weight: "bold", top-edge: 19pt)
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
      v(0.25in + 2pt)
      [*Anonymous authors*\ Paper under double-blind review\ ]
    }
  })
  v(0.3in + 12.5pt)

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

  set text(size: 10pt, font: font-face.serif, top-edge: 11pt)
  set par(justify: true, leading: 1pt, spacing: 5pt)
  set par.line(
    numbering: n => text(fill: gray, [#n]),
    number-clearance: 11pt)

  // Footnote's `\baselineskip` is 9.5pt.
  set footnote.entry(
    clearance: 9pt,
    indent: 10pt,
    gap: 1.5pt,
    separator: line(length: 2in, stroke: 0.42pt)
  )
  show footnote.entry: it => {
    set text(size: font-size.footnote, top-edge: 8pt)
    set par(justify: true, leading: 1.5pt, spacing: 1.5pt)
    set par.line(numbering: none)
    it
  }

  // Bullet and numbered lists.
  show list.where(tight: false): set list(spacing: 3pt)
  show enum.where(tight: false): set enum(spacing: 3pt)

  // Headings.
  set heading(numbering: "1.1")
  show heading.where(level: 1): h1
  show heading.where(level: 2): h2
  show heading.where(level: 3): h3
  show heading.where(level: 4): h4

  show figure.where(kind: image): set block(above: 0.3in, below: 0.3in)
  show figure.where(kind: image): set figure(gap: 13.5pt)

  show figure.where(kind: table): set block(above: 12pt, below: 20pt)
  show figure.where(kind: table): set figure(gap: 16.7pt)
  show figure.where(kind: table): set figure.caption(position: top)

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
