import Foundation

public struct Filter<Key> where Key: FilterKey {
    public let key: Key
    public let value: FilterValue
    
    public init(key: Key, value: FilterValue) {
        self.key = key
        self.value = value
    }
}
