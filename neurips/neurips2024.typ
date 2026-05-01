/**
 * neurips2024.typ
 *
 * Template for The 38-th Annual Conference on Neural Information Processing
 * Systems (NeurIPS) 2024.
 *
 * [1]: https://neurips.cc/Conferences/2024
 */

#import "/font-config.typ": font-config-merge
#import "/neurips2023.typ": appendix, neurips2023, paragraph, url

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
 *   font-config: Preferred font family and size overrides.
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
  font-config: (:),
  aux: (:),
  body,
) = {
  let fc = font-config-merge(font-config, aux: aux)

  // Update auxiliarry parametetrs with notice getter.
  aux.insert("get-notice", get-notice)

  show: neurips2023.with(
    title: title,
    authors: authors,
    keywords: keywords,
    date: date,
    abstract: abstract,
    accepted: accepted,
    font-config: font-config,
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
    show std.bibliography: set text(size: fc.size.small)
    set std.bibliography(..bibliography-opts)
    bibliography
  }

  if appendix != none {
    show: appendix
    appendix
  }
}
