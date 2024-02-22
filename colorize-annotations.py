#!/usr/bin/env python
"""Simple script based on MuPDF bindings for colorizing annotation in documents
produced by Typst v0.10.0 (or may be newer).
"""

from argparse import ArgumentParser, Namespace
from dataclasses import astuple, dataclass
from os import unlink
from pathlib import Path
from shutil import move
from tempfile import NamedTemporaryFile
from typing import Any, Self

import fitz
from fitz import Document, Page

DEFAULT_STROKE_CYAN = (0.0, 1.0, 1.0)

DEFAULT_STROKE_RED = (1.0, 0.0, 0.0)

parser = ArgumentParser(description=__doc__)
parser.add_argument('source', type=Path, help='path to original document')
parser.add_argument('target', type=Path, help='path to output document')


@dataclass
class Point:

    x: float

    y: float

    def __add__(self, other: Self) -> Self:
        return self.__class__(self.x + other.x, self.y + other.y)

    def __iadd__(self, other: Self) -> Self:
        self.x += other.x
        self.y += other.y
        return self


@dataclass
class Rect:

    top_left: Point

    bot_right: Point

    @classmethod
    def from_points(cls, x0: float, y0: float, x1: float, y1: float) -> Self:
        return cls(Point(x0, y0), Point(x1, y1))

    @classmethod
    def from_postscript(cls, value: str) -> Self:
        points = [float(x) for x in value[1:-1].split()]
        return cls.from_points(*points)

    def __add__(self, other) -> Self:
        return self.__class__(self.top_left + other.top_left,
                              self.bot_right + other.bot_right)

    def __iadd__(self, other) -> Self:
        self.top_left += other.top_left
        self.bot_right += other.bot_right
        return self

    def to_points(self) -> tuple[float, float, float, float]:
        return astuple(self.top_left) + astuple(self.bot_right)

    def to_postscript(self) -> str:
        points = self.to_points()
        coords = ' '.join(f'{point:g}' for point in points)
        return f'[{coords}]'


DEFAULT_SPACING = Rect.from_points(-0.5, -2.5, 0.5, 1.5)


@dataclass
class Style:

    stroke: tuple[float, float, float]

    spacing: Rect


DEFAULT_STYLES = {
    'external': Style(stroke=DEFAULT_STROKE_CYAN, spacing=DEFAULT_SPACING),
    'internal': Style(stroke=DEFAULT_STROKE_RED, spacing=DEFAULT_SPACING),
}


def enumerate_links(doc: Document):
    page: Page
    for ix, page in enumerate(doc):
        for link in page.get_links():
            yield ix, page, link


def colorize_link(doc: Document, link: dict[str, Any], styles=None):
    # If there is no valid xref then it is embedded annotation. Skip it.
    if (xref := link['xref']) is None or xref <= 0:
        return

    styles = styles or DEFAULT_STYLES
    if 'uri' in link:
        style = styles['external']
    else:
        style = styles['internal']

    stroke_str = ' '.join(f'{x:g}' for x in style.stroke)
    doc.xref_set_key(xref, 'H', '/I')
    doc.xref_set_key(xref, 'C', f'[{stroke_str}]')
    doc.xref_set_key(xref, 'BS', '<< /W 1 /S /S >>')

    # Adjust bounding box of annotation.
    type_, value = doc.xref_get_key(xref, 'Rect')
    if type_ != 'array':
        print(f'Attribute `Rect` of xref={xref} is not array.')
        return
    rect = Rect.from_postscript(value)
    rect += style.spacing
    doc.xref_set_key(xref, 'Rect', rect.to_postscript())


def colorize(source: Path, target: Path, styles=None):
    doc: Document = fitz.open(source)

    # Enumerate all available links and create new link with the same
    # attributes. The issue is that Typst writes embeddable annotations which
    # does not have xref. This makes impossible to modify annotation attributes
    # inplace.
    for _, page, link in enumerate_links(doc):
        new_link = {**link}
        new_link.pop('xref', None)
        new_link.pop('zoom', None)
        new_link.pop('id', None)
        page.insert_link(new_link)

    # As we duplicated annotations, we can update their appearence.
    total_pages = len(doc)
    for ix, page in enumerate(doc, 1):
        print(f'{ix}/{total_pages}: {page}')
        for link in page.links():
            colorize_link(doc, link, styles)

    # If source and target pathes are equal then write to temporary and then
    # replace the original one.
    if target != source:
        target.parent.mkdir(exist_ok=True, parents=True)
        doc.save(target, garbage=3, deflate=True)
        doc.close()
    else:
        prefix = '.' + target.name.removesuffix('.pdf') + '-'
        with NamedTemporaryFile(mode='w', dir=target.parent, prefix=prefix,
                                suffix='.pdf', delete=False) as tempfile:
            unlink(tempfile.name)
            doc.save(tempfile.name, garbage=3, deflate=True)
            doc.close()
            move(tempfile.name, source)  # Copy back.


def main():
    ns: Namespace = parser.parse_args()
    colorize(ns.source, ns.target)


if __name__ == '__main__':
    main()
