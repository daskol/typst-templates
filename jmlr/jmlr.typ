#let std-bibliography = bibliography  // Due to argument shadowing.

#let font-family = ("New Computer Modern", "Times New Roman",
                    "Latin Modern Roman", "CMU Serif",
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

/**
 * join-authors - Join a list of authors (full names, last names, or just
 * strings) to a single string.
 */
#let join-authors(authors) = {
  return if authors.len() > 2 {
    authors.join(", ", last: ", and ")
  } else if authors.len() == 2 {
    authors.join(" and ")
  } else {
    authors.at(0)
  }
}

#let make-author(author, affls) = {
  let author-affls = if type(author.affl) == array {
    author.affl
  } else {
    (author.affl, )
  }

  let lines = author-affls.map(key => {
    let affl = affls.at(key)
    let affl-keys = ("department", "institution", "location")
    return affl-keys
      .map(key => {
        let value = affl.at(key, default: none)
        if key != "location" {
          return value
        }

        // Location and country on the same line.
        let country = affl.at("country", default: none)
        if country == none {
          return value
        } else if value == none {
          return country
        } else {
          return value + ", " + country
        }
      })
      .filter(it => it != none)
      .join("\n")
  }).map(it => emph(it))

  return block(spacing: 0em, {
    show par: set block(spacing: 5.5pt)
    text(size: font-size.normal)[*#author.name*]
    set par(justify: true, leading: 5pt, first-line-indent: 0pt)
    text(size: font-size.small)[#lines.join([\ ])]
  })
}

#let make-email(author) = {
  let label = text(size: font-size.small, smallcaps(author.email))
  return block(spacing: 0em, {
    // Compensate difference between name and email font sizes (10pt vs 9pt).
    v(1pt)
    link("mailto:" + author.email, label)
  })
}

#let make-authors(authors, affls) = {
  let cells = authors
    .map(it => (make-author(it, affls), make-email(it)))
    .join()
  return grid(
    columns: (6fr, 4fr),
    align: (left + top, right + top),
    row-gutter: 12pt,  // Visually perfect.
    ..cells)
}

#let make-title(title, authors, affls, abstract, keywords, editors) = {
  // 1. Title.
  v(31pt - (0.25in + 4.5pt))
  block(width: 100%, spacing: 0em, {
    set align(center)
    set block(spacing: 0em)
    text(size: 14pt, weight: "bold", title)
  })

  // 2. Authors.
  v(23.6pt, weak: true)
  make-authors(authors, affls)
  // 3. Editors if exist.
  if editors != none and editors.len() > 0 {
    v(28.6pt, weak: true)
    text(size: font-size.small, [*Editor:* ] + editors.join([, ]))
  }

  // Render abstract.
  v(28.8pt, weak: true)
  block(spacing: 0em, width: 100%, {
    set text(size: font-size.small)
    set par(leading: 0.51em)  // Original 0.55em (or 0.45em?).
    align(center,
      text(size: font-size.large, weight: "bold", [*Abstract*]))
    v(8.2pt, weak: true)
    pad(left: 20pt, right: 20pt, abstract)
  })

  // Render keywords if exist.
  if keywords != none {
    keywords = keywords.join([, ])
    v(6.5pt, weak: true)  // ~1ex
    block(spacing: 0em, width: 100%, {
      set text(size: 10pt)
      set par(leading: 0.51em)  // Original 0.55em (or 0.45em?).
      pad(left: 20pt, right: 20pt)[*Keywords:* #keywords]
    })
  }

  // Space before paper content.
  v(23pt, weak: true)
}

/**
 * jmlr - Template for Journal of Machine Learning Research (JMLR).
 *
 * Args:
 *   title: Paper title.
 *   short-title: Paper short title (for page header).
 *   authors: Tuple of author objects and affilation dictionary.
 *   last-names: List of authors last names (for page header).
 *   date: Creation date (used in PDF metadata).
 *   abstract: Paper abstract.
 *   keywords: Publication keywords (used in PDF metadata).
 *   bibliography: Bibliography content. If it is not specified then there is
 *   not reference section.
 *   appendix: Content to append after bibliography section.
 *   pubdata: Dictionary with auxiliary information about publication.
 */
#let jmlr(
  title: [],
  short-title: none,
  authors: (),
  last-names: (),
  date: auto,
  abstract: [],
  keywords: (),
  bibliography: none,
  appendix: none,
  pubdata: (:),
  body,
) = {
  // If there is no short title then use title as a short title.
  if short-title == none {
    short-title = title
  }

  // Authors are actually a tuple of authors and affilations.
  let affls = ()
  if authors.len() == 2 {
    (authors, affls) = authors
  }

  // If last names are not specified then try to guess last names from author
  // names.
  if last-names.len() == 0 and authors.len() > 0 {
    last-names = authors.map(it => it.name.trim("\s").split(" ").at(-1))
  }

  // If there is only one editor then create an `editors` field with a single
  // editor.
  let is_preprint = pubdata.len() == 0
  let editors = if is_preprint {
    ()
  } else if pubdata.at("editors", default: none) == none {
    (pubdata.editor, )
  } else {
    pubdata.editors
  }

  // Set document metadata.
  let meta-authors = join-authors(authors.map(it => it.name))
  set document(title: title, author: meta-authors, keywords: keywords,
               date: date)

  set page(
    paper: "us-letter",
    margin: (left: 1.25in, right: 1.25in, top: 1.25in + 4.5pt, bottom: 1in),
    header-ascent: 24pt + 0.25in + 4.5pt,
    header: locate(loc => {
      // The first page is a title page. Short title on even pages and authors
      // on odd ones.
      let pageno = counter(page).at(loc).first()
      if pageno == 1 {
        // If this is preprint then there is nothing in header on title page.
        if is_preprint {
          return
        }

        let volume = pubdata.volume
        let year = pubdata.published-at.year()
        let nopages = locate(loc => counter(page).final().at(0))

        let format-date = (date, supplement) => {
          return date
            .display(supplement + " [month padding:none]/[year repr:last_two]")
        }
        let submitted = format-date(pubdata.submitted-at, "Submitted")
        let revised = format-date(pubdata.revised-at, "Revised")
        let published = format-date(pubdata.published-at, "Published")

        set text(size: font-size.script)
        grid(
          columns: (1fr, 1fr),
          align: (left, right),
          [Journal of Machine Learning Research #volume (#year) 1-#nopages],
          [#submitted\; #revised\; #published])
      } else if calc.rem(pageno, 2) == 0 {
        set align(center)
        set text(size: font-size.small)
        smallcaps[#join-authors(last-names)]
      } else {
        set align(center)
        set text(size: font-size.small)
        smallcaps(short-title)
      }
    }),
    footer-descent: 10%,
    footer: locate(loc => {
      let pageno = counter(page).at(loc).first()
      if pageno == 1 {
        set text(size: font-size.script)
        set par(first-line-indent: 0pt, justify: true)
        show par: set block(spacing: 9pt)

        // NOTE If this is preprint then we use metadata `date` for copyright
        // notice.
        let owners = join-authors(authors.map(it => it.name))
        let year = if not is_preprint {
          pubdata.published-at.year()
        } else if date == auto {
          datetime.today().year()
        } else {
          date.year()
        }
        [©#year #owners\.]
        parbreak()

        let href = addr => link(addr, raw(addr))
        let url-license = "https://creativecommons.org/licenses/by/4.0/"
        let url-attrib = (
          "http://jmlr.org/papers/v", str(pubdata.volume), "/",
          pubdata.id, ".html",
        ).join()
        [License: CC-BY 4.0, see #href(url-license).]
        if not is_preprint {
          [Attribution requirements are provided at #href(url-attrib).]
        }
      } else {
        v(-1pt)  // Compensatation for what?
        align(center, text(size: font-size.small, [#pageno]))
      }
    }),
  )

  // Basic paragraph and text settings.
  set text(font: font-family, size: font-size.normal)
  set par(leading: 0.55em, first-line-indent: 17pt, justify: true)
  show par: set block(spacing: 0.55em)

  // Configure heading appearence and numbering.
  set heading(numbering: "1.1")
  show heading.where(level: 1): it => {
    set text(size: font-size.large)
    set block(above: 13pt, below: 13pt)
    it
  }
  show heading.where(level: 2): it => {
    set text(size: font-size.normal)
    set block(above: 11.9pt, below: 11.8pt)
    it
  }
  show heading.where(level: 3): it => {
    set text(size: font-size.normal)
    set block(above: 11.9pt, below: 11.7pt)
    it
  }
  show heading.where(level: 4): it => {
    set text(size: font-size.normal)
    set block(above: 11.9pt, below: 11.7pt)
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

  make-title(title, authors, affls, abstract, keywords, editors)
  parbreak()
  body

  if appendix != none {
    set heading(numbering: "A.1", supplement: [Appendix])
    counter(heading).update(0)
    pagebreak()
    appendix
  }

  if bibliography != none {
    set std-bibliography(title: [References], style: "american-sociological-association")
    bibliography
  }
}
