# Typst: Templates

*A curated list of paper templates in the area of machine learning.*

## Overview

Some conferences and journals in machine learning allow submissions in PDF
without special requirement to use LaTeX. They also provides a template and an
example paper in LaTeX. With official author instructions, these materials
enable us to make our own template in Typst mark up language. We start with
template for ICML and are going to add templates for other conferences and
journals during calendar year.

- [International Conference on Machine Learning (ICML)](icml).
- [Neural Information Processing System (NeurIPS)](neurips).
- International Conference on Learning Representations (ICLR).
- Association for the Advancement of Artificial Intelligence (AAAI).

## Utilities

Typst of version 0.10.0 does not produce colored annotations. In order to
mitigate the issue, we add [a simple script](colorize-annotations.py) to the
repository. The script is plain and simple. One can use it as follows.

```shell
./colorize-annotations.py \
    neurips/example-paper.typst.pdf neurips/example-paper-colored.typst.pdf
```

It is written with PyMuPDF library and inserts colored annotation.
