import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// These tests fetch lookup/dictionary resources from a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars) to validate decoding. Responses are saved as new
// mocks via MOCK_PATH for future offline test runs.

@Test func testFetchAttributeGroups() async throws {
    let client = try makeClient()
    let list = try await AttributeGroup.list(client: client)
    print("AttributeGroups count: \(list.count)")
    for group in list.list {
        print(" * #\(group.attributeGroupId) \(group.name) langId:\(group.langId) active:\(String(describing: group.active))")
    }
    #expect(!list.list.isEmpty)
}

@Test func testFetchProducers() async throws {
    let client = try makeClient()
    let list = try await Producer.list(client: client)
    print("Producers count: \(list.count)")
    for producer in list.list {
        print(" * #\(producer.producerId) \(producer.name ?? "")")
    }
    #expect(!list.list.isEmpty)
}

@Test func testFetchTaxes() async throws {
    let client = try makeClient()
    let list = try await Tax.list(client: client)
    print("Taxes count: \(list.count)")
    for tax in list.list {
        print(" * #\(tax.taxId) \(tax.name) value:\(tax.value) class:\(tax.taxClass ?? "")")
    }
    #expect(!list.list.isEmpty)
}

@Test func testFetchUnits() async throws {
    let client = try makeClient()
    let list = try await Unit.list(client: client)
    print("Units count: \(list.count)")
    for unit in list.list {
        print(" * #\(unit.unitId) \(unit.name() ?? "") floatingPoint:\(unit.floatingPoint)")
    }
    #expect(!list.list.isEmpty)
}

@Test func testFetchDeliveries() async throws {
    let client = try makeClient()
    let list = try await Delivery.list(client: client)
    print("Deliveries count: \(list.count)")
    for delivery in list.list {
        print(" * #\(delivery.deliveryId) \(delivery.name() ?? "") hours:\(delivery.hours ?? "")")
    }
    #expect(!list.list.isEmpty)
}

@Test func testFetchAvailabilities() async throws {
    let client = try makeClient()
    let list = try await Availability.list(client: client)
    print("Availabilities count: \(list.count)")
    for availability in list.list {
        print(" * #\(String(describing: availability.availabilityId)) \(availability.name() ?? "") canBuy:\(String(describing: availability.canBuy))")
    }
    #expect(!list.list.isEmpty)
}

@Test func testFetchGauges() async throws {
    let client = try makeClient()
    let list = try await Gauge.list(client: client)
    print("Gauges count: \(list.count)")
    for gauge in list.list {
        print(" * #\(gauge.gaugeId) \(gauge.name() ?? "")")
    }
    // A shop may legitimately have zero gauges configured; only assert decoding didn't throw.
}

@Test func testFetchCurrencies() async throws {
    let client = try makeClient()
    let list = try await Currency.list(client: client)
    print("Currencies count: \(list.count)")
    for currency in list.list {
        print(" * #\(String(describing: currency.currencyId)) \(currency.name) rate:\(String(describing: currency.rate)) default:\(String(describing: currency.default))")
    }
    #expect(!list.list.isEmpty)
}
