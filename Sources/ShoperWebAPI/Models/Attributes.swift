import Foundation

public struct Attributes: Codable, Sendable {
    public let values: [String: Attribute]
    
    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.container(keyedBy: DynamicKey.self) {
            var values: [String: Attribute] = [:]
            for key in container.allKeys {
                let value = try container.decode(Attribute.self, forKey: key)
                values[key.stringValue] = value
            }
            self.values = values
        } else {
            values = [:]
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        for (key, value) in values {
            let key = DynamicKey(stringValue: key)
            try container.encode(value, forKey: key)
        }
    }
}

public struct Attribute: Codable, Sendable {
    public let values: [String: String]
    
    public init(from decoder: any Decoder) throws {
        if let container = try? decoder.container(keyedBy: DynamicKey.self) {
            var values: [String: String] = [:]
            for key in container.allKeys {
                let value = try container.decode(String.self, forKey: key)
                values[key.stringValue] = value
            }
            self.values = values
        } else {
            values = [:]
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: DynamicKey.self)
        for (key, value) in values {
            let key = DynamicKey(stringValue: key)
            try container.encode(value, forKey: key)
        }
    }
}