/**
 * font-config.typ
 *
 * Font configuration helpers.
 */

// Default font sizes from original LaTeX style file.
#let font-defaults = (
  tiny:         7pt,
  scriptsize:   7pt,
  footnotesize: 9pt,
  small:        9pt,
  normalsize:   10pt,
  large:        14pt,
  Large:        16pt,
  LARGE:        20pt,
  huge:         23pt,
  Huge:         28pt,
)

// We prefer to use Times New Roman when ever it is possible.
#let font-family = (
  "Times New Roman",
  "Liberation Serif",
  "Nimbus Roman",
  "TeX Gyre Termes",
)

#let font-size = (
  Large: font-defaults.Large,
  footnote: font-defaults.footnotesize,
  large: font-defaults.large,
  small: font-defaults.small,
  normal: font-defaults.normalsize,
  script: font-defaults.scriptsize,
)

#let font-config-default() = (
  family: (serif: font-family),
  size: font-size + (
    title: 17pt,
    section: 12pt,
    abstract-title: 12pt,
    notice: 9pt,
    line-number: 7pt,
  ),
)

#let font-config-merge(font-config, aux: (:)) = {
  let fc = font-config-default()

  // Compatibility path for older calls:
  //   aux: (font: (family: ("Times New Roman", ...)))
  if "font" in aux and "family" in aux.font {
    let family = aux.font.family
    if type(family) == dictionary {
      fc.family = fc.family + family
    } else {
      fc.family.insert("serif", family)
    }
  }

  if "family" in font-config {
    fc.family = fc.family + font-config.family
  }
  if "size" in font-config {
    fc.size = fc.size + font-config.size
  }

  return fc
}
