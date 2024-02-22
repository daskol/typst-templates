# Neural Information Processing Systems (NeurIPS) 2024

## Example Papers

Here are an example paper in [LaTeX][1] and in [Typst][2].

## Issues

- The biggest and the most important issues is related to line ruler. We are
  not aware of universal method for numbering lines in the main body of a
  paper.

- There is an issue in Typst with spacing between figures and between figure
  with floating placement. The issue is that there is no way to specify gap
  between subsequent figures. In order to have behaviour similar to original
  LaTeX template, one should consider direct spacing adjacemnt with `v(-1em)`
  as follows.

  ```typst
  #figure(
    rect(width: 4.25cm, height: 4.25cm, stroke: 0.4pt),
    caption: [Sample figure caption.#v(-1em)],
    placement: top,
  )
  #figure(
    rect(width: 4.25cm, height: 4.25cm, stroke: 0.4pt),
    caption: [Sample figure caption.],
    placement: top,
  )
  ```

- Another issue is related to Typst's inablity to produce colored annotation.
  In order to mitigte the issue, we add a script which modifies annotations and
  make them colored.

  ```shell
  ../colorize-annotations.py \
      example-paper.typst.pdf example-paper-colored.typst.pdf
  ```

  See [README.md][3] for details.

[1]: example-paper.latex.pdf
[2]: example-paper.typst.pdf
[3]: ../#colored-annotations
