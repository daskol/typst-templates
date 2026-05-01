/**
 * aaai.typ
 *
 * Template for The Association for the Advancement of Artificial Intelligence
 * (AAAI) conference.
 *
 * [1]: https://aaai.org/
 */

// Lists of acceptable fonts.
//
// We prefer to use CMU Bright variant instead of Computer Modern Bright when
// ever it is possible.
#let font-family = ("Times New Roman", )
#let font-family-sans = ("Latin Modern Sans", "New Computer Modern Sans",
                         "CMU Sans Serif")
#let font-family-mono = ("Latin Modern Mono", "New Computer Modern Mono")

#let font = (
  LARGE: 14.5pt,
  Large: 12pt,
  footnote: 10pt,
  large: 11pt,
  normal: 10pt,
  script: 8pt,
  small: 9pt,
)

/**
 * Default font config (FC).
 */
#let font-config-default() = (
  family: (serif: font-family,
           sans: font-family-sans,
           mono: font-family-mono),
  size: font,
)

/**
 * Ensure font config is valid.
 */
#let font-config-ensure(fc) = {
  if fc == none {
    return font-config-default()
  } else if type(fc) == array and fc.len() != 2 {
    return font-config-default()
  } else if type(fc) == dictionary and fc.len() != 2 {
    return font-config-default()
  } else {
    return fc
  }
}

/**
 * Merge auxiliary options to font config structure.
 */
#let font-config-merge(fc, aux) = {
  if "font-family" in aux {
    for kind in ("serif", "sans", "mono") {
      if kind in aux.font-family {
        fc.family.insert(kind, aux.font-family.at(kind))
      }
    }
  }

  if "font-size" in aux {
    // Large, footnote, large, and so on.
    for size in font.keys() {
      if size in aux.font-family {
        fc.family.insert(size, aux.font-family.at(size))
      }
    }
  }

  return fc
}

#let affl-keys = ("department", "institution", "location", "country")

#let make-author(author, affls, fc: none) = {
  let fc = font-config-ensure(fc)

  let author-affls = if type(author.affl) == array {
    author.affl
  } else {
    (author.affl, )
  }

  let lines = author-affls.map(key => {
    let affl = affls.at(key)
    return affl-keys
      .map(key => affl.at(key, default: none))
      .filter(it => it != none)
      .join("\n")
  }).map(it => emph(it))

  return block(spacing: 0em, {
    set par(justify: true, leading: 0.50em, spacing: 0em)  // Visually perfect.
    text(size: fc.size.normal)[*#author.name*\ ]
    text(size: fc.size.small)[#lines.join([\ ])]
  })
}

#let make-email(author, fc: none) = {
  let fc = font-config-ensure(fc)
  let label = text(size: fc.size.small, emph(author.email))
  return block(spacing: 0em, {
    // Compensate difference between name and email font sizes (10pt vs 9pt).
    v(1pt)
    link("mailto:" + author.email, label)
  })
}

#let make-authors(authors, affls, fc: none) = {
  let cells = authors
    .map(it => (make-author(it, affls, fc: fc), make-email(it, fc: fc)))
    .join()
  return grid(
    columns: (2fr, 1fr),
    align: (left + top, right + top),
    row-gutter: 15.8pt,  // Visually perfect.
    ..cells)
}

#let make-title-block(title, authors, review, accepted, fc: none) = {
  let fc = font-config-ensure(fc)
  set align(center)

  // Render title.
  v(1.25cm)
  block(spacing: 0em, {
    set text(font: fc.family.serif, size: font.LARGE)
    set par(leading: 0.15em, spacing: 0em)
    strong(title)
  })

  // Render authors if paper is accepted or not accepted or ther is no
  // acceptance status (aka preprint).
  if accepted == none {
    v(31pt, weak: true)  // Visually perfect.
    make-authors(..authors, fc: fc)
    v(-2pt)  // Visually perfect.
  } else if accepted {
    v(31pt, weak: true)  // Visually perfect.
    make-authors(..authors, fc: fc)
    v(14.9pt, weak: true)  // Visually perfect.
    let label = text(font: fc.family.mono, weight: "bold", emph(review))
    [*Reviewed on OpenReview:* #link(review, label)]
  } else {
    v(14pt)
    block(spacing: 0em, {
      set text(size: fc.size.Large)
      [*Anonymous submimssion*]
    })
  }

  v(0.5in)
}

#let h1(fc: none, body) = align(center, {
  set text(size: fc.size.Large, weight: "bold")
  set par(justify: false, leading: 0.53cm - 1em)
  let leading = 0.53cm - 1em
  v(0.64cm + leading)
  body
  v(0.21cm + leading)
})

#let h2(fc: none, body) = align(left, {
  set text(size: fc.size.large, weight: "bold")
  set par(justify: false, leading: 0.46cm - 1em)
  let leading = 0.46cm - 1em
  v(0.42cm + leading)
  body
  v(0.11cm + leading)
})

#let h3(fc: none, body) = align(left, {
  set text(size: fc.size.normal, weight: "bold")
  set par(justify: false, leading: 0.42cm - 1em)
  let leading = 0.42cm - 1em
  v(0.11cm + leading)
  body
  v(leading)
})

#let abstract-header(fc: none, body) = align(center, {
  set text(size: fc.size.normal, weight: "bold")
  set par(justify: false, leading: 0.42cm - 1em, spacing: 0pt)
  body
  v(0.11cm)
})

#let abstract-text(fc: none, body) = align(center, {
  set text(size: fc.size.small)
  set par(leading: 0.35cm - 1em, spacing: 0.35cm - 1em)
  pad(left: 0.35cm, right: 0.35cm, body)
})

#let make-abstract(abstract, fc: none) = {
  let fc = font-config-ensure(fc)

  block(spacing: 0em, width: 100%, {
    abstract-header(fc: fc)[Abstract]
    abstract-text(fc: fc, abstract)
  })
}

#let make-title(title, authors, review, accepted, fc: none) = place(
  top,
  block(width: 100%, {
    make-title-block(title, authors, review, accepted, fc: fc)
  }),
  scope: "parent",
  float: true,
)

/**
 * Show-rule for appendix styling.
 */
#let default-appendix(body) = {
  set heading(numbering: "A.1")
  counter(heading).update(0)
  body
}

/**
 * Show-rule for bibliography.
 */
#let default-bibliography(fc: none, body) = {
  let fc = font-config-ensure(fc)
  set text(size: fc.size.small)
  set par(
    justify: true,
    first-line-indent: 0em,
    leading: 0.35cm - 1em,
    spacing: 0.11cm + (0.35cm - 1em))
  set std.bibliography(title: [References], style: "acl.csl")
  body
}

/**
 * aaai2026
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
 *   review: Hypertext link to review on OpenReview.
 *   pubdate: Date of publication (used only month and date).
 */
#let aaai2026(
  title: [],
  authors: (),
  keywords: (),
  date: auto,
  abstract: none,
  bibliography: none,
  appendix: none,
  accepted: false,
  review: none,
  pubdate: none,
  aux: (:),
  body,
) = {
  if pubdate == none {
    pubdate = if date != auto and data != none {
      date
    } else {
      datetime.today()
    }
  }

  // Prepare authors for PDF metadata.
  let author = if accepted == none or accepted {
    authors.at(0).map(it => it.name)
  } else {
    ()
  }

  // Prepare font config (FC).
  let fc = font-config-default()
  fc = font-config-merge(fc, aux)

  set document(
    title: title,
    author: author,
    keywords: keywords,
    date: date)

  set page(
    paper: "us-letter",
    columns: 2,
    margin: (left: 0.75in, right: 0.75in, top: 0.75in, bottom: 1.25in))

  set columns(gutter: 0.35in)

  set text(
    font: fc.family.serif,
    size: fc.size.normal,
    top-edge: 1em,
    bottom-edge: 0em)
  let leading = 0.42cm - 1em
  set par(
    justify: true,
    first-line-indent: 1em,
    leading: leading,
    spacing: leading)

  // Configure heading appearence and numbering.
  set heading(numbering: "1.1")
  show heading: set text(font: fc.family.serif)
  show heading: it => block(width: 100%, spacing: 0pt, {
    // Render section with such names without numbering as level 3 heading.
    let unnumbered = (
      [Broader Impact Statement],
      [Author Contributions],
      [Acknowledgments],
    )
    let level = it.level

    if level == 1 {
      h1(fc: fc, it.body)
    } else if level == 2 {
      h2(fc: fc, it.body)
    } else if level == 3 {
      h3(fc: fc, it.body)
    }
  })

  // Configure code blocks (listings).
  show raw: set block(spacing: 1.95em)
  show raw: set block(spacing: 12pt)

  // Configure footnote (almost default).
  show footnote.entry: set text(size: 8pt)
  set footnote.entry(
    separator: line(length: 2in, stroke: 0.35pt),
    clearance: 6.65pt,
    gap: 0.40em,
    indent: 12pt)

  // All captions either centered or aligned to the left (See
  // https://github.com/daskol/typst-templates/issues/6 for details).
  show figure.caption: body => {
    set align(center)
    block(width: auto, {
      set align(start)
      body
    })
  }

  // Configure figures.
  show figure.where(kind: image): set figure.caption(position: bottom)
  set figure(gap: 16pt)

  // Configure tables.
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set figure(gap: 6pt)
  set table(inset: 4pt)

  // Configure numbered lists.
  set enum(indent: 0.5em, spacing: 2 * leading)
  show enum: it => {
    set block(above: leading * 0.8, below: leading)
    set par(leading: leading * 0.4)
    it
  }

  // Configure bullet lists.
  set list(indent: 0.5em, spacing: 2 * leading, marker: ([•], [‣], [⁃]))
  show list: it => {
    set block(above: leading * 0.8, below: leading)
    set par(leading: leading * 0.4)
    it
  }

  // Configure math numbering and referencing.
  set math.equation(numbering: "(1)", supplement: [])
  show ref: it => {
    let eq = math.equation
    let el = it.element
    if el != none and el.func() == eq {
      let numb = numbering(
        "1",
        ..counter(eq).at(el.location())
      )
      let color = rgb(0%, 8%, 45%)  // Originally `mydarkblue`. :D
      let content = link(el.location(), text(fill: color, numb))
      [(#content)]
    } else {
      it
    }
  }

  // Render title + authors + abstract.
  make-title(title, authors, review, accepted, fc: fc)
  make-abstract(abstract, fc: fc)

  // Render body as is.
  body

  if bibliography != none {
    show: default-bibliography
    bibliography
  }

  if appendix != none {
    show: default-appendix
    appendix
  }
}
