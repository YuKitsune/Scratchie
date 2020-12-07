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
    static let modifiers: NSEvent.ModifierFlags = [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.option]
    var toggleVisibilityHotKey: HotKey
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(UserData())
        }
    }
    
    init() {
        
        // Create the show/hide hotkey
        toggleVisibilityHotKey = HotKey(key: .r, modifiers: ScratchieApp.modifiers)
        toggleVisibilityHotKey.keyDownHandler = ScratchieApp.toggleVisability
    }
    
    static func configureStatusBarButton() {
        
        if (ScratchieApp.statusBarItem == nil) {
            
            // Create the status item
            ScratchieApp.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.squareLength))
            
            // Create the menu
            let menu = NSMenu()
            menu.autoenablesItems = false;
            
            // Create the menu item
            let item = NSMenuItem(title: "Toggle Visability", action:  #selector(toggleVisability), keyEquivalent: "r")
            item.keyEquivalentModifierMask = modifiers
            item.target = self
            menu.addItem(item)

            // Add the menu to the status bar item
            ScratchieApp.statusBarItem.menu = menu
        }
    }
    
    @objc static func toggleVisability() {
        if (!NSApp.isHidden && !NSApp.isActive) || NSApp.isHidden {
            NSApp.unhide(nil)
            NSApp.activate(ignoringOtherApps: true)
        } else {
            NSApp.hide(nil)
        }
    }
}
