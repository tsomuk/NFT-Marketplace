//
//  Order.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 29.03.2024.
//

import Foundation

struct Order: Codable {
    let id: String
    let nfts: [String]
}
