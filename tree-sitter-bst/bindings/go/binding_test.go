package tree_sitter_bst_test

import (
	"testing"

	tree_sitter "github.com/tree-sitter/go-tree-sitter"
	tree_sitter_bst "github.com/daskol/typst-templates/bindings/go"
)

func TestCanLoadGrammar(t *testing.T) {
	language := tree_sitter.NewLanguage(tree_sitter_bst.Language())
	if language == nil {
		t.Errorf("Error loading BeaST: Bibliography STyle Language grammar")
	}
}
