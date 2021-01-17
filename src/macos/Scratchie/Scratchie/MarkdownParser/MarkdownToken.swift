//
// Created by Eoin Motherway on 13/1/21.
//

import Foundation

class MarkdownToken {
    var value: String

    var isMultiline: Bool {
        value.contains { character in character == "\n" }
    }

    init(value: String) {
        self.value = value
    }
}

class MarkdownHeading: MarkdownToken {
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
}

class MarkdownHorizontalRule: MarkdownToken {
}

class MarkdownQuote: MarkdownToken {
}

class MarkdownCodeBlock: MarkdownToken {
}

class MarkdownParagraph: MarkdownToken {
}

class MarkdownBold: MarkdownToken {
}

class MarkdownItalic: MarkdownToken {
}

class MarkdownUnderline: MarkdownToken {
}

class MarkdownStrikethrough: MarkdownToken {
}

class MarkdownLink: MarkdownToken {

    private let linkTextRegex = "(?<=\\[).+(?=\\])"
    private let linkUrlRegex = "(?<=\\().+(?=\\))"

    var linkText: String {
        let range = value.range(of: linkTextRegex, options: .regularExpression)
        if range == nil {
            return ""
        }

        return String(value[range!])
    }

    var url: String {
        let range = value.range(of: linkUrlRegex, options: .regularExpression)
        if range == nil {
            return ""
        }

        return String(value[range!])
    }
}

class MarkdownImage: MarkdownLink {
}

class MarkdownTable: MarkdownToken {
}