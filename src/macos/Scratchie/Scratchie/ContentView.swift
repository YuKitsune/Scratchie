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
        ScratchpadEditor(scratchpad: userData.scratchpad)
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
    }
}
