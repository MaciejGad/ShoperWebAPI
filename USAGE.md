# Using ShoperWebAPI in your app

A practical guide for adding `ShoperWebAPI` to a Swift application and talking to a real Shoper
store. If you're looking to *modify* this package, see `AGENTS.md` instead — this file is for
consumers, not contributors.

## Install

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/MaciejGad/ShoperWebAPI.git", from: "1.0.0")
]
```

```swift
import ShoperWebAPI
```

## Connect to your shop

Two ways to authenticate. Pick one.

### Option A — login/password (the SDK fetches a token for you)

```swift
let config = Config(
    shopURL: URL(string: "https://your-shop.myshoper.pl")!,
    login: "your-webapi-login",
    password: "your-webapi-password"
)
let client = Client(config: config)
```

The client calls `POST /webapi/rest/auth` lazily on first request and caches the token until it
expires.

### Option B — you already have an access token

```swift
let config = Config(
    shopURL: URL(string: "https://your-shop.myshoper.pl")!,
    accessToken: "existing-oauth-access-token"
)
let client = Client(config: config)
```

Useful if your app does the OAuth dance itself (e.g. a Shoper AppStore app) and just needs to
hand the resulting token to the SDK.

### Useful `Config` options

```swift
Config(
    shopURL: ...,
    login: ..., password: ...,       // or accessToken: ...
    defaultLanguage: "pl_PL",         // default: "pl_PL"
    verbose: true                    // logs every request URL + response body — handy while wiring things up, turn off in production
)
```

## The core pattern

Every resource (`Product`, `ShopOrder`, `Currency`, ...) exposes the same five operations. Once
you know one, you know them all:

```swift
// List (paginated, filterable, sortable)
let page = try await Product.list(client: client)
print(page.count, page.pages, page.page)   // total count / total pages / current page
let products = page.list                   // [Product]

// Get one page you don't need to think about pagination for
let allProducts = try await Product.listAll(client: client)   // walks every page for you

// Get one by id
let product = try await Product.get(client: client, id: 36)

// Create — returns the new resource's Int id
let newId = try await Product.create(client: client, payload: myCreatePayload)

// Update — partial update, only set the fields you want to change
try await Product.update(client: client, id: 36, payload: myUpdatePayload)

// Delete — returns true if something was deleted, false if the id didn't exist
let deleted = try await Product.delete(client: client, id: 36)
```

Some resources are read-only lookups (e.g. `Tax`, `Currency`, `Delivery`) — `create`/`update` on
those exist for API consistency but their payload type is empty and calling them isn't useful.
The resource catalog below marks which resources support write operations.

### Filtering

```swift
let list = try await Product.list(client: client, filters: [
    .name("sneaker"),
    .stock(greaterThan: 0)
])
```

Available filters are defined as static functions on `Filter<Key>` per resource, in
`Sources/ShoperWebAPI/FilterKeys/`. Autocomplete on `.` inside the `filters:` array shows you
what's available for that resource.

### Sorting

```swift
let list = try await Product.list(client: client, sort: [
    .stock(direction: .descending),
    .name(direction: .ascending)
])
```

### Pagination

```swift
let page2 = try await Product.list(client: client, filters: [...], page: 2, limit: 50)
print("\(page2.page) / \(page2.pages), \(page2.count) total")
```

Or skip manual pagination entirely with `listAll(client:filters:sort:limit:maxPages:)`, which
walks every page and returns a flat array.

## Error handling

```swift
do {
    let products = try await Product.list(client: client)
} catch let error as ShoperError {
    switch error {
    case .invalidCredentials:
        // login/password or token rejected
    case .invalidResponse(let data, let response):
        // non-2xx HTTP response; `data` is the raw error body, `response` the URLResponse
        let status = (response as? HTTPURLResponse)?.statusCode
    case .invalidURL:
        // malformed shop URL / endpoint construction failure
    }
} catch {
    // network-level error (no connection, timeout, ...)
}
```

Some Shoper endpoints require elevated app permissions and return HTTP 403
(`insufficient_scope`) for a standard token — `OrderRefund` and `OrderTransaction` are the two
resources in this SDK affected by that. Expect to handle that status if you use them.

## Recipes

### Fetch a product and read its translation

```swift
let product = try await Product.get(client: client, id: 36)
let name = product.translations["pl_PL"]?.name ?? "—"
print("\(name): \(product.stock.stock) in stock, \(product.stock.price) PLN")
```

### Update stock quantity

```swift
let payload = UpdateProduct(stock: CreateProductStock(stock: 100))
try await Product.update(client: client, id: 36, payload: payload)
```

(`UpdateProduct` reuses `CreateProductStock` for its nested `stock` field — same shape, see
"Types you'll touch a lot" below.)

### Update product name/description

```swift
let payload = UpdateProduct(translations: [
    "pl_PL": CreateProductTranslation(name: "New name", shortDescription: "New short desc")
])
try await Product.update(client: client, id: 36, payload: payload)
```

### Create a new product

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

`categoryId`, `code`, `pkwiu`, `stock`, `translations` are the only required fields — everything
else on `CreateProduct` is optional (tax, unit, producer, dimensions, attributes, categories,
collections, safety information, ...).

### Clone an existing product (change color/variant, etc.)

```swift
let source = try await Product.get(client: client, id: sourceId)
var payload = CreateProduct(copying: source)   // copies every writable field, skips read-only ones
payload.code = "SKU-002-RED"
payload.translations["pl_PL"]?.name = "My Product — Red"
payload.stock.stock = 5
let clonedId = try await Product.create(client: client, payload: payload)
```

`CreateProduct(copying:)` flattens `Product.attributes` (nested `groupId -> attributeId -> value`
on read) into the flat `attributeId -> value` map the create endpoint expects — you don't need to
do that conversion yourself.

### Upload a product image

```swift
// From a URL the Shoper backend will fetch
let payload = CreateProductImage.image(url: "https://example.com/photo.jpg", productId: 36, name: "Front")
let imageId = try await ProductImage.create(client: client, payload: payload)

// From raw Data (base64-encoded automatically)
let data = try Data(contentsOf: localFileURL)
let payload2 = CreateProductImage.image(content: data, productId: 36, name: "Front")
let imageId2 = try await ProductImage.create(client: client, payload: payload2)
```

### List unpaid orders and their line items

```swift
let unpaid = try await ShopOrder.list(client: client, filters: [.paid(false)]).list
for order in unpaid {
    guard let orderId = order.orderId else { continue }
    let items = try await OrderProduct.list(client: client, filters: [.orderId(orderId)]).list
    print("Order \(orderId): \(items.count) item(s), total \(order.sum ?? 0)")
}
```

(The order resource is called `ShopOrder`, not `Order` — `Order<Key>` is the SDK's internal
sort-direction wrapper used for the `sort:` parameter, so the domain type got a different name to
avoid the clash.)

### Look up a product's stock as a standalone resource

`Product.stock` gives you the product's default stock. If you need the standalone
`/product-stocks` resource directly (e.g. to see all stock rows including variants):

```swift
let stocks = try await ProductStock.list(client: client)
```

### Work with typed enums instead of raw ints

A handful of coded fields are modeled as enums with an `.unknown(Int)` fallback, so unexpected
API values don't crash your app:

```swift
switch redirect.type {
case .own: ...
case .product: ...
case .unknown(let code): print("unhandled redirect type \(code)")
default: break
}
```

And bitmask fields as `OptionSet`:

```swift
let payload = CreateAdditionalField(
    type: .select,
    locate: [.orderForm, .contactForm],   // OptionSet literal — combine as many as you need
    translations: ["pl_PL": .init(name: "How did you hear about us?", description: "...", options: ["Google", "Friend"])]
)
```

## Types you'll touch a lot

| Type | What it is |
|---|---|
| `Identifier` | `.id(Int)` or `.none` — every resource's `id` property. Most of the time you just want the underlying `Int`; pattern-match or use `if case .id(let value) = resource.id`. |
| `CreateProductStock` | Shared between `CreateProduct.stock` and `UpdateProduct.stock` — the nested stock object accepted when creating/updating a product. **Not** the same shape as the standalone `ProductStockPayload` (see below) — some fields (`active`, `code`, `default`, `ean`, `weightType`) are read-only in this nested context but writable on the standalone endpoint. |
| `ProductStockPayload` | Create/update payload for the standalone `ProductStock` resource (`/product-stocks`) — has the fields `CreateProductStock` deliberately excludes. |
| `CreateProductTranslation` | Per-locale product fields (name, descriptions, SEO) for create/update. |
| `ResourceList<T>` | What `list(...)` returns: `.count`, `.pages`, `.page`, `.list: [T]`. |

## Resource catalog

Every type below conforms to the core pattern (`list`/`get`/`create`/`update`/`delete`/`listAll`)
unless noted. "Write" = has a real `CreatePayload`/`UpdatePayload`, not `EmptyPayload`.

### Products & catalog

| Type | Endpoint | Write? |
|---|---|---|
| `Product` | `/products` | ✅ |
| `ProductImage` | `/product-images` | ✅ |
| `ProductFile` | `/product-files` | ✅ |
| `ProductStock` | `/product-stocks` | ✅ |
| `ProductTag` | `/product-tags` | read-only |
| `ProductSpecialOffer` | `/specialoffers` | read-only |
| `ShoperCategory` | `/categories` | read-only |
| `CategoryTreeNode` | `/categories-tree` | read-only, own API shape — see below |
| `ShoperAttribute` | `/attributes` | read-only |
| `AttributeGroup` | `/attribute-groups` | read-only |
| `ShoperOption` | `/options` | read-only |
| `OptionGroup` | `/option-groups` | read-only |
| `OptionValue` | `/option-values` | read-only |
| `Collection` | `/collections` | read-only; product membership/position managed via `CollectionProduct`, see "Nested resources" below |
| `Producer` | `/producers` | read-only |

`CategoryTreeNode` doesn't follow the standard `Resource` pattern because
`/categories-tree` returns a flat array, not the usual paginated wrapper:

```swift
let tree = try await CategoryTreeNode.listAll(client: client)
let parentMap = CategoryTreeNode.buildParentMap(nodes: tree)   // childId -> parentId
// or in one call:
let parentMap2 = try await ShoperCategory.fetchParentMap(client: client)
```

### Orders

| Type | Endpoint | Write? |
|---|---|---|
| `ShopOrder` | `/orders` | ✅ |
| `OrderProduct` | `/order-products` | ✅ |
| `OrderTag` | `/order-tags` | ✅ |
| `Parcel` | `/parcels` | read-only |
| `OrderRefund` | `/order-refunds` | read-only; **requires elevated app scope**, HTTP 403 on a standard token |
| `OrderTransaction` | `/order-transactions` | read-only; **requires elevated app scope**, HTTP 403 on a standard token |

### Customers

| Type | Endpoint | Write? |
|---|---|---|
| `User` | `/users` | ✅ |
| `UserAddress` | `/user-addresses` | ✅ |
| `UserGroup` | `/user-groups` | ✅ |
| `UserTag` | `/user-tags` | ✅ |
| `Subscriber` | `/subscribers` | ✅ |
| `SubscriberGroup` | `/subscriber-groups` | ✅ |

### Marketing

| Type | Endpoint | Write? |
|---|---|---|
| `PromotionCode` | `/promotion-codes` | ✅ |
| `LoyaltyEvent` | `/loyalty-events` | create only — no update/delete endpoint exists in the API. Creating fails with HTTP 400 if the shop's loyalty program isn't enabled (`ApplicationConfig.loyaltyEnable`). |

### CMS

| Type | Endpoint | Write? |
|---|---|---|
| `Aboutpage` | `/aboutpages` | ✅ |
| `News` | `/news` | ✅ |
| `NewsCategory` | `/news-categories` | ✅ |
| `NewsComment` | `/news-comments` | ✅ |
| `NewsFile` | `/news-files` | ✅ |
| `NewsTag` | `/news-tags` | ✅ |

### Shipping, payment & geography

| Type | Endpoint | Write? |
|---|---|---|
| `Shipping` | `/shippings` | read-only |
| `Payment` | `/payments` | read-only; channels managed via `PaymentChannel`, see "Nested resources" below |
| `Zone` | `/zones` | read-only |
| `Delivery` | `/deliveries` | read-only |
| `Availability` | `/availabilities` | read-only |
| `GeolocationCountry` | `/geolocation-countries` | read-only |
| `GeolocationRegion` | `/geolocation-regions` | read-only |
| `GeolocationSubregion` | `/geolocation-subregions` | read-only |

### Shop configuration / dictionaries

| Type | Endpoint | Write? |
|---|---|---|
| `Tax` | `/taxes` | read-only |
| `Currency` | `/currencies` | read-only |
| `Unit` | `/units` | read-only |
| `Gauge` | `/gauges` | read-only |
| `Status` | `/statuses` | read-only |
| `Language` | `/languages` | update only — **creating a language is disabled in this SDK**; the live API returned HTTP 500 for every payload tried |
| `Redirect` | `/redirects` | ✅ |
| `AdditionalField` | `/additional-fields` | ✅ |
| `AdditionalFieldOption` | `/additional-field-options` | model exists, but this module isn't installed on every shop — expect HTTP 400 "Missing MODULE" if it's disabled on yours |
| `ProductSafetyProducer` | `/product-safety-producers` | read-only |
| `ProductSafetyImporter` | `/product-safety-importers` | read-only |
| `ProductSafetyResponsible` | `/product-safety-responsibles` | read-only |
| `ProductSafetyCertificate` | `/product-safety-certificates` | read-only |
| `Progress` | `/progresses` | read-only — status of long-running shop operations (bulk imports etc.) |
| `MetafieldValue` | `/metafield-values` | ✅ — generic key/value storage attached to any shop object via a `metafieldId` |
| `Webhook` | `/webhooks` | ✅ |

### Metafield binding (write-only action, no list/get)

```swift
let bindId = try await MetafieldBind.create(client: client, payload: MetafieldBind(
    type: "product", itemId: "36", metafieldId: 1, value: "some value"
))
```

Requires the `metafields_bind` feature flag to be enabled on your shop — expect HTTP 403 if it
isn't. `itemId` is a `String` (not `Int`) because that's what the API schema documents for this
specific field.

### Webhooks

```swift
let webhookId = try await Webhook.create(client: client, payload: CreateWebhook(
    url: "https://example.com/webhook-listener",
    format: .json,
    active: true,
    events: [.orderCreate, .orderPaid]
))
try await Webhook.delete(client: client, id: webhookId)
```

`events` takes `WebhookEvent`, a typed enum covering the 24 documented events:

| Group | Events |
|---|---|
| Categories | `.categoryCreate`, `.categoryEdit`, `.categoryDelete` |
| Orders | `.orderCreate`, `.orderEdit`, `.orderPaid`, `.orderStatus`, `.orderDelete` |
| Clients | `.clientCreate`, `.clientEdit`, `.clientDelete` |
| Products | `.productCreate`, `.productEdit`, `.productDelete` |
| Parcels | `.parcelCreate`, `.parcelDispatch`, `.parcelDelete`, `.parcelSend` |
| Special Offers | `.specialOfferCreate`, `.specialOfferEdit`, `.specialOfferDelete` |
| Subscribers | `.subscriberCreate`, `.subscriberEdit`, `.subscriberDelete` |

The API validates `events` server-side — an unrecognized value is rejected with HTTP 400. Real
stores may also have webhooks (usually created by installed AppStore apps) using event names
outside this list, e.g. `"admin.account_connected"`, `"order_transaction.create"`,
`"order_refund.create"` — these decode fine as `.unknown(String)` when reading, but aren't
documented as generally creatable.

### Verifying incoming webhook deliveries

This is about the *receiving* side (your webhook endpoint), not something this SDK does for you,
but worth knowing if you're building the app that registers webhooks above:

- Every delivery includes headers: `X-Shop-Domain`, `X-Shop-Version`, `X-Shop-License` (a license
  checksum, not the raw ID), `X-Webhook-Id`, `X-Webhook-Name` (e.g. `"order.create"`), and
  `X-Webhook-SHA1` (an HMAC signature of the request body).
- To verify: derive a shop-aware secret via
  `HMAC-SHA512(shopHash + ":" + webhookSecret, appstoreSecret)` where `shopHash` is the
  `X-Shop-License` header value and `webhookSecret` is the secret configured in your AppStore
  application settings — then use it to validate `X-Webhook-SHA1` with a constant-time comparison.
- Delivery is fire-and-forget: one attempt, 3-second timeout, no retry on failure. Your endpoint
  must respond 2xx within that window.

### Shop metadata (singletons — no list/id, different call shape)

```swift
let version = try await ApplicationVersion.get(client: client)   // "5.26.35"
let config = try await ApplicationConfig.get(client: client)     // shop name, defaults, feature flags (partial — not every field is modeled)
let lock = try await ApplicationLock.get(client: client)         // is the admin panel currently locked?
```

`ApplicationLock` intentionally only supports reading lock status — engaging the lock via this
SDK is not implemented, since a bug there could lock your own shop admins out of the panel.

### Loyalty events

```swift
let eventId = try await LoyaltyEvent.create(client: client, payload: CreateLoyaltyEvent(
    userId: 5, score: 100, note: "Welcome bonus"
))
let events = try await LoyaltyEvent.list(client: client, filters: [], sort: [], page: nil, limit: 50)
```

Only `create`/`get`/`list` exist — there's no update or delete endpoint for loyalty events.
Creating one fails with HTTP 400 ("Program lojalnościowy jest wyłączony") if the shop's loyalty
program isn't enabled; check `ApplicationConfig.loyaltyEnable` first if you're not sure.

### Admin dashboard

```swift
let stats = try await DashboardStat.get(client: client)
print(stats.general?.orders, stats.today?.income, stats.last7Days?.orders, stats.last30Days?.income)

let activities = try await DashboardActivity.list(client: client, limit: 20)
for activity in activities {
    print(activity.info ?? "", activity.object ?? "")   // object: "order", "client", or "user" (undocumented but real)
}
```

`DashboardActivity.list` isn't `listAll` — the endpoint returns a flat array with no
`count`/`pages` metadata, so there's no reliable way to auto-walk every page. Pass `page:`
yourself for more than the first batch.

### Nested resources (`CollectionProduct`, `PaymentChannel`)

A couple of endpoints are nested under a parent id (`/collections/{collection_id}/products`,
`/payments/{payment_id}/channels`) and don't fit the standard `Resource` pattern, so their static
functions take an extra `collectionId:`/`paymentId:` parameter instead of just `id:`:

```swift
let products = try await CollectionProduct.list(client: client, collectionId: 3)
try await CollectionProduct.update(client: client, collectionId: 3, productId: 36,
    payload: UpdateCollectionProduct(position: 1))
```

`CollectionProduct` only supports `list`/`update` — there's no create/delete endpoint for
collection membership. `position` only matters when the collection's sort type is manual.

```swift
let channels = try await PaymentChannel.list(client: client, paymentId: 1)
let channelId = try await PaymentChannel.create(client: client, paymentId: 1,
    payload: CreatePaymentChannel(channelKey: "my-channel"))
try await PaymentChannel.delete(client: client, paymentId: 1, id: channelId)
```

`PaymentChannel` supports the full `list`/`get`/`create`/`update`/`delete` set, but — per the
OpenAPI spec — is "available for selected applications"; expect HTTP 403 on a standard token
unless Shoper has granted your app this scope.

### CMS: blog posts and static pages

```swift
let pageId = try await Aboutpage.create(client: client, payload: CreateAboutpage(name: "Terms", langId: 1, content: "..."))

let newsId = try await News.create(client: client, payload: CreateNews(
    name: "New arrivals", content: "...", date: "2026-07-04 00:00:00", langId: 1
))
let items = try await News.list(client: client)
print(items.list.first?.tags)   // [Int] tag ids — live API returns ids, not full NewsTag objects

let commentId = try await NewsComment.create(client: client, payload: CreateNewsComment(
    newsId: newsId, content: "Great post!", langId: 1, userName: "Jane"
))

let fileId = try await NewsFile.create(client: client, payload: CreateNewsFile.file(
    content: pdfData, name: "brochure.pdf", newsId: newsId
))
```

`langId`/`userName` (for `CreateNewsComment`) and `newsId` (for `CreateNewsFile`) are modeled as
non-optional even though the OpenAPI spec doesn't list them as required — the live API rejects
requests missing them (see `AGENTS.md`'s mismatches table for the exact error messages).

## What's not in this SDK

Auctions (`auction-*`), metafield *definitions* (`/metafields/{object}` — but
`MetafieldValue`/`MetafieldBind` above **are** implemented), and multi-warehouse support
(`warehouses`, `Stock.warehouses`) are not implemented. If you need one of these, it's usually
straightforward to add — see `AGENTS.md` for the pattern, or open an issue.

## More examples

`README.md` has a slightly more narrative walkthrough of products/images/orders. This file is
meant as the more complete reference once you're past the "hello world" stage.
