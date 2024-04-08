//
//  NFTInfo.swift
//  FakeNFT
//
//  Created by Анастасия on 04.04.2024.
//

import Foundation

struct NFTInfo: Decodable {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}
