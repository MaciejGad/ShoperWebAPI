# ShoperWebAPI

A Swift SDK for integrating with the [Shoper Web API](https://developers.shoper.pl/developers/api/getting-started). This library provides a type-safe, modern Swift interface for accessing Shoper's REST API, enabling you to manage products, product images, and other e-commerce data programmatically.

## Features

- 🎯 **Type-safe**: Fully typed Swift models for all API responses
- 🔄 **Async/Await**: Modern Swift concurrency support
- 📱 **Cross-platform**: Works on macOS 12.0+ and other Apple platforms
- 🔍 **Advanced Filtering**: Powerful filtering and sorting capabilities
- 📄 **Pagination**: Built-in pagination support
- 🏗️ **Resource Pattern**: Consistent CRUD operations across all resources
- 🔐 **Authentication**: Automatic token management
- 🧪 **Well Tested**: Comprehensive test coverage with mock data

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/MaciejGad/ShoperWebAPI.git", from: "1.0.0")
]
```

Or add it through Xcode:
1. Go to File → Add Package Dependencies
2. Enter the repository URL: `https://github.com/MaciejGad/ShoperWebAPI.git`
3. Select the version and add to your target

## Quick Start

### 1. Configuration

First, configure the client with your Shoper store credentials:

```swift
import ShoperWebAPI

let config = Config(
    shopURL: URL(string: "https://your-shop.myshoper.pl")!,
    login: "your-api-login",
    password: "your-api-password",
    defaultLanguage: "pl_PL",
    verbose: false
)

let client = Client(config: config)
```

### 2. Basic Usage

#### Fetching Products

```swift
// Get all products
let productList = try await Product.list(client: client)
print("Total products: \(productList.count)")

// Get first page products
for product in productList.list {
    if let translation = product.translations["pl_PL"] {
        print("\(product.id): \(translation.name) - Stock: \(product.stock.stock)")
    }
}
```

#### Get a Specific Product

```swift
let product = try await Product.get(client: client, id: 36)
print("Product: \(product.translations["pl_PL"]?.name ?? "No name")")
```

### 3. Advanced Filtering

#### Filter Products by Name and Stock

```swift
let productList = try await Product.list(client: client, filters: [
    .name("smartphone"),
    .stock(greaterThan: 0)
])

for product in productList.list {
    let translation = product.translations["pl_PL"]
    print("\(translation?.name ?? "Unknown"): \(product.stock.stock) in stock")
}
```

#### Filter with Pagination

```swift
let productList = try await Product.list(
    client: client,
    filters: [.stock(greaterThan: 0)],
    page: 2
)
print("Page \(productList.page) of \(productList.pages)")
```

### 4. Sorting

```swift
// Sort products by name in ascending order
let productList = try await Product.list(client: client, sort: [
    .name(direction: .ascending)
])

// Sort by multiple criteria
let sortedProducts = try await Product.list(client: client, sort: [
    .stock(direction: .descending),
    .name(direction: .ascending)
])
```

### 5. Updating Products

#### Update Product Stock

```swift
let updatePayload = UpdateProduct(
    stock: CreateProductStock(stock: 100)
)

try await Product.update(client: client, id: 36, payload: updatePayload)
```

#### Update Product Information

```swift
let updatePayload = UpdateProduct(
    translations: [
        "pl_PL": CreateProductTranslation(
            name: "New Product Name",
            shortDescription: "Updated short description",
            description: "Updated full description"
        )
    ]
)

try await Product.update(client: client, id: 36, payload: updatePayload)
```

> `UpdateProduct` reuses `CreateProductStock`/`CreateProductTranslation` for its nested
> `stock`/`translations` fields — there's no separate `UpdateStock`/`UpdateProductTranslation`
> type. See [`USAGE.md`](USAGE.md) for why.

## Working with Product Images

### Fetching Product Images

```swift
// Get all images for a specific product
let imageList = try await ProductImage.list(client: client, filters: [
    .productId(36)
])

for image in imageList.list {
    print("Image: \(image.name), main: \(image.main), hidden: \(image.hidden)")
}
```

### Creating Product Images

#### Upload from URL

```swift
let createPayload = CreateProductImage.image(
    url: "https://example.com/image.jpg",
    productId: 36,
    name: "Product Main Image",
    language: "pl_PL"
)

let imageId = try await ProductImage.create(client: client, payload: createPayload)
print("Created image with ID: \(imageId)")
```

#### Upload Base64 Content

```swift
let imageData = Data() // Your image data
let createPayload = CreateProductImage.image(
    content: imageData,
    productId: 36,
    name: "Product Image",
    language: "pl_PL"
)

let imageId = try await ProductImage.create(client: client, payload: createPayload)
```

## Working with Orders

Orders represent customer purchases. Use `ShopOrder` (the name avoids a conflict with the SDK's internal `Order<Key>` sort-direction type).

### Fetching Orders

```swift
// Get all orders
let list = try await ShopOrder.list(client: client)
print("Total orders: \(list.count)")

// Get a specific order
let order = try await ShopOrder.get(client: client, id: 100)
print("Order \(order.orderId ?? 0): \(order.email ?? "") sum: \(order.sum ?? 0)")
```

### Filtering Orders

```swift
// Unpaid orders
let unpaid = try await ShopOrder.list(client: client, filters: [
    .paid(false)
])

// Orders with a specific status
let confirmed = try await ShopOrder.list(client: client, filters: [
    .statusId(2)
])

// Orders from a specific customer
let customerOrders = try await ShopOrder.list(client: client, filters: [
    .userId(5)
])
```

### Sorting Orders

```swift
// Most recent orders first
let recent = try await ShopOrder.list(client: client, sort: [
    .date(direction: .descending)
])

// Highest value orders first
let byValue = try await ShopOrder.list(client: client, sort: [
    .sum(direction: .descending)
])
```

### Pagination

```swift
let page2 = try await ShopOrder.list(client: client, page: 2, limit: 10)
print("Page \(page2.page) of \(page2.pages), total: \(page2.count)")
```

### Combining Orders with Their Products

```swift
// Fetch orders, then load line items for each
let orders = try await ShopOrder.list(client: client, filters: [.paid(false)]).list

for order in orders {
    guard let orderId = order.orderId else { continue }
    let items = try await OrderProduct.list(client: client, filters: [.orderId(orderId)])
    print("Order \(orderId): \(items.count) item(s), total: \(order.sum ?? 0)")
}

## Working with Order Products

Order products represent line items within an order. Use this resource to fetch which products were purchased and in what quantities.

### Fetching Order Products

```swift
// Get all order products
let list = try await OrderProduct.list(client: client)
print("Total order products: \(list.count)")

// Get products from a specific order
let orderItems = try await OrderProduct.list(client: client, filters: [
    .orderId(100)
])

for item in orderItems.list {
    print("Product: \(item.name ?? "") x\(item.quantity ?? 0) @ \(item.price ?? 0)")
}
```

### Get a Specific Order Product

```swift
let item = try await OrderProduct.get(client: client, id: 1)
print("Order product: \(item.name ?? "") qty: \(item.quantity ?? 0)")
```

### Joining Orders with Their Products

```swift
// Fetch orders first, then load their products
let orderProducts = try await OrderProduct.list(client: client, filters: [
    .orderId(orderId)
])

let productsByOrderId = Dictionary(grouping: orderProducts.list) { $0.orderId }
```

### Sorting Order Products

```swift
let sorted = try await OrderProduct.list(client: client, sort: [
    .price(direction: .descending)
])
```

### Pagination

```swift
let page2 = try await OrderProduct.list(client: client, page: 2, limit: 10)
print("Page \(page2.page) of \(page2.pages)")
```

## Available Filter Options

### Product Filters

```swift
// Text search
.name("search term")
.description("description text")

// Numeric comparisons
.stock(greaterThan: 10)
.price(lessThan: 100.0)
.productId(36)

// Boolean flags
.active(true)
.bestseller(true)
.newProduct(true)

// Date filters
.addDate(after: Date())
.editDate(before: Date())
```

### Product Image Filters

```swift
.productId(36)
.main(true)
.hidden(false)
```

## Sort Options

### Product Sorting

```swift
.productId(direction: .ascending)
.name(direction: .descending)
.stock(direction: .ascending)
.price(direction: .descending)
.addDate(direction: .descending)
```

## Error Handling

The SDK uses Swift's error handling mechanism:

```swift
do {
    let products = try await Product.list(client: client)
    // Handle success
} catch let error as ShoperError {
    switch error {
    case .invalidCredentials:
        print("Invalid API credentials")
    case .invalidResponse(let data, let response):
        print("API returned invalid response")
    default:
        print("Other Shoper error: \(error)")
    }
} catch {
    print("Network or other error: \(error)")
}
```

## Resource Pattern

All resources follow the same pattern with these operations:

- `list(client:)` - Get all resources
- `list(client:, page:)` - Get resources with pagination
- `list(client:, filters:)` - Get filtered resources
- `list(client:, sort:)` - Get sorted resources
- `list(client:, filters:, sort:, page:)` - Get resources with all options
- `listAll(client:, filters:, sort:, limit:, maxPages:)` - Walk every page and return a flat array
- `get(client:, id:)` - Get a specific resource by ID
- `create(client:, payload:)` - Create a new resource, returns the new `Int` id
- `update(client:, id:, payload:)` - Partially update an existing resource
- `delete(client:, id:)` - Delete a resource, returns `true` if something was deleted

## Supported Resources

This SDK covers ~50 Shoper resources, including products, product images/files/stocks,
categories, attributes/options, orders and order line items, customers (users, addresses,
groups, tags), subscribers, promotion codes, shipping/payment/geolocation dictionaries, shop
configuration, and more.

**For the full catalog with endpoint paths and read/write status, see [`USAGE.md`](USAGE.md).**
That file also has task-oriented recipes (creating a product, cloning a product, uploading
images, working with orders) beyond the quick start below.

## Configuration Options

```swift
let config = Config(
    shopURL: URL(string: "https://your-shop.myshoper.pl")!,
    login: "your-api-login",       // omit if using accessToken
    password: "your-api-password", // omit if using accessToken
    accessToken: nil,          // Default: nil - supply an existing OAuth token instead of login/password
    defaultLanguage: "pl_PL",  // Default: "pl_PL"
    verbose: false,            // Default: false - enables request logging
    storeToFile: false         // Default: false - for testing/debugging
)
```

## Requirements

- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+
- Swift 6.0+
- Xcode 14.0+

## API Documentation

This SDK is based on the official [Shoper Web API](https://developers.shoper.pl/developers/api/getting-started). For detailed API documentation, parameter descriptions, and advanced usage examples, please refer to the official Shoper developer documentation.

## Testing

The SDK includes comprehensive tests with mock data. 

### Local Testing

Run tests locally using:

```bash
# Run tests with parallel execution (default)
swift test

# Run tests sequentially (no parallel execution)
swift test --no-parallel
```

### Docker Testing (Linux/Ubuntu LTS)

To run tests on Linux using Docker, you have several options:

#### Option 1: Using the convenience scripts
```bash
# Run tests with parallel execution (default)
./run-tests-docker.sh

# Run tests sequentially (no parallel execution)
./run-tests-docker-serial.sh
```

#### Option 2: Using Make targets
```bash
# Run tests locally
make test                 # with parallel execution
make test-serial          # without parallel execution

# Run tests in Docker
make test-docker          # with parallel execution
make test-docker-serial   # without parallel execution
```

#### Option 3: Using Docker Compose directly
```bash
# Build and run tests (with parallel execution)
docker-compose run --rm shoper-webapi-tests

# Run tests without parallel execution
docker-compose run --rm shoper-webapi-tests swift test --no-parallel

# Or for interactive development
docker-compose run --rm shoper-webapi-dev
```

#### Option 4: Using Docker directly
```bash
# Build the image
docker build -t shoper-webapi .

# Run tests
docker run --rm shoper-webapi

# Or run interactively
docker run --rm -it shoper-webapi bash
```

The Docker environment uses Ubuntu LTS with Swift 6.0, ensuring compatibility with Linux deployment environments.

#### When to Use Serial Execution

Use serial execution (`--no-parallel`) when:
- **Debugging tests**: Easier to trace execution flow and identify issues
- **Shared resources**: Tests that modify shared state or files
- **Resource constraints**: Limited CPU or memory environments
- **Deterministic output**: When you need consistent test execution order
- **Race conditions**: When parallel execution causes intermittent failures

By default, Swift Testing runs tests in parallel for faster execution, but serial execution provides more predictable behavior for debugging and development.

## Documentation

- **[`tutorial.md`](tutorial.md)** / **[`tutorial_pl.md`](tutorial_pl.md)** — a step-by-step
  tutorial (English / Polish) for someone starting out with this SDK: installation, connecting,
  first requests, the resource pattern, filtering, creating/updating data, and a mini-project at
  the end.
- **[`USAGE.md`](USAGE.md)** — the complete usage reference: full resource catalog, recipes for
  common tasks (create/clone a product, upload images, work with orders), and notes on quirks
  you may run into.
- **[`AGENTS.md`](AGENTS.md)** — for contributors extending the SDK: architecture, conventions
  for adding a new resource, the live-testing workflow, and a table of confirmed mismatches
  between the Shoper OpenAPI spec and the real API.

### Using an AI coding assistant

If you're adding this package to a project and use Claude Code, [`skills/shoperwebapi/SKILL.md`](skills/shoperwebapi/SKILL.md)
in this repo is a self-contained reference for the SDK's patterns and resource catalog. Copy it
into your own project's `.claude/skills/shoperwebapi/` directory (or your global `~/.claude/skills/`)
to have Claude Code use it automatically when writing code against this package.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is available under the MIT license. See the LICENSE file for more info.

## Support

If you have any questions or issues, please:

1. Check the [official Shoper API documentation](https://developers.shoper.pl/developers/api/getting-started)
2. Search existing issues in this repository
3. Create a new issue with detailed information about your problem

---

**Note**: This is an unofficial SDK. For official support, please contact Shoper directly.