//
//  MarkdownLink.swift
//  Scratchie
//
//  Created by Eoin Motherway on 15/3/21.
//

import Foundation

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
