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
    let tokenizerFactory: (String) -> MarkdownTokenizer
    static let defaultFontSize: CGFloat = 17
    
    
    init (tokenizerFactory: @escaping (String) -> MarkdownTokenizer, inner: TextFormatter? = nil) {
        self.inner = inner
        self.tokenizerFactory = tokenizerFactory
    }
    
    func format(_ attributedString: NSMutableAttributedString) {
        
        let text = attributedString.string
        let tokenizer = tokenizerFactory(text)
        let tokens = tokenizer.getTokens()
        format(tokens: tokens, attributedString: attributedString)
        
        inner?.format(attributedString)
    }
    
    func format(tokens: [Token], attributedString: NSMutableAttributedString) {
        for token in tokens {
            addAttributesForToken(token: token, attributedString: attributedString)
        }
    }
    
    func addAttributesForToken(token: Token, attributedString: NSMutableAttributedString) {
        
        switch token.type {
        
        // MARK: Heading
        case .heading:
            
            let font: NSFont
            switch token.getHeadingLevel(token: token, text: attributedString.string) {
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
                range: token.range)
            
        // MARK: Bold
        case .bold:
            attributedString.addAttribute(
                .font,
                value: getPreferredFont(withWeight: .bold),
                range: token.range)
            break;
            
        // MARK: Underline
        case .underline:
            attributedString.addAttribute(
                .underlineStyle,
                value: 1,
                range: token.range)
            break;
            
        // MARK: Strikethrough
        case .strikethrough:
            attributedString.addAttributes(
                [
                    .font: getPreferredFont(),
                    .strikethroughStyle: 1
                ],
                range: token.range)
            break;
            
        default: attributedString.addAttribute(
            .font,
            value: getPreferredFont(),
            range: token.range)
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
