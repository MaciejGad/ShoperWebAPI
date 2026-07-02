import Foundation

public struct ProductSafetyCertificate: Decodable, Sendable {
    public let gpsrCertificateId: Int
    public let name: String
    public let translations: [String: CertificateTranslation]

    public struct CertificateTranslation: Decodable, Sendable {
        public let description: String?
    }

    public func description(locale: String = "pl_PL") -> String? {
        translations[locale]?.description
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gpsrCertificateId = try container.decodeInt(forKey: .gpsrCertificateId)
        self.name = try container.decode(String.self, forKey: .name)
        self.translations = (try? container.decode([String: CertificateTranslation].self, forKey: .translations)) ?? [:]
    }

    // CodingKeys must match AFTER convertFromSnakeCase conversion (i.e., camelCase).
    enum CodingKeys: CodingKey {
        case gpsrCertificateId
        case name
        case translations
    }
}

extension ProductSafetyCertificate: Resource {
    public typealias Key = EmptyFilterKey
    public typealias Sort = EmptySortKey
    public typealias CreatePayload = EmptyPayload
    public typealias UpdatePayload = EmptyPayload

    public var id: Identifier { .id(gpsrCertificateId) }
    public static var endpoint: Endpoint { .productSafetyCertificates }
}
