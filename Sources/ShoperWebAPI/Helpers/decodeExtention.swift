import Foundation

extension KeyedDecodingContainer {
    func decodeInt(forKey key: Key) throws -> Int {
        if let value = try? decode(Int.self, forKey: key) {
            return value
        } else {
            let rawValue = try decode(String.self, forKey: key)
            guard let value = Int(rawValue) else {
                throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Expected Int but found \"\(rawValue)\"")
            }
            return value
        }
    }
    
    func decodeDecimal(forKey key: Key) throws -> Decimal {
        if let value = try? decode(Decimal.self, forKey: key) {
            return value
        } else {
            let rawValue = try decode(String.self, forKey: key)
            guard let value = decimalFrom(string: rawValue) else {
                throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Expected Decimal but found \"\(rawValue)\"")
            }
            return value
        }
    }
    
    private func decimalFrom(string: String) -> Decimal? {
        return Decimal(string: string, locale: Locale(identifier: "en_US"))
    }

    func decodeDecimalIfPresent(forKey key: Key) throws -> Decimal? {
        guard contains(key) else {
            return nil
        }
        if try decodeNil(forKey: key) {
            return nil
        }
        return try decodeDecimal(forKey: key)
    }
                       
    func decodeIntIfPresent(forKey key: Key) throws -> Int? {
        guard contains(key) else {
            return nil
        }
        if try decodeNil(forKey: key) {
            return nil
        }
        return try decodeInt(forKey: key)
    }
    
    func decodeIntArray(forKey key: Key) throws -> [Int] {
        if let value = try? decode([Int].self, forKey: key) {
            return value
        } else {
            let rawValue = try decode([String].self, forKey: key)
            return rawValue.compactMap { Int($0) }
        }
    }
    
    func decodeIntArrayIfPresent(forKey key: Key) throws -> [Int]? {
        guard contains(key) else {
            return nil
        }
        if try decodeNil(forKey: key) {
            return nil
        }
        return try decodeIntArray(forKey: key)
    }
    
    func decodeBool(forKey key: Key) throws -> Bool {
        if let value = try? decode(Bool.self, forKey: key) {
            return value
        } else {
            let rawValue = try decode(String.self, forKey: key)
            guard let value = boolFrom(string: rawValue) else {
                throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Expected Bool but found \"\(rawValue)\"")
            }
            return value
        }
    }
    
    func decodeBoolIfPresent(forKey key: Key) throws -> Bool? {
        guard contains(key) else {
            return nil
        }
        if try decodeNil(forKey: key) {
            return nil
        }
        return try decodeBool(forKey: key)
    }
    
    private func boolFrom(string: String) -> Bool? {
        switch string {
        case "1", "true", "yes":
            return true
        case "0", "false", "no":
            return false
        default:
            return nil
        }
    }
}
