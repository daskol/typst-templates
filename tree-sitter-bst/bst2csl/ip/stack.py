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

import re
import sys
from typing import Any, Protocol, TypeAlias

import bst2csl.primitive as prim
from bst2csl.module import Expr, Val, Var
from bst2csl.primitive import Primitive

# Match suffix like '.    '.
RE_PERIOD = re.compile(r'(?P<period>[\.\!\?])?(?P<space>\s*)$')


class Interpreter(Protocol):

    def process(self, prim: Primitive, *args, **kwargs) -> Any:
        pass


Stack: TypeAlias = list


class StackMachine(Interpreter):

    def __init__(self):
        self.symbols: dict[str, Var] = {}

    def process(self, prim: Primitive, stack: Stack, **kwargs) -> Stack:
        if (fn := prim.resolve(type(self).__name__)) is None:
            raise RuntimeError(
                f'Missing abstract evaluation function for primitive `{prim}` '
                f'on {type(self).__name__}.')
        kwargs['symbols'] = self.symbols
        return fn(stack, **kwargs)


def evaluate(expr: Expr, init: Stack | None = None) -> Stack:
    stack = init or []

    # TODO(@daskol): Initial stack can contain concrete values that should be
    # lifted to monad of the active interpreter.

    ip = StackMachine()
    for i, eq in enumerate(expr.equations, 1):
        try:
            stack = ip.process(eq.primitive, stack, params=eq.params)
        except Exception as e:
            desc = f'Failed to evaluate equation on step {i}.'
            raise RuntimeError(desc) from e

    return stack


@prim.const_p.register('StackMachine')
def const(stack: Stack, params: list[Val], **kwargs) -> Stack:
    assert len(params) == 1
    param, = params
    stack.append(param)
    return stack


@prim.resolve_p.register('StackMachine')
def resolve(stack: Stack, params: list[Val], symbols: dict[str, Var]) -> Stack:
    assert len(params) == 1
    param, = params

    if not isinstance(param, Var):
        raise RuntimeError(
            f'Unexpected type of closure parameter {type(param)}.')
    if param.name is None:
        raise RuntimeError(f'No symbol name for {param}.')

    if (symbol := symbols.get(param.name)) is None:
        symbol = param
        symbols[param.name] = symbol

    stack.append(symbol)
    return stack


@prim.assign_p.register('StackMachine')
def assign(stack: Stack, **kwargs) -> Stack:
    if not isinstance(lhs := stack.pop(), Var):
        raise RuntimeError(
            f'Expected symbol ({type(Var).__name__}) on lhs but '
            f'not {type(lhs).__name__}.')
    rhs = stack.pop()
    lhs.value = rhs  # TODO(@daskol): Correcy assignment?
    return stack


def pop_scalar(stack: Stack,
               symbols: dict[str, Var]) -> tuple[Stack, int | str]:
    if isinstance(term := stack.pop(), Val):
        if not isinstance(term.val, int | str):
            raise RuntimeError('Expect either `int` or `str` value '
                               f'but not {type(term.val)}.')
        return stack, term.val
    elif isinstance(term, Var):
        if isinstance(term.value, int | str):
            return stack, term.value

        if (name := term.name) is None:
            raise RuntimeError(f'An empty unnamed variable {term}.')
        if (sym := symbols.get(name)) is None:
            raise RuntimeError(
                f'No global variable or entry field named {name}.')
        if isinstance(sym.value, int | str):
            raise RuntimeError(
                f'Expect value of variable {name} to be type `int` or `str`.')
        return sym.value
    else:
        raise RuntimeError(
            f'Expected literal or variable not primitive {term}.')


def pop_int(stack: Stack, symbols: dict[str, Var]) -> tuple[Stack, int]:
    stack, val = pop_scalar(stack, symbols)
    if isinstance(val, int):
        return stack, val
    raise RuntimeError(f'Expected value of type `int` but not {type(val)}.')


def pop_str(stack: Stack, symbols: dict[str, Var]) -> tuple[Stack, str]:
    stack, val = pop_scalar(stack, symbols)
    if isinstance(val, str):
        return stack, val
    raise RuntimeError(f'Expected value of type `str` but not {type(val)}.')


@prim.equal_p.register('StackMachine')
def equal(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, rhs = pop_scalar(stack, symbols)
    stack, lhs = pop_scalar(stack, symbols)
    if isinstance(lhs, int) and isinstance(rhs, int):
        res = int(lhs == rhs)
    elif isinstance(lhs, str) and isinstance(rhs, str):
        res = int(lhs == rhs)
    else:
        raise RuntimeError(
            f'Both operand must be of the same type: {type(lhs)} {type(rhs)}.')
    return stack + [res]


@prim.less_p.register('StackMachine')
def less(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, rhs = pop_scalar(stack, symbols)
    stack, lhs = pop_scalar(stack, symbols)
    if isinstance(lhs, int) and isinstance(rhs, int):
        return stack + [int(lhs < rhs)]
    else:
        raise RuntimeError(
            f'Both operand must be of the same type: {type(lhs)} {type(rhs)}.')


@prim.greater_p.register('StackMachine')
def greater(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, rhs = pop_scalar(stack, symbols)
    stack, lhs = pop_scalar(stack, symbols)
    if isinstance(lhs, int) and isinstance(rhs, int):
        return stack + [int(lhs > rhs)]
    else:
        raise RuntimeError(
            f'Both operand must be of the same type: {type(lhs)} {type(rhs)}.')


@prim.add_p.register('StackMachine')
def add(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, rhs = pop_scalar(stack, symbols)
    stack, lhs = pop_scalar(stack, symbols)
    if isinstance(lhs, int) and isinstance(rhs, int):
        return stack + [(lhs + rhs)]
    else:
        raise RuntimeError('Both operand must be of the same integer type: '
                           f'{type(lhs)} {type(rhs)}.')


@prim.sub_p.register('StackMachine')
def sub(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, rhs = pop_scalar(stack, symbols)
    stack, lhs = pop_scalar(stack, symbols)
    if isinstance(lhs, int) and isinstance(rhs, int):
        return stack + [lhs - rhs]
    else:
        raise RuntimeError('Both operand must be of the same integer type: '
                           f'{type(lhs)} {type(rhs)}.')


@prim.mul_p.register('StackMachine')
def mul(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, rhs = pop_scalar(stack, symbols)
    stack, lhs = pop_scalar(stack, symbols)
    if isinstance(lhs, str) and isinstance(rhs, str):
        return stack + [lhs + rhs]
    else:
        raise RuntimeError('Both operand must be of the same integer type: '
                           f'{type(lhs)} {type(rhs)}.')


@prim.cond_p.register('StackMachine')
def cond(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:

    def resolve_term():
        if isinstance(term := stack.pop(), Val):
            if not isinstance(term.val, Expr):
                raise RuntimeError(
                    f'Expected expression not {type(term.val).__name__}.')
            return term.val
        elif isinstance(term, Var):
            if term.name is None:
                raise RuntimeError(f'Symbol {term} is unnamed.')
            if (symbol := symbols.get(term.name)) is None:
                raise RuntimeError(f'No such symbol {term.name}.')
            if isinstance(symbol.value, Expr):
                raise RuntimeError(
                    f'Expected expression not {type(symbol.value).__name__}.')
            return symbol.value
        else:
            raise RuntimeError(f'Expected expression not primitive {term}.')

    # Reverse order (stack).
    else_fn = resolve_term()
    then_fn = resolve_term()

    if isinstance(term := stack.pop(), Val):
        val = term.val
    elif isinstance(term, Var):
        val = term.value
    else:
        raise RuntimeError(f'Expected integer-valued predicate not {term}.')

    if val > 0:
        return evaluate(then_fn, stack)
    else:
        return evaluate(else_fn, stack)


@prim.add_period_p.register('StackMachine')
def add_period(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, val = pop_str(stack, symbols)
    if (m := RE_PERIOD.search(val)) is None:
        raise RuntimeError(f'Unexpected matching error: \'{val}\'.')
    if not m.group('period'):
        pos = len(val) - len(m.group(0))
        val = f'{val[:pos]}.{val[:pos]}'
    return stack + [Val(val)]


@prim.call_type_p.register('StackMachine')
def call_type(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    raise NotImplementedError('Special built-in function call.type$ is '
                              'not implemented at the momemnt.')


@prim.change_case_p.register('StackMachine')
def change_case(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, mode = pop_str(stack, symbols)
    stack, val = pop_str(stack, symbols)
    match mode:
        case 't':
            val = val.capitalize()
        case 'l':
            val = val.lower()
        case 'u':
            val = val.upper()
        case _:
            raise RuntimeError(f'Unexpected argument "{val}" of change.case$.')
    return stack + [Val(val)]


@prim.chr_to_int_p.register('StackMachine')
def chr_to_int(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, val = pop_str(stack, symbols)
    if len(val) != 1:
        raise RuntimeError(f'Wrong length of string literal {len(val)}: '
                           'expected single character.')
    return stack + [Val(ord(val[0]))]


@prim.cite_p.register('StackMachine')
def cite(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    raise NotImplementedError(
        'Special built-in function cite$ is not implemented at the momemnt.')


@prim.int_to_chr_p.register('StackMachine')
def int_to_chr(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, val = pop_int(stack, symbols)
    return stack + [Val(chr(val))]


@prim.int_to_str_p.register('StackMachine')
def int_to_str(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, val = pop_int(stack, symbols)
    return stack + [Val(str(val))]


@prim.duplicate_p.register('StackMachine')
def duplicate(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, val = pop_scalar(stack, symbols)
    return stack + [Val(val), Val(val)]


@prim.empty_p.register('StackMachine')
def empty(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, val = pop_scalar(stack, symbols)
    if isinstance(val, int):
        ret = int(val == 0)
    elif isinstance(val, str):
        ret = int(val == '')
    else:
        raise RuntimeError(f'Unexpected type {type(val)} of value.')
    return stack + [Val(ret)]


@prim.format_name_p.register('StackMachine')
def format_name(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    raise NotImplementedError


@prim.global_max_p.register('StackMachine')
def global_max(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    return stack + [Val(5_000)]  # Default.


@prim.missing_p.register('StackMachine')
def missing(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    raise NotImplementedError('Special built-in function missing$ is '
                              'not implemented at the momemnt.')


@prim.newline_p.register('StackMachine')
def newline(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    sys.stdout.flush()
    sys.stdout.write('\n')
    return stack


@prim.num_names_p.register('StackMachine')
def num_names(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    raise NotImplementedError


@prim.pop_p.register('StackMachine')
def pop(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, _ = pop_scalar(stack, symbols)
    return stack


@prim.preamble_p.register('StackMachine')
def preamble(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    text = ''  # NOTE Ignore preamble at the moment.
    return stack + [Val(text)]


@prim.purify_p.register('StackMachine')
def purify(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    raise NotImplementedError


@prim.quote_p.register('StackMachine')
def quote(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    return stack + [Val('"')]


@prim.skip_p.register('StackMachine')
def skip(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    return stack  # Literaly, do nothing.


@prim.sort_key_p.register('StackMachine')
def sort_key(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    raise NotImplementedError('Special built-in constant sort.key$ is '
                              'not implemented at the momemnt.')


@prim.stack_p.register('StackMachine')
def stack(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    print(f'Stack: {len(stack)} elements', file=sys.stderr)
    print('=' * 80, file=sys.stderr)
    pairs = [*enumerate(stack)]
    for i, item in reversed(pairs):
        if isinstance(item, Val):
            print(f'{i: 4d} | value: {item.val}', file=sys.stderr)
        elif isinstance(item, Var):
            name = ''
            if item.name:
                name = f' ({item.name})'
            if isinstance(item.value, Expr):
                print(f'{i: 4d} | expr:  {item.value}{name}', file=sys.stderr)
            else:
                print(f'{i: 4d} | var:   {item.value}{name}', file=sys.stderr)
    print('=' * 80, file=sys.stderr)
    return []


@prim.substring_p.register('StackMachine')
def substring(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, end = pop_int(stack, symbols)
    stack, begin = pop_int(stack, symbols)
    stack, val = pop_str(stack, symbols)
    ret = val[begin:end]  # NOTE Simplified: does not account markup.
    return stack + [Val(ret)]


@prim.swap_p.register('StackMachine')
def swap(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, rhs = pop_scalar(stack, symbols)
    stack, lhs = pop_scalar(stack, symbols)
    return stack + [Val(rhs), Val(lhs)]


@prim.text_length_p.register('StackMachine')
def text_length_p(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, val = pop_str(stack, symbols)
    return stack + [Val(len(val))]


@prim.text_prefix_p.register('StackMachine')
def text_prefix_p(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, pos = pop_int(stack, symbols)
    stack, val = pop_str(stack, symbols)
    prefix = val[:pos]  # NOTE Siplified: does not account markup.
    return stack + [Val(prefix)]


@prim.top_p.register('StackMachine')
def top(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, val = pop_scalar(stack, symbols)
    if isinstance(val, str):
        print(f'Top: "{val}"', file=sys.stderr)
    else:
        print(f'Top: {val}', file=sys.stderr)
    return stack


@prim.type_p.register('StackMachine')
def type_(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    raise NotImplementedError(
        'Special built-in function type$ is not implemented at the momemnt.')


@prim.warning_p.register('StackMachine')
def warning(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, msg = pop_str(stack, symbols)
    print(f'Warning: {msg}\n', file=sys.stderr)
    return stack


@prim.width_p.register('StackMachine')
def width(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, val = pop_str(stack, symbols)
    width = len(val)  # NOTE Simplification: does no typesetting.
    return stack + [Val(width)]


@prim.write_p.register('StackMachine')
def write(stack: Stack, symbols: dict[str, Var], **kwargs) -> Stack:
    stack, msg = pop_str(stack, symbols)
    sys.stdout.write(msg)
    return stack
