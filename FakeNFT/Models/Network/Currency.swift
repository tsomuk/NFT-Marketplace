//
//  Currency.swift
//  FakeNFT
//
//  Created by Nikita Tsomuk on 30.03.2024.
//

import UIKit

struct Currency {
    let title: String
    let name: String
    let image: UIImage
    let id: String = ""
    
    static let mockCurrency : [Currency] = [
        Currency(title: "Bitcoin", name: "BTC", image: .mockNft),
        Currency(title: "Dogecoin", name: "DOGE", image: .mockNft),
        Currency(title: "Tether", name: "USDT", image: .mockNft),
        Currency(title: "Apecoin", name: "APE", image: .mockNft),
        Currency(title: "Solana", name: "SOL", image: .mockNft),
        Currency(title: "Ethereum", name: "ETH", image: .mockNft),
        Currency(title: "Cardano", name: "ADA", image: .mockNft),
        Currency(title: "Shiba Inu", name: "SHIB", image: .mockNft)
    ]
}
