//
//  ScratchieApp.swift
//  Scratchie
//
//  Created by Eoin Motherway on 25/11/20.
//

import SwiftUI

@main
struct ScratchieApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(UserData())
        }
    }
}
