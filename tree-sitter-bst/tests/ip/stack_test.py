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
from bst2csl.module import Eq, Expr, Func, Module, Val, Var
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


class TestStringFunc:

    @pytest.mark.parametrize('inp,out', [
        ('', '.'),
        ('.', '.'),
        ('lorem! \t', 'lorem! \t'),
    ])
    def test_add_period(self, inp: str, out: str):
        func = make_single_expr(primitive.add_period_p)
        stack = evaluate(func.expr, [Val(inp)])
        assert len(stack) == 1
        ret, = stack
        assert isinstance(ret, Val)
        assert ret.val == out

    @pytest.mark.parametrize('mode,inp,out', [
        ('t', 'lorem IPSUM', 'Lorem ipsum'),
        ('l', 'lorem IPSUM', 'lorem ipsum'),
        ('u', 'lorem IPSUM', 'LOREM IPSUM'),
    ])
    def test_change_case(self, mode: str, inp: str, out: str):
        func = make_single_expr(primitive.change_case_p)
        stack = evaluate(func.expr, [Val(inp), Val(mode)])
        assert len(stack) == 1
        ret, = stack
        assert isinstance(ret, Val)
        assert ret.val == out

    @pytest.mark.parametrize('val', ['A', ' '])
    def test_chr_to_int(self, val: str):
        func = make_single_expr(primitive.chr_to_int_p)
        stack = evaluate(func.expr, [Val(val)])
        assert len(stack) == 1
        ret, = stack
        assert isinstance(ret, Val)
        assert ret.val == ord(val[0])

    @pytest.mark.parametrize('val', [0x41, 0x20])
    def test_int_to_chr(self, val: int):
        func = make_single_expr(primitive.int_to_chr_p)
        stack = evaluate(func.expr, [Val(val)])
        assert len(stack) == 1
        ret, = stack
        assert isinstance(ret, Val)
        assert ret.val == chr(val)

    @pytest.mark.parametrize('val', [0x41, 0x20])
    def test_int_to_str(self, val: int):
        func = make_single_expr(primitive.int_to_str_p)
        stack = evaluate(func.expr, [Val(val)])
        assert len(stack) == 1
        ret, = stack
        assert isinstance(ret, Val)
        assert ret.val == str(val)

    @pytest.mark.parametrize('val', ['', 'lorem ipsum'])
    def test_substring(self, val: str, begin=1, end=5):
        func = make_single_expr(primitive.substring_p)
        stack = evaluate(func.expr, [Val(val), Val(begin), Val(end)])
        assert len(stack) == 1
        ret, = stack
        assert isinstance(ret, Val)
        assert ret.val == val[begin:end]

    @pytest.mark.parametrize('val', ['', 'lorem ipsum'])
    def test_text_length(self, val: str):
        func = make_single_expr(primitive.text_length_p)
        stack = evaluate(func.expr, [Val(val)])
        assert len(stack) == 1
        ret, = stack
        assert isinstance(ret, Val)
        assert ret.val == len(val)

    @pytest.mark.parametrize('val', ['', 'lorem ipsum'])
    def test_text_prefix(self, val: str, pos=5):
        func = make_single_expr(primitive.text_prefix_p)
        stack = evaluate(func.expr, [Val(val), Val(pos)])
        assert len(stack) == 1
        ret, = stack
        assert isinstance(ret, Val)
        assert ret.val == val[:pos]


class TestCommonFunc:

    @pytest.mark.parametrize('val', [42, 'lorem ipsum'])
    def test_duplicate(self, val: int | str):
        func = make_single_expr(primitive.duplicate_p)
        stack = evaluate(func.expr, [Val(val)])
        assert len(stack) == 2

        assert isinstance(stack[0], Val)
        assert stack[0].val == val

        assert isinstance(stack[1], Val)
        assert stack[1].val == val

    @pytest.mark.parametrize('val', [0, 42, '', 'lorem ipsum'])
    def test_empty(self, val: int | str):
        func = make_single_expr(primitive.empty_p)
        stack = evaluate(func.expr, [Val(val)])
        assert len(stack) == 1
        expected = not bool(val)
        actual, = stack
        assert isinstance(actual, Val)
        assert actual.val == int(expected)

    def test_swap(self):
        func = make_single_expr(primitive.swap_p)
        stack = evaluate(func.expr, [Val(42), Val('lorem ipsum')])
        assert len(stack) == 2
        bot, top = stack
        assert isinstance(bot, Val)
        assert isinstance(top, Val)
        assert bot.val == 'lorem ipsum'
        assert top.val == 42


class TestSpecialFunc:

    def test_global_max(self):
        func = make_single_expr(primitive.global_max_p)
        stack = evaluate(func.expr, [])
        assert len(stack) == 1
        ret, = stack
        assert isinstance(ret, Val)
        assert ret.val == 5_000

    def test_stack(self):
        func = make_single_expr(primitive.stack_p)
        stack = evaluate(func.expr, [Val(42), Var('lorem ipsum', 'var')])
        assert stack == []

    def test_top(self):
        func = make_single_expr(primitive.top_p)
        stack = evaluate(func.expr, [Val(42), Var('lorem ipsum', 'var')])
        assert len(stack) == 1

    def test_warning(self):
        func = make_single_expr(primitive.warning_p)
        stack = evaluate(func.expr, [Val('Hello, world!')])
        assert stack == []


class TestIOFunc:

    def test_newline(self):
        func = make_single_expr(primitive.newline_p)
        stack = evaluate(func.expr, [])
        assert stack == []

    def test_write(self):
        func = make_single_expr(primitive.write_p)
        stack = evaluate(func.expr, [Val('Hello, world!')])
        assert stack == []
