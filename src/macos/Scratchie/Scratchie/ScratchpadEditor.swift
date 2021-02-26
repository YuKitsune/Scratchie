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
    func onTextChanged(to value: String) {
        _ = self.provider.setScratchpadContent(value)
    }
    
    func onExternalChange(do callback: @escaping () -> Void) {
        // Todo: This might trigger onTextChanged, might need some kind of semaphore
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
