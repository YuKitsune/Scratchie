//
//  Scratchpad.swift
//  Scratchie
//
//  Created by Eoin Motherway on 25/11/20.
//

import Foundation

struct Scratchpad: Hashable, Identifiable {
    var id: Self { self }
    var selected: Bool = false
    
    var name: String
    var content: String
    
    init (_ name: String) {
        self.name = name
        self.content = ""
    }
}
