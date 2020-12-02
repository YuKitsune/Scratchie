//
//  ScratchieApp.swift
//  Scratchie
//
//  Created by Eoin Motherway on 25/11/20.
//

import SwiftUI
import HotKey

@main
@objcMembers
final class ScratchieApp: App {

    static var statusBarItem: NSStatusItem!
    var toggleVisibilityHotKey: HotKey
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(UserData())
        }
    }
    
    init() {
        
        // Create the show/hide hotkey
        toggleVisibilityHotKey = HotKey(key: .r, modifiers: [.command, .option])
        toggleVisibilityHotKey.keyDownHandler = ScratchieApp.toggleVisability
    }
    
    static func configureStatusBarButton() {
        
        if (ScratchieApp.statusBarItem == nil) {
            
            // Create the status item
            ScratchieApp.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.squareLength))
            
            // Create the menu
            let menu = NSMenu()
            menu.autoenablesItems = false;
            
            // BUG: action doesn't get invoked
            menu.addItem(NSMenuItem(title: "Toggle Visability", action:  #selector(ScratchieApp.toggleVisabilityAction(_:)), keyEquivalent: "R"))

            ScratchieApp.statusBarItem.menu = menu
        }
    }
    
    @objc static func toggleVisabilityAction(_ sender : NSMenuItem) {
        ScratchieApp.toggleVisability()
    }
    
    static func toggleVisability() {
        if (!NSApp.isHidden && !NSApp.isActive) || NSApp.isHidden {
            NSApp.unhide(nil)
            NSApp.activate(ignoringOtherApps: true)
        } else {
            NSApp.hide(nil)
        }
    }
}
