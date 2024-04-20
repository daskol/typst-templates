# Conference on Computer Vision and Pattern Recognition (CVPR)

## Issues

- In case of US Letter, column sizes + gap does not equals to text width (2 *
  3.25 + 5/16 != 6 + 7/8). It seems that correct gap should be 3/8.

- At the moment of Typst v0.11.0, it is impossible to indent the first paragraph
  in a section (see [typst/typst#311][2]). The workaround is to add indentation
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

+ CVPR 2022 conference [web site][1].

[1]: https://cvpr2022.thecvf.com/author-guidelines#dates
[2]: https://github.com/typst/typst/issues/311
