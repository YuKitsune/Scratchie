//
//  AppDelegate.swift
//  Scratchie
//
//  Created by Eoin Motherway on 27/12/20.
//

import AppKit
import SwiftUI
import HotKey

class AppDelegate: NSObject, NSApplicationDelegate {
    var popover: NSPopover?
    var statusBarItem: NSStatusItem?
    var toggleVisibilityHotKey: HotKey?
    var scratchpadProvider: ScratchpadProvider?

    func applicationDidFinishLaunching(_ notification: Notification) {
                    
        self.scratchpadProvider = UbiquitousScratchpadProvider()
        
        // Create the show/hide hotkey
        toggleVisibilityHotKey = HotKey(key: .r, modifiers: [.command, .option])
        toggleVisibilityHotKey!.keyDownHandler = togglePopover
        
        // Create the Content View
        let size = NSSize(width: 400, height: 500)
        let contentView = ContentView(self.scratchpadProvider!)
            .frame(width: size.width, height: size.height, alignment: .center)

        // Set the SwiftUI's ContentView to the Popover's ContentViewController
        // Todo: Find out how to allow the user to resize the popover
        self.popover = NSPopover.init()
        self.popover?.contentSize = size
        self.popover?.behavior = .transient
        self.popover?.contentViewController = NSHostingController(rootView: contentView)
                
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.squareLength))
        self.statusBarItem?.button?.title = "Scratchie"
        self.statusBarItem?.button?.image = NSImage(named: "MenuBarIcon")
        self.statusBarItem?.button?.action = #selector(AppDelegate.togglePopover)
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        self.scratchpadProvider?.flush()
    }
    
    @objc func togglePopover() {
        if let popover = self.popover {
            if popover.isShown {
                closePopover()
            } else {
                showPopover()
            }
        }
    }
    
    func showPopover() {
        // Bug: Popover is not centered
        if let button = statusBarItem?.button {
            self.popover?.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover() {
        self.popover?.performClose(nil)
    }
}
