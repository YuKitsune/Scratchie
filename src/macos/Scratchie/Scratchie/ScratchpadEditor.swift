//
//  CodeEditor.swift
//  Scratchie
//
//  Created by Eoin Motherway on 25/11/20.
//

import Foundation
import SwiftUI

struct ScratchpadEditor: View {
    @State var scratchpad: Scratchpad
    
    var body: some View {
        TextEditor(text: $scratchpad.content)
                    .padding(8)
                    .font(.system(.body, design: .monospaced))
    }
}
