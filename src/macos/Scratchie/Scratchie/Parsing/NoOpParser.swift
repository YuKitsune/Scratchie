//
//  NoOpParser.swift
//  Scratchie
//
//  Created by Eoin Motherway on 6/3/21.
//

import Foundation

struct NoOpParser: Parser {
    func parse(_ text: String) -> NSMutableAttributedString {
        NSMutableAttributedString(string: text)
    }
}
