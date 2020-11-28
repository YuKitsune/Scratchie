//
//  ScratchieApp.swift
//  Scratchie
//
//  Created by Eoin Motherway on 25/11/20.
//

import SwiftUI
import HotKey

@main
struct ScratchieApp: App {
    
    var toggleVisibilityHotKey: HotKey
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(UserData())
        }
    }
    
    init() {
        toggleVisibilityHotKey = HotKey(key: .r, modifiers: [.command, .option])
        toggleVisibilityHotKey.keyDownHandler = toggleVisability
    }
    
    func toggleVisability() {
        if NSApp.isHidden {
            NSApp.unhide(nil)
            NSApp.activate(ignoringOtherApps: true)
        } else {
            NSApp.hide(nil)
        }
    }
}
