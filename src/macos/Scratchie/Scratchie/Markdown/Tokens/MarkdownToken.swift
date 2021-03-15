//
//  MarkdownToken.swift
//  Scratchie
//
//  Created by Eoin Motherway on 15/3/21.
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
