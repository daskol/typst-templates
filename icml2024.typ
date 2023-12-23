// Metrical size of page body.
#let body = (
  width: 6.75in,
  height: 9.0in,
)

// Default font sizes from original LaTeX style file.
#let font-defaults = (
  tiny:	        6pt,
  scriptsize:   7pt,
  footnotesize: 9pt,
  small:        9pt,
  normalsize:   10pt,
  large:        12pt,
  Large:        14pt,
  LARGE:        17pt,
  huge:         20pt,
  Huge:         25pt,
)

// We prefer to use Times New Roman when ever it is possible.
#let font-family = ("Times New Roman", "Nimbus Roman", "TeX Gyre Termes")

#let font = (
  Large: font-defaults.Large + 0.4pt,  // Actual font size.
  footnote: font-defaults.footnotesize,
  large: font-defaults.large,
  small: font-defaults.small,
  normal: font-defaults.normalsize,
  script: font-defaults.scriptsize,
)

#let footnote_prologue = [
  _Proceedings of the 41#super[st] International Conference on Machine
  Learning_, Vienna, Austria. PMLR 235, 2024. Copyright 2024 by the author(s).
]

#let footnote_epilogue = [
  Preliminary work. Under review by the International Conference on Machine
  Learning (ICML). Do not distribute.
]

#let footnote_body = [
  Anonymous Institution, Anonymous City, Anonymous Region, Anonymous Country.
  Correspondence to: Anonymous Authors \<anon.email\@domain.com\>. \

  // #footnote_prologue
  #footnote_epilogue
]

#let format_author_names(authors) = {
  // Formats the author's names in a list with commas and a
  // final "and".
  let author_names = authors.map(author => author.name)
  let author-string = if authors.len() == 2 {
    author_names.join(" and ")
  } else {
    author_names.join(", ", last: ", and ")
  }
  return author_names
}

#let statement(kind: "statement", supplement: none, content) = {
  if supplement == none {
    supplement = upper(kind.first()) + lower(kind.slice(1))
  }
  figure(
    kind: kind,
    supplement: [#supplement],
    numbering: "1",
    content,
  )
}

#let statement_render(supplement_fn: strong, body_fn: emph, it) = {
  block(above: 11.5pt, below: 11.5pt, {
    supplement_fn({
      it.supplement
      if it.numbering != none {
        [ ]

        // Render prefix (heading) part of a counter.
        let prefix = locate(loc => {
          let index = counter(heading).at(loc)
          let prefix = index.slice(0, -1)  // Ignore the last level.
          let header = query(selector(heading).before(loc), loc,).at(-1)
          return numbering(header.numbering, ..prefix)
        })
        [#prefix]

        // Render last digit of a counter.
        let ix = locate(loc => {
          let ix_assump = counter(figure.where(kind: "assumption")).at(loc)
          let ix_state= counter(figure.where(kind: "statement")).at(loc)
          let ix_notice= counter(figure.where(kind: "notice")).at(loc)
          let index = ix_assump.first() + ix_state.first() + ix_notice.first()
          return numbering(it.numbering, index)
        })
        [#ix]
      }
      [.]
    })
    body_fn(it.body)
  })
}

#let notice_render(it) = statement_render(
  supplement_fn: emph,
  body_fn: body => body,
  it)

#let assumption(content) = {
  statement(kind: "assumption", supplement: [Assumption], content)
}

#let corollary(content) = { statement(supplement: [Colorary], content) }
#let definition(content) = { statement(supplement: [Definition], content) }
#let lemma(content) = { statement(supplement: [Lemma], content) }
#let proposition(content) = { statement(supplement: [Proposition], content) }
#let theorem(content) = { statement(supplement: [Theorem], content) }

#let note(content) = { statement(kind: "notice", supplement: [Note], content) }
#let remark(content) = {
  statement(kind: "notice", supplement: [Remark], content)
}

// And a definition for a proof.
#let proof(body) = block(spacing: 11.5pt, {
  emph[Proof.]
  [ ] + body
  h(1fr)
  box(scale(160%, origin: bottom + right, sym.square.stroked))
})

#let make_figure_caption(it) = {
  set align(center)
  block(width: 100%, {
    set align(left)
    set text(size: font.small)
    emph({
      it.supplement
      if it.numbering != none {
        [ ]
        it.counter.display(it.numbering)
      }
      it.separator
    })
    [ ]
    it.body
  })
}

#let make_figure(caption_above: false, it) = {
  // set align(center + top)
  place(center + top, float: true,
  block(breakable: false, width: 100%, {
    if caption_above {
      it.caption
    }
    v(0.1in, weak: true)
    it.body
    v(0.1in, weak: true)
    if not caption_above {
      it.caption
    }
  }))
}

/**
 * icml2024
 */
#let icml2024(
  title: [],
  authors: (),
  abstract: none,
  bibliography-file: none,
  header: none,
  accepted: false,
  body,
) = {
  if header == none {
    header = title
  }

  let author_names = format_author_names(authors)
  set document(title: title, author: author_names)

  set page(
    paper: "us-letter",
    margin: (left: 0.75in, right: 8.5in - (0.75in + 6.75in + 0.03in), top: 1.0in),
    header: locate(loc => {
      let pageno = counter(page).at(loc).first()
      if pageno == 1 { return }
      set text(size: font.script)
      align(center)[title]
    }),
    footer-descent: 25pt - font.normal,
    footer: locate(loc => {
      let i = counter(page).at(loc).first()
      align(center, text(size: font.normal, [#i]))
    })
  )

  // Main body font is Times (Type-1) font.
  set columns(2, gutter: 0.25in)
  set par(justify: true, leading: 0.58em)
  set text(font: font-family, size: font.normal)

  set heading(numbering: "1.")
  show heading: it => {
    // Create the heading numbering.
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      // h(7pt, weak: true
    }

    // Reset "theorem"counters.
    if it.level == 1 {
      counter(figure.where(kind: "assumption")).update(0)
      counter(figure.where(kind: "statement")).update(0)
      counter(figure.where(kind: "notice")).update(0)
    }

    set align(left)
    if it.level == 1 {
      text(size: font.large, weight: "bold")[
        #v(0.25in, weak: true)
        #number
        *#it.body*
        #v(0.15in, weak: true)
      ]
    } else if it.level == 2 {
      text(size: font.normal, weight: "bold")[
        #v(0.2in, weak: true)
        #number
        *#it.body*
        #v(0.13in, weak: true)
      ]
    } else if it.level == 3 {
      text(size: font.normal, weight: "regular")[
        #v(0.18in, weak: true)
        #number
        #smallcaps(it.body)
        #v(0.1in, weak: true)
      ]
    }
  }

  set figure.caption(separator: [.])
  show figure: set block(breakable: false)
  show figure.caption.where(kind: table): it => make_figure_caption(it)
  show figure.caption.where(kind: image): it => make_figure_caption(it)
  show figure.where(kind: image): it => make_figure(it)
  show figure.where(kind: table): it => make_figure(it, caption_above: true)

  show figure.where(kind: "assumption"): it => {
    statement_render(body_fn: body => body, it)
  }
  show figure.where(kind: "statement"): it => statement_render(it)
  show figure.where(kind: "notice"): it => notice_render(it)

  // Render title.
  text(size: font.Large, weight: "bold")[
    #v(0.5pt)
    #line(length: 100%)
    #v(1pt)
    #show par: set block(spacing: 18pt)
    #align(center)[#title]
    #v(1pt)
    #line(length: 100%)
  ]

  v(0.1in - 1pt)

  // Render authors.
  {
    set align(center)
    set text(weight: "bold")
    [Anonymous Authors]

    set super(typographic: false, size: font.script)
    set text(weight: "regular")
    [#footnote(footnote_body)]
  }

  v(0.2in)

  columns(2, gutter: 0.25in)[
    #set text(size: font.normal)
    #show par: set block(spacing: 11pt)
    // Render abstract.
    // ICML instruction tels that font size of `Abstract` must equal to 11 but
    // it does not like so.
    #text(size: font.large)[
      #align(center)[*Abstract*]
    ]
    #pad(left: 2em, right: 2em, abstract)
    #v(0.12in)

    // Display body.
    #set text(size: font.normal)
    #body

    // Display the bibliography, if any is given.
    #if bibliography-file != none {
      show bibliography: set text(size: font.normal)
      bibliography(style: "apa", title: "References", bibliography-file)
    }
  ]

  pagebreak()
  counter(heading).update(0)
  counter("appendices").update(1)
  set heading(
    numbering: (..nums) => {
      let vals = nums.pos()
      let value = "ABCDEFGHIJ".at(vals.at(0) - 1)
      return value + "." + nums.pos().slice(1).map(str).join(".")
    }
  )
  include "appendix.typ"
}

// NOTE We provide table support based on tablex package. It does not
// correspond closely to LaTeX's booktabs but it is the best of what we have at
// the moment.

#import "@preview/tablex:0.0.7": cellx, hlinex, tablex

// Tickness values are taken from booktabs.
#let toprule = hlinex(stroke: (thickness: 0.08em))
#let bottomrule = toprule
#let midrule = hlinex(stroke: (thickness: 0.05em))

#let map-col(mapper, ix, jx, content, ..args) = {
  return mapper(ix, jx, content, ..args)
}

#let map-row(mapper, ix, row, ..args) = {
  return row.enumerate().map(el => map-col(mapper, ix, ..el, ..args))
}

#let map-cells(cells, mapper, ..args) = {
  return cells.enumerate().map(el => map-row(mapper, ..el, ..args)).flatten()
}
