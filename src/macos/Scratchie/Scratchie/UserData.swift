//
//  UserData.swift
//  Scratchie
//
//  Created by Eoin Motherway on 26/11/20.
//

import SwiftUI
import Combine

final class UserData: ObservableObject  {
    public static var userDefaults = UserDefaults.standard
    @Published var scratchpad: Scratchpad
    
    init() {
        guard let scratchpadContent = UserData.userDefaults.string(forKey: "scratchpad") else {
            scratchpad = Scratchpad(content: "")
            return
        }
        
        scratchpad = Scratchpad(content: scratchpadContent)
    }
}
