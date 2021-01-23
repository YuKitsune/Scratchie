//
// Created by Eoin Motherway on 13/1/21.
//

import Foundation

protocol MarkdownToken {
    var value: String { get mutating set }
    func isComplete() -> Bool

    init(value: String)
}

extension MarkdownToken {
    func isMultiLine() -> Bool {
        value.contains { character in character == "\n" }
    }

    init (character: Character) {
        self.init(value: String(character))
    }

    init (characters: [Character]) {
        self.init(value: String(characters))
    }
}

class MarkdownHeading: MarkdownToken {
    var value: String
    var level: Int {
        var level: Int = 0
        for char in value {
            if char == "#" {
                level += 1
            } else {
                break
            }
        }

        return level
    }

    required init(value: String) {
        self.value = value
    }

    func isComplete() -> Bool {
        value.hasSuffix("\n")
    }
}

class MarkdownHorizontalRule: MarkdownToken {
    var value: String

    required init(value: String) {
        self.value = value
    }

    func isComplete() -> Bool {
        value.hasSuffix("\n")
    }
}

class MarkdownQuote: MarkdownToken {
    var value: String

    required init(value: String) {
        self.value = value
    }

    func isComplete() -> Bool {
        value.hasSuffix("\n")
    }
}

class MarkdownCodeBlock: MarkdownToken {
    var value: String

    required init(value: String) {
        self.value = value
    }

    func isComplete() -> Bool {
        value.hasSuffix("```")
    }
}

class MarkdownParagraph: MarkdownToken {
    var value: String

    required init(value: String) {
        self.value = value
    }

    func isComplete() -> Bool {
        false
    }
}

class MarkdownBold: MarkdownToken {
    var value: String

    required init(value: String) {
        self.value = value
    }

    func isComplete() -> Bool {
        value.hasSuffix(value.prefix(1))
    }
}

class MarkdownItalic: MarkdownToken {
    var value: String

    required init(value: String) {
        self.value = value
    }

    func isComplete() -> Bool {
        value.hasSuffix(value.prefix(1))
    }
}

class MarkdownUnderline: MarkdownToken {
    var value: String

    required init(value: String) {
        self.value = value
    }

    func isComplete() -> Bool {
        value.hasSuffix(value.prefix(1))
    }
}

class MarkdownStrikethrough: MarkdownToken {
    var value: String

    required init(value: String) {
        self.value = value
    }

    func isComplete() -> Bool {
        value.hasSuffix(value.prefix(1))
    }
}

class MarkdownLink: MarkdownToken {

    private let imageUrlRegex = try! NSRegularExpression(pattern: "(?<=!)(\\[.+\\])(\\(.+\\))")
    private let urlRegex = try! NSRegularExpression(pattern: "(?<!!)(\\[.+\\])(\\(.+\\))")

    private var linkRegex: NSRegularExpression {
        if isImage {
            return imageUrlRegex
        } else {
            return urlRegex
        }
    }

    private let linkTextRegexPattern = "(?<=\\[).+(?=\\])"
    private let linkUrlRegexPattern = "(?<=\\().+(?=\\))"

    var value: String

    var linkText: String {
        let range = value.range(of: linkTextRegexPattern, options: .regularExpression)
        if range == nil {
            return ""
        }

        return String(value[range!])
    }

    var url: String {
        let range = value.range(of: linkUrlRegexPattern, options: .regularExpression)
        if range == nil {
            return ""
        }

        return String(value[range!])
    }

    var isImage: Bool {
        value.prefix(1) == "!"
    }

    required init(value: String) {
        self.value = value
    }

    func isComplete() -> Bool {
        let match = linkRegex.firstMatch(
                in: value,
                options: .withoutAnchoringBounds,
                range: NSRange(location: 0, length: value.count))
        return match != nil
    }
}
