//
//  YKTextEditor.swift
//  Scratchie
//
//  Created by Eoin Motherway on 14/3/21.
//

import AppKit
import SwiftUI

public struct SmartTextEditor: NSViewRepresentable {
    
    @Binding var text: String {
        didSet {
            self.textDidChange(text)
        }
    }
    
    var textFormatter: TextFormatter
    
    // MARK: Callbacks
    var textDidChange: (String) -> Void = { _ in }
    var didBeginEditing: () -> Void = { }
    var onCommit: () -> Void = {}
    var didChangeSelection: ([NSRange]) -> Void = { _ in }
    
    // MARK: Modifiers
    private(set) var allowsDocumentBackgroundColorChange: Bool = true
    private(set) var backgroundColor: NSColor = .clear
    private(set) var color: NSColor? = nil
    private(set) var drawsBackground: Bool = false
    private(set) var font : NSFont? = .monospacedSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
    private(set) var insertionPointColor: NSColor? = nil
    
    public init(
        text: Binding<String>,
        textFormatter: TextFormatter,
        textDidChange: @escaping (String) -> Void =  { _ in },
        didBeginEditing: @escaping () -> Void = { },
        onCommit: @escaping () -> Void = { },
        didChangeSelection: @escaping ([NSRange]) -> Void = { _ in }
    ) {
        _text = text
        self.textFormatter = textFormatter
        self.textDidChange = textDidChange
        self.didBeginEditing = didBeginEditing
        self.onCommit = onCommit
        self.didChangeSelection = didChangeSelection
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeNSView(context: Context) -> CustomTextView {
        let textView = CustomTextView(
            text: text,
            font: font
        )

        textView.delegate = context.coordinator
        updateTextViewModifiers(textView, isFirstRender: true)
        
        return textView
    }
    
    public func updateNSView(_ view: CustomTextView, context: Context) {
        context.coordinator.updatingNSView = true
        view.text = text
        
        updateTextViewModifiers(view, isFirstRender: false)
                
        let formattedText = textFormatter.format(text)
        view.attributedText = formattedText
        
        view.selectedRanges = context.coordinator.selectedRanges
        context.coordinator.updatingNSView = false
    }
    
    private func updateTextViewModifiers(_ textView: CustomTextView, isFirstRender: Bool) {
        textView.drawsBackground = drawsBackground
        textView.allowsDocumentBackgroundColorChange = allowsDocumentBackgroundColorChange
        if isFirstRender || allowsDocumentBackgroundColorChange {
            textView.backgroundColor = backgroundColor
        }

        textView.insertionPointColor = insertionPointColor
    }
}

// MARK: Extensions
extension SmartTextEditor {
    public func backgroundColor(_ color: NSColor) -> Self {
        var editor = self
        editor.backgroundColor = color
        return editor
    }
    
    public func drawsBackground(_ shouldDraw: Bool) -> Self {
        var editor = self
        editor.drawsBackground = shouldDraw
        return editor
    }
}
