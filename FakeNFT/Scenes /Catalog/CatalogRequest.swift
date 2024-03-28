//
//  CatalogRequest.swift
//  FakeNFT
//
//  Created by Арина Колганова on 27.03.2024.
//

import Foundation

struct CatalogRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/collections")
    }
    var httpMethod: HttpMethod = .get
}
