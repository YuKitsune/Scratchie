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
}

class TokenFactory {
    let id = UUID()
    let startIndex: Int
    var length: Int

    let isFinished: (_ peeker: peekFunction) -> Bool
    let tokenFactory: () -> Token

    init (startIndex: Int, isFinishedPredicate: @escaping (peekFunction) -> Bool, tokenFactory: @escaping () -> Token) {
        self.startIndex = startIndex
        self.isFinished = isFinishedPredicate
        self.tokenFactory = tokenFactory
    }

    func continueEating() {
        length += 1
    }
}

enum TokenType {
}

public class Token {
    var tokenType: TokenType = .Plaintext
    var startIndex: Int
    var length: Int

    var endIndex: Int {
        get {
            startIndex + length
        }
    }

    var range: NSRange {
        get {
            NSRange(location: startIndex, length: length)
        }
    }
}

public class RealMarkdownTokenizer {
    let text: String

    private var index = 0

    private var pendingTokens: [TokenFactory] = []
    private var tokens: [Token] = []

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
    }

    private func checkForNewTokens() {

        // MARK: Headings
        if peek(length: -1) != "\n" && getCurrentCharacter() == "#" {
            startNewToken(
                until: { peekFunc in peekFunc(0) == "\n"},
                tokenFactory: { TODO })
            return
        }

        // MARK: Bold
        if peek(length: 2) == "**" {
            startNewToken(
                    until: { peekFunc in peekFunc(-2) == "**"},
                    tokenFactory: { TODO })
            return
        }

        if peek(length: 2) == "__" {
            startNewToken(
                    until: { peekFunc in peekFunc(-2) == "__"},
                    tokenFactory: { TODO })
            return
        }

        // MARK: Italic
        if peek(length: 1) == "*" {
            startNewToken(
                    until: { peekFunc in peekFunc(-1) == "*"},
                    tokenFactory: { TODO })
            return
        }

        if peek(length: 1) == "_" {
            startNewToken(
                    until: { peekFunc in peekFunc(-1) == "_"},
                    tokenFactory: { TODO })
            return
        }

        // MARK: Todo: Blockquote


    }

    private func checkPendingTokens() {

        var completedTokenFactoryIds: [UUID] = []
        pendingTokens.forEach { tokenFactory in

            // If the token has finished, then we can add it to our token list
            if (tokenFactory.isFinished(peek)) {

                // Make the new token
                let newToken = tokenFactory.tokenFactory()
                tokens.append(newToken)

                // We're done with this factory, mark it for removal
                completedTokenFactoryIds.append(tokenFactory.id)
            } else {
                // Otherwise, keep extending the length
                tokenFactory.continueEating()
            }
        }

        // Remove any completed factories
        completedTokenFactoryIds.forEach { id in
            pendingTokens.removeAll { factory in factory.id == id }
        }
    }

    private func startNewToken(
        until isFinishedPredicate: @escaping (peekFunction) -> Bool,
        tokenFactory: @escaping () -> Token) {
        let factory = TokenFactory(
                startIndex: index,
                isFinishedPredicate: isFinishedPredicate,
                tokenFactory: tokenFactory)
        pendingTokens.append(factory)
    }

    private func getCurrentCharacter() -> Character {
        let currentCharacterAsString = String(text.dropFirst(index).prefix(1) as Substring)
        return Character(currentCharacterAsString)
    }

    private func peek(length: Int = 1) -> Substring {
        if (length > 0) {
            return text.dropFirst(index).prefix(length)
        }

        if (length < 0) {
            return text.dropFirst(index - length).prefix(length)
        }

        return text.dropFirst(index - 1).prefix(1)
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
