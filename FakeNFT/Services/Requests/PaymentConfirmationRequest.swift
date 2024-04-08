//
//  PaymentConfirmationRequest.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 06.04.2024.
//

import Foundation

struct PaymentConfirmationRequest: NetworkRequest {
    var httpMethod: HttpMethod = .get
    
    var dto: (any Encodable)? = nil
    
    var headers: [String: String]? = ["X-Practicum-Mobile-Token": "b351241e-2dec-4598-9abd-083d84e52843"]
    
    let currencyId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(currencyId)")
    }
}
