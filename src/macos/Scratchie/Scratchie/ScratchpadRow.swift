//
//  ScratchpadRow.swift
//  Scratchie
//
//  Created by Eoin Motherway on 26/11/20.
//

import SwiftUI

struct ScratchpadRow: View {
    
    var scratchpad: Scratchpad
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "doc")
            Text(scratchpad.name).truncationMode(.middle)
            Spacer()
            
            // Todo: Add swipe to delete
        }
        .padding(.vertical, 4)
    }
}

struct Scratchpad_Previews: PreviewProvider {
    static var previews: some View {
        ScratchpadRow(scratchpad: Scratchpad("C# notes"))
    }
}
