//
//  AppDelegate.swift
//  Scratchie
//
//  Created by Eoin Motherway on 27/12/20.
//

import SwiftUI
import HotKey

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var popover = NSPopover.init()
    var statusBarItem: NSStatusItem?
    var toggleVisibilityHotKey: HotKey?

    func applicationDidFinishLaunching(_ notification: Notification) {
            
        // Create the show/hide hotkey
        toggleVisibilityHotKey = HotKey(key: .r, modifiers: [.command, .option])
        toggleVisibilityHotKey!.keyDownHandler = togglePopover
        
        // Create the Content View
        let contentView = ContentView()
            .environmentObject(UserData())
            .frame(width: 600, height: 600, alignment: .center)

        // Set the SwiftUI's ContentView to the Popover's ContentViewController
        // Todo: Find out how to allow the user to resize the popover
        popover.behavior = .transient // !!! - This does not seem to work in SwiftUI2.0 or macOS BigSur yet
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = NSHostingView(rootView: contentView)
                
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.squareLength))
        self.statusBarItem?.button?.title = "Scratchie"
        self.statusBarItem?.button?.image = NSImage(named: "MenuBarIcon")
        self.statusBarItem?.button?.action = #selector(AppDelegate.togglePopover)
    }
    
    @objc func togglePopover() {
        if popover.isShown {
            closePopover()
        } else {
            showPopover()
        }
    }
    
    @objc func showPopover() {
        if let button = statusBarItem?.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
//            !!! - displays the popover window with an offset in x in macOS BigSur.
        }
    }
    
    @objc func closePopover() {
        popover.performClose(nil)
    }
}
