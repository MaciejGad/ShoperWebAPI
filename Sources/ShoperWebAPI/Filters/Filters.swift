import Foundation

public struct Filters: Encodable {
    let filters: [AnyFilter]
    
    public init(_ filters: [AnyFilter]) {
        self.filters = filters
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        for filter in filters {
            try container.encode(filter.value, forKey: DynamicKey(stringValue: filter.key))
        }
    }
}

public struct AnyFilter: Encodable {
    let key: String
    let value: FilterValue
    
    init<Key: FilterKey>(_ filter: Filter<Key>) {
        key = filter.key.rawValue
        value = filter.value
    }
}
