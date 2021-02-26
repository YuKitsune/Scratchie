//
//  iCloudScratchpadProvider.swift
//  Scratchie
//
//  Created by Eoin Motherway on 22/2/21.
//

import Foundation

class iCloudScratchpadProvider : ScratchpadProvider {
    
    var key = "scratchpad"
    var keyStore = NSUbiquitousKeyValueStore()
    private var onExternalChangeCallback: (() -> Void)?
    
    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onUbiquitousKeyValueStoreDidChangeExternally(notification:)),
            name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: NSUbiquitousKeyValueStore.default)
    }
    
    func getScratchpadContent() -> String {
        keyStore.string(forKey: key) ?? ""
    }
    
    func setScratchpadContent(_ content: String) {
        return keyStore.set(content, forKey: key)
    }
    
    func onExternalChange(do callback: @escaping () -> Void) {
        self.onExternalChangeCallback = callback
    }
    
    func flush() {
        keyStore.synchronize()
    }
    
    @objc private func onUbiquitousKeyValueStoreDidChangeExternally(notification: Notification) {
        onExternalChangeCallback?()
    }
}
