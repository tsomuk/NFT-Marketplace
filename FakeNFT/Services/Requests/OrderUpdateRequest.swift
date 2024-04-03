//
//  OrderUpdateRequest.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 03.04.2024.
//

import Foundation


import Foundation

struct OrderUpdateRequest: NetworkRequest {
    var headers: [String: String]? = ["X-Practicum-Mobile-Token": "b351241e-2dec-4598-9abd-083d84e52843"]
    
    var dto: NewOrderModel?
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

struct NewOrderModel: Encodable {
    var nfts: [String]
}
