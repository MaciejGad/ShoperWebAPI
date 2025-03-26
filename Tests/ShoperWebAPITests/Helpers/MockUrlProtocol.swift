import Foundation

func mockUrlSession() -> URLSession {
    let configuration = URLSessionConfiguration.ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: configuration)
}

class MockURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        do {
            guard let url = request.url else {
                throw MockError.cantReadURL
            }
            guard let method = request.httpMethod else {
                throw MockError.cantReadMethod
            }
            guard let client else {
                throw MockError.noClient
            }
            let path = url.path()
            let filename = method + path.replacingOccurrences(of: "/", with: "_")
            guard let filepath = Bundle.module.path(forResource: filename, ofType: "json") else {
                throw MockError.cantFindMockFile(filename)
            }
            let data = try Data(contentsOf: URL(fileURLWithPath: filepath))
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: ["Content-Type": "application/json"]) else {
                throw MockError.cantCreateResponse
            }
            print("Loading response for \(method) \(path) from \(filename).json")
            client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client.urlProtocol(self, didLoad: data)
            client.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        print("Stop loading called")
    }
    
    enum MockError: Error {
        case cantReadURL
        case cantReadMethod
        case cantFindMockFile(String)
        case cantCreateResponse
        case noClient
    }
}


