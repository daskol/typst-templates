/**
 * Shared font configuration helpers. Venue defaults belong to the template.
 *
 * 1. Edit common/font-config.typ.
 * 2. Sync copies with .github/scripts/sync-font-config.py.
 */

#let ensure-font-family(value) = {
  assert(type(value) == dictionary,
    message: "aux.font-family must be a dictionary")
  let family = (:)
  for (kind, fonts) in value {
    let fonts = if type(fonts) == str { (fonts,) } else { fonts }
    let option = "aux.font-family." + kind
    assert(type(fonts) == array,
      message: option + " must be a string or an array of strings")
    assert(fonts.len() > 0,
      message: option + " must contain at least one font")
    for font in fonts {
      assert(type(font) == str and font.trim() != "",
        message: option + " must contain nonempty font names")
    }
    family.insert(kind, fonts)
  }
  return family
}

#let ensure-font-size(value) = {
  assert(type(value) == dictionary,
    message: "aux.font-size must be a dictionary")
  for (name, size) in value {
    assert(type(size) == length,
      message: "aux.font-size." + name + " must be a length")
  }
  return value
}

#let ensure-font-config(value) = {
  assert(type(value) == dictionary,
    message: "font config must be a dictionary")
  assert(value.len() == 2 and "family" in value and "size" in value,
    message: "font config must contain family and size dictionaries")
  return (
    family: ensure-font-family(value.family),
    size: ensure-font-size(value.size),
  )
}

#let font-config-merge(defaults, family: (:), size: (:)) = {
  let fc = ensure-font-config(defaults)
  let family = ensure-font-family(family)
  let size = ensure-font-size(size)
  for kind in family.keys() {
    assert(kind in fc.family,
      message: "unsupported font option: aux.font-family." + kind)
  }
  for name in size.keys() {
    assert(name in fc.size,
      message: "unsupported font option: aux.font-size." + name)
  }
  return (family: fc.family + family, size: fc.size + size)
}
