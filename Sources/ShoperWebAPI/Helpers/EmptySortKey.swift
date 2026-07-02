import Foundation

/// Placeholder sort key for read-only lookup resources that don't yet need sorting.
public struct EmptySortKey: SortKey {
    public let rawValue: String
}
