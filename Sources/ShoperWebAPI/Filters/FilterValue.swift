import Foundation

public enum FilterValue: Encodable {
    case equal(String)
    case notEqual(String)
    case greaterThan(Int)
    case greaterThanOrEqual(Int)
    case lessThan(Int)
    case lessThanOrEqual(Int)
    case like(String)
    case notLike(String)
    case inList([Int])
    case notInList([Int])
    
    func `operator`() -> Operator {
        switch self {
        case .equal:
            return .equal
        case .notEqual:
            return .notEqual
        case .greaterThan:
            return .greaterThan
        case .greaterThanOrEqual:
            return .greaterThanOrEqual
        case .lessThan:
            return .lessThan
        case .lessThanOrEqual:
            return .lessThanOrEqual
        case .like:
            return .like
        case .notLike:
            return .notLike
        case .inList:
            return .inList
        case .notInList:
            return .notInList
        }
    }
    
    func dynamicKey() -> DynamicKey {
        DynamicKey(stringValue: `operator`().rawValue)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        switch self {
        case .equal(let string), .notEqual(let string), .like(let string), .notLike(let string) :
            try container.encode(string, forKey: dynamicKey())
        case .greaterThan(let int), .greaterThanOrEqual(let int), .lessThan(let int), .lessThanOrEqual(let int):
            try container.encode(int, forKey: dynamicKey())
        case .inList(let array), .notInList(let array):
            try container.encode(array, forKey: dynamicKey())
        }
    }
}
