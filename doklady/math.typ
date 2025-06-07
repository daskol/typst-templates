/**
 * math.typ
 *
 * Typst templates for journal serieses "Doklady Mathematics" of Russian
 * Academy of Science (RAS).
 *
 * https://sciencejournals.ru/journal/danmiup/
 */


/**
 * math
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
#let math(
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
  // Prepare authors for PDF metadata.
  let author = if accepted == none or accepted {
    authors.at(0).map(it => it.name)
  } else {
    ()
  }

  set document(
    title: title,
    author: author,
    keywords: keywords,
    date: date)

  set page(
    paper: "a4",
    margin: (left: 25mm,
             right: 210mm - (165mm + 25mm),
             top: 15mm,
             bottom: 15mm),
    header-ascent: 46pt,  // 1.5em in case of 10pt font
    header: context {},
    footer-descent: 20pt, // Visually perfect.
    footer: context {
      let loc = here()
      let ix = counter(page).at(loc).first()
      return align(center)[#ix]
    })

  set text(size: 10pt)
  set par(first-line-indent: (amount: 1.6em, all: true), justify: true)

  set heading(numbering: "1")
  set std.math.equation(numbering: "(1)")

  body
}
