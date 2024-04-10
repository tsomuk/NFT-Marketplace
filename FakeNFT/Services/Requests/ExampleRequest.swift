import Foundation

struct ExampleRequest: NetworkRequest {
    var dto: Encodable?

    var endpoint: URL? {
        URL(string: "INSERT_URL_HERE")
    }
}
