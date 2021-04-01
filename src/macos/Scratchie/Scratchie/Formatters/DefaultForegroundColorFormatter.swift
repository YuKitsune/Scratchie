//
//  File.swift
//  Scratchie
//
//  Created by Eoin Motherway on 1/4/21.
//

import Foundation
import AppKit

class DefaultForegroundColorFormatter: TextFormatter {
    let inner: TextFormatter?
    
    init (inner: TextFormatter? = nil) {
        self.inner = inner
    }
    
    public func format(_ attributedString: NSMutableAttributedString) {
        attributedString.addAttribute(
            .foregroundColor,
            value: NSColor.labelColor,
            range: NSRange(location: 0, length: attributedString.length))
        inner?.format(attributedString)
    }
}
