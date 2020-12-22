//
//  ContentView.swift
//  Scratchie
//
//  Created by Eoin Motherway on 25/11/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var userData: UserData
    
    // BUG: When the view is closed, it cannot be re-opened, may need to consider re-instanciating the view from the ScratchieApp file if it's been closed, or somehow overriding the close command
    var body: some View {
        ScratchpadEditor(scratchpad: userData.scratchpad)
            .onAppear(perform: ScratchieApp.configureStatusBarButton)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
    }
}
