import Foundation

struct ExampleRequest: NetworkRequest {
    var headers: [String: String]?
    
    var endpoint: URL? {
        URL(string: "INSERT_URL_HERE")
    }
}
