//
//  MarkdownFormatter.swift
//  Scratchie
//
//  Created by Eoin Motherway on 15/3/21.
//

import Foundation
import SwiftUI

class MarkdownFormatter: TextFormatter {
    
    let inner: TextFormatter?
    let tokenizer: MarkdownTokenizer
    let colors: [NSColor] = [ .systemRed, .systemGreen]
    let useDebugColors = false
    
    
    init (tokenizer: MarkdownTokenizer, inner: TextFormatter? = nil) {
        self.inner = inner
        self.tokenizer = tokenizer
    }
    
    func format(_ attributedString: NSMutableAttributedString) {
        
        let text = attributedString.string
        let tokens = tokenizer.tokenize(text)
                
        var position = 0
        var index = 0
        
        for token in tokens {
            var length = token.value.count + 1
            
            // Make sure our length doesn't overrun the string
            if position + length > attributedString.length {
                length = attributedString.length - position
            }
            
            let range = NSRange(location: position, length: length)
            
            attributedString.addAttribute(
                .font,
                value: getAttributeForToken(token),
                range: range)
            
            if useDebugColors {
                let isEven = index % 2 == 0
                attributedString.addAttribute(
                    .backgroundColor,
                    value: colors[isEven ? 0 : 1],
                    range: range)
            }
            
            position += length 
            index += 1
        }
        
        inner?.format(attributedString)
    }
    
    func getAttributeForToken(_ token: MarkdownToken) -> Any {
        switch token {
        
        // MARK: Heading
        case let heading as MarkdownHeading:
            
            let font: NSFont
            switch heading.level {
            case 1: font = NSFont.monospacedSystemFont(ofSize: 34, weight: .regular); break;
            case 2: font = NSFont.monospacedSystemFont(ofSize: 28, weight: .regular); break;
            case 3: font = NSFont.monospacedSystemFont(ofSize: 22, weight: .regular); break;
            case 4: font = NSFont.monospacedSystemFont(ofSize: 20, weight: .regular); break;
            case 5: font = NSFont.monospacedSystemFont(ofSize: 17, weight: .semibold); break;
            default: font = NSFont.monospacedSystemFont(ofSize: 17, weight: .regular); break;
            }
            
            return font
            
        default: return NSFont.monospacedSystemFont(ofSize: 17, weight: .regular)
        }
        
    }
}
