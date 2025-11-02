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

from pathlib import Path

import pytest

from bst2csl.module import Expr, Module, Val, Var, cond_p, eval_expr, reduce_if

data_dir = Path(__file__).parent / 'testdata'


class TestModule:

    @pytest.mark.parametrize('filename', ['sample.bst', 'booleans.bst'])
    def test_from_path(self, filename: str):
        m = Module.from_path(data_dir / filename)
        assert len(m.list_functions()) == 3

    @pytest.mark.parametrize('input_', [0, 1])
    def test_eval_not(self, input_: int):
        m = Module.from_path(data_dir / 'booleans.bst')
        not_ = m.get_function('not')
        outputs = eval_expr(not_, [input_])
        assert isinstance(outputs, tuple)
        assert len(outputs) == 1
        output, = outputs
        assert output == (1 - input_)

    @pytest.mark.xfail(reason='no hof')
    @pytest.mark.parametrize('lhs,rhs', [
        (0, 0),
        (0, 1),
        (1, 0),
        (1, 1),
    ])
    def test_eval_or(self, lhs: int, rhs: int):
        m = Module.from_path(data_dir / 'booleans.bst')
        or_ = m.get_function('or')
        outputs = eval_expr(or_, [lhs, rhs])
        assert isinstance(outputs, tuple)
        assert len(outputs) == 1
        output, = outputs
        assert output == (lhs or rhs)


def test_reduce_if():
    pred = Var(None)

    skip = Var(None, name='skip$')
    then_fn = skip

    pop = Var(None, name='pop$')
    arg = Var(None, name='arg')
    ret = Val(0)
    else_fn = Val(Expr([pop], [arg], [ret]))

    eqs = reduce_if([], cond_p, pred, then_fn, else_fn)
    print('EQUATIONS:', eqs)
    pass
