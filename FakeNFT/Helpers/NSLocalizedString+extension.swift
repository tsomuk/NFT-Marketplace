//
//  NSLocalizedString+extension.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 08.04.2024.
//

import Foundation

postfix operator ~
postfix func ~ (string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
