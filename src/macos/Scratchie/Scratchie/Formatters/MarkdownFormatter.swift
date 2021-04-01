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
    static let defaultFontSize: CGFloat = 17
    
    
    init (tokenizer: MarkdownTokenizer, inner: TextFormatter? = nil) {
        self.inner = inner
        self.tokenizer = tokenizer
    }
    
    func format(_ attributedString: NSMutableAttributedString) {
        
        let text = attributedString.string
        let tokens = tokenizer.tokenize(text)
        format(tokens: tokens, attributedString: attributedString)
        
        inner?.format(attributedString)
    }
    
    func format(tokens: [MarkdownToken], attributedString: NSMutableAttributedString) {
        
        var position = 0
        for token in tokens {
            var length = token.value.count + 1
            
            // Make sure our length doesn't overrun the string
            if position + length > attributedString.length {
                length = attributedString.length - position
            }
            
            let range = NSRange(location: position, length: length)
            
            addAttributesForToken(token: token, range: range, attributedString: attributedString)
                        
            position += length
        }
    }
    
    func addAttributesForToken(token: MarkdownToken, range: NSRange, attributedString: NSMutableAttributedString) {
        
        switch token {
        
        // MARK: Heading
        case let heading as MarkdownHeading:
            
            let font: NSFont
            switch heading.level {
            case 1: font = getPreferredFont(withSize: 34); break;
            case 2: font = getPreferredFont(withSize: 28); break;
            case 3: font = getPreferredFont(withSize: 22); break;
            case 4: font = getPreferredFont(withSize: 20); break;
            case 5: font = getPreferredFont(withWeight: .semibold); break;
            default: font = getPreferredFont(); break;
            }

            attributedString.addAttribute(
                .font,
                value: font,
                range: range)
            
        // MARK: Bold
        case _ as MarkdownBold:
            attributedString.addAttribute(
                .font,
                value: getPreferredFont(withWeight: .bold),
                range: range)
            break;
            
        // MARK: Underline
        case _ as MarkdownUnderline:
            attributedString.addAttribute(
                .underlineStyle,
                value: 1,
                range: range)
            break;
            
        // MARK: Strikethrough
        case _ as MarkdownStrikethrough:
            attributedString.addAttributes(
                [
                    .font: getPreferredFont(),
                    .strikethroughStyle: 1
                ],
                range: range)
            break;
            
        default: attributedString.addAttribute(
            .font,
            value: getPreferredFont(),
            range: range)
        }
    }
    
    func getPreferredFont(
        withSize size: CGFloat = defaultFontSize,
        withWeight weight: NSFont.Weight = .regular,
        withTraits maybeTraits: NSFontDescriptor.SymbolicTraits? = nil) -> NSFont {
        let font = NSFont.monospacedSystemFont(ofSize: size, weight: weight)
        
        guard let traits = maybeTraits else {
            return font
        }
        
        let fontDescriptor = font.fontDescriptor.withSymbolicTraits(traits)
        guard let fontWithTraits = NSFont(descriptor: fontDescriptor, size: size) else {
            return font
        }
        
        return fontWithTraits
    }
}
