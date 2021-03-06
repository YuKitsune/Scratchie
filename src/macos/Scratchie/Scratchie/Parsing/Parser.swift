//
//  Parser.swift
//  Scratchie
//
//  Created by Eoin Motherway on 6/3/21.
//

import Foundation
import SwiftUI

protocol Parser {
    func parse(_ text: String) -> NSMutableAttributedString
}
