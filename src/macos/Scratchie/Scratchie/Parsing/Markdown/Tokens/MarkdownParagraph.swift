//
//  MarkdownParagraph.swift
//  Scratchie
//
//  Created by Eoin Motherway on 15/3/21.
//

import Foundation

class MarkdownParagraph: MarkdownToken {
    var value: String

    required init(value: String) {
        self.value = value
    }

    func isComplete() -> Bool {
        false
    }
}
