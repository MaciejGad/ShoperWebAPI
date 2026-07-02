import Foundation

/// Placeholder filter key for read-only lookup resources that don't yet need filtering.
public struct EmptyFilterKey: FilterKey {
    public let rawValue: String
}
