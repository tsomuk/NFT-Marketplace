//
//  Collection.swift
//  FakeNFT
//
//  Created by Арина Колганова on 28.03.2024.
//

import Foundation

struct Collection: Decodable {
    let id: String
    let cover: String
    let name: String
    let nfts: [String]
}
