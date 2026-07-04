import Foundation

/// `GET /dashboard-stats` — a singleton resource (no list, no id) with sales/customer/subscriber
/// stats for three time windows plus general shop counters.
public struct DashboardStat: Decodable, Sendable {
    public let today: Period?
    public let last7Days: Period?
    public let last30Days: Period?
    public let general: General?

    public struct Period: Decodable, Sendable {
        public let customers: Int?
        public let income: Decimal?
        public let newOrders: Int?
        public let openOrders: Int?
        public let orders: Int?
        public let returningCustomers: Int?
        public let subscribers: Int?
        public let uniqueCustomers: Int?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.customers = try container.decodeIntIfPresent(forKey: .customers)
            self.income = try container.decodeDecimalIfPresent(forKey: .income)
            self.newOrders = try container.decodeIntIfPresent(forKey: .newOrders)
            self.openOrders = try container.decodeIntIfPresent(forKey: .openOrders)
            self.orders = try container.decodeIntIfPresent(forKey: .orders)
            self.returningCustomers = try container.decodeIntIfPresent(forKey: .returningCustomers)
            self.subscribers = try container.decodeIntIfPresent(forKey: .subscribers)
            self.uniqueCustomers = try container.decodeIntIfPresent(forKey: .uniqueCustomers)
        }

        enum CodingKeys: CodingKey {
            case customers, income, newOrders, openOrders, orders, returningCustomers, subscribers, uniqueCustomers
        }
    }

    public struct General: Decodable, Sendable {
        public let customers: Int?
        public let expiringOrders: Int?
        public let openOrders: Int?
        public let orders: Int?
        public let outOfStockProducts: Int?
        public let overdueOrders: Int?
        public let products: Int?
        public let subscribers: Int?

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.customers = try container.decodeIntIfPresent(forKey: .customers)
            self.expiringOrders = try container.decodeIntIfPresent(forKey: .expiringOrders)
            self.openOrders = try container.decodeIntIfPresent(forKey: .openOrders)
            self.orders = try container.decodeIntIfPresent(forKey: .orders)
            self.outOfStockProducts = try container.decodeIntIfPresent(forKey: .outOfStockProducts)
            self.overdueOrders = try container.decodeIntIfPresent(forKey: .overdueOrders)
            self.products = try container.decodeIntIfPresent(forKey: .products)
            self.subscribers = try container.decodeIntIfPresent(forKey: .subscribers)
        }

        enum CodingKeys: CodingKey {
            case customers, expiringOrders, openOrders, orders, outOfStockProducts, overdueOrders, products, subscribers
        }
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.today = try container.decodeIfPresent(Period.self, forKey: .today)
        self.last7Days = try container.decodeIfPresent(Period.self, forKey: .last7Days)
        self.last30Days = try container.decodeIfPresent(Period.self, forKey: .last30Days)
        self.general = try container.decodeIfPresent(General.self, forKey: .general)
    }

    // The wire keys "7days"/"30days" aren't valid Swift identifiers, and convertFromSnakeCase
    // doesn't touch leading-digit keys, so they need explicit raw string overrides.
    enum CodingKeys: String, CodingKey {
        case today
        case last7Days = "7days"
        case last30Days = "30days"
        case general
    }

    public static func get(client: ClientProtocol) async throws -> DashboardStat {
        let data = try await client.get(endpoint: .dashboardStats, id: nil, filters: nil, sort: nil, page: nil, limit: nil)
        return try client.decode(data: data)
    }
}
