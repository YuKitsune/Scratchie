//
// Created by Eoin Motherway on 5/4/21.
//

import Foundation

public enum TokenType {
    case plainText

    case heading
    case quote
    case codeBlock

    case bold
    case italic
    case underline
    case strikethrough

    case link
    case image
}

public class Token {
    let type: TokenType
    let startIndex: Int
    let length: Int

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

    required init (type: TokenType, startIndex: Int, length: Int) {
        self.type = type
        self.startIndex = startIndex
        self.length = length
    }
}

extension Token {
    func getTokenValue(token: Token, text: String) -> String {
        String(text.dropFirst(token.startIndex).prefix(token.length))
    }

    func getHeadingLevel(token: Token, text: String) -> Int {
        guard token.type == .heading else {
            return 0
        }

        let tokenValue = getTokenValue(token: token, text: text)
        var level: Int = 0
        for char in tokenValue {
            if char == "#" {
                level += 1
            } else {
                break
            }
        }

        return level
    }
}