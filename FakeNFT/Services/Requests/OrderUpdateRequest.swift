//
//  OrderUpdateRequest.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 03.04.2024.
//

import Foundation

struct OrderUpdateRequest: NetworkRequest {
    let newOrder: NewOrderModel?
    
    var httpMethod: HttpMethod = .put
    
    var dto: (any Encodable)? {
        if let data = newOrder {
            let formData: [String: String] = [
                "nfts": data.nfts.joined(separator: ", ")
            ]
            return formData
        } else {
            return nil
        }
    }
    
    var headers: [String: String]? = ["X-Practicum-Mobile-Token": "b351241e-2dec-4598-9abd-083d84e52843"]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

struct NewOrderModel: Encodable {
    var nfts: [String]
}
