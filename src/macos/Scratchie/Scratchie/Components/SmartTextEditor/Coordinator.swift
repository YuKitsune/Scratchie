//
//  Coordinator.swift
//  Scratchie
//
//  Created by Eoin Motherway on 14/3/21.
//

import Foundation
import AppKit

extension SmartTextEditor {
    public class Coordinator: NSObject, NSTextViewDelegate {

        var parent: SmartTextEditor
        var selectedRanges: [NSValue] = []
        var updatingNSView = false
        
        public init(_ parent: SmartTextEditor) {
            self.parent = parent
        }
        
        public func textDidBeginEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            
            self.parent.text = textView.string
            self.parent.didBeginEditing()
        }
        
        public func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }

            self.parent.text = textView.string
            selectedRanges = textView.selectedRanges
        }
        
        public func textDidEndEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else { return }
            
            self.parent.text = textView.string
            self.parent.onCommit()
        }
        
        public func textViewDidChangeSelection(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView,
                  !updatingNSView,
                  let ranges = textView.selectedRanges as? [NSRange]
            else { return }
            let callback = parent.didChangeSelection
            DispatchQueue.main.async {
                callback(ranges)
            }
        }
    }
}
