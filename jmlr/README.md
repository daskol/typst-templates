# Journal of Machine Learning Research(JMLR)

## Overview

This is a Typst template for Journal of Machine Learning Research (JMLR). It is
based on official [author guide][1], [formatting instructions][2], and
[formatting error checklist][3] as well as the official [example paper][4].

## Usage

You can use this template in the Typst web app by clicking _Start from
template_ on the dashboard and searching for `classic-jmlr`.

Alternatively, you can use the CLI to kick this project off using the command

```shell
typst init @preview/classic-jmlr
```

Typst will create a new directory with all the files needed to get you started.

## Example Papers

Here are an example paper in [LaTeX][5] and in [Typst][6].

## Configuration

This template exports the `jmlr` function with the following named arguments.

- `title`: The paper's title as content.
- `short-title`: Paper short title (for page header).
- `authors`: An array of author dictionaries. Each of the author dictionaries
  must have a name key and can have the keys department, organization,
  location, and email.
- `last-names`: List of authors last names (for page header).
- `keywords`: Publication keywords (used in PDF metadata).
- `date`: Creation date (used in PDF metadata).
- `abstract`: The content of a brief summary of the paper or none. Appears at
  the top under the title.
- `bibliography`: The result of a call to the bibliography function or none.
  The function also accepts a single, positional argument for the body of the
  paper.
- `appendix`: Content to append after bibliography section.
- `pubdata`: Dictionary with auxiliary information about publication. It
  contains editor name(s), paper id, volume, and submission/review/publishing
  dates.

The template will initialize your package with a sample call to the `jmlr`
function in a show rule. If you want to change an existing project to use this
template, you can add a show rule at the top of your file.

```typst
#import "@preview/classic-jmlr": jmlr
#show: jmlr.with(
  title: [Sample JMLR Paper],
  authors: (authors, affls),
  abstract: blindtext,
  keywords: ("keyword one", "keyword two", "keyword three"),
  bibliography: bibliography("main.bib"),
  appendix: include "appendix.typ",
  pubdata: (
    id: "21-0000",
    editor: "My editor",
    volume: 23,
    submitted-at: datetime(year: 2021, month: 1, day: 1),
    revised-at: datetime(year: 2022, month: 5, day: 1),
    published-at: datetime(year: 2022, month: 9, day: 1),
  ),
)
```

## Issues

- JMLR example paper is not not representative.

- Leading in author affilations in in the original template is varying.

- There is no bibliography CSL-style. The closest one is
  `bristol-university-press`.

- Another issue is related to Typst's inablity to produce colored annotation.
  In order to mitigte the issue, we add a script which modifies annotations and
  make them colored.

  ```shell
  ../colorize-annotations.py \
      example-paper.typst.pdf example-paper-colored.typst.pdf
  ```

  See [README.md][7] for details.

[1]: https://www.jmlr.org/format/authors-guide.html
[2]: https://www.jmlr.org/format/format.html
[3]: https://www.jmlr.org/format/formatting-errors.html
[4]: https://github.com/jmlrorg/jmlr-style-file
[5]: example-paper.latex.pdf
[6]: example-paper.typst.pdf
[7]: ../#colored-annotations
