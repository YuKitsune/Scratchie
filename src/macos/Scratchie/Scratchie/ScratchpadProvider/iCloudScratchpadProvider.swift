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
    var synchronizeOnSet = false
    
    init(_ synchronizeOnSet: Bool = false) {
        self.synchronizeOnSet = synchronizeOnSet
    }
    
    func getScratchpadContent() -> String {
        keyStore.string(forKey: key) ?? ""
    }
    
    func setScratchpadContent(_ content: String) -> Bool {
        keyStore.set(content, forKey: key)
        
        var didSync = false
        if self.synchronizeOnSet {
            didSync = keyStore.synchronize()
        }
        
        return didSync
    }
    
    func synchronize() -> Bool {
        keyStore.synchronize()
    }
}
