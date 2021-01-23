//
//  MarkdownParserTests.swift
//  ScratchieTests
//
//  Created by Eoin Motherway on 16/1/21.
//

import XCTest
@testable import Scratchie

class MarkdownParserTests: XCTestCase {

    func testHeadingTokenizes() throws {

        // Arrange
        let parser = MarkdownParser()
        var markdownHeadings = [String]()

        let numberOfHeadings = 3
        for i in 1...numberOfHeadings {
            let prefix = String.init(repeating: "#", count: i)
            markdownHeadings.append("\(prefix) My Heading at level \(i)")
        }

        // Act/Assert
        var currentHeadingLevel = 1;
        for heading in markdownHeadings {

            // Tokenize
            let tokens = parser.tokenize(heading)
            XCTAssertEqual(tokens.count, 1);

            let token = tokens.first!
            if let headingToken = token as? MarkdownHeading {
                XCTAssertEqual(headingToken.level, currentHeadingLevel)
            } else {
                XCTFail("Token was not MarkdownHeading")
            }

            currentHeadingLevel += 1
        }
    }

    func testHorizontalRuleTokenizes() throws {

        // Arrange
        let parser = MarkdownParser()
        let markdownHorizontalRules: [String] = [
            "***",
            "---",
            "___"
        ]

        // Act/Assert
        for horizontalRule in markdownHorizontalRules {

            // Tokenize
            let tokens = parser.tokenize(horizontalRule)
            XCTAssertEqual(tokens.count, 1);

            let token = tokens.first!
            XCTAssertTrue(token is MarkdownHorizontalRule)
        }
    }

    func testQuoteTokenizes() throws {

        // Todo: Refactor this test, not happy with using a switch for assertion

        // Arrange
        let parser = MarkdownParser()
        let markdown = """
                       > Line 1 of quote
                       > Line 2 of quote
                       This is not a quote
                       > This is a quote
                       """

        // Act
        let tokens = parser.tokenize(markdown)

        // Assert
        XCTAssertEqual(tokens.count, 3)
        for i in 0...tokens.count - 1 {
            let token = tokens[i]

            switch i {
            case 0:
                if let quoteToken = token as? MarkdownQuote {
                    XCTAssertTrue(quoteToken.isMultiLine())
                } else {
                    XCTFail("First token was not a quote")
                }

                break

            case 2:
                if let quoteToken = token as? MarkdownQuote {
                    XCTAssertFalse(quoteToken.isMultiLine())
                } else {
                    XCTFail("2 nd token was not a quote")
                }
            default: break
            }
        }
    }

    func testCodeBlockTokenizes() {

        // Arrange
        let parser = MarkdownParser()
        let markdown = """
                       this is a paragraph
                       ```
                       var test = 123;
                       ```
                       this is also a paragraph
                       """

        // Act
        let tokens = parser.tokenize(markdown)

        // Assert
        XCTAssertEqual(tokens.count, 3)
        XCTAssertTrue(tokens[1] is MarkdownCodeBlock)

        let codeBlockToken = tokens[1] as! MarkdownCodeBlock
        XCTAssertNotNil(codeBlockToken)
        XCTAssertTrue(codeBlockToken.isMultiLine())
    }

    func testParagraphTokenizes() {

        // Arrange
        let parser = MarkdownParser()
        let markdown = """
                       # This is a heading
                       this is a paragraph
                       > This is a quote
                       this is also a paragraph
                       """

        // Act
        let tokens = parser.tokenize(markdown)

        // Assert
        XCTAssertEqual(tokens.count, 4)
        for i in 0...tokens.count - 1 {
            let token = tokens[i]

            switch i {
            case 1, 3:
                XCTAssertTrue(token is MarkdownParagraph)
            default:
                XCTAssertFalse(token is MarkdownParagraph)
            }
        }
    }

    func testLinkAndImageTokenizes() {

        // Arrange
        let parser = MarkdownParser()
        let normalLink = "https://github.com"
        let imageLink = "https://media.giphy.com/media/uCLiiV2WEUBHYcYc14/giphy.gif"
        let markdown = """
                       This is a paragraph
                       [This is a link](\(normalLink))
                       This is also a paragraph
                       ![This is an image](\(imageLink))
                       This is a paragraph [with an inline link](\(normalLink)) and also with an ![inline image](\(imageLink))
                       """

        // Act
        let tokens = parser.tokenize(markdown)

        // Assert
        XCTAssertEqual(tokens.count, 8)
        for i in 0...tokens.count - 1 {
            let token = tokens[i]

            switch i {

            case 1, 5:
                XCTAssertTrue(token is MarkdownLink)
                let link = token as! MarkdownLink
                XCTAssertEqual(link.url, normalLink)
                XCTAssertFalse(link.isImage)

            case 3, 7:
                XCTAssertTrue(token is MarkdownLink)
                let link = token as! MarkdownLink
                XCTAssertEqual(link.url, imageLink)
                XCTAssertTrue(link.isImage)
                
            default:
                XCTAssertTrue(token is MarkdownParagraph)
            }
        }
    }
}
