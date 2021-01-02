//
//  ContentView.swift
//  Scratchie
//
//  Created by Eoin Motherway on 25/11/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var userData: UserData
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: self.Quit,
                       label: {
                    Text("Quit")
                }).padding(2)
            }
            .padding(5)
            ScratchpadEditor(scratchpad: userData.scratchpad)
        }
    }
    
    func Quit() {
        NSApp.terminate(nil)
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
    }
}
