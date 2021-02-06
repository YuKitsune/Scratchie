//
//  CodeEditor.swift
//  Scratchie
//
//  Created by Eoin Motherway on 25/11/20.
//

import Foundation
import SwiftUI
import HighlightedTextEditor
import AttributedText

// Todo: Remove background

struct ScratchpadEditorView: View {
    private let attributedString: NSAttributedString = {
        let parser = MarkdownParser()
        let tokens = parser.tokenize("""
                # This is H1
                This is a paragraph

                ## This is H2
                This is a paragraph ~with strikethrough~

                ## This is a H3
                This is a paragraph **bold!!!** _and italic_ __now underline__
                """)
        let string = parser.parseTokens(tokens)
        return string
    }()

    var body: some View {
        VStack {
            AttributedText(attributedString)
                .background(Color.gray.opacity(0.5))
                .accentColor(.purple)
                .frame(width: 250, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}

//struct ScratchpadEditorView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ScratchpadEditorView(scratchpad: UserData().scratchpad)
//        }
//    }
//}
