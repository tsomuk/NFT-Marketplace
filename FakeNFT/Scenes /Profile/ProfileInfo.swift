//
//  ProfileInfo.swift
//  FakeNFT
//
//  Created by Анастасия on 29.03.2024.
//

import Foundation

struct ProfileInfo: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
