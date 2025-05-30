/**
 * neurips2024.typ
 *
 * Template for The 38-th Annual Conference on Neural Information Processing
 * Systems (NeurIPS) 2024.
 *
 * [1]: https://neurips.cc/Conferences/2024
 */

#import "/neurips2023.typ": font, neurips2023, paragraph, url

// Tickness values are taken from booktabs.
#let botrule = table.hline(stroke: (thickness: 0.08em))
#let midrule = table.hline(stroke: (thickness: 0.05em))
#let toprule = botrule

#let anonymous-notice = [
  Submitted to 38th Conference on Neural Information Processing Systems
  (NeurIPS 2024). Do not distribute.
]

#let arxiv-notice = [Preprint. Under review.]

#let public-notice = [
  38th Conference on Neural Information Processing Systems (NeurIPS 2024).
]

#let get-notice(accepted) = if accepted == none {
  return arxiv-notice
} else if accepted {
  return public-notice
} else {
  return anonymous-notice
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
  bibliography: none,
  bibliography-opts: (:),
  appendix: none,
  accepted: false,
  aux: (:),
  body,
) = {
  // Update auxiliarry parametetrs with notice getter.
  aux.insert("get-notice", get-notice)

  show: neurips2023.with(
    title: title,
    authors: authors,
    keywords: keywords,
    date: date,
    abstract: abstract,
    accepted: accepted,
    aux: aux,
  )
  body
  // Display the bibliography, if any is given.
  if bibliography != none {
    if "title" not in bibliography-opts {
      bibliography-opts.title = "References"
    }
    if "style" not in bibliography-opts {
      bibliography-opts.style = "natbib.csl"
    }
    // NOTE It is allowed to reduce font to 9pt (small) but there is not
    // small font of size 9pt in original sty.
    show std.bibliography: set text(size: font.small)
    set std.bibliography(..bibliography-opts)
    bibliography
  }

  if appendix != none {
    set heading(numbering: "A.1")
    counter(heading).update(0)
    appendix
  }
}
