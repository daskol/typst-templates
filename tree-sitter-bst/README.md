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
