//
//  TextParser.swift
//  Scratchie
//
//  Created by Eoin Motherway on 14/3/21.
//

import Foundation

public protocol TextFormatter {
    func format(_ attributedString: NSMutableAttributedString)
}

extension TextFormatter {
    func format(_ text: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        format(attributedString)
        return attributedString
    }
}
