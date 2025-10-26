/**
 * @file Bibliography style language.
 * @author Daniel Bershatsky <daniel.bershatsky@gmail.com>
 * @license Apache-2.0
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: 'bst',

  extras: $ => [/[\s　]/, $.comment],

  rules: {
    root: $ => repeat(choice($.comment, $.command)),

    comment: $ => token(prec(-1, seq('%', /[^\n]*/))),

    command: $ => choice(
      $.entry, $.integers, $.strings, $.macro, $.function, $.read, $.execute,
      $.iterate, $.sort, $.reverse,
    ),

    entry: $ => seq(token(/ENTRY/i), $.entries, $.ivars, $.svars),

    entries: $ => seq('{', repeat($.id), '}'),

    ivars: $ => $.vars,

    svars: $ => $.vars,

    vars: $ => seq('{', repeat($.id), '}'),

    integers: $ => seq(token(/INTEGERS/i), $.ivars),

    macro: $ => seq(token(/MACRO/i), '{', $.pattern, '}', '{', $.string, '}'),  // XXX

    pattern: $ => /[A-Za-z_][A-Za-z0-9_.-\/]*/,  // Similar to name or id.

    function: $ => seq(token(/FUNCTION/i), '{', $.name, '}', $.body),

    name: $ => $.id,

    body: $ => $.block,

    block: $ => seq(
      '{',
      repeat(choice($.literal, $.operator, $.builtin, $.ref, $.id, $.block)),
      '}',
    ),

    literal: $ => choice($.integer, $.string),

    string: $ => seq('"', /[^"]*/, '"'),

    integer: $ => seq('#', /-?\d+/),

    operator: $ => choice('=', ':=', '*', '>', '<', '+', '-', '&'),

    builtin: $ => prec(-1, /[A-Za-z_][A-Za-z0-9_.\-]*\$/),

    ref: $ => seq('\'', choice($.id, $.builtin)),

    strings: $ => seq(token(/STRINGS/i), $.svars),

    // NOTE See biblatex.bst and achicago.bst.
    id: $ => /[A-Za-z_][A-Za-z0-9_.\-+:<>&]*/,

    word: $ => /[A-Za-z_][A-Za-z0-9_.\-]*/,

    read: $ => token(/READ/i),

    execute: $ => seq(token(/EXECUTE/i), '{', $.func, '}'),

    func: $ => choice($.name, $.builtin),

    iterate: $ => seq(token(/ITERATE/i), '{', $.func, '}'),

    sort: $ => token(/SORT/i),

    reverse: $ => seq(token(/REVERSE/i), '{', $.func, '}'),
  }
});
