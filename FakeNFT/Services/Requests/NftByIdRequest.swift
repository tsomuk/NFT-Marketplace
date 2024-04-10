import Foundation

struct NFTRequest: NetworkRequest {
    var httpMethod: HttpMethod = .get
    
    var dto: (any Encodable)? = nil
    
    var headers: [String: String]? = ["X-Practicum-Mobile-Token": "b351241e-2dec-4598-9abd-083d84e52843"]
    
    let id: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }

    var httpMethod: HttpMethod = .get
    var dto: Encodable?
}
