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

#let conf-name = [CVPR]
#let conf-year = [2022]
#let notice = [CONFIDENTIAL REVIEW COPY. DO NOT DISTRIBUTE.]

/**
 * indent - Indentation helper.
 *
 * As Typst v0.11.0, the first paragraph is not indented (see [1]).
 *
 * [1]: https://github.com/typst/typst/issues/311
 */
#let indent = h(12pt)

#let eg = emph[e.g.]

#let etal = emph[et~al]

#let font-family = ("Times New Roman", "CMU Serif", "Latin Modern Roman",
                    "New Computer Modern", "Times", "Serif")

#let font-family-sans = ("Nimbus Sans", "CMU Sans Serif", "Latin Modern Sans",
                         "New Computer Modern Sans", "Sans")

#let font-family-mono = ("CMU Typewriter Text", "Latin Modern Mono",
                         "New Computer Modern Mono", "Mono")

#let font-family-link = ("Courier New", "Nimbus Mono PS") + font-family-mono

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

#let color = (
  ref: rgb(100%, 0%, 0%),  // Red.
  link: rgb(100%, 0%, 100%),  // Magenta.
)

#let lineno = counter("lineno")

#let lineno-fmt(numb, width: 3) = {
    let value = str(numb)
    let prefix-len = width - value.len()
    let prefix = ""
    for _ in range(prefix-len) {
      prefix = prefix + "0"
    }
    return prefix + value
}

#let ruler-color = rgb(50%, 50%, 100%)

#let ruler-style = body => {
  set text(size: 8pt, font: font-family-sans, weight: "bold", fill: ruler-color)
  set par(leading: 6.22pt)
  body
}

#let xruler(side, dx, dy, width, height, offset, num-lines) = {
  let alignment = if side == left {
    right
  } else {
    left
  }

  let numbs = range(0, num-lines).map(ix => {
    let anchor = lineno.step()
    let index = lineno-fmt(offset + ix)
    return [#anchor#index]
  })

  let ruler = block(width: width, height: height, spacing: 0pt, {
    show: ruler-style
    set align(alignment)
    numbs.join([\ ])

  })

  return place(left + top, dx: dx, dy: dy, ruler)
}

#let make-ruler(
  num-lines: 54,
  margin: auto,
  width: auto,
  height: 8.875in,
  gap: 30pt,
) = locate(loc => {
  let margin = if margin == auto {
    (top: 1in - 0.5pt, left: 0.8125in, right: 0.929in)  // CVPR 2022 defaults.
  } else {
    margin
  }

  let width = if width == auto {
    (left: margin.left - gap, right: margin.right - gap)
  } else {
    width
  }

  // Left ruler.
  let dx = 0pt
  let dy = margin.top
  let offset = lineno.get().at(0)
  xruler(left, dx, dy, width.left, height, offset, num-lines)

  // Right ruler.
  dx = 7.571in + gap
  offset += num-lines
  xruler(right, dx, dy, width.right, height, offset, num-lines)
})

#let ruler = make-ruler()  // Default CVPR 2022 ruler.

#let corner-text(id, width: auto, fill: ruler-color) = {
  block(width: width, align(center + horizon, {
    set par(leading: 4.9pt)
    set text(font: font-family-sans, fill: fill)
    text(size: font-size.small, [CVPR\ ])
    text(size: font-size.normal, [\##id])
  }))
}

/**
 * h, h1, h2, h3 - Style rules for headings.
 */

#let h(body) = {
  set text(size: font-size.normal, weight: "regular")
  set block(above: 11.9pt, below: 11.7pt)
  body
}

#let h1(body) = {
  set text(size: font-size.large, weight: "bold")
  set block(above: 17pt, below: 12.8pt)
  body
}

#let h2(body) = {
  set text(size: font-size.normal, weight: "bold")
  set text(size: 11pt, weight: "bold")
  set block(above: 11.4pt, below: 11.5pt)
  body
}

#let h3(body) = {
  set text(size: font-size.normal, weight: "bold")
  set text(size: 10pt, weight: "bold")
  set block(above: 21.7pt, below: 12.8pt)
  body
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

  if anonymous {
    authors = ([
      Anonymous CVPR submission \
      \
      Paper ID #id
    ], )
  }

  let author = ""  // TODO(@daskol): Fix this.
  set document(
    title: title,
    author: author,
    keywords: keywords,
    date: date)

  set page(
    paper: "us-letter",
    margin: (left: 0.696in, right: 0.929in, top: 1in, bottom: 1.125in),
    background: if accepted != none and not accepted {
      // Rullers on sides.
      ruler
      // Decorate top corners.
      place(top + left, dx: -14.6pt, dy: 15.5pt, corner-text(id, width: 1in))
      place(top + right, dx: 5pt, dy: 15.5pt, corner-text(id, width: 1in))
    },
    header-ascent: 27.9pt,
    header: {
      set align(center)
      set text(
        font: font-family-sans,
        size: font-size.footnote,
        fill: ruler-color)
      strong[#conf-name #conf-year Submission \##id. #notice]
    },
    footer-descent: 23.4pt, // Visually perfect.
    footer: locate(loc => {
      let ix = counter(page).at(loc).first()
      return align(center, text(size: font-size.normal, [#ix]))
    }),
  )

  set text(font: font-family, size: font-size.normal)
  set par(justify: true, first-line-indent: 0.166666in, leading: 0.532em)
  show par: set block(spacing: 0.54em)
  show raw: set text(font: font-family-mono, size: font-size.normal)

  // Configure heading appearence and numbering.
  set heading(numbering: "1.1.")
  show heading.where(level: 1): h1
  show heading.where(level: 2): h2
  show heading.where(level: 3): h3

  set math.equation(numbering: "(1)", supplement: [Eq.])
  show math.equation: set block(spacing: 9pt)

  set quote(quotes: false)
  show quote.where(block: true): it => {
    set block(spacing: 14pt)
    set pad(left: 20pt, right: 20pt)
    set par(first-line-indent: 0em)
    show par: set block(spacing: 9.8pt)
    it
  }

  // Configure footnote (almost default).
  show footnote.entry: set text(size: font-size.footnote)
  set footnote.entry(
    separator: line(length: 1.3in, stroke: 0.35pt),
    clearance: 6.65pt,
    gap: 0.40em,
    indent: 12pt)

  // Figures
  set figure(gap: 12pt)
  set figure.caption(separator: [.])
  show figure.caption: set text(size: font-size.small)
  show figure.caption: set align(center)
  show figure.caption: it => block({
    align(left, it)
  })

  // Links and references.
  show link: set text(font: font-family-link, fill: color.link)
  show ref: it => {
    let el = it.element
    if el == none {
      return it
    }

    // Supplement exist for every element and we have already checked element
    // existance.
    let supplement = if it.supplement != auto {
      it.supplement
    } else {
      el.supplement
    }

    if el.func() == math.equation {
      show link: set text(font: font-family, fill: color.ref)
      let cnt = counter(math.equation)
      let ix = numbering("1", ..cnt.at(el.location()))
      let href = link(el.location(), ix)
      [#supplement~(#href)]
    } else if el.func() == heading {
      show link: set text(font: font-family, fill: color.ref)
      let cnt = counter(math.equation)
      let ix = numbering("1.1", ..cnt.at(el.location()))  // TODO: Appendices?
      let href = link(el.location(), ix)
      [#supplement~#href]
    } else if el.func() == figure {
      let fig = el
      if fig.kind == image {
        show link: set text(font: font-family, fill: color.ref)
        let cnt = counter(figure.where(kind: image))
        let ix = numbering(el.numbering, ..cnt.at(el.location()))
        let href = link(el.location(), ix)
        [#supplement~#href]
      } else if fig.kind == table {
        show link: set text(font: font-family, fill: color.ref)
        let cnt = counter(figure.where(kind: table))
        let ix = numbering(el.numbering, ..cnt.at(el.location()))
        let href = link(el.location(), ix)
        [#supplement~#href]
      } else {
        it
      }
    } else {
      it
    }
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
    v(17.6pt, weak: true)
    emph[#abstract\ \ ]
    body

    if bibliography != none {
      set std-bibliography(title: [References], style: "ieee")
      show std-bibliography: set text(size: font-size.small)
      bibliography
    }
  })

  if appendix != none {
    set heading(numbering: "A.1")
    counter(heading).update(0)
    appendix
  }
}
