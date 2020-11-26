//
//  UserData.swift
//  Scratchie
//
//  Created by Eoin Motherway on 26/11/20.
//

import SwiftUI
import Combine

final class UserData: ObservableObject  {
    @Published var scratchpads: [Scratchpad] = [
        Scratchpad("My First Scratchpad"),
        Scratchpad("CS notes"),
        Scratchpad("python snips"),
        Scratchpad("aaaaaaa")
    ]
}
