//
//  ProfileUpdateRequest.swift
//  FakeNFT
//
//  Created by Анастасия on 29.03.2024.
//

import Foundation

struct ProfileUpdateRequest: NetworkRequest {
    let userId: String
    let newProfileData: ProfileInfo

    var endpoint: URL? {
        return URL(string: "\(RequestConstants.baseURL)\(userId)")
    }

    var httpMethod: HttpMethod { .put }
    var headers: [String: String]? {
        return ["X-Practicum-Mobile-Token": RequestConstants.token]
    }
    var dto: Encodable? {
        // Form data in x-www-form-urlencoded
        var formData: [String: String] = [
            "name": newProfileData.name,
            "description": newProfileData.description,
            "website": newProfileData.website,
            "avatar": newProfileData.avatar
        ]

        let likesString = newProfileData.likes.joined(separator: ",")

        formData["likes"] = likesString

        return formData
    }
}
