//
//  Collection.swift
//  FakeNFT
//
//  Created by Арина Колганова on 28.03.2024.
//

import Foundation

struct CatalogCollection: Decodable {
    let id: String
    let cover: String
    let name: String
    let description: String
    let author: String
    let nfts: [String]
}
