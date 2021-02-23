//
//  CodeEditor.swift
//  Scratchie
//
//  Created by Eoin Motherway on 25/11/20.
//

import Foundation
import SwiftUI
import HighlightedTextEditor

// Todo: Remove background

struct ScratchpadEditor: View {
    private var provider: ScratchpadProvider
    @State var text: String {
        didSet {
            _ = provider.setScratchpadContent(text)
        }
    }
        
    init (_ provider: ScratchpadProvider) {
        self.provider = provider
        _text = State<String>.init(initialValue: self.provider.getScratchpadContent())
    }
    
    var body: some View {
        VStack {
            HighlightedTextEditor(
                text: $text,
                highlightRules: .markdown)
                .defaultFont(.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .thin))
                .drawsBackground(false)
                .backgroundColor(.clear)
        }
    }
}

struct ScratchpadEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScratchpadEditor(UserDefaultsScratchpadProvider())
        }
    }
}
