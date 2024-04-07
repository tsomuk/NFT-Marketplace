import Foundation

struct Nft: Decodable {
    let name: String
    let images: [URL]
    let price: Double
    let rating: Int
    let id: String
}
