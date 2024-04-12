//
//  PaymentConfirmation.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 06.04.2024.
//

import Foundation

struct PaymentConfirmation: Codable {
    let success: Bool
    let orderId: String
    let id: String
}
