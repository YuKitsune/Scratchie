//
//  MarkdownFormatter.swift
//  Scratchie
//
//  Created by Eoin Motherway on 15/3/21.
//

import Foundation
import SwiftUI
import MarkdownKit

class MarkdownFormatter: TextFormatter {
    
    let markdownParser = MarkdownParser()
    
    func format(_ attributedString: NSMutableAttributedString) {
        markdownParser.parse(attributedString)
    }
}
