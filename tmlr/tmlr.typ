#let std-bibliography = bibliography

// We prefer to use CMU Bright variant instead of Computer Modern Bright when
// ever it is possible.
#let font-family = ("CMU Serif", "Latin Modern Roman", "New Computer Modern")
#let font-family-heading = ("CMU Sans Serif", "Latin Modern Sans")

#let font = (
  Large: 17pt,
  footnote: 10pt,
  large: 12pt,
  small: 9pt,
  normal: 10pt,
  script: 8pt,
)

#let tmlr(
  title: [],
  authors: (),
  keywords: (),
  date: auto,
  abstract: none,
  bibliography: none,
  header: none,
  accepted: false,
  appendix: none,
  body,
) = {
  set document(
    title: title,
    author: authors.at(0).map(it => it.name),
    keywords: keywords,
    date: date)

  header = "Under review as submission to TMLR"
  set page(
    paper: "us-letter",
    margin: (left: 1in,
             right: 8.5in - (1in + 6.5in),
             // top: 1in - 0.25in,
             // bottom: 11in - (1in + 9in + 0.25in)),
             top: 1.18in,
             bottom: 11in - (1.18in + 9in)),
    header-ascent: 46pt,  // 1.5em in case of 10pt font
    header: locate(loc => {
      // TODO
      set block(spacing: 0em)
      block(spacing: 0em, fill: luma(230), {
        header
        v(3.5pt, weak: true)
        line(length: 100%, stroke: (thickness: 0.4pt))
      })
    }),
    footer-descent: 20pt, // TODO(@daskol): Why such multiplier?
    footer: locate(loc => {
      let ix = counter(page).at(loc).first()
      return align(center, text(size: font.normal, [#ix]))
    }))

  // The original style requirements is to use Computer Modern Bright but we
  // just use OpenType CMU Bright font.
  set text(font: font-family, size: font.normal)
  set par(justify: true, leading: 0.52em)  // TODO: Why? Visually perfect.
  show par: set block(spacing: 1.1em)

  // Configure heading appearence and numbering.
  set heading(numbering: "1.1")
  show heading: set text(font: font-family-heading)
  show heading: it => {
    // Create the heading numbering.
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
    }

    // Render section with such names without numbering as level 3 heading.
    let unnumbered = (
      [Broader Impact Statement],
      [Author Contributions],
      [Acknowledgments],
    )
    let level = it.level
    let prefix = [#number ]
    if unnumbered.any(name => name == it.body) {
      level = 3
      prefix = []
    }

    // TODO(@daskol): Use styles + measure to estimate ex.
    set align(left)
    if level == 1 {
      text(size: font.large, weight: "bold", {
        let ex = 10pt
        v(2.05 * ex, weak: true)  // Visually perfect.
        [#prefix*#it.body*]
        v(1.80 * ex, weak: true) // Visually perfect.
      })
    } else if level == 2 {
      text(size: font.normal, weight: "bold", {
        let ex = 6.78pt
        v(2.8 * ex, weak: true)  // Visually perfect.
        [#prefix*#it.body*]
        v(2.15 * ex, weak: true)  // Visually perfect. Original 1ex.
      })
    } else if level == 3 {
      text(size: font.normal, weight: "bold", {
        let ex = 6.78pt
        v(2.7 * ex, weak: true)  // Visually perfect.
        [#prefix*#it.body*]
        v(2.0 * ex, weak: true)  // Visually perfect. Original -0.7em.
      })
    }
  }

  // Configure code blocks (listings).
  show raw: set block(spacing: 1.95em)

  // Configure footnote (almost default).
  show footnote.entry: set text(size: 8pt)
  set footnote.entry(
    separator: line(length: 2in, stroke: 0.35pt),
    clearance: 6.65pt,
    gap: 0.40em,
    indent: 12pt)  // Original 12pt.

  // Configure figures.
  show figure.where(kind: image): set figure.caption(position: bottom)
  set figure(gap: 16pt)

  // Configure tables.
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set figure(gap: 6pt)
  set table(inset: 4pt)

  // Render title.
  v(-0.03in)  // Visually perfect.
  block(fill: luma(230), {
    set block(spacing: 0em)
    set par(leading: 10pt)  // Empirically found.
    text(font: font-family-heading, size: font.Large, weight: "bold", title)
  })
  v(0.3in + 0.2in - 3.5pt, weak: true)  // \aftertiskip
  // Render authors.
  block(fill: luma(230), {
    [*Anonymous authors*\ ]
    [*Paper under double-blind review*]
  })
  v(0.45in, weak: true)  // Visually perfect.

  // Render abstract.
  block(width: 100%, fill: luma(230), {
    set text(size: font.normal)
    set par(leading: 0.45em)  // Original 0.55em (or 0.45em?).

    // NeurIPS instruction tels that font size of `Abstract` must equal to 12pt
    // but there is not predefined font size.
    align(center,
      text(
        font: "CMU Sans Serif",
        size: font.large,
        weight: "bold",
        [*Abstract*]))
    v(22pt, weak: true)
    pad(left: 0.5in, right: 0.5in, abstract)
  })
  v(0.4in + 1pt, weak: true)  // Visually perfect.

  body

  if bibliography != none {
    set std-bibliography(title: [References])
    bibliography
  }

  if appendix != none {
    set heading(numbering: "A.1")
    counter(heading).update(0)
    appendix
  }
}
