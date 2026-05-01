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
from pathlib import Path
from typing import IO, Any, Self, cast

from bst2csl.primitive import (
    TABLE, TABLE_GREEDY, Primitive, add_p, add_period_p, assign_p, call_p,
    call_type_p, change_case_p, chr_to_int_p, cite_p, cond_p, const_p,
    duplicate_p, empty_p, entry_max_p, equal_p, format_name_p, global_max_p,
    greater_p, int_to_chr_p, int_to_str_p, less_p, missing_p, mul_p, newline_p,
    num_names_p, pop_p, preamble_p, purify_p, quote_p, resolve_p, skip_p,
    sort_key_p, stack_p, sub_p, substring_p, swap_p, text_length_p,
    text_prefix_p, top_p, type_p, warning_p, while_p, width_p, write_p)
from tree_sitter import Language, Node, Parser
from tree_sitter_bst import language


class PrettyPrinter:

    def process(self, prim: Primitive, inputs, *args, **kwargs):
        pass


class SimpleUntyped:

    def process(self, prim: Primitive, inputs, *args, **kwargs):
        if (eval_fn := TABLE.get(prim)) is None:
            raise RuntimeError(
                f'Missing abstract evaluation function for primitive {prim}.')
        return eval_fn(*inputs)


VM = [SimpleUntyped()]

def bind(prim: Primitive, *args, **kwargs) -> tuple:
    vm = VM[-1]
    return vm.process(prim, *args, **kwargs)


@assign_p.def_simple_eval
def assign(x, y):
    return ()


@equal_p.def_simple_eval
def equal(lhs, rhs):
    return (Var(None), )


@mul_p.def_simple_eval
def mul(x, y):
    return (Var(None), )


@cond_p.def_simple_eval
def cond(pred, lhs, rhs):
    return ()


@duplicate_p.def_simple_eval
def duplicate(val):
    return val, Var(val)


@empty_p.def_simple_eval
def empty(val):
    return (Var(None), )


@pop_p.def_simple_eval
def pop(_):
    return ()


@skip_p.def_simple_eval
def skip():
    return ()


@write_p.def_simple_eval
def write(x):
    return ()


@newline_p.def_simple_eval
def newline():
    return ()


@add_period_p.def_simple_eval
def add_period(val):
    return (Var(None), )


PRIMITIVES = {
    ':=': assign_p,
    '=': equal_p,
    '<': less_p,
    '>': greater_p,
    '+': add_p,
    '-': sub_p,
    '*': mul_p,
    'add.period$': add_period_p,
    'add.period$': add_period_p,
    'call.type$': call_type_p,
    'change.case$': change_case_p,
    'chr.to.int$': chr_to_int_p,
    'cite$': cite_p,
    'duplicate$': duplicate_p,
    'empty$': empty_p,
    'entry.max$': entry_max_p,
    'format.name$': format_name_p,
    'global.max$': global_max_p,
    'if$': cond_p,
    'int.to.chr$': int_to_chr_p,
    'int.to.str$': int_to_str_p,
    'missing$': missing_p,
    'newline$': newline_p,
    'newline$': newline_p,
    'num.names$': num_names_p,
    'pop$': pop_p,
    'preamble$': preamble_p,
    'purify$': purify_p,
    'quote$': quote_p,
    'skip$': skip_p,
    'sort.key$': sort_key_p,
    'stack$': stack_p,
    'substring$': substring_p,
    'swap$': swap_p,
    'text.length$': text_length_p,
    'text.prefix$': text_prefix_p,
    'top$': top_p,
    'type$': type_p,
    'warning$': warning_p,
    'while$': while_p,
    'width$': width_p,
    'write$': write_p,
}


@dataclass(slots=True)
class Val:

    val: Any

    def __hash__(self) -> int:
        return id(self)


@dataclass(slots=True)
class Var:
    """An abstract representation of a value (or variable)."""

    value: Any

    name: str | None = None

    def __hash__(self) -> int:
        return id(self)


@dataclass(slots=True, frozen=True)
class Eq:
    """An abstract representation of a single clause."""

    primitive: Primitive

    inputs: list[Any]

    outputs: list[Any]

    params: list[Val | Var] = field(default_factory=list)

    def __repr__(self) -> str:
        buf = StringIO()
        self.write(buf)
        return buf.getvalue()

    def write(self, fp: IO, indent: str = ''):
        self.primitive.write(fp, self.inputs, self.outputs, indent)


@dataclass(slots=True)
class Expr:
    """An abstract representation of a program.

    The program is represented as a linearly ordered set of simple clauses.
    These clauses are evaluated sequentially.

    Args:
        equations: Ordered set of statements ready to evaluate.
        inputs: Input values or literals.
        outputs: Output variables.
        params: Closure variables.
    """

    equations: list[Eq]

    inputs: list[Any] = field(default_factory=list)

    outputs: list[Var] = field(default_factory=list)

    params: list[Var] = field(default_factory=list)

    name: str | None = None

    @property
    def num_inputs(self) -> int:
        return len(self.inputs)

    @property
    def num_outputs(self) -> int:
        return len(self.outputs)

    @property
    def signature(self) -> str:
        return f'{self.num_inputs} -> {self.num_outputs}'

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

        fp.write(f'({self.num_inputs} args) -> {self.num_outputs}-tuple {{\n')

        for eq in self.equations:
            eq.write(fp, indent + '  ')
            fp.write(indent)
            fp.write('\n')
        fp.write(indent)
        fp.write('}')


Abstraction = Expr
Term = Primitive | Val | Var


def process_statement(node: Node, symbols: dict[str, Expr] = {}):
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
            return process_function(node, symbols)
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


def process_function(node: Node, symbols: dict[str, Expr]) -> Expr:
    if (head := node.child_by_field_name('name')) is None:
        raise RuntimeError
    if (body := node.child_by_field_name('body')) is None:
        raise RuntimeError

    name = cast(bytes, head.text).decode('utf-8')
    if name in symbols:
        raise RuntimeError(f'Duplicated declaration of symbol {expr.name}.')

    symbols[name] = Expr([], name='dummy')  # Insert a dummy expression.
    expr = process_block(body)
    expr.name = name
    symbols[expr.name] = expr

    # print('```bst\n', node.text.decode('utf-8'), '\n```')
    # print(expr)
    return expr


def process_block(node: Node) -> Expr:
    terms: list[Term] = []
    for term in node.children_by_field_name('term'):
        match term.type:
            case 'integer':
                child = term.child_by_field_name('value')
                value = int(child.text)
                terms += [Val(value)]
            case 'string':
                child = term.child_by_field_name('value')
                value = child.text.decode('utf-8')
                terms += [Val(value)]
            case 'ref':
                child = term.child_by_field_name('symbol')
                value = child.text.decode('utf-8')
                terms += [Var(None, name=value)]
            case 'id':
                # BST have only declaration and limited type information (const
                # vs arrow). Hence, resolve all identifiers greedily. Also, we
                # does not distinguish variables and references.
                value = term.text.decode('utf-8')
                terms += [Var(None, name=value)]
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
                terms += [Val(expr)]

    # At the moment, we have an expression that is represented with values,
    # variables, and primitives (i.e. callable-like). They are all concrete
    # data instances but we need more abstract "functionalized" representation.
    return remove_tags(terms)


def remove_tags(terms: list[Term]) -> Expr:
    """Map a sequence of AGDT-like terms to a sequence of tagless equations."""
    eqs: list[Eq] = []
    for term in terms:
        if isinstance(term, Val):
            eq = Eq(const_p, [], [], params=[term])
            eqs.append(eq)
        elif isinstance(term, Var):
            eq = Eq(resolve_p, [], [], params=[term])
            eqs.append(eq)
        elif isinstance(term, Primitive):
            eq = Eq(term, [], [])
            eqs.append(eq)
        else:
            raise RuntimeError(f'Unexpected term of type {type(term)}.')
    return Expr(eqs)


def reduce(terms: list[Term]) -> Expr:
    """Perform naive beta-reduction."""
    eqs = []
    stack = []
    inputs = []
    for term in terms:
        if isinstance(term, Val | Var):
            stack += [term]
            continue

        # Free var analysis.
        print(type(term), term)
        arity = term.arity  # TODO(@daskol): Evaluate arity.
        missing_args = []
        if (diff := arity - len(stack)) > 0:
            missing_args = [Var(None) for _ in range(diff)]
            inputs.extend(missing_args)  # TODO(@daskol): Order?
        args = missing_args + stack[-arity:]

        if term == cond_p:
            pred, lhs, rhs = args
            result = reduce_if(stack, term, pred, lhs, rhs)
        else:
            result: tuple = bind(term, args)

        stack = stack[:-arity]
        stack.extend(result)

        eq = Eq(term, args, result)
        eqs.append(eq)

    return Expr(eqs, inputs, stack)


def reduce_if(stack: list[Term], prim: Primitive, pred, lhs, rhs):
    then_fn = resolve_symbol(lhs)
    assert isinstance(then_fn, Expr)

    else_fn = resolve_symbol(rhs)
    assert isinstance(else_fn, Expr), f'{type(else_fn)}'
    print('if$', then_fn.signature, else_fn.signature)

    # Calculate signature of entire `if$` HOF.
    num_ins = max(then_fn.num_inputs, else_fn.num_inputs)
    num_outs = max(then_fn.num_inputs, else_fn.num_inputs)

    if then_fn.num_inputs > else_fn.num_inputs:
        else_fn = extend(else_fn, then_fn)
    if then_fn.num_inputs < else_fn.num_inputs:
        then_fn = extend(then_fn, else_fn)

    # TODO(@daskol): Add expression extension and closing.

    length = max(then_fn.num_outputs, else_fn.num_outputs)
    result = tuple([Var(None) for _ in range(length)])
    return result


def extend(fn: Expr, target: Expr) -> Expr:
    if fn.num_inputs >= target.num_inputs:
        return fn

    eq = Eq(call_p, fn.inputs, fn.outputs)
    expr = Expr([eq], eq.inputs, eq.outputs)
    return fn


def resolve_symbol(sym: Val | Var) -> Expr:
    match sym:
        case Val(value):
            return value
        case Var(value, name):
            if isinstance(value, Expr):
                return value

            if name is None:
                raise RuntimeError(
                    f'Failed to resolve anonymous symbol {value}.')

            if (prim := PRIMITIVES.get(name)) is not None:
                return reduce([prim])
            return SYMBOLS[name]


SYMBOLS: dict[str, Expr] = {}


@dataclass(slots=True)
class Func:

    name: str

    source: str

    expr: Expr

    kind: Any = None


class Module:
    """An internal joint representation of a program and its state."""

    def __init__(self, funcs: dict[str, Func], symbols):
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
        SYMBOLS.clear()  # TODO(@daskol): Make symbol table local to a module.

        while True:
            if (node := it.node) is None:
                raise RuntimeError  # TODO

            if node.type != 'comment':
                ret = process_statement(node, SYMBOLS)
                if isinstance(ret, Expr):
                    funcs[ret.name] = Func(ret.name or '', '', ret)

            if not it.goto_next_sibling():
                break

        return cls(funcs, {**ivars, **svars, **fields})

    def list_functions(self) -> list[str]:
        return [*self.funcs.keys()]

    def get_function(self, name: str) -> Func:
        return self.funcs[name]


class GreedyEval:

    def process(self, prim: Primitive, inputs, *args, **kwargs):
        if (eval_fn := TABLE_GREEDY.get(prim)) is None:
            raise RuntimeError(
                f'Missing abstract evaluation function for primitive {prim}.')
        return eval_fn(*inputs)


@cond_p.def_greedy_eval
def cond(pred, lhs, rhs):
    if not isinstance(pred, int):
        raise RuntimeError(f'Expected integer valued predicate: {pred}.')
    if pred > 0:
        return eval_expr(lhs, [])
    else:
        return eval_expr(rhs, [])


def eval_expr(expr: Expr, args: list[Any]):
    print(expr)
    if len(expr.inputs) != len(args):
        raise RuntimeError(
            'Number of expression arguments does not match arity: '
            f'{len(expr.inputs)} vs {len(args)}')

    def read(sym: Val | Var):
        if isinstance(sym, Val):
            return sym.val
        return env[sym]

    def write(var: Var, val: Val):
        env[var] = val  # TODO(@daskol): Is duplicated vars okay?

    env = {}
    for var, val in zip(expr.inputs, args):
        write(var, val)

    VM.append(GreedyEval())
    try:
        for i, eq in enumerate(expr.equations):
            print(f'STEP {i: <4d}', eq)
            print(env)
            inputs = [read(x) for x in eq.inputs]
            print('INTPUTS:', inputs)
            outputs = bind(eq.primitive, inputs)
            for var, val in zip(eq.outputs, outputs):
                write(var, val)
        return tuple([read(x) for x in expr.outputs])
    except Exception:
        raise
    finally:
        VM.pop()
