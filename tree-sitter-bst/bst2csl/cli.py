# Copyright 2025 Daniel Bershatsky
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""TBD"""

from argparse import ArgumentParser, Namespace
from pathlib import Path

parser = ArgumentParser(description=__doc__)
parser.add_argument('-a', '--arg', type=str, default=[], action='append',
                    help='function to call')
parser.add_argument('-f', '--func', type=str, help='function to call')
parser.add_argument('path', type=Path, help='path to bst-file')


def compile_(path: Path, func: str | None = None, args=[]):
    from bst2csl.module import Module
    m = Module.from_path(path)
    for i, name in enumerate(m.list_functions()):
        fn = m.get_function(name)
        print(f'{i: 3d} {name}')
    print('functions:', m.list_functions())
    print('module:   ', m)

    if func is not None:
        fn = m.get_function(func)
        from bst2csl.ip.stack import evaluate
        stack = []
        for arg in args:
            try:
                val = int(arg)
            except ValueError:
                val = arg
            stack.append(val)
        stack = evaluate(fn.expr, stack)
        print(stack)


def main() -> None:
    ns: Namespace = parser.parse_args()
    compile_(ns.path, ns.func, ns.arg)
