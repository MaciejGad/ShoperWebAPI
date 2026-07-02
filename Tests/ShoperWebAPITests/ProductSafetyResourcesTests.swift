import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests fetch GPSR product-safety resources from a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding. Responses are saved as new
// mocks via MOCK_PATH for future offline test runs. A shop may legitimately have none configured,
// so these only assert that decoding didn't throw, not that the lists are non-empty.

@Test func testFetchProductSafetyProducers() async throws {
    let client = try makeClient()
    let list = try await ProductSafetyProducer.list(client: client)
    print("ProductSafetyProducers count: \(list.count)")
    for producer in list.list {
        print(" * #\(producer.gpsrProducerId) \(producer.name) \(producer.city), \(producer.countryCode)")
    }
}

@Test func testFetchProductSafetyImporters() async throws {
    let client = try makeClient()
    let list = try await ProductSafetyImporter.list(client: client)
    print("ProductSafetyImporters count: \(list.count)")
    for importer in list.list {
        print(" * #\(importer.gpsrImporterId) \(importer.name) \(importer.city), \(importer.countryCode)")
    }
}

@Test func testFetchProductSafetyResponsibles() async throws {
    let client = try makeClient()
    let list = try await ProductSafetyResponsible.list(client: client)
    print("ProductSafetyResponsibles count: \(list.count)")
    for responsible in list.list {
        print(" * #\(responsible.gpsrResponsibleId) \(responsible.name) \(responsible.city), \(responsible.countryCode)")
    }
}

@Test func testFetchProductSafetyCertificates() async throws {
    let client = try makeClient()
    let list = try await ProductSafetyCertificate.list(client: client)
    print("ProductSafetyCertificates count: \(list.count)")
    for certificate in list.list {
        print(" * #\(certificate.gpsrCertificateId) \(certificate.name) desc:\(certificate.description() ?? "")")
    }
}
