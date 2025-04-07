import Foundation

func mockFilename(method: String, path: String, query: String?) throws -> String {
    var filename = method + path.replacingOccurrences(of: "/", with: "_")
    if let query = query, !query.isEmpty {
        let query = query.split(separator: "=").map{$0.split(separator: ",").sorted().joined(separator: "_")}.joined(separator: "_")
        filename += "_" + query
            .replacingOccurrences(of: "&", with: "_")
            .replacingOccurrences(of: "%22", with: "")
            .replacingOccurrences(of: "%25", with: "")
            .replacingOccurrences(of: "%7B", with: "")
            .replacingOccurrences(of: "%7D", with: "")
            .replacingOccurrences(of: ":", with: "_")
            .replacingOccurrences(of: "~", with: "")
            .replacingOccurrences(of: "__", with: "_")
            .replacingOccurrences(of: "%2F", with: "_")
            .replacingOccurrences(of: "%", with: "")
            .replacingOccurrences(of: "=", with: "_")
            .replacingOccurrences(of: "?", with: "_")
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: ",", with: "_")
    }
    return filename
}

