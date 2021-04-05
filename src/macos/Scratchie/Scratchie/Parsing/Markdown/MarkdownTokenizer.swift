//
//  MarkdownTokenizer.swift
//  Scratchie
//
//  Created by Eoin Motherway on 15/3/21.
//

import Foundation
import AppKit

public class MarkdownTokenizer : StringTraverser {
    let text: String
    var currentIndex: Int = 0

    private var tokenBuilderFactories: [TokenBuilderFactory]!

    private var tokenBuilders: [TokenBuilder] = []
    private var tokens: [Token] = []

    init (text: String) {
        self.text = text
        self.tokenBuilderFactories = getTokenBuilderFactories()
    }

    func getTokens() -> [Token] {

        setInitialState()

        while (currentIndex < text.count) {
            checkForNewTokens()
            checkPendingTokens()
            advance(by: 1)
        }

        return tokens
    }

    private func setInitialState() {
        currentIndex = 0
        tokenBuilders = []
        tokens = []
    }

    private func checkForNewTokens() {
        tokenBuilderFactories.forEach { factory in
            if factory.canMakeFactory() && factory.beginningPredicate(self) {
                let builder = factory.createBuilder(startIndex: currentIndex)
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
                builder.continueBuilding()
            }
        }

        // Remove any completed factories
        tokenBuilders.removeAll { builder in builder.isComplete(self) }
    }
    
    func advance(by length: Int) {
        currentIndex += length
    }

    private func getTokenBuilderFactories() -> [TokenBuilderFactory] {
        [
            // Heading
            TokenBuilderFactory(
                    tokenType: .heading,
                    startingFrom: { traverser in traverser.peekBehind(by: 1) == "\n" && traverser.currentCharacter() == "#" },
                    until: { traverser in traverser.peekAhead(by: 1) == "\n" },
                    predicate: { !self.tokenBuilders.contains { builder in builder.tokenType == .codeBlock } }),

            // Bold
            TokenBuilderFactory(
                    tokenType: .bold,
                    startingFrom: { traverser in traverser.currentCharacter() == "*" && traverser.peekAhead(by: 1) == "*" },
                    until: { traverser in traverser.peekBehind(by: 1) == "*" && traverser.currentCharacter() == "*" },
                    predicate: { !self.tokenBuilders.contains { builder in builder.tokenType == .codeBlock } }),
            TokenBuilderFactory(
                    tokenType: .bold,
                    startingFrom: { traverser in traverser.currentCharacter() == "_" && traverser.peekAhead(by: 1) == "_" },
                    until: { traverser in traverser.peekBehind(by: 1) == "_" && traverser.currentCharacter() == "_" },
                    predicate: { !self.tokenBuilders.contains { builder in builder.tokenType == .codeBlock } }),

            // Italic
            TokenBuilderFactory(
                    tokenType: .italic,
                    startingFrom: { traverser in traverser.peekBehind(by: 1) != "*" && traverser.currentCharacter() == "*" },
                    until: { traverser in traverser.currentCharacter() == "*" },
                    predicate: { !self.tokenBuilders.contains { builder in builder.tokenType == .codeBlock } }),
            TokenBuilderFactory(
                    tokenType: .italic,
                    startingFrom: { traverser in traverser.peekBehind(by: 1) != "_" && traverser.currentCharacter() == "_" },
                    until: { traverser in traverser.currentCharacter() == "_" },
                    predicate: { !self.tokenBuilders.contains { builder in builder.tokenType == .codeBlock } }),

            // Strikethrough
            TokenBuilderFactory(
                    tokenType: .italic,
                    startingFrom: { traverser in traverser.currentCharacter() == "~" },
                    until: { traverser in traverser.currentCharacter() == "~" },
                    predicate: { !self.tokenBuilders.contains { builder in builder.tokenType == .codeBlock } }),

            // Todo: Blockquote

            // Code block
            TokenBuilderFactory(
                    tokenType: .codeBlock,
                    startingFrom: { traverser in traverser.currentCharacter() == "`" && traverser.peekAhead(by: 2) == "``" },
                    until: { traverser in traverser.peekBehind(by: 2) == "`" && traverser.currentCharacter() == "`" }),
            TokenBuilderFactory(
                    tokenType: .codeBlock,
                    startingFrom: { traverser in traverser.currentCharacter() == "`" && traverser.peekAhead(by: 2) != "``" },
                    until: { traverser in traverser.peekBehind(by: 2) != "`" && traverser.currentCharacter() == "`" }),

            // Todo: Links and Images
        ]
    }
}
