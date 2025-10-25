import XCTest
import SwiftTreeSitter
import TreeSitterBst

final class TreeSitterBstTests: XCTestCase {
    func testCanLoadGrammar() throws {
        let parser = Parser()
        let language = Language(language: tree_sitter_bst())
        XCTAssertNoThrow(try parser.setLanguage(language),
                         "Error loading BeaST: Bibliography STyle Language grammar")
    }
}
