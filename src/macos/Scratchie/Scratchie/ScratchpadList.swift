//
//  ScratchpadList.swift
//  Scratchie
//
//  Created by Eoin Motherway on 26/11/20.
//

import SwiftUI

struct ScratchpadList: View {
    
    @EnvironmentObject private var userData: UserData
    @Binding var selectedScratchpad: Scratchpad?

    var body: some View {
        List(selection: $selectedScratchpad) {
            ForEach(userData.scratchpads) { scratchpad in
                ScratchpadRow(scratchpad: scratchpad).tag(scratchpad)
            }
        }
    }
}

struct ScratchpadList_Previews: PreviewProvider {
    
    private static var scratchpadData = UserData()
    
    static var previews: some View {
        ScratchpadList(selectedScratchpad: .constant(scratchpadData.scratchpads[0]))
            .environmentObject(scratchpadData)
    }
}
