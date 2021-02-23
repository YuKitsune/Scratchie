//
//  UserDefaultsScratchpadProvider.swift
//  Scratchie
//
//  Created by Eoin Motherway on 22/2/21.
//

import Foundation

class UserDefaultsScratchpadProvider : ScratchpadProvider {
    var key = "scratchpad"
    var userDefaults = UserDefaults.standard
    
    func getScratchpadContent() -> String {
        userDefaults.string(forKey: key) ?? ""
    }
    
    func setScratchpadContent(_ content: String) -> Bool {
        userDefaults.set(content, forKey: key)
        return true
    }
}
