from io import StringIO
from pathlib import Path

from publish import filter_template_files, fix_template_import

INPUT = """\
#import "/neurips.typ": botrule, midrule, neurips2025, paragraph, toprule, url
#import "/logo.typ": LaTeX, LaTeXe, TeX
"""

OUTPUT = """\
#import "@preview/bloated-neurips:0.7.0": botrule, midrule, neurips2025, paragraph, toprule, url
#import "/logo.typ": LaTeX, LaTeXe, TeX
"""


def test_filter_template_files():
    files = [
        'iclr/logo.typ', 'iclr/main.typ', 'iclr/main.bib', 'iclr/iclr.csl',
        'iclr/iclr2025.typ'
    ]
    entrypoint = Path(files[1])
    paths = [Path(x) for x in files]
    pack, temp = filter_template_files(paths, entrypoint)

    assert len(temp) == 3
    assert entrypoint in temp
    assert paths[0] in temp
    assert paths[2] in temp

    assert len(pack) == 2
    assert paths[3] in pack
    assert paths[4] in pack


def test_fix_template_import():
    buf = StringIO()
    buf.write(INPUT)
    buf.seek(0)

    actual = StringIO()
    fix_template_import(buf, actual, 'neurips.typ', 'bloated-neurips', '0.7.0')

    actual.seek(0)
    assert actual.getvalue() == OUTPUT
