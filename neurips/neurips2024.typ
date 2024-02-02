// Metrical size of page body.
#let viewport = (
  width: 5.5in,
  height: 9in,
)

// Default font sizes from original LaTeX style file.
#let font-defaults = (
  tiny:	        7pt,
  scriptsize:   7pt,
  footnotesize: 9pt,
  small:        9pt,
  normalsize:   10pt,
  large:        14pt,
  Large:        16pt,
  LARGE:        20pt,
  huge:         23pt,
  Huge:         28pt,
)

// We prefer to use Times New Roman when ever it is possible.
#let font-family = ("Times New Roman", "Nimbus Roman", "TeX Gyre Termes")

#let font = (
  Large: font-defaults.Large,
  footnote: font-defaults.footnotesize,
  large: font-defaults.large,
  small: font-defaults.small,
  normal: font-defaults.normalsize,
  script: font-defaults.scriptsize,
)

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
          let ix_state = counter(figure.where(kind: "statement")).at(loc)
          let ix_notice = counter(figure.where(kind: "notice")).at(loc)
          let index = ix_assump.first() + ix_state.first() + ix_notice.first()
          return numbering(it.numbering, index)
        })
        [#ix]
      }
      [. ]
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

#let definition(content) = {
  statement(kind: "assumption", supplement: [Definition], content)
}

#let corollary(content) = { statement(supplement: [Colorary], content) }
#let lemma(content) = { statement(supplement: [Lemma], content) }
#let proposition(content) = { statement(supplement: [Proposition], content) }
#let theorem(content) = { statement(supplement: [Theorem], content) }

#let note(content) = { statement(kind: "notice", supplement: [Note], content) }
#let remark(content) = {
  statement(kind: "notice", supplement: [Remark], content)
}

// Render reference to theorem-like figures (definitions, lemmas, theorems, and
// so on).
#let render-ref-statement(it) = {
  // Ignore all elements that are not figures and not theorem-like figures.
  let el = it.element
  if el == none or el.func() != figure {
    return it
  } else if el.kind not in ("assumption", "notice", "statement") {
    return it
  }

  // Reference number for theorem-like figures has form
  // "<section>.<number>". So, we get the section number if there is any.
  let loc = el.location()
  let ix_heading = counter(heading).at(loc)
  let prefix = ix_heading.at(0, default: 0)

  // And now we compute a number of a theorem-like figure in the section.
  let ix_assump = counter(figure.where(kind: "assumption")).at(loc)
  let ix_state = counter(figure.where(kind: "statement")).at(loc)
  let ix_notice = counter(figure.where(kind: "notice")).at(loc)
  let suffix = ix_assump.first() + ix_state.first() + ix_notice.first()

  // Finally, render it as a content.
  el.supplement
  [~]
  numbering("1.1", prefix, suffix)
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

#let anonymous-author = (
  name: "Anonymous Author(s)",
  email: "anon.email@example.org",
  affl: ("anonymous-affl", ),
)

#let anonymous-affl = (
  department: none,
  institution: "Affilation",
  location: "Address",
)

#let anonymous-notice = [
  Submitted to 38th Conference on Neural Information Processing Systems
  (NeurIPS 2024). Do not distribute.
]

#let arxiv-notice = []

#let public-notice = [
  _Proceedings of the 41#super[st] International Conference on Machine
  Learning_, Vienna, Austria. PMLR 235, 2024. Copyright 2024 by the author(s).
]

#let make-author(author, affl2idx) = {
  // Sanitize author affilations.
  let affl = author.at("affl")
  if type(affl) == str {
    affl = (affl,)
  }

  // Make a list of superscript indices.
  let indices = affl.map(it => str(affl2idx.at(it)))
  let has-equal-contrib = author.at("equal", default: false)
  if has-equal-contrib {
    indices.insert(0, "*")
  }

  // Render author and affilation references to content.
  set text(size: font.normal, weight: "regular")
  return [
    #strong(author.name) \
    Affilation \
    Address \
    `email`
  ]
}

#let make-affilations-and-notice(authors, affls) = {
  let info = ()

  // Add equal contribution notice.
  let has-equal-contrib = authors.fold(false, (acc, it) => {
    let equal-contrib = it.at("equal", default: false)
    return acc or equal-contrib
  })
  if has-equal-contrib {
    info.push(super[\*] + [Equal contribution])
  }

  // Prepare list of affilations.
  let ordered-affls = authors.map(it => it.affl).flatten().dedup()
  let affilations = ordered-affls.enumerate(start: 1).map(pair => {
    let (ix, it) = pair
    let affl = affls.at(it, default: none)
    assert(affl != none, message: "unknown affilation: " + it)

    // Convert structured affilation representation to plain one (array).
    if type(affl) == dictionary {
      let keys = ("department", "institution", "location", "country")
      let parts = ()
      for key in keys {
        let val = affl.at(key, default: none)
        if val != none {
          parts.push(val)
        }
      }
      affl = parts
    }

    // Validate affilation representation.
    assert(type(affl) == array,
           message: "wrong affilation type: " + type(affl))
    assert(affl.len() > 0,
           message: "empty affilation: " + it + " :" + repr(affl))

    // Finally, join parts of affilation.
    return super(str(ix)) + affl.join(", ")
  })
  if affilations != () {
    info.push(affilations.join([ ]) + [.])
  }

  // Prepare list of corresponding authors (author which has its email).
  let correspondents = authors.fold((), (acc, it) => {
    let email = it.at("email", default: none)
    if email != none {
      let mailto = link("mailto:" + it.email, it.email)
      acc.push([#it.name \<#mailto\>])
    }
    return acc
  })
  if correspondents != () {
    info.push([Correspondence to: ] + correspondents.join(", ") + [.])
  }

  return info
}

/**
 * neurips2024
 *
 * Args:
 *   accepted: Valid values are `none`, `false`, and `true`. Missing value
 *   (`none`) is designed to prepare arxiv publication. Default is `false`.
 */
#let neurips2024(
  title: [],
  authors: (),
  keywords: (),
  date: auto,
  abstract: none,
  bibliography-file: none,
  bibliography-opts: (),
  header: none,
  accepted: false,
  body,
) = {
  if header == none {
    header = title
  }

  // Sanitize authors and affilations arguments.
  if accepted != none and not accepted {
    authors = ((anonymous-author,), (anonymous-affl: anonymous-affl))
  }
  let (authors, affls) = authors

  // Configure document metadata.
  set document(
    title: title,
    author: authors.map(it => it.name),
    keywords: keywords,
    date: date,
  )

  // Prepare authors and footnote anchors.
  let ordered-affls = authors.map(it => it.affl).flatten().dedup()
  let affl2idx = ordered-affls.enumerate(start: 1).fold((:), (acc, it) => {
    let (ix, affl) = it
    acc.insert(affl, ix)
    return acc
  })
  let make-authors() = authors.map(it => make-author(it, affl2idx))

  set page(
    paper: "us-letter",
    margin: (left: 1.5in, right: 1.5in,
             top: 1.0in, bottom: 1in),
    footer-descent: 25pt - font.normal,
    footer: locate(loc => {
      let i = counter(page).at(loc).first()
      if i == 1 {
        return align(center, text(size: 9pt, anonymous-notice))
      } else {
        return align(center, text(size: font.normal, [#i]))
      }
    }),
  )

  // In the original style, main body font is Times (Type-1) font but we use
  // OpenType analogue.
  set par(justify: true, leading: 0.55em)
  set text(font: font-family, size: font.normal)

  set heading(numbering: "1.1")
  show heading: it => {
    // Create the heading numbering.
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
    }

    // Reset "theorem"counters.
    if it.level == 1 {
      counter(figure.where(kind: "assumption")).update(0)
      counter(figure.where(kind: "statement")).update(0)
      counter(figure.where(kind: "notice")).update(0)
    }

    set align(left)
    if it.level == 1 {
      // TODO: font.large?
      text(size: 12pt, weight: "bold")[
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
      text(size: font.normal, weight: "bold")[
        #v(0.18in, weak: true)
        #number
        #it.body
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

  // Math equation numbering and referencing.
  set math.equation(numbering: "(1)")
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
    } else if el != none and el.func() == heading {
      let numb = numbering(
        el.numbering,
        ..counter(el.func()).at(el.location()))
      if numb.at(-1) == "." {
        numb = numb.slice(0, -1)
      }
      let color = rgb(0%, 8%, 45%)  // Originally `mydarkblue`. :D
      let content = text(fill: color, numb)
      // If numbering starts with letter then the heading is an appendix.
      let supplement = el.supplement
      if numb.at(0) not in ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9") {
        supplement = [Appendix]
      }
      link(el.location())[#supplement~#content]
    } else if el != none and el.func() == figure {
      let numb = numbering(
        el.numbering,
        ..counter(figure.where(kind: el.kind)).at(el.location()))
      if numb.at(-1) == "." {
        numb = numb.slice(0, -1)
      }
      let color = rgb(0%, 8%, 45%)  // Originally `mydarkblue`. :D
      let content = text(fill: color, numb)
      link(el.location())[#el.supplement~#content]
    } else {
      render-ref-statement(it)
    }
  }

  // Configure algorithm rendering.
  counter(figure.where(kind: "algorithm")).update(0)
  show figure.caption.where(kind: "algorithm"): it => {
    strong[#it.supplement #it.counter.display(it.numbering)]
    [ ]
    it.body
  }
  show figure.where(kind: "algorithm"): it => {
    place(top, float: true,
      block(breakable: false, width: 100%, {
        set block(spacing: 0em)
        line(length: 100%, stroke: (thickness: 0.08em))
        block(spacing: 0.4em, it.caption)  // NOTE: No idea why we need it.
        line(length: 100%, stroke: (thickness: 0.05em))
        it.body
        line(length: 100%, stroke: (thickness: 0.08em))
      })
    )
  }

  // Render title.
  block(width: 5.5in, {
    // We need to define line widths to reuse them in spacing.
    let top-rule-width = 4pt
    let bot-rule-width = 1pt

    // Add some space based on line width.
    v(0.1in + top-rule-width / 2)
    line(length: 100%, stroke: top-rule-width + black)
    align(center, text(size: 17pt, weight: "bold", [#title]))
    v(-bot-rule-width)
    line(length: 100%, stroke: bot-rule-width + black)
  })

  v(0.1in - 1pt)

  {
    // Render authors.
    set align(center)
    make-authors().map(it => {
      box(inset: (left: 0.5em, right: 0.5em), it)
    }).join()
  }

  // Vertical spacing between authors and abstract.
  v(0.3in - 0.2in)
  v(0.075in)

  // Render abstract.
  {
    set text(size: 10pt)
    set par(leading: 0.55em)

    // NeurIPS instruction tels that font size of `Abstract` must equal to 12pt
    // but there is not predefined font size.
    align(center, text(size: 12pt)[*Abstract*])
    v(0.5em)
    pad(left: 0.5in, right: 0.5in, abstract)
  }

  v(0.20in)

  // Render main body
  {
    // Display body.
    set text(size: font.normal)
    set par(leading: 0.55em)
    body

    // Display the bibliography, if any is given.
    if bibliography-file != none {
      if "full" not in bibliography-opts {
        bibliography-opts["full"] = false
      }
      // NOTE It is allowed to reduce font to 9pt (small) but there is not
      // small font of size 9pt in original sty.
      show bibliography: set text(size: font.small)
      bibliography(
        bibliography-file,
        // style: "icml2024.csl",
        title: "",
        full: true,
        ..bibliography-opts,
      )
    }
  }

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
  // include "appendix.typ"
}
