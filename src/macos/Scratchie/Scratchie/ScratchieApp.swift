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

    var statusBarItem: NSStatusItem!
    let modifiers: NSEvent.ModifierFlags = [NSEvent.ModifierFlags.command, NSEvent.ModifierFlags.option]
    var toggleVisibilityHotKey: HotKey
        
    // BUG: When the view is closed, it cannot be re-opened, may need to consider re-instanciating the view from the ScratchieApp file if it's been closed, or somehow overriding the close command
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(UserData())
                .onAppear(perform: {
                    self.configureStatusBarButton()
                })
        }
    }
    
    init() {
        
        // Create the show/hide hotkey
        toggleVisibilityHotKey = HotKey(key: .r, modifiers: self.modifiers)
        toggleVisibilityHotKey.keyDownHandler = toggleVisability
    }
    
    func configureStatusBarButton() {
        
        if (self.statusBarItem == nil) {
            
            // Create the status item
            self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.squareLength))
            if let button = self.statusBarItem.button {
                button.image = NSImage(named: "MenuBarIcon")
            }
            
            // Create the menu
            let menu = NSMenu()
            menu.autoenablesItems = false;
            
            // Create the menu item
            let item = NSMenuItem(title: "Toggle Visability", action:  #selector(toggleVisability), keyEquivalent: "r")
            item.keyEquivalentModifierMask = modifiers
            item.target = self
            menu.addItem(item)

            // Add the menu to the status bar item
            self.statusBarItem.menu = menu
        }
    }
    
    @objc func toggleVisability() {
        
        if NSApp.isHidden {
            NSApp.unhide(nil)
        } else {
            NSApp.hide(nil)
            return;
        }
        
        if !NSApp.isActive {
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
