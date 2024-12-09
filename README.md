# Typst: Templates

*A curated list of paper templates in the area of machine learning.*

## Overview

Some conferences and journals in machine learning allow submissions in PDF
without special requirement to use LaTeX. They also provides a template and an
example paper in LaTeX. With official author instructions, these materials
enable us to make our own template in Typst mark up language. We start with
template for ICML and are going to add templates for other [Core A\*][1]
conferences and journals during next calendar years. The fields of research is
below.

- Artificial intelligence (4602).
- Computer vision and multimedia computation (4603).
- Data management and data science (4605).
- Machine learning (4611).

The list of A* conferences of the fields given follows.

- ACM International Conference on Computer Graphics and Interactive Techniques
  (SIGGRAPH).
- ACM International Conference on Knowledge Discovery and Data Mining (KDD).
- ACM International World Wide Web Conference (WWW).
- Association for Computational Linguistics (ACL).
- Association for the Advancement of Artificial Intelligence (AAAI).
- Conference on Learning Theory (COLT).
- Empirical Methods in Natural Language Processing (EMNLP).
- European Conference on Computer Vision (ECCV).
- [IEEE Conference on Computer Vision and Pattern Recognition (CVPR)](cvpr).
- IEEE International Conference on Computer Vision (ICCV).
- International Conference on Automated Planning and Scheduling (ICAPS).
- [International Conference on Learning Representations (ICLR)](iclr).
- International Joint Conference on Artificial Intelligence (IJCAI).
- International World Wide Web Conference (WWW).
- [International Conference on Machine Learning (ICML)](icml).
- International Conference on the Principles of Knowledge Representation and
  Reasoning (KR).
- International Joint Conference on Artificial Intelligence (IJCAI).
- International Joint Conference on Autonomous Agents and Multiagent Systems
  (AAMAS).
- [Neural Information Processing System (NeurIPS)](neurips).

Additionally, we are going to provide templates for popular machine learning
scientific journals as well.

- [Journal of Machine Learning Research (JMLR)](jmlr).
- [Reinforcement Learning Conference/Journal (RLC/RLJ)](rlj).
- [Transactions on Machine Learning Research (TMLR)](tmlr).

## Usage

You can use this template in the [Typst][2] WebApp by clicking _Start from
template_ on the dashboard and searching for a template (e.g. `lucky-icml`).

Alternatively, you can use the CLI to kick this project off using the command

```shell
typst init @preview/lucky-icml
```

## Utilities

Typst of version 0.10.0 does not produce colored annotations. In order to
mitigate the issue, we add [a simple script](colorize-annotations.py) to the
repository. The script is plain and simple. One can use it as follows.

```shell
./colorize-annotations.py \
    neurips/example-paper.typst.pdf neurips/example-paper-colored.typst.pdf
```

It is written with PyMuPDF library and inserts colored annotation.

[1]: https://portal.core.edu.au/conf-ranks/?search=A*&by=rank&source=CORE2023&sort=aacronym
[2]: https://typst.app/
