/**
 * neurips2026.typ
 *
 * Template for The 40th Annual Conference on Neural Information Processing
 * Systems (NeurIPS) 2026.
 *
 * [1]: https://neurips.cc/Conferences/2026
 */

#import "/neurips2023.typ": appendix, font, neurips2023, paragraph, url

// Tickness values are taken from booktabs.
#let botrule = table.hline(stroke: (thickness: 0.08em))
#let midrule = table.hline(stroke: (thickness: 0.05em))
#let toprule = botrule

#let anonymous-notice = [
  Submitted to 40th Conference on Neural Information Processing Systems
  (NeurIPS 2026). Do not distribute.
]

#let arxiv-notice = [Preprint.]

// Track-specific notice strings for camera-ready copies.
#let get-track-notice(track, workshop-title: none) = {
  if track == "position" {
    [40th Conference on Neural Information Processing Systems (NeurIPS 2026). Position Paper Track.]
  } else if track == "eandd" {
    [40th Conference on Neural Information Processing Systems (NeurIPS 2026). Track on Evaluations and Datasets.]
  } else if track == "creativeai" {
    [40th Conference on Neural Information Processing Systems (NeurIPS 2026). Creative AI Track.]
  } else if track == "workshop" {
    [40th Conference on Neural Information Processing Systems (NeurIPS 2026). Workshop: #workshop-title.]
  } else {
    // Default: main track.
    [40th Conference on Neural Information Processing Systems (NeurIPS 2026).]
  }
}

#let make-get-notice(track, workshop-title) = {
  return accepted => if accepted == none {
    arxiv-notice
  } else if accepted {
    get-track-notice(track, workshop-title: workshop-title)
  } else {
    anonymous-notice
  }
}

/**
 * neurips2026 - Show rule for the 40th NeurIPS conference (Sydney, 2026).
 *
 * Args:
 *   title: The paper title as content.
 *   authors: A tuple `(authors, affls)` where `authors` is an array of author
 *     dictionaries (keys: `name`, `affl`, `email`) and `affls` is a dictionary
 *     mapping affiliation keys to dictionaries (keys: `department`,
 *     `institution`, `location`, `country`).
 *   keywords: Array of keyword strings for document metadata.
 *   date: Publication date, or `auto` to use the current date.
 *   abstract: Paper abstract as content, or `none`.
 *   bibliography: Result of a `bibliography(...)` call, or `none`.
 *   bibliography-opts: Named options forwarded to `set bibliography(...)`.
 *     Defaults to `(title: "References", style: "natbib.csl")`.
 *   accepted: Controls the submission mode and footer notice.
 *     - `false` (default): anonymous submission with line numbers.
 *     - `true`: camera-ready; use `track` to select the footer notice.
 *     - `none`: preprint (arXiv) — non-anonymous, footer reads "Preprint."
 *   track: Selects the footer notice for camera-ready copies (`accepted:
 *     true`). Valid values:
 *     - `"main"` (default) — Main Track.
 *     - `"position"` — Position Paper Track.
 *     - `"eandd"` — Track on Evaluations and Datasets.
 *     - `"creativeai"` — Creative AI Track.
 *     - `"workshop"` — Workshop; set `workshop-title` as well.
 *   workshop-title: Workshop name as content. Required when `track` is
 *     `"workshop"`.
 *   aux: Dictionary of advanced overrides. The `get-notice` key accepts a
 *     function `accepted => content` to fully customize the footer notice.
 */
#let neurips2026(
  title: [],
  authors: (),
  keywords: (),
  date: auto,
  abstract: none,
  bibliography: none,
  bibliography-opts: (:),
  accepted: false,
  track: "main",
  workshop-title: none,
  aux: (:),
  body,
) = {
  // Update auxiliary parameters with notice getter.
  aux.insert("get-notice", make-get-notice(track, workshop-title))

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

}
