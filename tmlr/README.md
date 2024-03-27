- While author instruction says the all text should be in sans serif font
  Computer Modern Bright, only headers and titles are in sans font Computer
  Modern Sans and the rest of text is causal Computer Modern Serif (or Roman).
  To be precice, the original template uses Latin Modern, a descendant of
  Computer Modern. In this tempalte we stick to CMU (Computer Modern Unicode)
  font family.
- In the original template paper, the word **Abstract** is of large font size
  (12pt) and bold. This affects slightly line spacing. We don't know how to
  adjust Typst to reproduce this feature of the reference template but this
  issue does not impact a lot on visual appearence and layouting.
- In the original template special level-3 sections like "Author Contributions"
  or "Acknowledgements" are not added to outline. We add them to outline as
  level-1 header but still render them as level-3 headers.
- ICML-like bibliography style. In this case, the bibliography slightly differs
  from the one in the original example paper. The main difference is that we
  prefer to use author's lastname at first place to search an entry faster.
- In the original template a lot of vertical space is inserted before and after
  graphics and table figures. It is unclear why so much space are inserted. We
  belive that the reason is how Typst justify content verticaly. Nevertheless,
  we append a page break after "Default Notation" section in order to show that
  spacing does not differ visually.
