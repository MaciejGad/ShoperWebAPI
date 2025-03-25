import Foundation

enum Operator: String, Encodable {
    case equal = "="
    case notEqual = "!="
    case greaterThan = ">"
    case greaterThanOrEqual = ">="
    case lessThan = "<"
    case lessThanOrEqual = "<="
    case like = "~"
    case notLike = "!~"
    case inList = "IN"
    case notInList = "NOT IN"
}
