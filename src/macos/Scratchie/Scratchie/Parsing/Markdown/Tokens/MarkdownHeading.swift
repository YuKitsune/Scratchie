//
//  MarkdownHeading.swift
//  Scratchie
//
//  Created by Eoin Motherway on 15/3/21.
//

import Foundation

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
