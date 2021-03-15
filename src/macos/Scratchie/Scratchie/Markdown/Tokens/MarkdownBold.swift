//
//  MarkdownBold.swift
//  Scratchie
//
//  Created by Eoin Motherway on 15/3/21.
//

import Foundation

class MarkdownBold: MarkdownToken {
    var value: String

    required init(value: String) {
        self.value = value
    }

    func isComplete() -> Bool {
        value.hasSuffix(value.prefix(1))
    }
}
