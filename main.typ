#import "icml2024.typ": *
#import "logo.typ": LaTeX, TeX

#show: icml2024.with(
  title: [
    Submission and Formatting Instructions for \
    International Conference on Machine Learning (ICML 2023)
  ],
  authors: (),
  abstract: [
    This document provides a basic paper template and submission guidelines.
    Abstracts must be a single paragraph, ideally between 4–6 sentences long.
    Gross violations will trigger corrections at the camera-ready phase.
  ],
  bibliography-file: "main.bib",
)

= Electronic Submission

Submission to ICML 2023 will be entirely electronic, via
a web site (not email). Information about the submission
process and #LaTeX templates are available on the conference
web site at:

#align(center)[
  ```
  https://icml.cc/
  ```
]

The guidelines below will be enforced for initial submissions and camera-ready
copies. Here is a brief summary:

- Submissions must be in PDF.

- *New to this year:* If your paper has appendices, submit the appendix
  together with the main body and the references *as a single file*. Reviewers
  will not look for appendices as a separate PDF file. So if you submit such an
  extra file, reviewers will very likely miss it.

- Page limit: The main body of the paper has to be fitted to 8 pages, excluding
  references and appendices; the space for the latter two is not limited. For
  the final version of the paper, authors can add one extra page to the main
  body.

- *Do not include author information or acknowledgements* in your initial
  submission.

- Your paper should be in *10 point Times font*.

- Make sure your PDF file only uses Type-1 fonts.

- Place figure captions _under_ the figure (and omit titles from inside the
  graphic file itself). Place table captions _over_ the table.

- References must include page numbers whenever possible and be as complete as
  possible. Place multiple citations in chronological order.

- Do not alter the style template; in particular, do not compress the paper
  format by reducing the vertical spaces.
- Keep your abstract brief and self-contained, one paragraph and roughly 4–6
  sentences. Gross violations will require correction at the camera-ready
  phase. The title should have content words capitalized.

== Submitting Papers

*Paper Deadline:* The deadline for paper submission that is advertised on the
conference website is strict. If your full, anonymized, submission does not
reach us on time, it will not be considered for publication.

*Anonymous Submission:* ICML uses double-blind review: no identifying author
information may appear on the title page or in the paper itself. @author-info
gives further details.

*Simultaneous Submission:* ICML will not accept any paper which, at the time of
submission, is under review for another conference or has already been
published. This policy also applies to papers that overlap substantially in
technical content with conference papers under review or previously published.
ICML submissions must not be submitted to other conferences and journals during
ICML's review period. Informal publications, such as technical reports or
papers in workshop proceedings which do not appear in print, do not fall under
these restrictions.

#v(6pt)  // TODO: Original is \medskip.

Authors must provide their manuscripts in *PDF* format. Furthermore, please
make sure that files contain only embedded Type-1 fonts (e.g.,~using the
program `pdffonts` in linux or using File/DocumentProperties/Fonts in Acrobat).
Other fonts (like Type-3) might come from graphics files imported into the
document.

Authors using *Word* must convert their document to PDF. Most of the latest
versions of Word have the facility to do this automatically. Submissions will
not be accepted in Word format or any format other than PDF. Really. We're not
joking. Don't send Word.

Those who use *\LaTeX* should avoid including Type-3 fonts. Those using `latex`
and `dvips` may need the following two commands:

```shell
dvips -Ppdf -tletter -G0 -o paper.ps paper.dvi ps2pdf paper.ps
```

It is a zero following the "-G", which tells dvips to use the `config.pdf`
file. Newer #TeX distributions don't always need this option.

Using `pdflatex` rather than `latex`, often gives better results. This program
avoids the Type-3 font problem, and supports more advanced features in the
`microtype` package.

*Graphics files* should be a reasonable size, and included from
an appropriate format. Use vector formats (.eps/.pdf) for plots,
lossless bitmap formats (.png) for raster graphics with sharp lines, and
jpeg for photo-like images.

The style file uses the `hyperref` package to make clickable links in
documents. If this causes problems for you, add `nohyperref` as one of the
options to the `icml2024` usepackage statement.

== Submitting Final Camera-Ready Copy

The final versions of papers accepted for publication should follow the same
format and naming convention as initial submissions, except that author
information (names and affiliations) should be given. See @final-author for
formatting instructions.

The footnote, "Preliminary work. Under review by the International Conference
on Machine Learning (ICML). Do not distribute." must be modified to
"_Proceedings of the 41#super("st") International Conference on Machine
Learning_, Vienna, Austria, PMLR 235, 2024. Copyright 2024 by the
author(s)."

For those using the *#LaTeX* style file, this change (and others) is handled
automatically by simply changing `\usepackage{icml2024}` to

```tex
\usepackage[accepted]{icml2024}
```

Authors using *Word* must edit the footnote on the first page of the document
themselves.

Camera-ready copies should have the title of the paper as running head on each
page except the first one. The running title consists of a single line centered
above a horizontal rule which is $1$~point thick. The running head should be
centered, bold and in $9$~point type. The rule should be $10$~points above the
main text. For those using the *#LaTeX* style file, the original title is
automatically set as running head using the `fancyhdr` package which is
included in the ICML 2024 style file package. In case that the original title
exceeds the size restrictions, a shorter form can be supplied by using

```tex
\icmltitlerunning{...}
```

just before `\begin{document}`. Authors using *Word* must edit the header of
the document themselves.

= Format of the Paper

All submissions must follow the specified format.

== Dimensions

The text of the paper should be formatted in two columns, with an overall width
of 6.75 inches, height of 9.0 inches, and 0.25 inches between the columns. The
left margin should be 0.75 inches and the top margin 1.0 inch (2.54 cm). The
right and bottom margins will depend on whether you print on US letter or A4
paper, but all final versions must be produced for US letter size. Do not write
anything on the margins.

The paper body should be set in 10 point type with a vertical spacing of 11
points. Please use Times typeface throughout the text.}

== Title

The paper title should be set in 14~point bold type and centered between two
horizontal rules that are 1~point thick, with 1.0~inch between the top rule and
the top edge of the page. Capitalize the first letter of content words and put
the rest of the title in lower case.

== Author Information for Submission <author-info>

ICML uses double-blind review, so author information must not appear. If you
are using #LaTeX and the `icml2024.sty` file, use `\icmlauthor{...}` to specify
authors and `\icmlaffiliation{...}` to specify affiliations. (Read the TeX code
used to produce this document for an example usage.) The author information
will not be printed unless `accepted` is passed as an argument to the style
file. Submissions that include the author information will not be reviewed.

=== Self-Citations

If you are citing published papers for which you are an author, refer to
yourself in the third person. In particular, do not use phrases that reveal
your identity (e.g., "in previous work @langley00, we have shown ...").

Do not anonymize citations in the reference section. The only exception are
manuscripts that are not yet published (e.g., under submission). If you choose
to refer to such unpublished manuscripts @anonymous, anonymized copies have to
be submitted as Supplementary Material via OpenReview. However, keep in mind
that an ICML paper should be self contained and should contain sufficient
detail for the reviewers to evaluate the work. In particular, reviewers are not
required to look at the Supplementary Material when writing their review (they
are not required to look at more than the first $8$ pages of the submitted
document).

=== Camera-Ready Author Information <final-author>

If a paper is accepted, a final camera-ready copy must be prepared. For
camera-ready papers, author information should start 0.3~inches below the
bottom rule surrounding the title. The authors' names should appear in 10~point
bold type, in a row, separated by white space, and centered. Author names
should not be broken across lines. Unbolded superscripted numbers, starting 1,
should be used to refer to affiliations.

Affiliations should be numbered in the order of appearance. A single footnote
block of text should be used to list all the affiliations. (Academic
affiliations should list Department, University, City, State/Region, Country.
Similarly for industrial affiliations.)

Each distinct affiliations should be listed once. If an author has multiple
affiliations, multiple superscripts should be placed after the name, separated
by thin spaces. If the authors would like to highlight equal contribution by
multiple first authors, those authors should have an asterisk placed after
their name in superscript, and the term `\textsuperscript{*}Equal contribution`
should be placed in the footnote block ahead of the list of affiliations. A
list of corresponding authors and their emails (in the format Full Name
\textless{}email\@domain.com\textgreater{}) can follow the list of
affiliations. Ideally only one or two names should be listed.

A sample file with author names is included in the ICML2024 style file package.
Turn on the `[accepted]` option to the stylefile to see the names rendered. All
of the guidelines above are implemented by the #LaTeX style file.

== Citations and References

Please use APA reference format regardless of your formatter or word processor.
If you rely on the #LaTeX bibliographic facility, use `natbib.sty` and
`icml2024.bst` included in the style-file package to obtain this format.

Citations within the text should include the authors' last names and year. If
the authors' names are included in the sentence, place only the year in
parentheses, for example when referencing Arthur Samuel's pioneering work
(#cite(<Samuel59>, form: "year")). Otherwise place the entire reference in
parentheses with the authors and year separated by a comma @Samuel59. List
multiple references separated by semicolons @kearns89 @Samuel59 @mitchell80.
Use the 'et~al.' construct only for citations with three or more authors or
after listing all authors to a publication in an earlier reference
@MachineLearningI.

Authors should cite their own work in the third person in the initial version
of their paper submitted for blind review. Please refer to @author-info for
detailed instructions on how to cite your own papers.

Use an unnumbered first-level section heading for the references, and use a
hanging indent style, with the first line of the reference flush against the
left margin and subsequent lines indented by 10 points. The references at the
end of this document give examples for journal articles @Samuel59, conference
publications @langley00, book chapters @Newell81, books @DudaHart2nd, edited
volumes @MachineLearningI, technical reports @mitchell80, and dissertations
@kearns89.

Alphabetize references by the surnames of the first authors, with
single author entries preceding multiple author entries. Order
references for the same authors by year of publication, with the
earliest first. Make sure that each reference includes all relevant
information (e.g., page numbers).

Please put some effort into making references complete, presentable, and
consistent, e.g. use the actual current name of authors.
If using bibtex, please protect capital letters of names and
abbreviations in titles, for example, use \{B\}ayesian or \{L\}ipschitz
in your .bib file.

= Accessibility

Authors are kindly asked to make their submissions as accessible as possible
for everyone including people with disabilities and sensory or neurological
differences. Tips of how to achieve this and what to pay attention to will be
provided on the conference website \url{http://icml.cc/}.
