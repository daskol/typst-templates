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

from operator import add, concat, eq, gt, lt, sub

import pytest

import bst2csl.primitive as primitive
from bst2csl.ip.stack import evaluate
from bst2csl.module import Eq, Expr, Func, Module, Val
from bst2csl.primitive import Primitive


@pytest.mark.parametrize('value', [0, 1])
def test_cond(value: int):
    source = 'FUNCTION {not} {   { #0 } { #1 } if$ }'
    mod = Module.from_text(source)
    func = mod.get_function('not')
    stack = evaluate(func.expr, [Val(value)])
    assert len(stack) == 1
    assert isinstance(ret := stack.pop(), Val)
    assert ret.val == (1 - value)


def make_single_expr(prim: Primitive) -> Func:
    eq = Eq(prim, [], [])
    expr = Expr([eq])
    return Func('func', '', expr)


class TestBinaryOp:

    def _test_op(self, op, prim: Primitive, lhs: int | str, rhs: int | str):
        expected = op(lhs, rhs)
        if isinstance(expected, str):
            expected_ty = type(expected)
        else:
            expected_ty = int

        func = make_single_expr(prim)
        stack = evaluate(func.expr, [Val(lhs), Val(rhs)])
        assert len(stack) == 1
        actual, = stack
        assert isinstance(actual, expected_ty)
        assert actual == op(lhs, rhs)

    @pytest.mark.parametrize('lhs,rhs', [
        (0, 0),
        (0, 1),
        (1, 1),
        (-1, 1),
        (-1, -1),
        ('', ''),
        ('', 'lorem ipsum'),
        ('lorem', 'ipsum'),
    ])
    def test_equal(self, lhs: int | str, rhs: int | str):
        self._test_op(eq, primitive.equal_p, lhs, rhs)

    @pytest.mark.parametrize('lhs,rhs', [
        (0, 0),
        (0, 1),
        (1, 0),
        (1, 1),
        (-1, 1),
        (-1, -1),
    ])
    def test_less(self, lhs: int, rhs: int):
        self._test_op(lt, primitive.less_p, lhs, rhs)


    @pytest.mark.parametrize('lhs,rhs', [(0, 0), (-1, 1), (1, -1), (1, 1)])
    def test_greater(self, lhs: int, rhs: int):
        self._test_op(gt, primitive.greater_p, lhs, rhs)

    @pytest.mark.parametrize('lhs,rhs', [
        (0, 0),
        (-54, -20),
        (-4076, 6340),
        (433921, -197378),
    ])
    def test_add(self, lhs: int, rhs: int):
        self._test_op(add, primitive.add_p, lhs, rhs)

    @pytest.mark.parametrize('lhs,rhs', [
        (0, 0),
        (-54, -20),
        (-4076, 6340),
        (433921, -197378),
    ])
    def test_sub(self, lhs: int, rhs: int):
        self._test_op(sub, primitive.sub_p, lhs, rhs)

    @pytest.mark.parametrize('lhs,rhs', [('', ''), ('lorem', 'ipsum')])
    def test_mul(self, lhs: str, rhs: str):
        self._test_op(concat, primitive.mul_p, lhs, rhs)
