#!/usr/bin/env python3
"""This is a simple script (aka build system) to prepare releases of Typst
packages.
"""

import json
from tempfile import NamedTemporaryFile
from os import getenv
from shutil import copyfile
import re
import tomllib
from argparse import ArgumentParser, Namespace
from pathlib import Path
from subprocess import PIPE, run
from typing import IO

parser = ArgumentParser(description=__doc__)
parser.add_argument('--index-dir', type=Path, default=Path('index'),
                    help='root of typst/packages repo')
parser.add_argument('--typst', type=Path, default=Path('typst'),
                    help='typst compiler to use')
parser.add_argument('template_dir', type=Path, nargs='?',
                    help='prepare release to specific template')


def find_template_dirs(root_dir: Path) -> dict[str, Path]:
    paths = {}
    for path in root_dir.glob('*/main.typ'):
        paths[path.parent.name] = path.parent
    return paths


def dist_template(base_dir: Path, index_dir: Path, compiler='typst'):
    with open(base_dir / 'typst.toml', 'rb') as fin:
        desc = tomllib.load(fin)

    package_name = desc['package']['name']
    version = desc['package']['version']

    output_dir = index_dir / 'packages/preview' / package_name / version
    output_dir.mkdir(exist_ok=True, parents=True)

    template_dir = output_dir / desc['template']['path']
    template_dir.mkdir(exist_ok=True, parents=True)
    template_entrypoint = base_dir / desc['template']['entrypoint']
    template_path = template_dir / 'main.pdf'

    cmd = (compiler, 'compile', '--deps=-', '--diagnostic-format=short',
           f'--root={base_dir}', str(template_entrypoint), str(template_path))
    proc = run(cmd, stdout=PIPE)
    proc.check_returncode()

    all_deps = json.loads(proc.stdout)
    curr_dir = Path.cwd()
    paths = [curr_dir / x for x in all_deps['inputs']]
    package_files, template_files = filter_template_files(
        paths, template_entrypoint)
    package_files.append(base_dir / 'README.md')
    package_files.append(base_dir / 'typst.toml')

    # Copy package files.
    for path in package_files:
        src = path.relative_to(curr_dir)
        dst = output_dir / path.relative_to(base_dir)
        print(f'copy:    {src} -> {dst}')
        copyfile(src, dst)

    # Copy template files.
    for path in template_files:
        src = path.relative_to(curr_dir)
        dst = template_dir / path.relative_to(base_dir)

        if path.suffix != '.typ':
            print(f'copy:    {src} -> {dst}')
            copyfile(path, dst)
            continue

        with open(src) as fin, open(dst, 'w') as fout:
            print(f'rewrite: {src} -> {dst}')
            fix_template_import(fin, fout, desc['package']['entrypoint'],
                                package_name, version)

    # Render thumbnail.
    thumbnail_path = output_dir / desc['template']['thumbnail']
    print(f'render:  {template_entrypoint} -> {thumbnail_path}')
    render_thumbnail(template_path, thumbnail_path)


def filter_template_files(paths: list[Path], entrypoint: Path):
    package_files = []
    template_files = []
    for path in paths:
        if path.suffix == '.bib':
            template_files.append(path)
        elif path == entrypoint:
            template_files.append(path)
        elif path.name == 'logo.typ':  # Make a util package.
            template_files.append(path)
        elif path.name in ('appendix.typ', 'checklist.typ',
                           'supplementary.typ'):
            template_files.append(path)
        elif path.is_relative_to(package_cache_dir):
            pass
        else:
            package_files.append(path)
    return package_files, template_files


def fix_template_import(fin: IO, fout: IO, entrypoint: str, name: str,
                        version: str):
    entrypoint = re.escape(entrypoint)
    pattern = re.compile(rf'(?P<prefix>^.*)\"\/?{entrypoint}\"(?P<suffix>.*$)')

    import_name = f'@preview/{name}:{version}'
    repl = rf'\g<prefix>"{import_name}"\g<suffix>'

    for line in fin:
        line = pattern.sub(repl, line)
        fout.write(line)


def render_thumbnail(pdf_path: Path, png_path: Path):
    # Because of buggy `inkscape`, we render pdf to a temporary file.
    with NamedTemporaryFile(prefix='thumbnail', suffix='.png') as temp:
        cmd = ('inkscape', str(pdf_path), '--export-page=1',
               '--export-type=png', f'--export-filename={temp.name}',
               '--export-area-page', '--export-dpi=288',
               '--export-background=white', '--export-background-opacity=1')
        proc = run(cmd, capture_output=True)
        proc.check_returncode()

        proc = run(['oxipng', temp.name], capture_output=True)
        proc.check_returncode()

        copyfile(temp.name, png_path)
        pdf_path.unlink(missing_ok=True)


def main() -> None:
    ns: Namespace = parser.parse_args()

    global package_cache_dir
    package_cache_dir = Path.home() / '.cache/typst/packages'
    if (val := getenv('TYPST_PACKAGE_PATH')) is not None:
        package_cache_dir = Path(val)
    if (val := getenv('TYPST_PACKAGE_CACHE_PATH')) is not None:
        package_cache_dir = Path(val)

    index_dir: Path = ns.index_dir
    root_dir = Path(__file__).parent

    if (template_dir := ns.template_dir) is not None:
        base_dir: Path = Path.cwd() / template_dir
        dist_template(base_dir, index_dir, compiler=str(ns.typst))
    else:
        template_dirs = find_template_dirs(root_dir)
        for name, base_dir in template_dirs.items():
            print(f'processing {name}')
            dist_template(base_dir, index_dir, compiler=str(ns.typst))


if __name__ == '__main__':
    main()
