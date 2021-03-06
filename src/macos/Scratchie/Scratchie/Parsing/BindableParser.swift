//
//  BindableParser.swift
//  Scratchie
//
//  Created by Eoin Motherway on 6/3/21.
//

import Foundation
import SwiftUI

class BindableParser: Parser, ObservableObject {
    private let inner: Parser
    @Binding public var text: String {
        didSet {
            self.parsedText = self.parse(text)
        }
    }
    
    public var parsedText: NSMutableAttributedString
    
    init (inner: Parser, text: Binding<String>) {
        self.inner = inner
        _text = text
        parsedText = NSMutableAttributedString()
    }
    
    func parse(_ text: String) -> NSMutableAttributedString {
        inner.parse(text)
    }
}
