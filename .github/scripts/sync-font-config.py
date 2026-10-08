#!/usr/bin/env python3
"""Vendor the shared font helpers into the templates that use them."""

import argparse
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
VENUES = ('icml', 'iclr', 'cvpr', 'jmlr', 'rlj')

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--check', action='store_true',
                    help='report stale copies without changing files')
args = parser.parse_args()


def main():
    source = (ROOT / 'common/font-config.typ').read_bytes()
    stale = []
    for venue in VENUES:
        target = ROOT / venue / 'font-config.typ'
        if target.is_file() and target.read_bytes() == source:
            continue
        if args.check:
            stale.append(str(target.relative_to(ROOT)))
        else:
            target.write_bytes(source)
    if stale:
        parser.exit(1, 'Stale font helpers: ' + ', '.join(stale)
                    + '\nRun python3 .github/scripts/sync-font-config.py\n')


if __name__ == '__main__':
    main()
