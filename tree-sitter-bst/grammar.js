/**
 * @file Bibliography style language.
 * @author Daniel Bershatsky <daniel.bershatsky@gmail.com>
 * @license Apache-2.0
 */

/// <reference types="tree-sitter-cli/dsl" />
// @ts-check

module.exports = grammar({
  name: "bst",

  rules: {
    // TODO: add the actual grammar rules
    source_file: $ => "hello"
  }
});
