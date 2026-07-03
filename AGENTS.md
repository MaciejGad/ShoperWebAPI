# AGENTS.md

Instructions for AI agents (and future-you) working in this repository. This file documents
architecture, conventions, and workflow discovered while building out 50+ Shoper API resources.
Read this before adding new resources or modifying existing ones.

## What this is

`ShoperWebAPI` is a Swift Package providing a typed client for the
[Shoper Web API](https://developers.shoper.pl/developers/api/getting-started) (a Polish
e-commerce platform). The canonical API contract lives in an OpenAPI spec (`api-1.yaml`,
supplied by the user, not committed to this repo) — **treat it as a starting point, not ground
truth**. Section "Known spec-vs-reality mismatches" below lists confirmed discrepancies between
the documented schema and what the live API actually does.

For user-facing usage examples, see `README.md`. This file is about *how to extend the SDK*, not
how to consume it.

## Architecture

### The `Resource` protocol

Every listable/gettable API resource conforms to `Resource` (`Sources/ShoperWebAPI/Resource.swift`):

```swift
public protocol Resource: Decodable, Sendable {
    associatedtype Key: FilterKey
    associatedtype Sort: SortKey
    associatedtype CreatePayload: Encodable
    associatedtype UpdatePayload: Encodable

    var id: Identifier { get }
    static var endpoint: Endpoint { get }
}
```

Conforming gives you `list`, `get`, `create`, `update`, `delete`, and `listAll` for free via
protocol extensions. You only need to supply `id`, `endpoint`, and the four associated types.

```swift
extension MyResource: Resource {
    public typealias Key = MyResourceFilterKey   // or EmptyFilterKey
    public typealias Sort = MyResourceSortKey     // or EmptySortKey
    public typealias CreatePayload = CreateMyResource  // or EmptyPayload
    public typealias UpdatePayload = UpdateMyResource  // or EmptyPayload

    public var id: Identifier { .id(myResourceId) }
    public static var endpoint: Endpoint { .myResource }
}
```

### Singleton resources (no list, no id)

A handful of endpoints are singletons — `GET /application-config`, `GET /application-version`,
`GET /application-lock` — with no list wrapper and no `{id}` in the URL. These don't fit
`Resource`. Pattern: a plain `Decodable` struct with a static `get(client:)` that calls
`client.get(endpoint:id: nil, ...)` directly. See `ApplicationVersion.swift`,
`ApplicationConfig.swift`, `ApplicationLock.swift`.

### Read-only / dictionary resources

Many resources (taxes, currencies, deliveries, availabilities, product-safety-*, etc.) are
lookup dictionaries the API doesn't let you meaningfully create/update, or where create/update
wasn't needed for the use case this SDK was built for (see "Scope" below). For these:

- `CreatePayload = EmptyPayload`, `UpdatePayload = EmptyPayload` (`Sources/ShoperWebAPI/Helpers/EmptyPayload.swift`)
- `Key = EmptyFilterKey`, `Sort = EmptySortKey` (`Sources/ShoperWebAPI/Helpers/EmptyFilterKey.swift`, `EmptySortKey.swift`) — shared, generic, string-rawValue types. Don't create a bespoke `XFilterKey`/`XSortKey` unless the resource actually needs typed filters (see `ProductFilterKey`/`ProductSortKey` for a real example with dozens of cases).

If a resource later needs real filtering, swap `EmptyFilterKey`/`EmptySortKey` for a dedicated type — don't retrofit filtering into `EmptyFilterKey` itself, it's meant to stay generic.

### Write-only action endpoints

A few endpoints are pure actions with no list/get — `POST /metafield-bind` is the example so far.
Pattern: a plain `Encodable` struct (the request body) with a static `create(client:payload:)` that
calls `client.post(endpoint:payload:)` directly and decodes the raw `Int` id, mirroring
`Resource.create`'s behavior without the rest of the protocol. See `MetafieldBind.swift`.

### Resources that don't fit the pattern: dynamic path segments

`Endpoint` is a `String`-backed enum; `Endpoint.url(...)` builds `<rawValue>/<id>` where `id` is
an optional `Int`. Some Shoper endpoints put a dynamic **string** segment in the path before any
numeric id — e.g. `GET /metafields/{object}` where `{object}` is `"product"`, `"category"`, etc.
This doesn't fit `Endpoint`/`Resource`/`ClientProtocol` as they exist today, and extending
`ClientProtocol` to support it would change a signature every conformer (`Client`, plus any
hand-written fakes in tests like `FakeDeleteClient`) depends on.

Current decision: **skip modeling these** rather than hack around it. `Metafield` (the
`/metafields/{object}` definitions endpoint) is not implemented; only `MetafieldValue`
(`/metafield-values`, a normal `{id}`-based resource) is. If a real need for the object-scoped
endpoint comes up, the clean fix is adding a new `ClientProtocol` method with a default
implementation in a protocol extension (so existing conformers don't break), not modifying the
existing `get`/`post`/`put`/`delete` signatures.

### Decoding conventions

The global `JSONDecoder` (in `Client.swift`) uses `.convertFromSnakeCase`. This means:

- **`CodingKeys` values must be written in the post-conversion camelCase form**, matching your
  Swift property names 1:1 in the common case (no `= "snake_case"` override needed).
- Only add an explicit raw string override when the wire key doesn't survive
  `convertFromSnakeCase` cleanly — e.g. `Tax.taxClass = "class"` (Swift reserved word),
  `Producer.isDefault = "isdefault"` (no underscore in the wire key, so it stays `"isdefault"`
  post-conversion, not `"isDefault"`).
- The API is **wildly inconsistent about types on the wire**: booleans arrive as `"0"`/`"1"`
  strings, `true`/`false`, or `0`/`1` integers depending on endpoint; numbers arrive as JSON
  numbers or numeric strings. Never write `try container.decode(Bool.self, ...)` or
  `decode(Int.self, ...)` directly — always use the tolerant helpers in
  `Sources/ShoperWebAPI/Helpers/decodeExtention.swift`:
  - `decodeInt` / `decodeIntIfPresent` / `decodeIntArray` / `decodeIntArrayIfPresent`
  - `decodeBool` / `decodeBoolIfPresent`
  - `decodeDecimal` / `decodeDecimalIfPresent`
  - `decodeDateStringIfPresent` (treats `"0000-00-00 00:00:00"` as `nil`)
- If a field can legitimately arrive as `""` (empty string) instead of a proper `false`/`null`
  (confirmed on `ApplicationConfig`'s `shop_off`, `shopping_allow_overselling`), the shared
  helpers will throw. Don't weaken the shared helper for one endpoint's quirk — wrap the call
  locally: `(try? container.decodeBoolIfPresent(forKey: .x)) ?? nil`.
- Nested translation dictionaries (`[String: XTranslation]`) should be decoded tolerantly too:
  `(try? container.decode([String: XTranslation].self, forKey: .translations)) ?? [:]` — some
  endpoints omit `translations` entirely rather than sending `{}`.

### Enums for coded values

When a field has a small set of documented integer codes (e.g. `type: 0 - own, 1 - product, ...`),
model it as an enum with an `.unknown(Int)` case rather than exposing the raw `Int` — this way API
additions don't corrupt/crash decoding. Pattern (see `RedirectType.swift`,
`AdditionalFieldType.swift`):

```swift
public enum XType: Equatable, Sendable {
    case caseA, caseB, /* ... */
    case unknown(Int)

    public init(rawValue: Int) { /* switch, default: .unknown(rawValue) */ }
    public var rawValue: Int { /* inverse switch */ }
}

extension XType: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) { self.init(rawValue: intValue); return }
        let stringValue = try container.decode(String.self)
        guard let intValue = Int(stringValue) else { throw DecodingError.dataCorruptedError(...) }
        self.init(rawValue: intValue)
    }
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
```

### Bitmasks

When a field is a documented bitmask (e.g. `AdditionalField.locate`), model it as an `OptionSet`
with named static members, `Codable` via the same lenient Int-or-String pattern as above (no
`.unknown` case needed — unrecognized bits are naturally preserved in `rawValue`). See
`AdditionalFieldLocate.swift`.

### Create/Update payload conventions

- `CreateX`/`UpdateX` are usually **separate types**, even when their field sets are identical,
  because `Insert` schemas often have required fields that `Update` doesn't. Only collapse them
  into one shared type (see `ProductStockPayload.swift`, `RedirectPayload.swift`) when the OpenAPI
  Insert/Update schemas are structurally identical *and* nothing is required beyond what's already
  optional in practice.
- `CreateProduct`/`UpdateProduct` reuse the same nested types (`CreateProductStock`,
  `CreateProductTranslation`, `ProductSafetyInformationPayload`) because `ProductInsert` and
  `ProductUpdate`'s nested `stock`/`translations`/`safety_information` shapes are identical in the
  spec — don't duplicate nested payload types if you've confirmed the shapes match.
- Nested `stock` inside `ProductInsert`/`ProductUpdate` has a **different writable-field set**
  than the standalone `/product-stocks` endpoint (`ProductStockInsert`): `active`, `code`,
  `default`, `ean`, `extended`, `weight_type` are `readOnly: true` in the nested context only.
  `CreateProductStock` (nested) and `ProductStockPayload` (standalone) are intentionally separate
  types reflecting this.
- `Product.create` / most `create` calls return a raw JSON integer (not a wrapped object) —
  `Resource.create` already handles this (`client.decode(data:) as Int`). Don't second-guess it.

### `Identifier`

`Identifier` is `.id(Int)` or `.none`. Use `.none` when the resource's ID field is nullable in
the API (e.g. `Currency.currencyId: Int?`, `Availability.availabilityId: Int?`):
`public var id: Identifier { currencyId.map { .id($0) } ?? .none }`.

## Adding a new resource: step-by-step

This is the loop used dozens of times while building this SDK. Follow it for consistency.

1. **Read the OpenAPI schema** for the resource (base schema + `XInsert` + `XUpdate` if present).
   Note: required fields, nullable/readOnly fields, and whether Insert/Update shapes actually
   match each other and match nested payload types you might reuse.
2. **Add the endpoint** to `Sources/ShoperWebAPI/Endpoint.swift` (one `case` line, matches the
   URL path exactly, e.g. `case productTags = "webapi/rest/product-tags"`).
3. **Write the read model** in `Sources/ShoperWebAPI/Models/X.swift`: `Decodable, Sendable`,
   custom `init(from:)` using the tolerant decode helpers, explicit `CodingKeys` (only override
   raw values where needed — see Decoding conventions above).
4. **Decide Create/Update payload strategy**: `EmptyPayload` for read-only/out-of-scope,
   dedicated `CreateX`/`UpdateX` types otherwise (in `CreateModels/` and `UpdateModels/`
   respectively).
5. **Decide Filter/Sort key strategy**: `EmptyFilterKey`/`EmptySortKey` unless the resource needs
   real filtering.
6. **Conform to `Resource`** (or write a singleton `get(client:)` if it has no list/id).
7. **Build**: `swift build`.
8. **Write a live-verification test** (see Testing workflow below) hitting the real store to
   confirm decoding actually works — the OpenAPI spec has been wrong often enough that this step
   has caught real bugs almost every time it's been skipped-then-added.
9. **Restore the auth mock** after every live run (see below) — never commit a real access token.
10. **Run the full suite offline** (`swift test`, no env vars) to confirm the new mocks work and
    nothing else broke.

## Testing workflow

### Two test modes, same test file

`Tests/ShoperWebAPITests/Helpers/Config.swift`'s `makeClient()` checks
`ProcessInfo.processInfo.environment["SHOPER_DOMAIN"]`:

- **Set** → builds a `Client` against the **real** shop over `URLSession.shared`, with
  `storeToFile: true` (every response gets saved as a new mock JSON file under
  `Tests/ShoperWebAPITests/Mocks/`, filename derived from method+path+query — see
  `Sources/ShoperWebAPI/Helpers/mockFilename.swift`).
- **Unset** → builds a `Client` against a mocked `URLSession` (`MockURLProtocol`) that replays
  whatever mock file matches the request's method+path+query, always as HTTP 200. This is what
  CI / `swift test` runs by default.

This means: **the same test function can run live or offline** depending on whether you set the
env vars. The recommended loop when adding a resource:

```bash
# 1. Run new/target tests live to fetch real data and generate mocks
MOCK_PATH=/absolute/path/to/Tests/ShoperWebAPITests/Mocks \
SHOPER_USERNAME=<login> SHOPER_PASSWORD=<password> SHOPER_DOMAIN=<shop-domain> \
swift test --filter "testFetchNewThing|testCreateNewThingRoundTrip"

# 2. Restore the auth mock (see below), inspect git status for new mock files

# 3. Run everything offline to make sure nothing broke
swift test
```

**Credentials are supplied by whoever is driving the session — never hardcode them in a test file
or commit them.** If you don't have live credentials, you can still add a resource and its models,
but skip step 1 and be upfront that decoding is unverified against real data — spec-vs-reality
mismatches are common enough that this is a real limitation, not a formality.

### Critical: restore the auth mock after every live run

Every live test run re-authenticates and overwrites
`Tests/ShoperWebAPITests/Mocks/POST_webapi_rest_auth.json` with a **real, currently-valid access
token**. This must never be committed. After any live run:

```bash
git checkout -- Tests/ShoperWebAPITests/Mocks/POST_webapi_rest_auth.json
git status --short Tests/ShoperWebAPITests/Mocks/   # review what's actually new
```

### Mutating (create/update/delete) tests against the live store

Only do this against a store you've been told is a sandbox / test store, and even then:

- **Safe to do freely**: creating throwaway records (promo codes, redirects, additional fields,
  product files) — cheap, easily identified, harmless if left behind.
- **Ask first / avoid**: anything that changes shop-wide visible state (installing a new
  language, locking the admin panel via `ApplicationLock`, deleting real customer/order data).
  `ApplicationLock`'s create/update was deliberately **not implemented** in this SDK because it
  can lock administrators out of the panel — too risky to verify live without explicit sign-off,
  and it doesn't fit the id-based `ClientProtocol.put/delete` shape anyway (see the doc comment
  on `ApplicationLock.swift`).
- **Idempotency for repeatable tests**: mutating round-trip tests (`testCreateXRoundTrip`) that
  use a unique value (timestamp-suffixed name/code) must assert with `hasPrefix(...)` rather than
  exact equality, because `MockURLProtocol` replays a *frozen* response — a second offline run
  will regenerate a different timestamp than what's baked into the mock. Search this codebase for
  `hasPrefix("shoperwebapi-test-` for the established pattern.
- **Sequential state can't be mocked accurately**: `MockURLProtocol` always returns the same
  frozen response for a given URL, so a test asserting "second delete returns false, first
  returns true" will pass live but can't be asserted strictly offline (both calls replay the
  same mock). Pattern used: assert strictly on the first call, only `print(...)` the second
  (see `testDeleteRedirectRoundTrip` in `RedirectTests.swift`), or convert to a pure offline unit
  test against a hand-written fake `ClientProtocol` (see `ResourceDeleteTests.swift`'s
  `FakeDeleteClient` for testing the 404-means-false logic deterministically).
- **`MockURLProtocol` always returns HTTP 200.** It cannot replay non-2xx responses. Tests that
  need to assert behavior on a specific error status (403 insufficient_scope, 404, 501) must
  either: (a) only run meaningfully live and be written to not fail when no mock exists offline
  (catch broadly, `print` and return — see `testFetchOrderRefundsRequiresSpecialPermission`), or
  (b) use a hand-written fake `ClientProtocol` for deterministic offline coverage (see
  `ResourceDeleteTests.swift`).

### Namespace collisions to watch for

- `ShoperWebAPI.SortOrder` collides with a Swift stdlib `SortOrder` (used by `sorted(using:)`).
  In test files that need `ClientProtocol` conformance, qualify explicitly:
  `ShoperWebAPI.SortOrder`.
- `Order` (SDK's sort-direction wrapper, `Order<Key>`) collides with the domain concept of a
  customer order — hence the read model is named `ShopOrder`, not `Order`.
- `Option` (product option) was renamed `ShoperOption` to avoid colliding with Swift's
  `Optional`/`Option` naming conventions.
- `SpecialOffer` (nested summary inside `Stock`/`ProductStock`) and `ProductSpecialOffer`
  (standalone `/specialoffers` resource) are deliberately different types with different shapes —
  don't conflate them.

## Known spec-vs-reality mismatches

Confirmed by live testing against a real store. If you touch these resources, don't "fix" the
code to match the OpenAPI doc — the doc is wrong, the code already matches reality.

| Resource | Spec says | Reality |
|---|---|---|
| `ProductFile` | `add_date` field | Actual wire key is `date_add` |
| `ProductFile` | `file_name` = name given at upload | Server stores upload name in `name`; `file_name` is a server-generated unique hash |
| `Resource.delete` | Body `1`/`0` for deleted/not-found | Deleting an already-deleted resource returns **HTTP 404**, not a `0` body. `Resource.delete` treats both as `false`. |
| `PromotionCodeInsert` | `code_id` listed as required | It's `readOnly`; omit it, the API generates it |
| `AdditionalFieldInsert` | Only `name` required in translations | `description` is also enforced as required (HTTP 400 without it) |
| `AdditionalField.translations[].options` | `items: type: string` | Actually an array of objects `{trans_id, option_id, lang_id, value}` — `AdditionalField.FieldTranslation` decodes both shapes leniently |
| `ApplicationConfig` | Booleans typed `boolean` | Several fields (`shop_off`, `shopping_allow_overselling`) arrive as `""` when unset, not `false`/`null` |
| `object-mtime` | Documented as a working endpoint | Returns HTTP 501 "Not implemented" live — **removed from the SDK entirely**, don't re-add without confirming it works somewhere |
| `order-refunds`, `order-transactions` | Normal-looking endpoints | Marked `x-internal: true`; return HTTP 403 `insufficient_scope` without a special app grant. Implemented anyway (in case some integrations have the scope) but not usable from a standard token. |
| `POST /languages` | Should create a language | Consistently returns HTTP 500 on the store this was tested against, with both minimal and full payloads. **`Language.CreatePayload` is `EmptyPayload`** — creation is deliberately disabled in the SDK, not just untested. |
| `additional-field-options` | Normal-looking endpoint | Returns HTTP 400 "Missing MODULE" — module not installed on the store tested against. Model exists, but list/create are unverified. |
| `OrderTransaction` id field | Undocumented — spec's property list omits an id despite `/order-transactions/{id}` existing | Modeled as `transactionId` on a best-effort basis; unconfirmed live (403-gated) |
| `MetafieldBind.item_id` | Documents `type: string, pattern: ^[0-9]+$` — unlike almost every other numeric id in this API's `*Insert` schemas, which use `type: integer` | Untested live (`metafields_bind` feature flag disabled on the store tested against, HTTP 403). Modeled as `String` to match the schema literally rather than guessing it also accepts a JSON integer. |
| `metafield-bind` | Normal-looking action endpoint | Requires the `metafields_bind` feature flag; returns HTTP 403 without it (confirmed live) |

When you find a new mismatch like this, add a row here — this table is the single most valuable
artifact for anyone continuing this work, since re-discovering these by trial and error is slow
and some (like the 500 on language creation, or the 404-not-0 delete behavior) are not obvious
from a single failed request.

## Scope: what's deliberately not covered

This SDK was built to support a specific consumer (a product-cloning/management CLI called
AndesProducts), not as an exhaustive 1:1 mapping of every Shoper endpoint. Deliberately excluded
or deferred:

- **Multi-warehouse support** (`warehouses`, `warehouse-logs`, `warehouse-relocations`,
  `Stock.warehouses` mapping) — excluded per explicit instruction; the target shops don't use
  multi-warehouse.
- **CMS/content** (`news*`, `aboutpages`), **auctions** (`auction-*`), **loyalty**
  (`loyalty-events`), **admin dashboard** (`dashboard-*`), **webhooks** — not yet implemented;
  out of scope for product management but straightforward to add following the pattern above if
  needed.
- **`Metafield`** (`/metafields/{object}`, the metafield *definitions* endpoint) — not
  implemented; its dynamic string path segment doesn't fit the current `Endpoint`/`Resource`
  pattern. See "Resources that don't fit the pattern: dynamic path segments" above.
  `MetafieldValue` (`/metafield-values`) *is* implemented — it's a normal `{id}`-based resource.
- **Nested sub-resources with their own CRUD** — `collections/{id}/products`,
  `payments/{payment_id}/channels` — deliberately not modeled as simple resources; they need
  bespoke handling beyond the standard `Resource` pattern.
- **`ApplicationLock` engage/release** — see Testing workflow above; a genuine safety decision,
  not a scope-cutting one.
- Several models intentionally **omit deeply nested substructures** to avoid modeling complexity
  with uncertain payoff: `Shipping` (no `payments[]`/`ranges[]`/`countries{}`/`gauges[]`),
  `Parcel` (no `billingAddress`/`deliveryAddress`/`products[]`), `PromotionCode` (no
  `categoriesLimit`/`collectionsLimit`/etc.), `User` (no `additionalFields`). If you need one of
  these, add the field — the omission was about not building unused surface area, not a technical
  blocker.

## Reference: current resource coverage

Run this to see everything currently implemented:

```bash
grep 'case ' Sources/ShoperWebAPI/Endpoint.swift
```

For the full list of *unimplemented* endpoints (as of this writing) grouped by priority/theme,
see the conversation history that produced this SDK, or diff the output above against the
`/webapi/rest/*` paths in the OpenAPI spec.
