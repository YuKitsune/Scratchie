//
//  ScratchpadViewModel.swift
//  Scratchie
//
//  Created by Eoin Motherway on 4/3/21.
//

import Foundation

class ScratchpadViewModel: ObservableObject {
    private let provider: ScratchpadProvider
    
    public var text: String {
        didSet {
            onInternalChange()
        }
    }
    
    init(_ provider: ScratchpadProvider) {
        self.provider = provider
        text = self.provider.getScratchpadContent()
        self.provider.onExternalChange(do: onExternalChange)
    }
    
    private func onInternalChange() {
        provider.setScratchpadContent(text)
    }
    
    private func onExternalChange() {
        text = provider.getScratchpadContent()
    }
}
