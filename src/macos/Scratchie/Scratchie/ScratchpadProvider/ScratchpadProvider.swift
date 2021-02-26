//
//  ScratchpadProvider.swift
//  Scratchie
//
//  Created by Eoin Motherway on 22/2/21.
//

import Foundation

protocol ScratchpadProvider {
    func getScratchpadContent() -> String
    func setScratchpadContent(_ content: String)
    func onExternalChange(do callback: @escaping () -> Void)
    func flush()
}
