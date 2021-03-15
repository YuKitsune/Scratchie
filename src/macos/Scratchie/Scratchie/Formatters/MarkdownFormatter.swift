//
//  MarkdownFormatter.swift
//  Scratchie
//
//  Created by Eoin Motherway on 15/3/21.
//

import Foundation

class MarkdownFormatter: TextFormatter {
    let tokenizer: MarkdownTokenizer
    
    init (tokenizer: MarkdownTokenizer) {
        self.tokenizer = tokenizer
    }
    
    func format(_ attributedString: NSMutableAttributedString) {
        
        let text = attributedString.string
        let tokens = tokenizer.tokenize(text)
        
        for token in tokens {
            
        }
    }
}
