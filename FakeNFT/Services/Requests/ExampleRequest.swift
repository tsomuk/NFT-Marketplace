import Foundation

struct ExampleRequest: NetworkRequest {
    var httpMethod: HttpMethod = .get
    
    var dto: (any Encodable)? = nil
    
    var headers: [String: String]? = nil
    
    var endpoint: URL? {
        URL(string: "INSERT_URL_HERE")
    }
}
