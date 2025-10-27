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

  supertypes: $ => [
    $.statement,
    $.term,
    $.symbol,
  ],

  rules: {
    source_file: $ => repeat(choice($.comment, $.statement)),

    comment: $ => token(prec(-1, seq('%', /[^\n]*/))),

    statement: $ => choice(
      $.entry, $.integers, $.strings, $.macro, $.function, $.read, $.execute,
      $.iterate, $.sort, $.reverse,
    ),

    entry: $ => seq(
      token(/ENTRY/i),
      field('fields', $.entries),
      field('integers', $.ivars),
      field('strings', $.svars),
    ),

    entries: $ => seq('{', repeat($.id), '}'),

    ivars: $ => $._vars,

    svars: $ => $._vars,

    _vars: $ => seq('{', repeat($.id), '}'),

    integers: $ => seq(token(/INTEGERS/i), field('integers', $.ivars)),

    macro: $ => seq(
      token(/MACRO/i),
      '{', field('pattern', $.pattern), '}',
      '{', field('subst', $.string), '}',
    ),

    pattern: $ => /[A-Za-z_][A-Za-z0-9_.-\/]*/,  // Similar to name or id.

    function: $ => seq(
      token(/FUNCTION/i),
      '{', field('name', $.id), '}',
      field('body', $.block),
    ),

    block: $ => seq('{', field('term', repeat($.term)), '}'),

    term: $ => choice(
      $.integer,
      $.string,
      $.ref,
      $.id,
      $.operator,
      $.builtin,
      $.block,
    ),

    string: $ => seq('"', field('value', $.string_value), '"'),

    string_value: $ => /[^"]*/,

    integer: $ => seq('#', field('value', $.integer_value)),

    integer_value: $ => /-?\d+/,

    operator: $ => choice('=', ':=', '*', '>', '<', '+', '-', '&'),

    builtin: $ => prec(-1, /[A-Za-z_][A-Za-z0-9_.\-]*\$/),

    ref: $ => seq('\'', field('symbol', $.symbol)),

    strings: $ => seq(token(/STRINGS/i), $.svars),

    // NOTE See biblatex.bst and achicago.bst.
    id: $ => /[A-Za-z_][A-Za-z0-9_.\-+:<>&]*/,

    word: $ => /[A-Za-z_][A-Za-z0-9_.\-]*/,

    read: $ => token(/READ/i),

    execute: $ => seq(token(/EXECUTE/i), '{', field('func', $.symbol), '}'),

    symbol: $ => choice($.builtin, $.id),

    iterate: $ => seq(token(/ITERATE/i), '{', field('func', $.symbol), '}'),

    sort: $ => token(/SORT/i),

    reverse: $ => seq(token(/REVERSE/i), '{', field('func', $.symbol), '}'),
  }
});
