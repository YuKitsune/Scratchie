//
// Created by Eoin Motherway on 2/4/21.
//

import Foundation

enum StringTraverserError: Error {
    case InvalidPeekLength(length: Int)
}

protocol StringTraverser {
    var text: String { get }
    var currentIndex: Int { get }
}

extension StringTraverser {

    func currentCharacter() -> Character {
        let currentCharacterAsString = String(text.dropFirst(currentIndex).prefix(1) as Substring)
        return Character(currentCharacterAsString)
    }

    func peek(by length: Int = 1) throws -> Substring {
        if (length > 0) {
            return peekAhead(by: UInt(length))
        }

        if (length < 0) {
            return peekBehind(by: UInt(length))
        }

        throw StringTraverserError.InvalidPeekLength(length: length)
    }

    func peekAhead(by length: UInt = 1) -> Substring {
        text.dropFirst(currentIndex).prefix(Int(length))
    }

    func peekBehind(by length: UInt = 1) -> Substring {
        let startIndex = currentIndex - Int(length)
        text.dropFirst(startIndex).prefix(Int(length))
    }
}
