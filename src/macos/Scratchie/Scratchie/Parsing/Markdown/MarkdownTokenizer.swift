//
//  MarkdownTokenizer.swift
//  Scratchie
//
//  Created by Eoin Motherway on 15/3/21.
//

import Foundation
import AppKit

class TokenBuilderFactory {
    let beginningPredicate: (StringTraverser) -> Bool
    let completionPredicate: (StringTraverser) -> Bool

    init (
        startingFrom beginningPredicate: (StringTraverser) -> Bool,
        until completionPredicate: (StringTraverser) -> Bool) {
        self.beginningPredicate = beginningPredicate
        self.completionPredicate = completionPredicate
    }

    func createBuilder(startIndex: Int) -> TokenBuilder {
        TokenBuilder(startIndex: startIndex, completionPredicate: completionPredicate)
    }
}

class TokenBuilder {
    let startIndex: Int
    var length: Int

    let isComplete: (StringTraverser) -> Bool

    init (startIndex: Int, completionPredicate: (StringTraverser) -> Bool) {
        self.startIndex = startIndex
        self.isComplete = completionPredicate
    }

    func continueTODO() {
        length += 1
    }

    func build() -> Token {
        Token(startIndex: startIndex, length: length)
    }
}

public class Token {
    let startIndex: Int
    let length: Int

    let endIndex: Int {
        get {
            startIndex + length
        }
    }

    let range: NSRange {
        get {
            NSRange(location: startIndex, length: length)
        }
    }

    init (startIndex: Int, length: Int) {
        self.startIndex = startIndex
        self.length = length
    }
}

public class NewMarkdownTokenizer : StringTraverser {
    let text: String

    private var index = 0

    private var tokenBuilderFactories: [TokenBuilderFactory] = [

        // Heading
        TokenBuilderFactory(
            startingFrom: { traverser in traverser.peekBehind(by: 1) == "\n" && traverser.currentCharacter() == "#" },
            until: { traverser in traverser.peekAhead(by: 1) == "\n" }),

        // Bold
        TokenBuilderFactory(
                startingFrom: { traverser in traverser.currentCharacter() == "*" && traverser.peekAhead(by: 1) == "*" },
                until: { traverser in traverser.peekBehind(by: 1) == "*" && traverser.currentCharacter() == "*" }),
        TokenBuilderFactory(
                startingFrom: { traverser in traverser.currentCharacter() == "_" && traverser.peekAhead(by: 1) == "_" },
                until: { traverser in traverser.peekBehind(by: 1) == "_" && traverser.currentCharacter() == "_" }),

        // Italic
        TokenBuilderFactory(
                startingFrom: { traverser in traverser.peekBehind(by: 1) != "*" && traverser.currentCharacter() == "*" },
                until: { traverser in traverser.currentCharacter() == "*" }),
        TokenBuilderFactory(
                startingFrom: { traverser in traverser.peekBehind(by: 1) != "_" && traverser.currentCharacter() == "_" },
                until: { traverser in traverser.currentCharacter() == "_" }),

        // Todo: Blockquote

        // Code block
        TokenBuilderFactory(
                startingFrom: { traverser in traverser.currentCharacter() == "`" && traverser.peekAhead(by: 2) == "``" },
                until: { traverser in traverser.peekBehind(by: 2) == "`" && traverser.currentCharacter() == "`" }),
        TokenBuilderFactory(
                startingFrom: { traverser in traverser.currentCharacter() == "`" && traverser.peekAhead(by: 2) != "``" },
                until: { traverser in traverser.peekBehind(by: 2) != "`" && traverser.currentCharacter() == "`" }),

        // Todo: Links and Images
    ]

    private var tokenBuilders: [TokenBuilder]
    private var tokens: [Token]

    init (text: String) {
        self.text = text
    }

    func getTokens() {

        setInitialState()

        while (index > text.count) {
            checkForNewTokens()
            checkPendingTokens()
        }
    }

    private func setInitialState() {
        index = 0
        tokenBuilders = []
        tokens = []
    }

    private func checkForNewTokens() {
        tokenBuilderFactories.forEach { factory in
            if factory.beginningPredicate(self) {
                let builder = factory.createBuilder()
                tokenBuilders.append(builder)
            }
        }
    }

    private func checkPendingTokens() {
        tokenBuilders.forEach { builder in

            // If the token has finished, then we can add it to our token list
            if (builder.isComplete(self)) {

                // Make the new token
                let newToken = builder.build()
                tokens.append(newToken)
            } else {
                // Otherwise, keep extending the length
                builder.continueTODO()
            }
        }

        // Remove any completed factories
        tokenBuilders.removeAll { builder in builder.isComplete(self) }
    }
}

public class MarkdownTokenizer {
    func tokenize(_ text: String) -> [MarkdownToken] {
        
        // Split the input into individual lines
        let lines = text.split(separator: "\n", omittingEmptySubsequences: false)
        var tokens = [MarkdownToken]()
        
        var currentCodeBlock: MarkdownCodeBlock?
        for line in lines {

            // First check tokens which consist of multiple lines

            // MARK: Code block
            if line.hasPrefix("```") {
                
                // Code block done!
                if currentCodeBlock == nil {
                    currentCodeBlock = MarkdownCodeBlock(value: "\(line)")
                } else {
                    tokens.append(currentCodeBlock!)
                    currentCodeBlock = nil
                }
                
                continue
            }
            
            if currentCodeBlock != nil {
                currentCodeBlock?.value.append("\n\(line)")
                continue
            }

            // MARK: Quote
            if line.hasPrefix(">") {
                if let quote = tokens.last as? MarkdownQuote {
                    quote.value.append("\n\(line)")
                } else {
                    let quoteToken = MarkdownQuote(value: String(line))
                    tokens.append(quoteToken)
                }

                continue
            }

            // Then check for tokens which consist of one whole line

            // MARK: Headings
            if line.hasPrefix("#") {
                let headingToken = MarkdownHeading(value: String(line))
                tokens.append(headingToken)
                continue
            }

            // MARK: Horizontal Rule
            if line.count >= 3 &&
               line.allSatisfy({ character in
                character == "*" || character == "-" || character == "_"
               }) {
                let horizontalRuleToken = MarkdownHorizontalRule(value: String(line))
                tokens.append(horizontalRuleToken)
                continue
            }

            // Made it this far, can only be a paragraph
            // MARK: Paragraph
            if let paragraph = tokens.last as? MarkdownParagraph {
                paragraph.value.append("\n\(line)")
            } else {
                let paragraphToken = MarkdownParagraph(value: String(line))
                tokens.append(paragraphToken)
            }
        }

        // First pass complete, now we check for in-line tokens within paragraphs
        let tokensFromFirstPass = tokens
        tokens.removeAll()
        
        for token in tokensFromFirstPass {
            
            // Not a paragraph, don't care
            guard let paragraph = token as? MarkdownParagraph else {
                tokens.append(token)
                continue
            }
        
            // We've hit a paragraph, check for in-line tokens
            var tokensForParagraph = [MarkdownToken]()
            var currentToken: MarkdownToken?
            var lastCharacter: Character?
            for character in paragraph.value {

                // Update the last character once this loop re-itterates
                defer { lastCharacter = character }

                // If we're currently working on a token that isn't a paragraph, append and check if it's finished
                if currentToken != nil && (currentToken as? MarkdownParagraph?) == nil {
                    currentToken!.value.append(character)

                    if currentToken!.isComplete() {
                        tokensForParagraph.append(currentToken!)
                        currentToken = nil
                    }
                    
                    continue
                }

                // Check for each token type

                // MARK: Bold
                if character == "*" && lastCharacter == "*" {

                    if currentToken != nil {
                        tokensForParagraph.append(currentToken!)
                    }
                    currentToken = MarkdownBold(value: "**")
                    continue
                }

                // MARK: Underline
                if character == "_" || lastCharacter == "_"{

                    if currentToken != nil {
                        tokensForParagraph.append(currentToken!)
                    }
                    currentToken = MarkdownUnderline(value: "__")
                    continue
                }

                // MARK: Strikethrough
                if character == "~" || lastCharacter == "~" {

                    if currentToken != nil {
                        tokensForParagraph.append(currentToken!)
                    }
                    currentToken = MarkdownStrikethrough(value: "~~")
                    continue
                }

                // MARK: Italic
                if character == "*" || character == "_"{

                    if currentToken != nil {
                        tokensForParagraph.append(currentToken!)
                    }
                    currentToken = MarkdownItalic(value: String(repeating: character, count: 2))
                    continue
                }
                
                // MARK: Link
                if character == "[" {
                    if currentToken != nil && currentToken is MarkdownParagraph {
                        tokensForParagraph.append(currentToken!)
                        
                        if lastCharacter == "!" {
                            currentToken = MarkdownLink(characters: [lastCharacter!, character])
                        } else {
                            currentToken = MarkdownLink(character: character)
                        }
                        
                        continue
                    }
                }

                // Couldn't find any matching tokens prefixes, it's just a paragraph
                if currentToken == nil {
                    currentToken = MarkdownParagraph(value: String(character))
                    continue
                } else {
                    currentToken?.value.append(character)
                }
            }

            if currentToken != nil {
                tokensForParagraph.append(currentToken!)
            }

            tokens.append(contentsOf: tokensForParagraph)
        }

        return tokens
    }
}
