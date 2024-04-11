import Foundation

struct ExampleRequest: NetworkRequest {
    var httpMethod: HttpMethod = .get

    var dto: (any Encodable)?

    var headers: [String: String]?

    var endpoint: URL? {
        URL(string: "INSERT_URL_HERE")
    }
}
