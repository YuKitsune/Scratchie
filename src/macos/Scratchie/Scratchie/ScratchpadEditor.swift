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
    @State var scratchpad: Scratchpad
    var body: some View {
        VStack {
            HighlightedTextEditor(
                text: $scratchpad.content,
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
            ScratchpadEditor(scratchpad: UserData().scratchpad)
        }
    }
}
