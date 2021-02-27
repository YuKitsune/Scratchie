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
    @State var text: String
        
    init (_ provider: ScratchpadProvider) {
        self.provider = provider
        _text = State<String>.init(initialValue: self.provider.getScratchpadContent())
        self.provider.onExternalChange(do: onExternalChange)
    }
    
    var body: some View {
        VStack {
            HighlightedTextEditor(
                text: $text.onChange(onTextChanged),
                highlightRules: .markdown)
                .defaultFont(.monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .thin))
                .drawsBackground(false)
                .backgroundColor(.clear)
        }
    }
    
    // Todo: Buffer the value so it's not constantly saving
    private func onTextChanged(to value: String) {
        self.provider.setScratchpadContent(value)
    }
    
    private func onExternalChange() {
        text = provider.getScratchpadContent()
    }
}

struct ScratchpadEditor_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScratchpadEditor(UserDefaultsScratchpadProvider())
        }
    }
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
