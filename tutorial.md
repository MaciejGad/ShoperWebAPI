# Tutorial: how to use ShoperWebAPI

This document is a practical, step-by-step tutorial for a developer who wants to start using the
`ShoperWebAPI` package — a typed Swift client for the Shoper store REST API. If you're looking for
the full resource catalog or architecture details, check [`USAGE.md`](USAGE.md) (complete
reference) and [`AGENTS.md`](AGENTS.md) (for people extending the package itself). This file is
meant to teach you the basics through examples — read it top to bottom.

## Table of contents

1. [Installation](#1-installation)
2. [Connecting to your shop](#2-connecting-to-your-shop)
3. [Your first request](#3-your-first-request)
4. [The resource pattern — how every type in the SDK works](#4-the-resource-pattern)
5. [Filtering and sorting](#5-filtering-and-sorting)
6. [Pagination and fetching everything](#6-pagination-and-fetching-everything)
7. [Creating and updating data](#7-creating-and-updating-data)
8. [Error handling](#8-error-handling)
9. [Special types: coded fields, bitmasks, inconsistent data](#9-special-types)
10. [Resources that don't fit the standard pattern](#10-resources-that-dont-fit-the-standard-pattern)
11. [Mini-project: unpaid orders report](#11-mini-project-unpaid-orders-report)
12. [Where to go next](#12-where-to-go-next)

---

## 1. Installation

Add the package to `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/MaciejGad/ShoperWebAPI.git", from: "1.0.0")
]
```

or in Xcode: **File → Add Package Dependencies** and paste the repository URL.

Requirements: Swift 6.0+, iOS 15 / macOS 12+ (see `README.md` for the full platform list).

## 2. Connecting to your shop

Everything starts with `Config` and `Client`. There are two ways to authenticate:

**Option A — login and password** (the SDK fetches and refreshes the token for you):

```swift
import ShoperWebAPI

let config = Config(
    shopURL: URL(string: "https://your-shop.myshoper.pl")!,
    login: "webapi-login",
    password: "webapi-password"
)
let client = Client(config: config)
```

**Option B — you already have an OAuth token** (e.g. your app does its own AppStore OAuth flow):

```swift
let config = Config(
    shopURL: URL(string: "https://your-shop.myshoper.pl")!,
    accessToken: "existing-token"
)
let client = Client(config: config)
```

Useful optional `Config` parameters:

```swift
Config(
    shopURL: ...,
    login: ..., password: ...,
    defaultLanguage: "pl_PL",   // default: "pl_PL"
    verbose: true               // logs every request/response — handy while learning
)
```

> `client` stores the token and refreshes it automatically — you don't need to worry about
> re-authenticating between requests.

## 3. Your first request

Let's confirm everything works by fetching a list of products:

```swift
let page = try await Product.list(client: client)
print("Total products: \(page.count)")

for product in page.list {
    let name = product.translations["pl_PL"]?.name ?? "(no name)"
    print("\(product.productId ?? 0): \(name) — \(product.stock.stock) in stock")
}
```

`Product.list(client:)` returns a single page of results (`ResourceList<Product>`) with fields
`.count` (total count), `.pages` (total pages), `.page` (current page), and `.list` (the array of
objects).

## 4. The resource pattern

This is the most important thing to remember: **every resource in this SDK (Product, ShopOrder,
User, PromotionCode, News, Auction...) exposes the exact same set of methods.** Learn one, know
them all:

```swift
let page   = try await Product.list(client: client)               // one page
let all    = try await Product.listAll(client: client)             // walks every page for you, as [Product]
let one    = try await Product.get(client: client, id: 36)          // a single record by id
let newId  = try await Product.create(client: client, payload: myCreatePayload)   // returns Int — the new id
try await Product.update(client: client, id: 36, payload: myUpdatePayload)        // partial update
let ok     = try await Product.delete(client: client, id: 36)       // Bool: was something actually deleted?
```

Swap `Product` for any other type (`ShopOrder`, `User`, `PromotionCode`, `Redirect`, `News`...) and
the code looks identical. Create/update payload types are called `CreateX`/`UpdateX` (e.g.
`CreateProduct`, `UpdateProduct`).

> Some resources are **read-only** (e.g. `Tax`, `Currency`, `Delivery`) — `create`/`update` still
> exist (the shared protocol requires them), but their payload type is empty and calling them
> won't do anything. See [`USAGE.md`](USAGE.md) for the full list of which resources support
> writes.

## 5. Filtering and sorting

Filters and sorting are static functions specific to each resource — just start typing `.` inside
the `filters:`/`sort:` array and Xcode's autocomplete will show you what's available for that
type.

```swift
// Filtering
let sneakers = try await Product.list(client: client, filters: [
    .name("sneaker"),
    .stock(greaterThan: 0)
])

// Sorting
let sorted = try await Product.list(client: client, sort: [
    .stock(direction: .descending),
    .name(direction: .ascending)
])

// You can combine both at once
let both = try await Product.list(client: client, filters: [.stock(greaterThan: 0)], sort: [.name(direction: .ascending)])
```

Example on orders — all unpaid ones, newest first:

```swift
let unpaid = try await ShopOrder.list(client: client,
    filters: [.paid(false)],
    sort: [.date(direction: .descending)]
)
```

> Orders in this SDK are called `ShopOrder`, not `Order` — the name `Order<Key>` is taken by the
> SDK's internal sort-direction type.

## 6. Pagination and fetching everything

Manual pagination:

```swift
let page2 = try await Product.list(client: client, page: 2, limit: 50)
print("Page \(page2.page) of \(page2.pages), \(page2.count) products total")
```

If you want everything at once and don't want to walk pages yourself:

```swift
let allProducts = try await Product.listAll(client: client)   // walks every page for you
```

`listAll` also works with filters/sorting: `listAll(client:filters:sort:limit:maxPages:)`.

## 7. Creating and updating data

When creating a resource you always pass a separate `CreateX` type — it has a different (usually
smaller) set of required fields than the object you read back.

```swift
let payload = CreateProduct(
    categoryId: 19,
    code: "SKU-001",
    pkwiu: "",
    stock: CreateProductStock(price: 99.90, stock: 10),
    translations: ["pl_PL": CreateProductTranslation(name: "My new product")]
)
let newProductId = try await Product.create(client: client, payload: payload)
```

Updates are **partial** — you only set the fields you want to change:

```swift
try await Product.update(client: client, id: newProductId, payload: UpdateProduct(
    stock: CreateProductStock(stock: 5)
))
```

Deleting returns a `Bool` — whether the record actually existed and was deleted:

```swift
let deleted = try await Product.delete(client: client, id: newProductId)
print(deleted ? "Deleted" : "Nothing to delete")
```

**Cloning an existing product** is a common case — the SDK has a dedicated initializer for it:

```swift
let source = try await Product.get(client: client, id: sourceId)
var clonePayload = CreateProduct(copying: source)   // copies writable fields, skips read-only ones
clonePayload.code = "SKU-002"
let clonedId = try await Product.create(client: client, payload: clonePayload)
```

## 8. Error handling

```swift
do {
    let products = try await Product.list(client: client)
} catch let error as ShoperError {
    switch error {
    case .invalidCredentials:
        print("Invalid login/password or token")
    case .invalidResponse(let data, let response):
        let status = (response as? HTTPURLResponse)?.statusCode
        print("Server returned error \(status ?? -1): \(String(data: data, encoding: .utf8) ?? "")")
    case .invalidURL:
        print("Malformed shop URL")
    }
} catch {
    print("Network error: \(error)")
}
```

A few resources require an elevated app permission scope that Shoper grants only to selected
applications and normally return HTTP 403 (`OrderRefund`, `OrderTransaction`, `PaymentChannel`) —
that's not a bug in your code, your application simply hasn't been granted access to those
resources.

## 9. Special types

Shoper's API can be inconsistent about wire types (e.g. `"1"`/`"0"` instead of `true`/`false`).
The SDK hides this from you — you always see proper Swift types:

**Coded fields** (an enum instead of a raw int), with a fallback for unrecognized values:

```swift
switch redirect.type {
case .own: ...
case .product: ...
case .unknown(let code): print("unhandled redirect type: \(code)")
default: break
}
```

**Bitmasks** as `OptionSet`:

```swift
let payload = CreateAdditionalField(
    type: .select,
    locate: [.orderForm, .contactForm],   // combine as many flags as you need
    translations: ["pl_PL": .init(name: "How did you hear about us?", options: ["Google", "Friend"])]
)
```

## 10. Resources that don't fit the standard pattern

Most resources work exactly like `Product` from section 4, but there are a few exceptions worth
knowing about:

**Singleton resources** (no list, no id) — data about the shop itself:

```swift
let version = try await ApplicationVersion.get(client: client)
let shopConfig = try await ApplicationConfig.get(client: client)
let stats = try await DashboardStat.get(client: client)
```

**Resources nested under another resource** — they need an extra parameter instead of a plain
`id`:

```swift
let collectionProducts = try await CollectionProduct.list(client: client, collectionId: 3)
let paymentChannels = try await PaymentChannel.list(client: client, paymentId: 1)
```

**Category tree** — returns a flat array instead of standard pagination:

```swift
let parentMap = try await ShoperCategory.fetchParentMap(client: client)   // childId -> parentId
```

See `USAGE.md` for the full list of exceptions, with an explanation of *why* each one is
different.

## 11. Mini-project: unpaid orders report

Let's combine a few things from this tutorial into one small, practical script:

```swift
import ShoperWebAPI

let config = Config(shopURL: URL(string: "https://your-shop.myshoper.pl")!,
                     login: "login", password: "password")
let client = Client(config: config)

let unpaidOrders = try await ShopOrder.list(client: client,
    filters: [.paid(false)],
    sort: [.date(direction: .descending)]
).list

var total: Decimal = 0
for order in unpaidOrders {
    guard let orderId = order.orderId else { continue }
    let items = try await OrderProduct.list(client: client, filters: [.orderId(orderId)]).list
    let sum = order.sum ?? 0
    total += sum
    print("Order #\(orderId): \(items.count) item(s), total \(sum), email: \(order.email ?? "-")")
}
print("Total value of unpaid orders: \(total)")
```

## 12. Where to go next

- **[`USAGE.md`](USAGE.md)** — the full catalog of all ~65 resources (endpoint, whether it's
  writable), ready-made recipes for common tasks (uploading an image, creating a webhook, working
  with the CMS/blog, auctions), and a table of the types you'll touch most often.
- **[`README.md`](README.md)** — a short project introduction, requirements, how to run the tests.
- **[`AGENTS.md`](AGENTS.md)** — if you want to extend the package itself (add new resources) or
  understand the mismatches between the official API docs and how Shoper actually responds.
- Official Shoper API docs: <https://developers.shoper.pl/developers/api/getting-started>
