import Foundation

public struct Order<Key: SortKey> {
    let key: Key
    let order: SortDirection
    
    public init(_ key: Key, _ order: SortDirection = .ascending) {
        self.key = key
        self.order = order
    }
}


public struct SortOrder {
    let values: [String]
    
    init?<Key: SortKey>(_ values: [Order<Key>]) {
        guard !values.isEmpty else { return nil }
        self.values = values.map { "\($0.key.rawValue) \($0.order.rawValue)"}
    }
    
//    func urlEncoded() -> String {
//        var encoded: [String] = []
//        for (index, value) in values.enumerated() {
//            encoded.append("order%5B\(index)%5D=\(value)")
//        }
//        return encoded.joined(separator: "&")
//    }
}
    
