//
//  ContentView.swift
//  Scratchie
//
//  Created by Eoin Motherway on 25/11/20.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ScratchpadViewModel
    var provider: ScratchpadProvider
    
    init(_ provider: ScratchpadProvider) {
        self.provider = provider
        self.viewModel = ScratchpadViewModel(self.provider)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                // Todo: Sidebar show/hide
                Spacer()
                Text("Scratchie")
                    .font(.title)
                Spacer()
                MenuButton(label: Image(systemName: "ellipsis.circle")) {
                    Button("About", action: showAbout)
                    Button("Preferences", action: showPreferences)
                    Button("Quit", action: quit)
                }
                .menuButtonStyle(BorderlessButtonMenuButtonStyle())
                .aspectRatio(1, contentMode: .fit) // This prevents the button from taking all available horizontal space
            }
            .padding(2)
            SmartTextEditor(
                text: $viewModel.text,
                textFormatter: MonospaceEverythingParser())
                .drawsBackground(true)
                .backgroundColor(NSColor.clear)
        }
    }
    
    func showAbout() {
        NSApplication.shared.orderFrontStandardAboutPanel(self)
    }
    
    func showPreferences() {
        // Todo: Implement
    }
    
    func quit() {
        NSApp.terminate(nil)
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(UserDefaultsScratchpadProvider())
    }
}
