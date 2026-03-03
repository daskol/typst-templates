# BST2CSL: Bibliography Style Translator

## Status

At the moment, it can parse `*.bst` files and build abstract syntax tree (AST)
with limited set of built-in functions. Function evaluation works only for
limitted set of operators and function. Specifically, high-order functions
(e.g. `if$`) are not supported completely. However, it is able to evaluate the
following.

```bst
FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}
```

## Corpus

Files usually contains some textual parts out of BST grammar (e.g. email header
or LaTeX in the footer). We keep original files as is and apply a patch to fix
this human typos.

```bash
patch --strip=1 --input=corpus/corpus.diff
```

### Preprocessor

However, there is an example of C preprocessor usage. We fix this BST-file with
the following command.

```bash
cpp -E -P corpus/obsolete/biblio/bibtex/contrib/physics.bst
```
