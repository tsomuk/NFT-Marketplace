//
//  CurrencyListRequest.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 02.04.2024.
//

import Foundation

struct CurrencyListRequest: NetworkRequest {
    var httpMethod: HttpMethod = .get

    var dto: (any Encodable)?

    var headers: [String: String]? = ["X-Practicum-Mobile-Token": "b351241e-2dec-4598-9abd-083d84e52843"]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}
