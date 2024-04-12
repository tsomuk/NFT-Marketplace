//
//  ProfileInfoRequest.swift
//  FakeNFT
//
//  Created by Анастасия on 29.03.2024.
//

import Foundation

struct ProfileInfoRequest: NetworkRequest {
    var dto: Encodable?
    
    let userId: String

    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)\(userId)")
    }

    var httpMethod: HttpMethod { .get }
    var headers: [String: String]? {
        return ["X-Practicum-Mobile-Token": RequestConstants.token]
    }
}
