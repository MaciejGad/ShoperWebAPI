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
    stock: UpdateStock(stock: 100)
)

try await Product.update(client: client, id: 36, payload: updatePayload)
```

#### Update Product Information

```swift
let updatePayload = UpdateProduct(
    translations: [
        "pl_PL": UpdateProductTranslation(
            name: "New Product Name",
            shortDescription: "Updated short description",
            description: "Updated full description"
        )
    ]
)

try await Product.update(client: client, id: 36, payload: updatePayload)
```

## Working with Product Images

### Fetching Product Images

```swift
// Get all images for a specific product
let imageList = try await ProductImage.list(client: client, filters: [
    .productId(36)
])

for image in imageList.list {
    print("Image ID: \(image.id), URL: \(image.url ?? "No URL")")
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
- `get(client:, id:)` - Get a specific resource by ID
- `create(client:, payload:)` - Create a new resource
- `update(client:, id:, payload:)` - Update an existing resource

## Supported Resources

Currently supported resources:

- **Products** (`Product`) - Complete product management
- **Product Images** (`ProductImage`) - Product image management

More resources will be added in future versions.

## Configuration Options

```swift
let config = Config(
    shopURL: URL(string: "https://your-shop.myshoper.pl")!,
    login: "your-api-login",
    password: "your-api-password",
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
swift test
```

### Docker Testing (Linux/Ubuntu LTS)

To run tests on Linux using Docker, you have several options:

#### Option 1: Using the convenience script
```bash
./run-tests-docker.sh
```

#### Option 2: Using Docker Compose directly
```bash
# Build and run tests
docker-compose run --rm shoper-webapi-tests

# Or for interactive development
docker-compose run --rm shoper-webapi-dev
```

#### Option 3: Using Docker directly
```bash
# Build the image
docker build -t shoper-webapi .

# Run tests
docker run --rm shoper-webapi

# Or run interactively
docker run --rm -it shoper-webapi bash
```

The Docker environment uses Ubuntu LTS with Swift 6.0, ensuring compatibility with Linux deployment environments.

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