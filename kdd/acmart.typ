// made according to typst ieee template and official acm word template

// --- Draft Formatting

// Papers will be submitted electronically in PDF format via the web submission form.

// 1. Submissions may have at most 12 pages of technical content, including all text, figures, tables, etc. Bibliographic references are not included in the 12-page limit.
// 2. Use A4 or US letter paper size, with all text and figures fitting inside a 178 x 229 mm (7 x 9 in) block centered on the page, using two columns separated by 8 mm (0.33) of whitespace.
// 3. Use 10-point font (typeface Times Roman, Linux Libertine, etc.) on 12-point (single-spaced) leading.
// 4. Graphs and figures should be readable when printed in grayscale, without magnification.
// 5. All pages should be numbered, and references within the paper should be hyperlinked.

// Authors may optionally include supplementary material, such as formal proofs or analyses, as a separate document; PC members are not required to read this material, so the submission must stand alone without it. Supplementary material is intended for items that are not critical for evaluating the paper but may be of interest to some readers.

// Submissions violating these rules will not be considered for publication, and there will be no extensions for fixing violations. We encourage you to upload an early draft of the paper well before the deadline to check if the paper meets the formatting rules.

// Most of these rules are automatically applied when using the official SIGPLAN Latex or MS Word templates from the ACM.

// For Latex, we recommend you use:

// \documentclass[sigplan,10pt]{acmart}
// \renewcommand\footnotetextcopyrightpermission[1]{}
// ...
// \settopmatter{printfolios=true}
// \maketitle
// \pagestyle{plain}
// ...

// --- Camera-ready Formatting

// 1. Camera-ready papers can have 12 pages of technical content, including all text, figures, tables, etc. Your shepherd can approve up to two additional pages of technical content. Bibliographic references are not included in the 12-page limit.
// 2. You must use the US letter paper size, with all text and figures fitting inside a 178 x 229 mm (7 x 9 in) block centered on the page, using two columns separated by 8 mm (0.33) of whitespace.
// 3. Use 10-point font (typeface Times Roman, Linux Libertine, etc.) on 12-point (single-spaced) leading.
// 4. Graphs and figures should be readable when printed in grayscale, without magnification.
// 5. Do not include page numbers, footers, or headers. References within the paper should be hyperlinked.
// 6. Paper titles should be in Initial Caps Meaning First Letter of the Main Words Should be Made Capital Letters. As an example, refer to the previous sentence: note the Capital Letter "M" in Must, Meaning, and Main, the Capital Letter "C" in Caps and Capital and the Capital Letter "L" in Letter and Letters.

// Most of these rules are automatically applied when using the official SIGPLAN LaTeX or MS Word templates from the ACM, available from the ACM Template Page.

// Please follow the font requirements from part 8 of the ACM Guidelines for Proceedings.
// 7. In particular, papers should have Type 1 fonts (scalable), not Type 3 (bit-mapped).
// 8. All fonts MUST be embedded within the PDF file. This will usually happen by default when using pdflatex, but in rare cases, PDFs generated with pdflatex will not contain embedded fonts. This most often occurs when vector images included in paper do not themselves embed their fonts.

// 9. Authors should make sure to use the ACM classification system. For details, please see the ACM CCS Page.

// 10. Be sure that there are no bad page or column breaks, meaning no widows (last line of a paragraph at the top of a column). 
// 11. Section and Sub-section heads should remain with at least 2 lines of body text when near the end of a page or column.

// 12. When submitting the camera-ready paper, make sure the author full names and affiliations in HotCRP are up-to-date, and that the abstract in HotCRP is also updated.

// ---


#let copyright-owner(mode: none) = {
  if mode == "acmcopyright" [
    ACM.
  ] else if mode == "acmlicensed" [
    Copyright held by the owner/author(s). Publication rights licensed to ACM.
  ] else if mode in ("rightsretained", "cc") [
    Copyright held by the owner/author(s).
  ] else [
    // TODO
  ]
}

#let copyright-permission(mode: none) = {
  if mode == "acmcopyright" [
    Permission to make digital or hard copies of all or part of this
    work for personal or classroom use is granted without fee provided
    that copies are not made or distributed for profit or commercial
    advantage and that copies bear this notice and the full citation on
    the first page. Copyrights for components of this work owned by
    others than ACM must be honored. Abstracting with credit is
    permitted. To copy otherwise, or republish, to post on servers or
    to redistribute to lists, requires prior specific permission
    and/or a fee. Request permissions from permissions\@acm.org.
  ] else if mode == "acmlicensed" [
    Permission to make digital or hard copies of all or part of this
    work for personal or classroom use is granted without fee provided
    that copies are not made or distributed for profit or commercial
    advantage and that copies bear this notice and the full citation on
    the first page. Copyrights for components of this work owned by
    others than the author(s) must be honored. Abstracting with credit
    is permitted. To copy otherwise, or republish, to post on servers
    or to redistribute to lists, requires prior specific permission
    and/or a fee. Request permissions from
    permissions\@acm.org.
  ] else if mode == "rightsretained" [
    Permission to make digital or hard copies of part or all of this
    work for personal or classroom use is granted without fee provided
    that copies are not made or distributed for profit or commercial
    advantage and that copies bear this notice and the full citation on
    the first page. Copyrights for third-party components of this work
    must be honored. For all other uses, contact the
    owner/author(s).
  ] else if mode == "cc" [
    #v(-0.5em)
    #image("cc-by.svg", width: 25%)
    #v(-0.5em)
    This work is licensed under a
    #link("https://creativecommons.org/licenses/by/4.0/")[
      Creative Commons Attribution International 4.0
    ]
    License.
  ] else [
    // TODO
  ]
}

// This function gets your whole document as its `body` and formats
#let acmart(
  // The paper's title.
  title: "Paper Title",
  
  subtitle: none,

  // An array of authors. For each author you can specify a name,
  // department, organization, location, and email. Everything but
  // but the name is optional.
  authors: (
    (
      name: "Junliang Hu",
      department: [Department of Computer Science and Engineering],
      organization: [The Chinese University of Hong Kong],
      location: [Hong Kong],
      email: "jlhu@cse.cuhk.edu.hk"
    ),
  ),

  // The paper's abstract. Can be omitted if you don't have one.
  abstract: none,

  ccs-concepts: (
    (
      generic: "Software and its engineering", 
      specific: ("Virtual machines", "Virtual memory", ),
    ),
    (
      generic:"Computer systems organization", 
      specific: ("Heterogeneous (hybrid) systems", ),
    ),
  ),

  keywords: ("Virtual machine", "Virtual memory", "Operating system"),

  conference: (
    name: "ACM SIGOPS 30th Symposium on Operating Systems Principles",
    short: "SOSP ’24",
    year: "2024",
    date: "November 4–6",
    venue: "Austin, TX, USA",
  ),

  copyright: (
    doi: "https://doi.org/10.1145/1234567890",
    isbn: "979-8-0000-0000-0/00/00",
    price: "$15.00",
    mode: "cc",
  ),

  // Whether we are submitting as a draft version or for the camera-ready stage
  review: false,
 
  // The path to a bibliography file if you want to cite some external
  // works.
  bibliography-file: none,

  // The paper's content.
  body
) = {
  let anon = if review { hide } else { x => x }
  // Set document metdata.
  set document(
    title: title, 
    author: authors.map(author => author.name), 
    keywords: keywords
  )

  // Set the body font. (rule 3)
  set text(font: "Linux Libertine", size: 10pt)
  let spacing = 0.55em

  // Configure the page. (rule 2)
  // Text block: 178 x 229 mm (7 x 9 in)
  // US letter: 8½″ × 11″ (216 mm × 279 mm)
  // A4: 210 mm × 297 mm (8.3″ × 11.7″)
  set page(
    paper: "us-letter",
    margin: (x: (8.5 - 7) / 2 * 1in, y: (11 - 9) / 2 * 1in),
  )

  // Configure equation numbering and spacing.
  // set math.equation(numbering: "(1)")
  // we used the em unit to specify the leading relative to the size of the font
  // https://typst.app/docs/tutorial/formatting/
  // show math.equation: set block(spacing: spacing)

  // Configure lists.
  set enum(indent: 10pt, body-indent: 9pt)
  set list(indent: 10pt, body-indent: 9pt)

  // Configure headings.
  set heading(numbering: "1.1.1.")
  show heading: it => locate(loc => {
    // Find out the final number of the heading counter.
    let levels = counter(heading).at(loc)
    let deepest = if levels != () { levels.last() } else { 1 }
    v(2 * spacing, weak: true)
    if it.level == 1 {
      let no-numbering = it.body in ([Abstract], [Acknowledgments], [Acknowledgment])
      block(text(size: 11pt, {
        if it.numbering != none and not no-numbering{ 
          numbering(it.numbering, ..levels)
          h(spacing, weak: true)
        }
        it.body
        v(1.5 * spacing, weak: true)
      }))
    } else if it.level == 2 {
      block(text(size: 10pt,{
        if it.numbering != none { 
          numbering(it.numbering, ..levels)
          h(spacing, weak: true)
        }
        it.body
        v(1.5 * spacing, weak: true)
      }))
    } else {
      if it.numbering != none { 
        h(-1em)
        numbering(it.numbering, ..levels)
        h(spacing, weak: true)
      }
      it.body + [.]
    }
  })

  // Display the paper's title.
  align(center, text(font: "Linux Biolinum", size: 2.1em, [* #title *]))
  
  // Display the authors list.
  for i in range(calc.ceil(authors.len() / 3)) {
    let end = calc.min((i + 1) * 3, authors.len())
    let is-last = authors.len() == end
    let slice = authors.slice(i * 3, end)
    anon(grid(
      columns: slice.len() * (1fr,),
      gutter: 1.2em,
      ..slice.map(author => align(center, {
        text(1.2em, author.name)
        if "department" in author [
          \ #author.department
        ]
        if "organization" in author [
          \ #author.organization
        ]
        if "location" in author [
          \ #author.location
        ]
        if "email" in author [
          \ #link("mailto:" + author.email)
        ]
      }))
    ))

    if not is-last {
      v(1.6em, weak: true)
    }
  }

  // Start two column mode and configure paragraph properties.
  show: columns.with(2, gutter: 8mm)

  // 12pt leading, i.e. 1.2x font-size (rule 3)
  set par(justify: true, first-line-indent: 1em, leading: spacing)
  show par: set block(spacing: spacing)

  // copyright footer
  set footnote.entry(separator: line(length: 100%, stroke: 0.5pt))
  place(bottom + end, float: true, clearance: 0em, {
    footnote(numbering: (loc) => " ", par(first-line-indent: 0em, [
      #v(-spacing)
      #copyright-permission(mode: copyright.mode)
      
      _ #conference.short, #conference.date, #conference.year, #conference.venue. _
      
      #sym.copyright #conference.year #copyright-owner(mode: copyright.mode)
      
      ACM ISBN #copyright.isbn...#copyright.price
      
      #copyright.doi
    ]))
    v(-spacing)
  })
  set footnote.entry(separator: line(length: 30%, stroke: 0.5pt))
  
  if abstract != none [
    #heading(numbering: none, level: 1, [
      Abstract
    ])
    #abstract
  ]
  // ccs
  [
    #set par(first-line-indent: 0em)
    #v(spacing)
    *
    _CCS Concepts:_ 
    #ccs-concepts.map(concept => 
      [ #sym.bullet #concept.generic #sym.arrow.r #concept.specific.join("; ")]
    ).join("; ").
    *
  ]
  // keywords
  [
    #set par(first-line-indent: 0em)
    #v(spacing)
    *_Keywords:_* 
    #keywords.join(", ")
  ]
  // reference
  [
    #set par(first-line-indent: 0em)
    #set text(size: 0.9em)
    #v(spacing)
    *ACM Reference Format:*
    
    #anon(authors.map(author => if authors.last() == author { "and " } else { } + author.name).join(", ") + [.])
    #conference.year
    #title.
    In _ #conference.name (#conference.short), #conference.date, #conference.year, #conference.venue. _
    ACM, New York, NY, USA, #counter(page).display() pages.
    #copyright.doi
  ]

  // Display the paper's contents.
  body
  
  // Display bibliography.
  if bibliography-file != none {
    show bibliography: set text(8pt)
    bibliography(bibliography-file, title: text(11pt)[References], style: "association-for-computing-machinery")
  }
}
