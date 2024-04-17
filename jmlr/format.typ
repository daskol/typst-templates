#import "/jmlr.typ": jmlr
#import "/logo.typ": LaTeX

#let affls = (
  one: (
    department: "Artificial Intelligence Laboratory",
    institution: "Massachusetts Institute of Technology",
    address: "545 Technology Square",
    location: "Cambridge, MA 02139",
    country: "USA"),
  two: (
    institution: "Burning Glass Technologies",
    address: "Burning Glass Technologies",
    location: "Pittsburgh, PA 15213",
    country: "USA"),
)

#let authors = (
  (name: "Leslie Pack Kaelbling",
   affl: "one",
   email: "lpk@ai.mit.edu"),
  (name: "David Cohn",
   affl: "two",
   email: "david.cohn@burning-glass.com"),
)

#show: jmlr.with(
  title: [Instructions for Formatting JMLR Articles],
  authors: (authors, affls),
  abstract: [
    This document, which is based on an earlier document by @minton1999,
    describes the required formatting of JMLR papers, including margins, fonts,
    citation styles, and figure placement. It describes how authors can obtain
    and use a #LaTeX style file that will ease adherence to the requirements.
    It also contains a section on avoiding formatting errors that frequently
    appear in JMLR submissions. While the format requirements are only
    compulsory for final submissions, we encourage authors to adopt and adhere
    to its recommendations throughout the submission process.
  ],
  keywords: ("keyword one", "keyword two", "keyword three"),
  bibliography: bibliography("format.bib"),
  appendix: include "format-appendix.typ",
  pubdata: (
    id: "21-0000",
    editor: "My editor",
    volume: 23,
    submitted-at: datetime(year: 2021, month: 1, day: 1),
    revised-at: datetime(year: 2022, month: 5, day: 1),
    published-at: datetime(year: 2022, month: 9, day: 1),
  ),
)

#let href = it => link(it, raw(it))

= Introduction

To ensure that all articles published in the journal have a uniform appearance,
authors must produce a PostScript or PDF document that meets the formatting
specifications outlined here. The document will be used for both the hardcopy
and electronic versions of the journal.

This document briefly describes and illustrates the JMLR format. It draws very
heavily from an earlier document by @minton1999. Your article should look as
similar as possible to the JMLR sample article which can be found at
#href("https://github.com/JmlrOrg/jmlr-style-file"). Below we outline the basic
specifications, including font sizes, margins, etc. However, the point is to
have your articles look similar to the sample, and when in doubt you should use
the sample as your guide. Please feel free to contact the editor of JMLR if you
have any questions.

The remainder of this document is organized as follows. Section 2 describes the
style and formatting requirements for JMLR papers. Section 3 describes how to
obtain the formatting templates that should simplify following the
requirements, and Section 4 describes common formatting errors that should be
avoided.

= Style and Format

Papers must be printed in the single column format as shown in the enclosed
sample. Margins should be $1 1/4$ inch left and right. Headers should be $1/2$
inch from top and footer should be $1$ inch from bottom of page. Title should
start $1 1/2$ inches from the top of the page.

== Fonts

You should use Times Roman style fonts. Please be very careful not to use
nonstandard or unusual fonts in the paper. Including such fonts will cause
problems for many printers.

Headers and Footers should be in 9pt type. The title of the paper should be in
14pt bold type. The abstract title should be in 11pt bold type, and the
abstract itself should be in 10pt type. First headings should be in 12 point
bold type and second headings should be in 11 point bold type. The text and
body of the paper should be in 11 point type.

== Title and Authors

The title appears near the top of the first page, centered. Authors' names
should appear in designated areas below the title of the paper in twelve point
bold type. Authors' affiliations and complete addresses should be in italics,
and their electronic addresses should be in small capitals (see sample
article).

== Abstract

The abstract appears at the beginning of the paper, indented $1/4$ of an inch
from the left and right margins. The title "Abstract" should appear in bold
face 11 point type, centered above the body of the abstract. The abstract body
should be in 10 point type.

== Headings and Sections

When necessary, headings should be used to separate major sections of your
paper. First-level headings should be in 12 point bold type and second-level
headings should be in 11 point bold type. Do not skip a line between
paragraphs. Third-level headings should also be in 11 point bold type. All
headings should be capitalized. After a heading, the first sentence should not
be indented.

References to sections (as well as figures, tables, theorems and so on), should
be capitalized, as in "In Section 4, we show that...".

=== Appendices

Appendices, if included, follow the acknowledgments. Each appendix should be
lettered, e.g., "Appendix A". If online appendices are submitted, they should
not be included in the final manuscript (see below), although they may be
referred to in the manuscript. They will be published online in separate files.
The online appendices should be numbered and referred to as Online Appendix 1,
Online Appendix 2, etc.

=== Acknowledgements and Disclosure of Funding

All acknowledgements go at the end of the paper before appendices and
references. Moreover, you are required to declare funding (financial activities
supporting the submitted work) and competing interests (related financial
activities outside the submitted work).

== Figures and Tables

Figures and tables should be inserted in proper places throughout the text. Do
not group them together at the beginning of a page, nor at the bottom of the
paper. Number figures sequentially, e.g., Figure 1, and so on.

The figure or table number and the caption should appear under the
illustration. Leave a margin of one-quarter inch around the area covered by the
figure and caption. Captions, labels, and other text in illustrations must be
at least nine-point type.

At present, some types of illustrations in your manuscript may cause problems
for some printers/previewers. Although this is gradually becoming less of an
issue, we encourage authors to use "reliable" programs for producing figures.
Before your paper can be accepted, we must verify that all your figures print
successfully on our printers and may be viewed with Adobe Acrobat Reader or
Ghostview.

== Headers and Footers

The first page of your article should include the journal name, volume number,
year and page numbers in the upper left corner, the submission date and
publication date in the upper right corner, and the copyright notice in the
lower left corner. The editor will let you know the volume number, year, pages,
submission date and publication date.

On the even numbered pages, the header of the page should be the authors'
names. On the odd pages, starting with page 3, the header should be the title
of the paper (shortened if necessary, as in the sample).

=== Page Numbering and Publication Date

Leave the page number starting at one. The Production Editor will change the
page numbers according to the actual order of publication, and will insert the
proper page numbers in the heading of your article.

For submission dates, please do the following. If the paper was accepted with
no revisions the first time just include the submission date (month and year)
as the fourth argument to the `\jmlrheading` command. For example, for a paper
submitted February 12, 2005, the fourth argument should be

```tex
    2/05
```

If your paper was returned for revisions, please insert the original date of
submission followed by the text "; Revised " and then the date the revision was
submitted, like this (for a paper originally submitted Feb, 2005 and
resubmitted in April of 2005):

```
    2/05; Revised 4/05
```

You may leave the publication date (the fifth argument to `\jmlrheading`) blank
and it will be filled in by the Production Editor.

=== Footnotes

We encourage authors to use footnotes sparingly, especially since they may be
difficult to read online. Footnotes should be numbered sequentially and should
appear at the bottom of the page, as shown below.#footnote[A footnote should
appear like this. Please ensure that your footnotes are complete, fully
punctuated sentences.]

== References

The reference section should be labeled "References" and should appear at the end of the paper in natbib format. A sample list of references is given in Appendix A. Poorly prepared, incomplete or sloppy references reflect badly on the quality of your scholarship. Please prepare complete and accurate citations.
Citations within the text should include the author's last name and year, for example (Cheeseman, 1992). Append lower-case letters to the year in cases of ambiguity, as in (Cheeseman, 1993a). Multiple authors should be treated as follows: (Cheeseman & Englemore 1988) or (Englemore, Cheeseman & Buchanan, 1992). In the case of three or more authors, the citation can be shortened by referring only the first author, followed by "et al.", as in (Clancey et al., 1991). Multiple citations should be separated by a semi-colon, as in (Cheeseman, 1993a; Buntine, 1992). If two works have the same author or authors, the appropriate format is as follows: (Drummond 1990, 1991).

If the authors' names are mentioned in the text, the citation need only refer
to the year, as in "Cheeseman and Englemore (1988) showed that...".

In general, you shouldn't have parenthetical statements embedded in
parenthetical statements. Therefore, citations within parenthetical statements
should not be embedded in parentheses. Use commas as separators instead. For
instance, rather than "(as shown by Bresina (1992))" you should write "(as
shown by Bresina, 1992)". Similarly, "(e.g., (Bresina, 1992))" should be
"(e.g., Bresina, 1992). Note that the natbib style file supports the inclusion
of prefixes in citations.

= Formatting Templates

To ready your work for publication, please typeset it using software such LATEX
that produces PostScript or PDF output (LATEX is preferred.) A LATEX style file
is available at
#href("https://raw.githubusercontent.com/JmlrOrg/jmlr-style-file/master/jmlr2e.sty").
We hope to eventually have macros/samples for other document preparation
systems as well. We recommend working from the LATEX source of the sample
article (at
#href("https://raw.githubusercontent.com/JmlrOrg/jmlr-style-file/master/sample.tex")),
which has been annotated to simplify use of the macros in the style file. If
you must use a document preparation system other than LATEX, please discuss
this with the editor prior to submitting your final document. If you do not
have the software necessary to produce acceptable PostScript or PDF files, the
editor will recommend a professional service for formatting your article.
(Authors will be responsible for paying for this service).

== Using `jmlr2e.sty`

The #LaTeX source for the sample paper, at
#href("http://www.jmlr.org/format/sample.tex"), details the use of most of the
macros in `jmlr2e`; we describe a few of the macros here for illustration.

The paper should begin with a specification of the document class and JMLR
style file:

```tex
    \documentclass[twoside,11pt]{article}
    \usepackage{jmlr2e}
```

The following command can be used in the LaTex version of your paper to set the
first page header:

```tex
    # dates/pages from editor
    \jmlrheading{1}{2000}{1-48}{4/00}{10/00}{00-000}{author list}
```

To set your title and authors for headings:

```tex
    \ShortHeadings{short title}{short authors}
```

For example:

```tex
      \ShortHeadings{Minimizing Conflicts}{Minton et al.}
```

To set your page numbers:

```tex
    \firstpageno{?} the pagenumber you are assigned to start with by the editor.
```

Authors are specified with the `author` macro:

```tex
    \author{\name Author One \email author-one-email\\
    \addr Author One address line one\\
    Author One address line two\\
    Author One address line three...
    \AND
    \name Author Two \email author-two-email\\
    \addr Author Two address line one\\
    Author Two address line two\\
    Author Two address line three...}
```

If multiple authors share an affiliation, it may be appended to the group by
specifying:

```tex
    \author{\name Author One \email author-one-email\\
    \name Author Two \email author-two-email\\
    \addr Authors' address line one\\
    Authors' address line two\\
    Authors' address line three...}
```

== Citations using `natbib`

The recommended citation style file, natbib, is included in `jmlr2e.sty`. It
supports the citation styles described in Section 2.7 with macros such as
`\citep{}` and `\citet{}`. The basic uses of `\citep{}` and `\citet{}` are as
follows:

```
\citet{jon90}	=>	Jones et al. (1990)
\citet[chap.~2]{jon90}	=>	Jones et al. (1990, chap. 2)
\citep{jon90}	=>	(Jones et al., 1990)
\citep[chap.~2]{jon90}	=>	(Jones et al., 1990, chap. 2)
\citep[see][]{jon90}	=>	(see Jones et al., 1990)
\citep[see][chap.~2]{jon90}	=>	(see Jones et al., 1990, chap. 2)
\citet*{jon90}	=>	Jones, Baker, and Williams (1990)
\citep*{jon90}	=>	(Jones, Baker, and Williams, 1990)
```

For details on making citations with natbib macros, see the natbib
documentation @daly1997, a copy of which is available at
#href("http://www.jmlr.org/format/natbib.pdf").


= Avoiding Common Errors

As we do the final editing passes on JMLR papers, we find a fairly consistent
set of problems repeated over and over. Here's a list of them. JMLR won't
enforce conformity with these rules, but it would certainly please the editors
if you followed them.

== Dashes

Dashes should be used --- with care --- to set off interjections in a sentence.
They should be long and there should not be spaces between them and the
preceding and following words. Thus, in LaTeX, the input should look like this:

```tex
    Dashes should be used---with care---to set off ...
```

== Lower case names

The names of fields, algorithms, methods, etc., should be in lower case:
cognitive science, reinforcement learning, principal components analysis.
Exceptions are when they are in names of organizational entities, like
Cognitive Science Department, or when they include proper names, such as Markov
decision processes or Gaussian densities, or Bayes' rule.

== Latin abbrevs.

Scientists seem to like to use the Latin abbreviations i.e. and e.g. First, I'd
like to encourage you to try to do without them. If you can't, then use the
English equivalents ("that is" instead of i.e. and "for example" instead of
e.g.) If you really love the Latin (then you're a Latin lover?) you should at
least do it right. There should be a period after each letter (because they're
abbreviations), and there should be a comma after the expression. If you're
addicted to these things, I encourage you to define and use LaTeX macros like

```tex
    \newcommand{\ie}{i.e.}
```

== Equation numbers

Only number equations that are actually referred to later in the text.

== Citations

Citations are not nouns. It is not correct to say "Using the method of (Smith,
1999), we ..." Instead, say "Using the method of Smith (1999), we ..." or
"Using the method of partial discombobulation (Smith, 1999), we ....". See the
section on references (Section 2.7) for more details on correct and incorrect
citation forms.

== Punctuate math

Sentences with mathematical statements in them are still sentences, subject to
the usual rules of grammar and punctuation. As @knuth1989 say,#footnote[I
recommend this book highly to anyone who likes to think about technical
writing. While we're on the subject, I also highly recommend the (sadly, out of
print) Handbook for Scholars by @leunen1992.] you should test this by reading
out your paper with things like "snort" and "grunt" substituted in for the
mathematics and listening to see whether it's grammatically correct.

Never put a footnote directly after a mathematical expression; it is too easily
confused with an exponent.

== Hyphenating compound nouns

When you have a long string of nouns together, they often need hyphenation to make the meaning clear (and to make your editor happy). Here are some examples of correct expressions:

- reinforcement learning
- reinforcement-learning algorithm
- delayed-reinforcement learning (learning from delayed reinforcement)
- delayed reinforcement learning (reinforcement learning that is delayed)

What are the rules? Here's a simple view: by default, modifiers bind to the
phrase to their right. If you want to override that, then you need to use a
hyphen. Consider the string of words "country chicken pump dispenser" (seen in
an actual catalog). A "pump dispenser" is either something that dispenses pumps
or that dispenses by pumping. A "chicken pump dispenser" is, perhaps, a pump
dispenser in the shape of a chicken. But a "chicken-pump dispenser" is
something that dispenses chicken pumps. The object in the catalog was a soap
dispenser in the shape of a country chicken (as opposed to a city chicken, I
guess) with a pump. So, probably, it should have been a "country-chicken pump
dispenser", since "pump" modifies "dispenser," "country" modifies "chicken,"
and the phrase "country chicken" modifies "pump dispenser." Whew. Many people
think it's bad form to use such long strings of nouns anyway.

== Don't use "utilize."

== Don't start a section with a subsection

A section heading should never immediately follow another section heading
without intervening text. So don't do this:

```tex
  5. Experimental Results

  5.1 Results on a Simulated Domain
```

Instead, do this:

```tex
  5. Experimental Results

  In this section, we first describe blah, blah, blah...

  5.1 Results on a Simulated Domain
```
