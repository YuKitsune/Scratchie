//
//  MonospaceEverythingParser.swift
//  Scratchie
//
//  Created by Eoin Motherway on 14/3/21.
//

import Foundation
import AppKit

public class MonospaceEverythingParser: TextFormatter {
    public func format(_ attributedString: NSMutableAttributedString) {
        attributedString.addAttribute(
            .font,
            value: NSFont.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular),
            range: NSRange(location: 0, length: attributedString.length))
    }
}