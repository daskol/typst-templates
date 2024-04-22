# Conference on Computer Vision and Pattern Recognition (CVPR)

## Usage

You can use this template in the Typst web app by clicking _Start from
template_ on the dashboard and searching for `blind-cvpr`.

Alternatively, you can use the CLI to kick this project off using the command

```shell
typst init @preview/blind-cvpr
```

Typst will create a new directory with all the files needed to get you started.

## Example Papers

Here are an example paper in [LaTeX][1] and in [Typst][2].

## Configuration

This template exports the `cvpr2022` function with the following named
arguments.

- `title`: The paper's title as content.
- `authors`: An array of author dictionaries. Each of the author dictionaries
  must have a name key and can have the keys department, organization,
  location, and email.
- `keywords`: Publication keywords (used in PDF metadata).
- `date`: Creation date (used in PDF metadata).
- `abstract`: The content of a brief summary of the paper or none. Appears at
  the top under the title.
- `bibliography`: The result of a call to the bibliography function or none.
  The function also accepts a single, positional argument for the body of the
  paper.
- `appendix`: Content to append after bibliography section.
- `accepted`: If this is set to `false` then anonymized ready for submission
  document is produced; `accepted: true` produces camera-redy version. If
  the argument is set to `none` then preprint version is produced (can be
  uploaded to arXiv).
- `id`: Identifier of a submission.

The template will initialize your package with a sample call to the `cvpr2022`
function in a show rule. If you want to change an existing project to use this
template, you can add a show rule at the top of your file.

## Issues

- In case of US Letter, column sizes + gap does not equals to text width (2 *
  3.25 + 5/16 != 6 + 7/8). It seems that correct gap should be 3/8.

- At the moment of Typst v0.11.0, it is impossible to indent the first paragraph
  in a section (see [typst/typst#311][3]). The workaround is to add indentation
  manually as follows.

  ```typst
  == H2

  #h(12pt)  Manually as space for the first paragraph.
  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.

  // The second one is just fine.
  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do.
  ```

  Also, we add `indent` constant as a shortcut for `h(12pt)`.

- At the moment Typst v0.11.0 does not allow flexible customization of citation
  styles. Specifically, CVPR 2022 citation lookes like `[42]` where number is
  colored hyperlink. In order to achive this, we shouuld provide custom
  CSL-style and then colorize number and put it into square parenthesis in
  typst markup.


## References

+ CVPR 2022 conference [web site][4].

[1]: example-paper.latex.pdf
[2]: example-paper.typst.pdf
[3]: https://github.com/typst/typst/issues/311
[4]: https://cvpr2022.thecvf.com/author-guidelines#dates
