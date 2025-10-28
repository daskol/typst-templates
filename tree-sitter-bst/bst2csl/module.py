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

from dataclasses import dataclass, field
from io import StringIO
from itertools import count
from pathlib import Path
from string import ascii_lowercase
from typing import IO, Any, Callable, Self

from tree_sitter import Language, Node, Parser
from tree_sitter_bst import language

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


@dataclass(slots=True)
class Primitive:

    name: str

    arity: int = 1

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

    def def_write(self, fn: WriteFn):
        self._write = fn

    def write(self, fp: IO, inputs: list[Any], outputs: list[Any], indent=''):
        return self._write(self, fp, inputs, outputs, indent)


class SimpleUntyped:

    def process(self, prim: Primitive, inputs, *args, **kwargs):
        if (eval_fn := TABLE.get(prim)) is None:
            raise RuntimeError(
                f'Missing abstract evaluation function for primitive {prim}.')
        return eval_fn(*inputs)


TABLE: dict[Primitive, callable] = {}


VM = [SimpleUntyped()]

def bind(prim: Primitive, *args, **kwargs) -> tuple:
    vm = VM[-1]
    return vm.process(prim, *args, **kwargs)


const = Primitive('const')  # XXX
call = Primitive('call')  # XXX

assign_p = Primitive(':=', 2)


@assign_p.def_simple_eval
def assign(x, y):
    return ()


equal_p = Primitive('=', 2)
add_p = Primitive('+', 2)
sub_p = Primitive('-', 2)
mul_p = Primitive('*', 2)


@equal_p.def_simple_eval
def equal(lhs, rhs):
    return (Variable(None), )


@mul_p.def_simple_eval
def mul(x, y):
    return (Variable(None), )


cond_p = Primitive('if', 3)
empty_p = Primitive('empty')
duplicate_p = Primitive('duplicate')
write_p = Primitive('write')
add_period_p = Primitive('add_period')
newline_p = Primitive('newline', 0)


@cond_p.def_simple_eval
def cond(pred, lhs, rhs):
    return ()


@duplicate_p.def_simple_eval
def duplicate(val):
    return val, Variable(val)


@empty_p.def_simple_eval
def empty_p(val):
    return Variable(None)


@write_p.def_simple_eval
def write(x):
    return ()


@newline_p.def_simple_eval
def newline():
    return ()


@add_period_p.def_simple_eval
def add_period_p(lhs, rhs):
    return (Variable(None), )


PRIMITIVES = {
    ':=': assign_p,
    '=': equal_p,
    '+': add_p,
    '-': sub_p,
    '*': mul_p,
    'if$': cond_p,
    'empty$': empty_p,
    'duplicate$': duplicate_p,
    'write$': write_p,
    'add.period$': add_period_p,
    'newline$': newline_p,
}


@dataclass(slots=True)
class Eq:
    """An abstract representation of a single clause."""

    primitive: Primitive

    inputs: list[Any]

    outputs: list[Any]

    def __repr__(self) -> str:
        buf = StringIO()
        self.write(buf)
        return buf.getvalue()

    def write(self, fp: IO, indent: str = ''):
        self.primitive.write(fp, self.inputs, self.outputs, indent)


@dataclass(slots=True)
class Variable:
    """An abstract representation of a value (or variable)."""

    value: Any

    name: str | None = None


@dataclass(slots=True)
class Expr:
    """An abstract representation of a program.

    The program is represented as a linearly ordered set of simple clauses.
    These clauses are evaluated sequentially.
    """

    equations: list[Eq]

    inputs: list[Variable] = field(default_factory=list)

    outputs: list[Variable] = field(default_factory=list)

    name: str | None = None

    def __repr__(self) -> str:
        buf = StringIO()
        self.write(buf)
        return buf.getvalue()

    def write(self, fp: IO, indent: str = ''):
        fp.write(indent)
        if self.name is None:
            fp.write('lambda')
        else:
            fp.write(self.name)

        num_inputs = len(self.inputs)
        num_outputs = len(self.outputs)
        fp.write(f'({num_inputs} args) -> {num_outputs}-tuple {{\n')

        for eq in self.equations:
            eq.write(fp, indent + '  ')
            fp.write(indent)
            fp.write('\n')
        fp.write(indent)
        fp.write('}')


Abstraction = Expr
Term = Primitive | Variable


def process_statement(node: Node):
    match node.type:
        case 'entry':
            pass
        case 'integers':
            pass
        case 'strings':
            pass
        case 'macro':
            pass
        case 'function':
            return process_function(node)
        case 'read':
            pass
        case 'execute':
            pass
        case 'iterate':
            pass
        case 'sort':
            pass
        case 'reverse':
            pass
        case _:
            raise RuntimeError(f'Unknown statement of type \'{node.type}\'.')


def process_function(node: Node) -> Expr:
    print('```bst\n', node.text.decode('utf-8'), '\n```')

    name = node.child_by_field_name('name').text.decode('utf-8')
    body = node.child_by_field_name('body')
    expr = process_block(body)
    expr.name = name

    print(expr)
    return expr


def process_block(node: Node):
    terms: list[Term] = []
    for term in node.children_by_field_name('term'):
        match term.type:
            case 'integer':
                child = term.child_by_field_name('value')
                value = int(child.text)
                terms += [Variable(value)]
            case 'string':
                child = term.child_by_field_name('value')
                value = child.text.decode('utf-8')
                terms += [Variable(value)]
            case 'ref':
                child = term.child_by_field_name('symbol')
                value = child.text.decode('utf-8')
                terms += [Variable(None, name=value)]
            case 'id':
                # BST have only declaration and limited type information (const
                # vs arrow). Hence, resolve all identifiers greedily. Also, we
                # does not distinguish variables and references.
                value = term.text.decode('utf-8')
                terms += [Variable(None, name=value)]
            case 'operator':
                # All operators are binary except for assignment (:=) that has
                # arity 2 and returns nothing.
                text = term.text.decode('utf-8')
                if (prim := PRIMITIVES.get(text)) is None:
                    raise RuntimeError(f'Unknown operator `{text}`.')
                terms += [prim]
            case 'builtin':
                text = term.text.decode('utf-8')
                if (prim := PRIMITIVES.get(text)) is None:
                    raise RuntimeError(f'Unknown built-in `{text}`.')
                terms += [prim]
            case 'block':
                expr = process_block(term)
                terms += [Variable(expr)]
                # print('```bst\n', term.text.decode('utf-8'), '\n```')
                # print(expr)

    return reduce(terms)


def reduce(terms: list[Term]) -> Expr:
    """Perform naive beta-reduction."""
    eqs = []
    stack = []
    inputs = []
    for term in terms:
        match term:
            case Primitive(_, arity):
                missing_args = []
                if (diff := arity - len(stack)) > 0:
                    missing_args = [Variable(None) for _ in range(diff)]
                    inputs.extend(missing_args)  # TODO(@daskol): Order?
                args = missing_args + stack[-arity:]

                result: tuple = bind(term, args)
                stack = stack[:-arity]
                stack.extend(result)

                eq = Eq(term, args, result)
                eqs.append(eq)
            case Variable():
                stack += [term]
    return Expr(eqs, inputs, stack)


class Module:
    """An internal joint representation of a program and its state."""

    def __init__(self, funcs, symbols):
        self.funcs = funcs
        self.symbols = symbols

    def __repr__(self) -> str:
        args = ', '.join([
            f'funcs={len(self.funcs)}',
            f'vars={len(self.symbols)}',
        ])
        return f'{type(self).__name__}({args})'

    @classmethod
    def from_path(cls, path: Path) -> Self:
        with open(path, 'rb') as fin:
            text = fin.read()
        return cls.from_text(text)

    @classmethod
    def from_text(cls, text: str | bytes) -> Self:
        bst = Language(language())
        parser = Parser(bst)

        if isinstance(text, str):
            content = text.encode('utf-8')
        elif isinstance(text, bytes):
            content = text
        else:
            raise RuntimeError(
                f'Expected source as bytes or str not {type(text)}.')

        tree = parser.parse(content)

        it = tree.walk()
        if not it.goto_first_child():
            raise RuntimeError('Empty or malformed BST source file.')

        funcs = {}
        ivars = {}
        svars = {}
        fields = {}

        while True:
            if (node := it.node) is None:
                raise RuntimeError  # TODO

            if node.type != 'comment':
                ret = process_statement(node)
                if isinstance(ret, Expr):
                    funcs[ret.name] = Expr

            if not it.goto_next_sibling():
                break

        return cls(funcs, {**ivars, **svars, **fields})

    def list_functions(self) -> list[str]:
        return [*self.funcs.keys()]

    def get_function(self, name: str) -> Expr:
        return self.funcs[name]
