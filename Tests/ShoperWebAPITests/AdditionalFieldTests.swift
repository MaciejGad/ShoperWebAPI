import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

@Test func testAdditionalFieldTypeEncodesAsInt() throws {
    let payload = CreateAdditionalField(type: .checkbox, locate: [.orderForm, .contactForm], translations: [:])
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    let data = try encoder.encode(payload)
    let json = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
    #expect(json["type"] as? Int == 2)
    #expect(json["locate"] as? Int == 8 + 128)
}

@Test func testAdditionalFieldTypeDecodesUnknownValue() throws {
    let type = try JSONDecoder().decode(AdditionalFieldType.self, from: Data("42".utf8))
    #expect(type == .unknown(42))
    #expect(type.rawValue == 42)
}

@Test func testAdditionalFieldLocateOptionSet() {
    let locate: AdditionalFieldLocate = [.orderForm, .contactForm]
    #expect(locate.contains(.orderForm))
    #expect(locate.contains(.contactForm))
    #expect(!locate.contains(.userContext))
    #expect(locate.rawValue == 136)
}

// These tests fetch additional-fields / additional-field-options from a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding. Responses are saved as new
// mocks via MOCK_PATH for future offline test runs.

@Test func testFetchAdditionalFields() async throws {
    let client = try makeClient()
    let list = try await AdditionalField.list(client: client)
    print("AdditionalFields count: \(list.count)")
    for field in list.list {
        print(" * #\(field.fieldId) \(field.name() ?? "") type:\(String(describing: field.type)) locate:\(String(describing: field.locate))")
    }
}

// Live finding (2026-07-03, sklep173975.shoparena.pl): GET /additional-field-options returns
// HTTP 400 "Missing MODULE 'additional-field-options'" — the module doesn't appear to be
// installed/enabled on this store. This documents the failure rather than asserting success.
@Test func testFetchAdditionalFieldOptions() async throws {
    let client = try makeClient()
    do {
        let list = try await AdditionalFieldOption.list(client: client)
        print("AdditionalFieldOptions count: \(list.count)")
        for option in list.list {
            print(" * #\(option.optionId) fieldId:\(String(describing: option.fieldId)) value:\(option.value() ?? "")")
        }
    } catch {
        print("AdditionalFieldOptions request failed as observed: \(error)")
    }
}

// This test store is a sandbox, so it's safe to mutate: it creates a real additional field
// (a "select" field with two options) to verify the full create -> get round trip against the
// live API.
//
// Live finding: the OpenAPI spec for AdditionalFieldInsert marks only `name` as required inside
// each translation, but the live API also rejects the request without `description`.
@Test func testCreateAdditionalFieldRoundTrip() async throws {
    let client = try makeClient()
    let uniqueName = "ShoperWebAPI test field \(Int(Date().timeIntervalSince1970))"
    let payload = CreateAdditionalField(
        type: .select,
        locate: .orderForm,
        translations: ["pl_PL": .init(name: uniqueName, description: "Test field description", options: ["Opcja A", "Opcja B"])],
        active: true,
        req: false
    )
    let fieldId = try await AdditionalField.create(client: client, payload: payload)
    print("Created additional field id: \(fieldId)")
    #expect(fieldId > 0)

    let fetched = try await AdditionalField.get(client: client, id: fieldId)
    print(fetched)
    #expect(fetched.fieldId == fieldId)
    #expect(fetched.type == .select)
    #expect(fetched.locate == .orderForm)
    // Match by prefix rather than exact equality: when re-run offline against a frozen mock,
    // `uniqueName` (built from the current timestamp) won't equal the value baked into the mock
    // from whichever run originally recorded it.
    #expect(fetched.name()?.hasPrefix("ShoperWebAPI test field ") == true)
}
