//
//  CatalogRequest.swift
//  FakeNFT
//
//  Created by Арина Колганова on 27.03.2024.
//

import Foundation

struct CatalogRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
    var httpMethod: HttpMethod = .get
    var dto: Encodable?
}

struct OrderRequest: NetworkRequest {
    let newData: Orders?
    var dto: Encodable? {
        if let data = newData {
            let formData: [String: String] = [
                "nfts": !data.nfts.isEmpty ? data.nfts.joined(separator: ", ") : "null"
            ]
            return formData
        } else {
            return nil
        }
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }

    var httpMethod: HttpMethod = .get
}

struct LikesNftRequest: NetworkRequest {
    let newData: Profile?
    var dto: Encodable? {
        if let data = newData {
            let formData: [String: String] = [
                "likes": !data.likes.isEmpty ? data.likes.joined(separator: ", ") : "null"
            ]
            return formData
        } else {
            return nil
        }
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var httpMethod: HttpMethod = .get
}
