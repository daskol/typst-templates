/**
 * lib.typ — blind-cvpr template.
 *
 * Originally based on work by [@dasayan05][1] (see [issue][3]), adopted
 * from [dasayan05/typst-ai-conf-templates][2].
 *
 * [1]: https://github.com/dasayan05
 * [2]: https://github.com/dasayan05/typst-ai-conf-templates.
 * [3]: https://github.com/daskol/typst-templates/issues/8
 */

#let std-bibliography = bibliography  // Due to argument shadowing.

#let notice = [CONFIDENTIAL REVIEW COPY. DO NOT DISTRIBUTE.]

#let _FNSYMBOLS = ("*", "†", "‡", "§", "¶", "‖", "**", "††", "‡‡", "§§", "¶¶", "‖‖")
#let _thanks-numbering(n) = if n <= _FNSYMBOLS.len() {
  _FNSYMBOLS.at(n - 1)
} else { str(n) }
#let thanks(body) = footnote(numbering: _thanks-numbering, body)

#let _to-string(c) = {
  if type(c) == str { c }
  else if type(c) == content {
    if c.func() == footnote { "" }
    else if c.has("text") { c.text }
    else if c.has("children") { c.children.map(_to-string).join() }
    else if c.has("body") { _to-string(c.body) }
    else { "" }
  }
  else { "" }
}

#let eg    = emph[e.g] + "."
#let Eg    = emph[E.g] + "."
#let ie    = emph[i.e] + "."
#let Ie    = emph[I.e] + "."
#let cf    = emph[cf] + "."
#let Cf    = emph[Cf] + "."
#let etc   = emph[etc] + "."
#let vs    = emph[vs] + "."
#let etal  = emph[et~al] + "."
#let wrt   = "w.r.t."
#let dof   = "d.o.f."
#let iid   = "i.i.d."
#let wolog = "w.l.o.g."

// Booktabs-style table rules: cvpr.sty:36 requires booktabs.
// Each helper expands to hline + zero-content padding cells that
// reproduce \abovetopsep / \belowrulesep / \aboverulesep gaps.
//
// Usage:
//   #table(
//     columns: N,
//     stroke: none,
//     ..toprule(N),
//     ...header...,
//     ..midrule(N),
//     ...rows...,
//     ..bottomrule(N),
//   )

#let toprule(n) = (
  table.hline(stroke: 1.5pt),
  table.cell(colspan: n, inset: (top: 2pt, bottom: 0pt), []),
)

#let midrule(n) = (
  table.cell(colspan: n, inset: (top: 0pt, bottom: 1.5pt), []),
  table.hline(stroke: 0.5pt),
  table.cell(colspan: n, inset: (top: 1pt, bottom: 0pt), []),
)

#let bottomrule(n) = (
  table.cell(colspan: n, inset: (top: 1.5pt, bottom: 0pt), []),
  table.hline(stroke: 1.5pt),
)

#let font-family = ("Times New Roman", "CMU Serif", "Latin Modern Roman",
                    "New Computer Modern", "Libertinus Serif")

#let font-family-sans = ("Arial", "TeX Gyre Heros", "New Computer Modern Sans",
                         "CMU Sans Serif", "DejaVu Sans")

#let font-family-mono = ("CMU Typewriter Text", "Latin Modern Mono",
                         "New Computer Modern Mono", "DejaVu Sans Mono")

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
) = context {
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
}

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
 * h_, h1, h2, h3 - Style rules for headings.
 */

#let h_(body) = {
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

#let format-affilation(affl) = {
  // Department and institution on a seperate lines.
  let lines = ()
  if "department" in affl {
    lines.push(affl.department)
  }
  if "institution" in affl {
    lines.push(affl.institution)
  }

  // Address components on a single one.
  let address = ()
  if "location" in affl {
    address.push(affl.location)
  }
  if "country" in affl {
    address.push(affl.country)
  }
  if address.len() > 0 {
    lines.push(address.join([, ]))
  }

  lines.join([\ ])
}

#let format-author(author, affls) = box(baseline: 100%, {
  author.name
  if "affl" in author {
    [\ ]
    author.affl
      .map(it => format-affilation(affls.at(it)))
      .join([\ ])
  }
  if "email" in author {
    show raw: set text(
      font: font-family-link,
      size: font-size.small,
      fill: black)
    v(9pt, weak: true)
    link(author.email, raw(author.email))
  }
})

#let make-title(title, authors, affls, id, mode) = {
  let title-size = if mode == "rebuttal" { font-size.large } else { font-size.Large }
  let top-skip = if mode == "rebuttal" { -0.3in } else { 0.5in - 0.6pt }
  let post-title-skip = if mode == "rebuttal" { -22pt } else { 30pt }

  // 1. Title.
  block(width: 100%, spacing: 0pt, {
    set align(center)
    set text(size: title-size, weight: "bold")
    v(top-skip)
    title
  })
  v(post-title-skip, weak: true)

  // 2. Authors and affilations.
  if mode != "rebuttal" {
    block(width: 100%, spacing: 0pt, {
      set align(center + top)
      set text(size: font-size.large)
      if mode == "review" {
        [Anonymous CVPR submission\ ]
        [\ ]
        [Paper ID #id]
      } else {
        pad(left: 10pt, right: 12pt, {
          authors.map(it => format-author(it, affls)).join(h(0.5in))
        })
      }
    })
    v(34.5pt, weak: true)
  }
}

/**
 * cvpr - Template for Computer Vision and Pattern Recognition Conference
 * (CVPR) papers.
 *
 * Args:
 *   title: Paper title.
 *   authors: Tuple of author objects and affilation dictionary.
 *   keywords: Publication keywords (used in PDF metadata).
 *   date: Creation date (used in PDF metadata).
 *   abstract: Paper abstract.
 *   bibliography: Bibliography content. If it is not specified then there is
 *   not reference section.
 *   supplementary: Content rendered after the bibliography as a
 *     supplementary material section (per cvpr.sty's \maketitlesupplementary:
 *     pagebreak + cross-column "Supplementary Material" title + heading
 *     numbering shift to A.1.).
 *   mode: One of `"review"`, `"final"`, or `"rebuttal"`. Maps to
 *     cvpr.sty's `[review]`, `[final]` (default), and `[rebuttal]`
 *     options respectively. Default `"final"` matches cvpr.sty:55-58
 *     where `\toggletrue{cvprfinal}` is set unconditionally.
 *   id: Submission identifier.
 *   conf-year: Conference year shown in the review banner. Default `2025`.
 *   page-numbers: `auto`, `true`, or `false`. `auto` follows cvpr.sty
 *     default — page numbers in review mode only. Pass `true` for
 *     camera-ready + page numbers (cvpr.sty `[pagenumbers]`).
 */
#let cvpr(
  title: [],
  authors: (),
  keywords: (),
  date: auto,
  abstract: [],
  bibliography: none,
  supplementary: none,
  mode: sys.inputs.at("mode", default: "final"),
  id: none,
  conf-year: [2025],
  page-numbers: {
    let v = sys.inputs.at("pagenumbers", default: "auto")
    if v == "true" { true } else if v == "false" { false } else { auto }
  },
  body,
) = {
  let show-page-numbers = if page-numbers == auto {
    mode == "review"
  } else { page-numbers }
  // Deconstruct authors for convenience.
  let (authors, affls) = if authors.len() == 2 {
    authors
  } else {
    ((), ())
  }
  if mode == "review" {
    authors = ((name: "Anonymous Author"), )
  }

  // If there is not submission id then use a placeholder.
  if id == none {
    id = "*****"
  }

  set document(
    title: title,
    author: authors.map(it => _to-string(it.name)).join(", ", last: " and "),
    keywords: keywords,
    date: date)

  set page(
    paper: "us-letter",
    margin: (left: 0.696in, right: 0.929in, top: 1in, bottom: 1.125in),
    background: if mode == "review" {
      // Rullers on sides.
      ruler
      // Decorate top corners.
      place(top + left, dx: -14.6pt, dy: 15.5pt, corner-text(id, width: 1in))
      place(top + right, dx: 5pt, dy: 15.5pt, corner-text(id, width: 1in))
    },
    header-ascent: 27.9pt,
    header: if mode == "review" {
      set align(center)
      set text(
        font: font-family-sans,
        size: font-size.footnote,
        fill: ruler-color)
      strong[CVPR #conf-year Submission \##id. #notice]
    },
    footer-descent: 23.4pt, // Visually perfect.
    footer: if show-page-numbers {
      let ix = context counter(page).get().first()
      align(center, text(size: font-size.normal, [#ix]))
    },
  )

  set text(font: font-family, size: font-size.normal)
  set par(
    first-line-indent: (amount: 0.166666in, all: true),
    leading: 0.532em, spacing: 0.54em, justify: true)
  show raw: set text(font: font-family-mono, size: font-size.normal)

  show regex("\.\.[^.]"): m => "." + m.text.slice(2)


  let _suppress-indent = state("blind-cvpr-suppress-indent", false)
  show heading: it => { it; _suppress-indent.update(true) }
  show par: it => context {
    if _suppress-indent.get() {
      _suppress-indent.update(false)
      block({ set par(first-line-indent: 0pt); it.body })
    } else { it }
  }

  // Configure heading appearence and numbering.
  set heading(numbering: "1.1.")
  show heading.where(level: 1): h1
  show heading.where(level: 2): h2
  show heading.where(level: 3): h3
  show heading.where(level: 4): it => {
    v(7.1pt, weak: false)
    box(text(size: font-size.normal, weight: "bold", it.body))
    h(0.6em)
  }

  set math.equation(numbering: "(1)", supplement: [Eq.])
  show math.equation: set block(spacing: 9pt)
  show math.equation.where(block: true): it => {
    if it.numbering == none { it }
    else if it.has("label") { it }
    else {
      counter(math.equation).update(n => if n > 0 { n - 1 } else { 0 })
      math.equation(block: true, numbering: none, it.body)
    }
  }

  set quote(quotes: false)
  show quote.where(block: true): it => {
    set block(spacing: 14pt)
    set pad(left: 20pt, right: 20pt)
    set par(spacing: 9.8pt)
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
  show figure.caption: it => layout(container => context {
    let single-line = measure(it).width <= container.width
    block(width: 100%, {
      set align(if single-line { center } else { left })
      it
    })
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
  make-title(title, authors, affls, id, mode)
  counter(footnote).update(0)

  // NOTE It seems that there is a typo in formatting instructions and actual
  // gutter is 3/8 in not 5/16 in.
  //
  // TODO(@daskol): Set number of columns in page settings. Otherwise,
  // footnotes use all page width.
  columns(2, gutter: 0.3125in, {
    // Render abstract.
    block(width: 100%, {
      set par(first-line-indent: 0pt)
      align(center, text(size: font-size.large)[*Abstract*])
      v(17.6pt, weak: true)
      emph[#abstract\ \ ]
    })

    body  // Render paper body.

    if bibliography != none {
      set std-bibliography(title: [References], style: "ieee.csl")
      show std-bibliography: set text(size: font-size.small)
      bibliography
    }
  })

  if supplementary != none {
    pagebreak(weak: true)
    place(top, scope: "parent", float: true, {
      v(0.375in)
      align(center, text(size: font-size.Large, weight: "bold", title))
      v(0.5em)
      align(center, text(size: font-size.Large, weight: "bold", [Supplementary Material]))
      v(1em)
    })
    columns(2, gutter: 0.3125in, {
      set heading(numbering: "A.1")
      counter(heading).update(0)
      supplementary
    })
  }
}
