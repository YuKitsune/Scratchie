//
// Created by Eoin Motherway on 5/4/21.
//

import Foundation

// Todo: Add commonly used rules
//  E.g: Cannot begin part way through a line
// Todo: Expose current builders to prevent overlapping tokens
//  E.g: Don't want bold inside of a code block
class TokenBuilderFactory {
    let tokenType: TokenType
    let beginningPredicate: (StringTraverser) -> Bool
    let completionPredicate: (StringTraverser) -> Bool
    let canMakeFactory: () -> Bool

    init (
        tokenType: TokenType,
        startingFrom beginningPredicate: @escaping (StringTraverser) -> Bool,
        until completionPredicate: @escaping (StringTraverser) -> Bool,
        predicate canMakeFactory: @escaping () -> Bool = { true }) {
        self.tokenType = tokenType
        self.beginningPredicate = beginningPredicate
        self.completionPredicate = completionPredicate
        self.canMakeFactory = canMakeFactory
    }

    convenience init (
        tokenType: TokenType,
        prefix: String,
        suffix: String,
        predicate canMakeFactory: @escaping () -> Bool = { true }) {
        let prefixFirstChar = prefix.first
        let prefixRestChar = prefix.dropFirst(1)

        let suffixLastChar = suffix.last
        let suffixChars = suffix.dropLast(1)

        self.init(
                tokenType: tokenType,
                startingFrom: { traverser in
                    try! traverser.currentCharacter() == prefixFirstChar &&
                            (prefixRestChar.isEmpty || traverser.peek(by: prefixRestChar.count) == prefixRestChar) },
                until: { traverser in
                    try! traverser.currentCharacter() == suffixLastChar &&
                            (suffixChars.isEmpty || traverser.peek(by: suffixChars.count) == suffixChars) },
                predicate: canMakeFactory)
    }

    func createBuilder(startIndex: Int) -> TokenBuilder {
        TokenBuilder(tokenType: tokenType, startIndex: startIndex, completionPredicate: completionPredicate)
    }
}

class TokenBuilder {
    let tokenType: TokenType
    let startIndex: Int
    var length: Int = 0

    let isComplete: (StringTraverser) -> Bool

    required init (
            tokenType: TokenType,
            startIndex: Int,
            completionPredicate: @escaping (StringTraverser) -> Bool) {
        self.tokenType = tokenType
        self.startIndex = startIndex
        self.isComplete = completionPredicate
    }

    func continueBuilding() {
        length += 1
    }

    func build() -> Token {
        Token(type: tokenType, startIndex: startIndex, length: length)
    }
}
