#import "/tmlr.typ": tmlr
#import "/logo.typ": LaTeX, LaTeX as LaTeX2e

#let affls = (
  nyu: (
    department: "Department of Computer Science",
    institution: "University of New York"),
  deepmind: (
    institution: "DeepMind"),
  mila: (
    department: "Mila",
    institution: "Universit\'e de Montr\'eal"),
  google-research: (
    institution: "Google Research"),
  cifar: (
    institution: "CIFAR Fellow")
)

#let authors = (
  (name: "Kyunghyun Cho", email: "kyunghyun.cho@nyu.edu", affl: "nyu"),
  (name: "Raia Hadsell", email: "raia@google.com", affl: "deepmind"),
  (name: "Hugo Larochelle",
   email: "hugolarochelle@google.com",
   affl: ("mila", "google-research", "cifar")),
)

#show: tmlr.with(
  title: [Formatting Instructions for TMLR \ Journal Submissions],
  authors: (authors, affls),
  keywords: (),
  abstract: [
    The abstract paragraph should be indented 1/2~inch on both left and
    right-hand margins. Use 10~point type, with a vertical spacing of
    11~points. The word #text(size: 12pt)[*Abstract*] must be centered, in
    bold, and in point size~12. Two line spaces precede the abstract. The
    abstract must be limited to one paragraph.
  ],
  bibliography: bibliography("main.bib"),
  accepted: false,
)

#let url(uri) = { 
  link(uri, raw(uri))
}

= Submission of papers to TMLR

TMLR requires electronic submissions, processed by
#url("https://openreview.net/"). See TMLR's website for more instructions.

If your paper is ultimately accepted, use option `accepted` with the `tmlr`
package to adjust the format to the camera ready requirements, as follows:

#align(center, ```tex
\usepackage[accepted]{tmlr}
```)

You also need to specify the month and year by defining variables `month` and
`year`, which respectively should be a 2-digit and 4-digit number. To
de-anonymize and remove mentions to TMLR (for example for posting to preprint
servers), use the preprint option, as in `\usepackage[preprint]{tmlr}`.

Please read carefully the instructions below, and follow them faithfully.

== Style

Papers to be submitted to TMLR must be prepared according to the instructions
presented here.

Authors are required to use the TMLR #LaTeX style files obtainable at the TMLR
website. Please make sure you use the current files and not previous versions.
Tweaking the style files may be grounds for rejection.

== Retrieval of style files

The style files for TMLR and other journal information are available online on
the TMLR website. The file `tmlr.pdf` contains these instructions and
illustrates the various formatting requirements your TMLR paper must satisfy.
Submissions must be made using #LaTeX and the style files `tmlr.sty` and
`tmlr.bst` (to be used with #LaTeX2e). The file `tmlr.tex` may be used as a
"shell" for writing your paper. All you have to do is replace the author,
title, abstract, and text of the paper with your own.

The formatting instructions contained in these style files are summarized in
sections @gen_inst, @headings, and @others below.

= General formatting instructions <gen_inst>

The text must be confined within a rectangle 6.5~inches wide and 9~inches long.
The left margin is 1~inch. Use 10~point type with a vertical spacing of
11~points. Computer Modern Bright is the preferred typeface throughout.
Paragraphs are separated by 1/2~line space, with no indentation.

Paper title is 17~point, in bold and left-aligned. All pages should start at
1~inch from the top of the page.

Authors' names are set in boldface. Each name is placed above its corresponding
address and has its corresponding email contact on the same line, in italic and
right aligned. The lead author's name is to be listed first, and the
co-authors' names are set to follow vertically.

Please pay special attention to the instructions in section @others
regarding figures, tables, acknowledgments, and references.

= Headings: first level <headings>

First level headings are in bold, flush left and in point size 12. One line
space before the first level heading and 1/2~line space after the first level
heading.

== Headings: second level

Second level headings are in bold, flush left and in point size 10. One line
space before the second level heading and 1/2~line space after the second level
heading.

=== Headings: third level

Third level headings are in bold, flush left and in point size 10. One line
space before the third level heading and 1/2~line space after the third level
heading.

= Citations, figures, tables, references <others>

These instructions apply to everyone, regardless of the formatter being used.

== Citations within the text

Citations within the text should be based on the `natbib` package and include
the authors' last names and year (with the "et~al." construct for more than two
authors). When the authors or the publication are included in the sentence, the
citation should not be in parenthesis, using `\citet{}` (as in "See @Hinton06
for more information."). Otherwise, the citation should be in parenthesis using
`\citep{}` (as in "Deep learning shows promise to make progress towards
AI~@Bengio2007.").

The corresponding references are to be listed in alphabetical order of authors,
in the *References* section. As to the format of the references themselves, any
style is acceptable as long as it is used consistently.

== Footnotes

Indicate footnotes with a number#footnote[Sample of the first footnote] in the
text. Place the footnotes at the bottom of the page on which they appear.
Precede the footnote with a horizontal rule of 2~inches.#footnote[Sample of the
second footnote]

== Figures

All artwork must be neat, clean, and legible. Lines should be dark enough for
purposes of reproduction; art work should not be hand-drawn. The figure number
and caption always appear after the figure. Place one line space before the
figure caption, and one line space after the figure. The figure caption is
lower case (except for first word and proper nouns); figures are numbered
consecutively.

Make sure the figure caption does not get separated from the figure. Leave
sufficient space to avoid splitting the figure and figure caption.

You may use color figures. However, it is best for the figure captions and the
paper body to make sense if the paper is printed either in black/white or in
color.

#figure(
```tex
\begin{figure}[h]
\begin{center}
%\framebox[4.0in]{$\;$}
\fbox{\rule[-.5cm]{0cm}{4cm} \rule[-.5cm]{4cm}{0cm}}
\end{center}
\end{figure}
```,
  kind: image,
  caption: [Sample figure caption.])

== Tables

All tables must be centered, neat, clean and legible. Do not use hand-drawn
tables. The table number and title always appear before the table. See
@sample-table. Place one line space before the table title, one line space
after the table title, and one line space after the table. The table title must
be lower case (except for first word and proper nouns); tables are numbered
consecutively.

#figure(```tex
\begin{table}[t]
\caption{Sample table title}
\begin{center}
\begin{tabular}{ll}
\multicolumn{1}{c}{\bf PART}  &\multicolumn{1}{c}{\bf DESCRIPTION}
\\ \hline \\
Dendrite         &Input terminal \\
Axon             &Output terminal \\
Soma             &Cell body (contains cell nucleus) \\
\end{tabular}
\end{center}
\end{table}
```,
  kind: table,
  caption: [Sample table title]) <sample-table>

= Default Notation

In an attempt to encourage standardized notation, we have included the notation
file from the textbook, _Deep Learning_ @goodfellow2016deep available at
#url("https://github.com/goodfeli/dlbook_notation/").  Use of this style is not
required and can be disabled by commenting out `math_commands.tex`.

#align(center, [*Numbers and Arrays*])
// \def\arraystretch{1.5}
#table(
  columns: (1in, 3.25in),
  $a$, [A scalar (integer or real)],
  $\va$, [A vector],
  $\mA$, [A matrix],
  $\tA$, [A tensor],
  $\mI_n$, [Identity matrix with $n$ rows and $n$ columns],
  $\mI$, [Identity matrix with dimensionality implied by context],
  $\ve^((i))$, [Standard basis vector $[0,dots,0,1,0,dots,0]$ with a 1 at position $i$],
  $op("diag")(\va)$, [A square, diagonal matrix with diagonal entries given by $\va$],
  $\ra$, [A scalar random variable],
  $serif(a)$, [A vector-valued random variable],
  $serif(A)$, [A matrix-valued random variable])
#v(0.25cm)

#align(center, [*Sets and Graphs*])
// \def\arraystretch{1.5}
#table(
  columns: (1in, 3.25in),
  $AA$, [A set],
  $RR$, [The set of real numbers],
  $\{0, 1\}$, [The set containing 0 and 1],
  $\{0, 1, dots, n \}$, [The set of all integers between $0$ and $n$],
  $[a, b]$, [The real interval including $a$ and $b$],
  $(a, b]$, [The real interval excluding $a$ but including $b$],
  $AA \\ BB$, [Set subtraction, i.e., the set containing the elements of $\sA$ that are not in $\sB$],
  $cal(G)$, [A graph],
  $op("parents")_cal(G)(serif(x)_i)$, [The parents of $serif(x)_i$ in $cal(G)$])
#v(0.25cm)

#align(center, [*Indexing*])
// \def\arraystretch{1.5}
#table(
  columns: (1in, 3.25in),
  $serif(a)_i$, [Element $i$ of vector $\va$, with indexing starting at 1],
  $serif(a)_(-i)$, [All elements of vector $\va$ except for element $i$],
  $serif(A)_(i, j)$, [Element $i, j$ of matrix $\mA$],
  $\mA_(i, :)$, [Row $i$ of matrix $\mA$],
  $\mA_(:, i)$, [Column $i$ of matrix $\mA$],
  $A_(i, j, k)$, [Element $(i, j, k)$ of a 3-D tensor $\tA$],
  $\tA_(:, :, i)$, [2-D slice of a 3-D tensor],
  $serif(a)_i$, [Element $i$ of the random vector $serif(a)$])
#v(0.25cm)

#align(center, [*Calculus*])
// \def\arraystretch{1.5}
#table(
  columns: (1in, 3.25in),
  $(d y) / (d x)$, [Derivative of $y$ with respect to $x$],
  $(diff y) / (diff x)$, [Partial derivative of $y$ with respect to $x$],
  $nabla_\vx y$, [Gradient of $y$ with respect to $\vx$],
  $nabla_\mX y$, [Matrix derivatives of $y$ with respect to $\mX$],
  $nabla_\tX y$, [Tensor containing derivatives of $y$ with respect to $\tX$],
  $(diff f) / (diff \vx}$, [Jacobian matrix $\mJ \in \R^{m times n}$ of $f: \R^n arrow.r \R^m$],
  $nabla_\vx^2 f(\vx) " or " \mH( f)(\vx)$, [The Hessian matrix of $f$ at input point $\vx$],
  $integral f(\vx) d\vx$, [Definite integral over the entire domain of $\vx$],
  $integral_SS f(\vx) d\vx$, [Definite integral with respect to $\vx$ over the set $\sS$])
#v(0.25cm)

#align(center, [*Probability and Information Theory*])
// \def\arraystretch{1.5}
#table(
  columns: (1in, 3.25in),
  $P(\ra)$, [A probability distribution over a discrete variable],
  $p(\ra)$, [A probability distribution over a continuous variable, or over a
  variable whose type has not been specified],
  $\ra \sim P$, [Random variable $\ra$ has distribution $P$], 
  // $\E_{\rx\sim P} [ f(x) ]\text{ or } \E f(x)$, [Expectation of $f(x)$ with respect to $P(\rx)$],
  // $\Var(f(x))$, [Variance of $f(x)$ under $P(\rx)$],
  // $\Cov(f(x),g(x))$, [Covariance of $f(x)$ and $g(x)$ under $P(\rx)$],
  // $H(\rx)$, [Shannon entropy of the random variable $\rx$],
  // $\KL ( P \Vert Q )$, [Kullback-Leibler divergence of P and Q],
  $cal(N)( \vx ; \vmu , \mSigma)$,
  [Gaussian distribution % over $\vx$ with mean $\vmu$ and covariance
  $\mSigma$])
#v(0.25cm)

#align(center, [*Functions*])
// \def\arraystretch{1.5}
#table(
  columns: (1in, 3.25in),
  $f: AA arrow.r BB$, [The function $f$ with domain $\sA$ and range $\sB$],
  $f dot.c g $, [Composition of the functions $f$ and $g$],
  $f(\vx ; \vtheta) $,
  [A function of $\vx$ parametrized by $\vtheta$. (Sometimes we write $f(\vx)$
  and omit the argument $\vtheta$ to lighten notation)],
  $log(x)$, [Natural logarithm of $x$],
  $sigma(x)$, [Logistic sigmoid, $1 / (1 + exp(-x))$],
  $zeta(x)$, [Softplus, $log(1 + exp(x))$],
  $|| \vx ||_p $, [$L^p$ norm of $\vx$],
  $|| \vx || $, [$L^2$ norm of $\vx$],
  $x^+$, [Positive part of $x$, i.e., $max(0,x)$],
  $\1_sans("condition")$, [is 1 if the condition is true, 0 otherwise])
#v(0.25cm)

= Final instructions

Do not change any aspects of the formatting parameters in the style files. In
particular, do not modify the width or length of the rectangle the text should
fit into, and do not change font sizes (except perhaps in the *References*
section; see below). Please note that pages should be numbered.

= Preparing PostScript or PDF files

Please prepare PostScript or PDF files with paper size "US Letter", and not,
for example, "A4". The -t letter option on dvips will produce US Letter files.

Consider directly generating PDF files using `pdflatex` (especially if you are
a MiKTeX user). PDF figures must be substituted for EPS figures, however.

Otherwise, please generate your PostScript and PDF files with the following
commands:

```shell
dvips mypaper.dvi -t letter -Ppdf -G0 -o mypaper.ps
ps2pdf mypaper.ps mypaper.pdf
```

== Margins in LaTeX

Most of the margin problems come from figures positioned by hand using
`\special` or other commands. We suggest using the command `\includegraphics`
from the graphicx package. Always specify the figure width as a multiple of the
line width as in the example below using .eps graphics

```tex
   \usepackage[dvips]{graphicx} ...
   \includegraphics[width=0.8\linewidth]{myfile.eps}
```

or % Apr 2009 addition

```tex
   \usepackage[pdftex]{graphicx} ...
   \includegraphics[width=0.8\linewidth]{myfile.pdf}
```

for .pdf graphics. See section~4.4 in the graphics bundle documentation
(#url("http://www.ctan.org/tex-archive/macros/latex/required/graphics/grfguide.ps")

A number of width problems arise when #LaTeX cannot properly hyphenate a line.
Please give LaTeX hyphenation hints using the `\-` command.

=== Broader Impact Statement

In this optional section, TMLR encourages authors to discuss possible
repercussions of their work, notably any potential negative impact that a user
of this research should be aware of. Authors should consult the TMLR Ethics
Guidelines available on the TMLR website for guidance on how to approach this
subject.

=== Author Contributions

If you'd like to, you may include a section for author contributions as is done
in many journals. This is optional and at the discretion of the authors. Only
add this information once your submission is accepted and deanonymized. 

=== Acknowledgments

Use unnumbered third level headings for the acknowledgments. All
acknowledgments, including those to funding agencies, go at the end of the
paper. Only add this information once your submission is accepted and
deanonymized. 

// \bibliography{main}
// \bibliographystyle{tmlr}

= Appendix

You may include other additional sections here.
