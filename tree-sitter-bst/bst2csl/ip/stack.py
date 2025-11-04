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

from typing import Any, Protocol, TypeAlias

import bst2csl.primitive as prim
from bst2csl.module import Expr, Val, Var
from bst2csl.primitive import Primitive


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
