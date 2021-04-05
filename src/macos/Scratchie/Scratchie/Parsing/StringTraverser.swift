//
// Created by Eoin Motherway on 2/4/21.
//

import Foundation

protocol StringTraverser {
    var text: String { get }
    var currentIndex: Int { get set }
    
    func advance(by length: Int)
}

extension StringTraverser {

    func currentCharacter() -> Character {
        let currentCharacterAsString = String(text.dropFirst(currentIndex).prefix(1) as Substring)
        return Character(currentCharacterAsString)
    }

    func peek(by length: Int = 1) throws -> Substring? {
        if (length > 0) {
            return peekAhead(by: UInt(length))
        }

        if (length < 0) {
            return peekBehind(by: UInt(length))
        }

        return nil
    }

    func peekAhead(by length: UInt = 1) -> Substring? {
        if (currentIndex + Int(length) > text.count) { return nil }
        return text.dropFirst(currentIndex).prefix(Int(length))
    }

    func peekBehind(by length: UInt = 1) -> Substring? {
        let startIndex = currentIndex - Int(length)
        if (startIndex < 0) { return nil }

        return text.dropFirst(startIndex).prefix(Int(length))
    }
}
