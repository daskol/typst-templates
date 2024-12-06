## Issues

1. Vertical space between "Abstract" and abstract is `10pt - 1.5ex` but some
   stretching and shrinking are possible.
2. Figures, specifically @fig:example, allows a lot of stretching and shrinking
   of space above and below figure. Typst can not do such transformations at
   the moment. Thus we manually shrink spaces around the first example figure
   in order to preset pixel perfect template.
