//
//  Scratchpad.swift
//  Scratchie
//
//  Created by Eoin Motherway on 25/11/20.
//

import Foundation

public struct Scratchpad {
    public var content: String {
        didSet {
            UserData.userDefaults.set(content, forKey: "scratchpad")
        }
    }
    
    init (content: String) {
        self.content = content
    }
}
