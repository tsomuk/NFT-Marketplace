//
//  MyNFTInfoRequest.swift
//  FakeNFT
//
//  Created by Анастасия on 04.04.2024.
//

import Foundation

struct MyNFTInfoRequest: NetworkRequest {
    let userId: String
    let nftId: String

    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)\(userId)\(nftId)")
    }

    var httpMethod: HttpMethod { .get }
    var headers: [String: String]? {
        return ["X-Practicum-Mobile-Token": RequestConstants.token]
    }
}
