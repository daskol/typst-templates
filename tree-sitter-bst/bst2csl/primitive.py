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

from collections import defaultdict
from dataclasses import dataclass
from io import StringIO
from itertools import count
from string import ascii_lowercase
from typing import IO, Any, Callable

WriteFn = Callable[['Primitive', IO, list[Any], list[Any], str], None]


def write_default(prim: 'Primitive', fp: IO, inputs: list[Any],
                  outputs: list[Any], indent: str = ''):
    names = (ascii_lowercase[i] for i in count())
    inames = [next(names) for _ in inputs]
    if len(outputs) > 0:
        onames = [next(names) for _ in outputs]
        parts = onames
        parts.append('=')
    else:
        parts = []
    parts.append(prim.name)
    parts.extend(inames)
    fp.write(indent)
    fp.write(' '.join(parts))


@dataclass(slots=True, frozen=True)
class Primitive:
    """Represents an abstract arrow."""

    name: str

    arity: int = 1  # TODO(@daskol): Rework this.

    _write: WriteFn = write_default

    def __hash__(self) -> int:
        return id(self)

    def __str__(self) -> str:
        buf = StringIO()
        self.write(buf, [], [])
        return buf.getvalue()

    def def_simple_eval(self, fn: Callable[..., Any]):
        TABLE[self] = fn
        return fn

    def def_greedy_eval(self, fn: Callable[..., Any]):
        TABLE_GREEDY[self] = fn
        return fn

    def def_write(self, fn: WriteFn):
        self._write = fn

    def register(self, fn_or_ip: str | Callable):
        if callable(fn_or_ip):
            raise NotImplementedError

        def deco(fn: Callable) -> Callable:
            impls = PRIMITIVE_IMPLEMENTATIONS[fn_or_ip]
            if self in impls:
                raise KeyError(
                    f'Interpreter already has implementation for {fn}.')
            impls[self] = fn
            return fn

        return deco

    def resolve(self, ip: str) -> Callable | None:
        return PRIMITIVE_IMPLEMENTATIONS[ip].get(self)

    def write(self, fp: IO, inputs: list[Any], outputs: list[Any], indent=''):
        return self._write(self, fp, inputs, outputs, indent)


PRIMITIVE_IMPLEMENTATIONS = defaultdict[str, dict[Primitive, Callable]](dict)


# TODO(@daskol): Remove legacy approach.
TABLE: dict[Primitive, callable] = {}
TABLE_GREEDY: dict[Primitive, callable] = {}


call_p = Primitive('call')
const_p = Primitive('const')  # Special primitive (intrinsic) for values.
resolve_p = Primitive('resolve')  # Special primitive (intrinsic) for symbols.
assign_p = Primitive(':=', 2)
equal_p = Primitive('=', 2)
add_p = Primitive('+', 2)
sub_p = Primitive('-', 2)
mul_p = Primitive('*', 2)
cond_p = Primitive('if', 3)
empty_p = Primitive('empty')
duplicate_p = Primitive('duplicate')
pop_p = Primitive('pop')
skip_p = Primitive('skip', 0)
write_p = Primitive('write')
add_period_p = Primitive('add_period')
newline_p = Primitive('newline', 0)
