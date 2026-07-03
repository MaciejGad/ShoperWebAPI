---
name: shoperwebapi
description: Reference for the ShoperWebAPI Swift SDK — a typed client for the Shoper e-commerce REST API covering products, orders, customers, marketing, shipping/payment, and shop-config resources. Use when writing or reviewing Swift code that adds this package to an app, authenticates against a Shoper store, or calls any of its ~50 resources (Product, ShopOrder, User, PromotionCode, Redirect, etc.).
---

# ShoperWebAPI usage reference

This skill helps you write correct Swift code against the `ShoperWebAPI` package
(https://github.com/MaciejGad/ShoperWebAPI). It's a knowledge/reference skill — no tools beyond
normal file editing are needed; just use this content when generating or reviewing code.

If the target project has a local checkout of the `ShoperWebAPI` package with `USAGE.md` /
`AGENTS.md` at its root, prefer reading those directly (`Read` tool) for the authoritative,
up-to-date version — this file is a portable summary meant to work even when only the compiled
package is present as a dependency (e.g. resolved via SPM, no local source checkout).

## Install & connect

```swift
// Package.swift
.package(url: "https://github.com/MaciejGad/ShoperWebAPI.git", from: "1.0.0")
```

```swift
import ShoperWebAPI

// Option A: login/password — SDK fetches and caches a token for you
let config = Config(shopURL: URL(string: "https://your-shop.myshoper.pl")!,
                     login: "webapi-login", password: "webapi-password")

// Option B: you already have an OAuth access token
let config = Config(shopURL: URL(string: "https://your-shop.myshoper.pl")!,
                     accessToken: "existing-token")

let client = Client(config: config)
```

`Config` also takes `defaultLanguage` (default `"pl_PL"`) and `verbose: Bool` (logs every
request/response — useful while debugging, turn off in production).

## The core pattern — every resource works the same way

```swift
let page = try await Product.list(client: client)          // ResourceList<Product>: .count, .pages, .page, .list
let all = try await Product.listAll(client: client)         // walks every page for you, returns [Product]
let one = try await Product.get(client: client, id: 36)
let newId = try await Product.create(client: client, payload: createPayload)   // returns Int id
try await Product.update(client: client, id: 36, payload: updatePayload)       // partial update
let deleted = try await Product.delete(client: client, id: 36)                 // Bool: was something actually deleted?
```

Filtering and sorting:

```swift
let filtered = try await Product.list(client: client, filters: [.name("sneaker"), .stock(greaterThan: 0)])
let sorted = try await Product.list(client: client, sort: [.stock(direction: .descending)])
```

Available `.filterName(...)` / `.sortName(...)` cases are resource-specific static functions —
rely on autocomplete inside `filters:`/`sort:` arrays rather than guessing names.

Some resources are read-only lookups (`Tax`, `Currency`, `Delivery`, ...): `create`/`update`
exist for protocol consistency but their payload type is `EmptyPayload` and calling them isn't
meaningful. See the catalog below for which resources actually support writes.

## Error handling

```swift
do {
    _ = try await Product.list(client: client)
} catch let error as ShoperError {
    switch error {
    case .invalidCredentials: break        // bad login/password/token
    case .invalidResponse(let data, let response):
        let status = (response as? HTTPURLResponse)?.statusCode   // non-2xx; `data` is the raw error body
    case .invalidURL: break
    }
} catch { /* network-level failure */ }
```

`OrderRefund` and `OrderTransaction` require an elevated app permission scope Shoper grants only
to selected apps — expect HTTP 403 `insufficient_scope` on a standard token.

## Common recipes

**Update stock:**
```swift
try await Product.update(client: client, id: 36, payload: UpdateProduct(stock: CreateProductStock(stock: 100)))
```

**Create a product** (only `categoryId`, `code`, `pkwiu`, `stock`, `translations` are required):
```swift
let payload = CreateProduct(
    categoryId: 19, code: "SKU-001", pkwiu: "",
    stock: CreateProductStock(price: 99.90, stock: 10),
    translations: ["pl_PL": CreateProductTranslation(name: "My new product")]
)
let newId = try await Product.create(client: client, payload: payload)
```

**Clone an existing product:**
```swift
let source = try await Product.get(client: client, id: sourceId)
var payload = CreateProduct(copying: source)   // copies writable fields, flattens attributes, skips read-only fields
payload.code = "SKU-002"
let clonedId = try await Product.create(client: client, payload: payload)
```

**Upload a product image:**
```swift
let payload = CreateProductImage.image(url: "https://example.com/photo.jpg", productId: 36, name: "Front")
// or: CreateProductImage.image(content: imageData, productId: 36, name: "Front")
let imageId = try await ProductImage.create(client: client, payload: payload)
```

**Coded/bitmask fields** are typed, not raw `Int` — handle unknown API values gracefully:
```swift
switch redirect.type {
case .own: ...
case .unknown(let code): print("unhandled redirect type \(code)")
default: break
}
let locate: AdditionalFieldLocate = [.orderForm, .contactForm]   // OptionSet literal
```

**Category tree** doesn't follow the standard paginated pattern (the endpoint returns a flat
array):
```swift
let parentMap = try await ShoperCategory.fetchParentMap(client: client)   // childId -> parentId
```

**Shop metadata** are singletons (no list/id, different call shape):
```swift
let version = try await ApplicationVersion.get(client: client)
let shopConfig = try await ApplicationConfig.get(client: client)
```

## Resource catalog (type — endpoint — writable?)

**Products & catalog:** `Product` `/products` ✅ · `ProductImage` `/product-images` ✅ ·
`ProductFile` `/product-files` ✅ · `ProductStock` `/product-stocks` ✅ · `ProductTag`
`/product-tags` ro · `ProductSpecialOffer` `/specialoffers` ro · `ShoperCategory` `/categories` ro
· `CategoryTreeNode` `/categories-tree` ro (own shape, see above) · `ShoperAttribute`
`/attributes` ro · `AttributeGroup` `/attribute-groups` ro · `ShoperOption` `/options` ro ·
`OptionGroup` `/option-groups` ro · `OptionValue` `/option-values` ro · `Collection`
`/collections` ro · `Producer` `/producers` ro

**Orders:** `ShopOrder` `/orders` ✅ (named `ShopOrder`, not `Order` — that name is taken by the
SDK's internal sort-direction type) · `OrderProduct` `/order-products` ✅ · `OrderTag`
`/order-tags` ✅ · `Parcel` `/parcels` ro · `OrderRefund` `/order-refunds` ro, 403-gated ·
`OrderTransaction` `/order-transactions` ro, 403-gated

**Customers:** `User` `/users` ✅ · `UserAddress` `/user-addresses` ✅ · `UserGroup`
`/user-groups` ✅ · `UserTag` `/user-tags` ✅ · `Subscriber` `/subscribers` ✅ · `SubscriberGroup`
`/subscriber-groups` ✅

**Marketing:** `PromotionCode` `/promotion-codes` ✅ · `LoyaltyEvent` `/loyalty-events` create-only
(no update/delete endpoint exists; creating requires the shop's loyalty program to be enabled —
HTTP 400 otherwise)

**Shipping/payment/geo:** `Shipping` `/shippings` ro · `Payment` `/payments` ro · `Zone` `/zones`
ro · `Delivery` `/deliveries` ro · `Availability` `/availabilities` ro · `GeolocationCountry`
`/geolocation-countries` ro · `GeolocationRegion` `/geolocation-regions` ro ·
`GeolocationSubregion` `/geolocation-subregions` ro

**Shop config/dictionaries:** `Tax` `/taxes` ro · `Currency` `/currencies` ro · `Unit` `/units` ro
· `Gauge` `/gauges` ro · `Status` `/statuses` ro · `Language` `/languages` update-only (creating a
language is disabled — the live API returned HTTP 500 for every payload tried) · `Redirect`
`/redirects` ✅ · `AdditionalField` `/additional-fields` ✅ · `AdditionalFieldOption`
`/additional-field-options` ✅ but module not installed on every shop (HTTP 400 "Missing MODULE"
if disabled) · `ProductSafetyProducer`/`Importer`/`Responsible`/`Certificate`
`/product-safety-*` ro · `Progress` `/progresses` ro · `MetafieldValue` `/metafield-values` ✅
(generic key/value storage attached to any object via `metafieldId`) · `Webhook` `/webhooks` ✅

**Metafield binding** (write-only action, no list/get, requires the `metafields_bind` feature
flag — expect HTTP 403 if disabled):
```swift
let bindId = try await MetafieldBind.create(client: client,
    payload: MetafieldBind(type: "product", itemId: "36", metafieldId: 1, value: "some value"))
```

**Webhooks** — `events` takes `WebhookEvent`, a typed enum of the 24 documented events (7 groups:
category/order/client/product/parcel/specialoffer/subscriber, each with `.create`/`.edit`/`.delete`
plus a few extras like `.orderPaid`, `.orderStatus`, `.parcelDispatch`, `.parcelSend`). Unknown
values (e.g. system webhooks from installed apps, like `"admin.account_connected"`) decode as
`.unknown(String)`.
```swift
let webhookId = try await Webhook.create(client: client,
    payload: CreateWebhook(url: "https://example.com/hook", format: .json, events: [.orderCreate]))
```

**Not implemented:** CMS/blog, auctions, metafield *definitions* (`/metafields/{object}` — its
dynamic path segment doesn't fit this SDK's resource pattern; use `MetafieldValue` directly if you
already know the `metafieldId`), admin dashboard stats, multi-warehouse support
(`warehouses`, `Stock.warehouses`).

## When something doesn't match the docs

The Shoper OpenAPI spec has confirmed inaccuracies (wrong required fields, wrong field names,
undocumented response shapes). If a request fails in a way that contradicts what the type system
suggests should work, don't assume your code is wrong before checking — it may be a known
spec-vs-reality mismatch. See `AGENTS.md` in the `ShoperWebAPI` repo for the full list if you have
access to it; otherwise treat unexpected 400/500 responses as a hint to try the minimal payload
first and add fields back one at a time.
