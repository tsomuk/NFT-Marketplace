//
//  User.swift
//  FakeNFT
//
//  Created by mihail on 27.03.2024.
//

import Foundation

struct User: Codable {
    let name: String
    let avatar: URL
    let description: String
    let website: URL
    let nfts: [String]
    let rating: String
    let id: String
}
