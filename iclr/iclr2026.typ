/**
 * iclr2026.typ
 *
 * Template for International Conference on Learning Representations (ICLR) 2026.
 * This is a thin wrapper around iclr2025.typ with updated header titles.
 */

#import "/iclr2025.typ": iclr2025

#let default-header-title = (
  [Under review as a conference paper at ICLR 2026],  // blind
  [Published as a conference paper at ICLR 2026],  // accepted
)

/**
 * iclr2026 - Template for International Conference on Learning Representations
 * (ICLR) 2026.
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
 *   aux: Auxiliary parameters to tune font settings (e.g. font familty) or
 *   page decorations (e.g. page header).
 *   id: Submission identifier.
 */
#let iclr2026(
  title: [],
  authors: (),
  keywords: (),
  date: auto,
  abstract: [],
  bibliography: none,
  appendix: none,
  accepted: false,
  aux: (:),
  id: none,
  body,
) = {
  // Merge aux with ICLR 2026 header-title as default.
  let header-title = aux.at("header-title", default: default-header-title)
  let aux = aux + (header-title: header-title)

  show: iclr2025.with(
    title: title,
    authors: authors,
    keywords: keywords,
    date: date,
    abstract: abstract,
    bibliography: bibliography,
    appendix: appendix,
    accepted: accepted,
    aux: aux,
    id: id,
  )
  body
}
