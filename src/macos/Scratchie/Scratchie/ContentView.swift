//
//  ContentView.swift
//  Scratchie
//
//  Created by Eoin Motherway on 25/11/20.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedScratchpad: Scratchpad?
    
    var body: some View {
        NavigationView {
            ScratchpadList(selectedScratchpad: $selectedScratchpad)
            
            if (selectedScratchpad != nil) {
                CodeEditor(scratchpad: selectedScratchpad!)
            } else {
                Text("Select a Scratchpad")
            }
        }
        .frame(minWidth: 700, minHeight: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
    }
}
