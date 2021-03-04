//
//  UbiquitousScratchpadProvider.swift
//  Scratchie
//
//  Created by Eoin Motherway on 22/2/21.
//

import Foundation

class UbiquitousScratchpadProvider : ScratchpadProvider {
    
    var key = "dev.YuKitsune.Scratchie.scratchpad"
    private var onExternalChangeCallback: (() -> Void)?
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onUbiquitousKeyValueStoreDidChangeExternally(_:)),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: NSUbiquitousKeyValueStore.default)
    }
    
    func getScratchpadContent() -> String {
        NSUbiquitousKeyValueStore.default.string(forKey: key) ?? ""
    }
    
    func setScratchpadContent(_ content: String) {
        NSUbiquitousKeyValueStore.default.set(content, forKey: key)
    }
    
    func onExternalChange(do callback: @escaping () -> Void) {
        self.onExternalChangeCallback = callback
    }
    
    func flush() {
        NSUbiquitousKeyValueStore.default.synchronize()
    }
    
    // Bug: This isn't being invoked...
    @objc func onUbiquitousKeyValueStoreDidChangeExternally(_ notification: Notification) {
        onExternalChangeCallback?()
    }
}
