//
//  MarkdownTokenizerTests.swift
//  Scratchie
//
//  Created by Eoin Motherway on 15/3/21.
//

import Foundation

import XCTest
@testable import Scratchie

class MarkdownTokenizerTests: XCTestCase {

    func testHeadingTokenizes() throws {

        // Arrange
        var markdownHeadings = [String]()
        let numberOfHeadings = 3
        for i in 1...numberOfHeadings {
            let prefix = String.init(repeating: "#", count: i)
            markdownHeadings.append("\(prefix) My Heading at level \(i)")
        }

        // Act/Assert
        for heading in markdownHeadings {

            let tokenizer = MarkdownTokenizer(text: heading)

            // Tokenize
            let tokens = tokenizer.getTokens()
            XCTAssertEqual(tokens.count, 1);

            guard let token = tokens.first else {
                XCTFail("No tokens found")
                return
            }

            XCTAssertEqual(token.type, TokenType.heading)
        }
    }

    func testQuoteTokenizes() throws {

        // Todo: Refactor this test, not happy with using a switch for assertion

        // Arrange
        let markdown = """
                       > Line 1 of quote
                       > Line 2 of quote
                       This is not a quote
                       > This is a quote
                       """

        // Act
        let tokenizer = MarkdownTokenizer(text: markdown)
        let tokens = tokenizer.getTokens()

        // Assert
        XCTAssertEqual(tokens.count, 3)
        for i in 0...tokens.count - 1 {
            let token = tokens[i]

            switch i {
            case 0, 1, 3:
                XCTAssertEqual(token.type, TokenType.quote)
                break

            case 2:
                XCTAssertEqual(token.type, TokenType.quote)

            default: break
            }
        }
    }

    func testCodeBlockTokenizes() {

        // Arrange
        let markdown = """
                       this is plain text
                       ```
                       var test = 123;
                       ```
                       this is also plain text
                       """

        // Act
        let tokenizer = MarkdownTokenizer(text: markdown)
        let tokens = tokenizer.getTokens()

        // Assert
        XCTAssertEqual(tokens.count, 3)
        XCTAssertEqual(tokens[1].type, TokenType.codeBlock)
        XCTAssertEqual(tokens[2].type, TokenType.plainText)
    }

    func testPlainTextTokenizes() {

        // Arrange
        let markdown = """
                       # This is a heading
                       this is plain text
                       > This is a quote
                       this is also plain text
                       """

        // Act
        let tokenizer = MarkdownTokenizer(text: markdown)
        let tokens = tokenizer.getTokens()

        // Assert
        XCTAssertEqual(tokens.count, 4)
        for i in 0...tokens.count - 1 {
            let token = tokens[i]

            switch i {
            case 1, 3:
                XCTAssertEqual(token.type, TokenType.plainText)
            default:
                XCTAssertNotEqual(token.type, TokenType.plainText)
            }
        }
    }

    func testLinkAndImageTokenizes() {

        // Arrange
        let normalLink = "https://github.com"
        let imageLink = "https://media.giphy.com/media/uCLiiV2WEUBHYcYc14/giphy.gif"
        let markdown = """
                       This is plain text
                       [This is a link](\(normalLink))
                       This is also plain text
                       ![This is an image](\(imageLink))
                       This is plain text [with an inline link](\(normalLink)) and also with an ![inline image](\(imageLink))
                       """

        // Act
        let tokenizer = MarkdownTokenizer(text: markdown)
        let tokens = tokenizer.getTokens()

        // Assert
        XCTAssertEqual(tokens.count, 8)
        for i in 0...tokens.count - 1 {
            let token = tokens[i]

            switch i {

            case 1, 5:
                XCTAssertEqual(token.type, TokenType.link)

            case 3, 7:
                XCTAssertEqual(token.type, TokenType.image)
                
            default:
                XCTAssertEqual(token.type, TokenType.plainText)
            }
        }
    }
}
