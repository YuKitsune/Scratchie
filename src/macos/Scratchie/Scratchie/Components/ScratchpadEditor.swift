//
//  CodeEditor.swift
//  Scratchie
//
//  Created by Eoin Motherway on 25/11/20.
//

import Foundation
import SwiftUI

struct ScratchpadEditor: NSViewRepresentable {
    
    @Binding var text: String
    
    @ObservedObject var parser: BindableParser
    
    var onEditingChanged: () -> Void = {}
    var onCommit: () -> Void = {}
    var onTextChange: (String) -> Void = { _ in }
    var onSelectionChanged: ([NSRange]) -> Void = { _ in }
            
    init(
        text: Binding<String>,
        parser: BindableParser,
        onEditingChanged: @escaping () -> Void = {},
        onCommit: @escaping () -> Void = {},
        onTextChange: @escaping (String) -> Void = { _ in },
        onSelectionChanged: @escaping ([NSRange]) -> Void = { _ in }
    ) {
        _text = text
        self.parser = parser
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
        self.onTextChange = onTextChange
        self.onSelectionChanged = onSelectionChanged
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeNSView(context: Context) -> CustomTextView {
        let textView = CustomTextView(
            text: text
        )
        
        textView.delegate = context.coordinator
        
        return textView
    }
    
    public func updateNSView(_ view: CustomTextView, context: Context) {
        context.coordinator.updatingNSView = true
        view.text = text

        let highlightedText = parser.parse(text)
        
        view.attributedText = highlightedText
        view.selectedRanges = context.coordinator.selectedRanges
        context.coordinator.updatingNSView = false
    }
}

internal class Coordinator: NSObject, NSTextViewDelegate {

    var parent: ScratchpadEditor
    var selectedRanges: [NSValue] = []
    var updatingNSView = false
    
    init(_ parent: ScratchpadEditor) {
        self.parent = parent
    }
    
    public func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        return true
    }
    
    public func textDidBeginEditing(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else {
            return
        }
        
        self.parent.text = textView.string
        self.parent.onEditingChanged()
    }
    
    public func textDidChange(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else { return }
        let content: String = String(textView.textStorage?.string ?? "")
        
        self.parent.text = content
        selectedRanges = textView.selectedRanges
    }
    
    public func textViewDidChangeSelection(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView,
              !updatingNSView,
              let ranges = textView.selectedRanges as? [NSRange]
        else { return }
        selectedRanges = textView.selectedRanges
        DispatchQueue.main.async {
            self.parent.onSelectionChanged(ranges)
        }
    }
    
    public func textDidEndEditing(_ notification: Notification) {
        guard let textView = notification.object as? NSTextView else {
            return
        }
        
        self.parent.text = textView.string
        self.parent.onCommit()
    }
}

