# Samouczek: jak korzystać z ShoperWebAPI

Ten dokument to praktyczny, krok po kroku samouczek dla programisty, który chce zacząć używać
pakietu `ShoperWebAPI` — typowanego klienta Swift do REST API sklepu Shoper. Jeśli szukasz pełnego
katalogu zasobów albo szczegółów architektury, zajrzyj do [`USAGE.md`](USAGE.md) (pełne
referencje) i [`AGENTS.md`](AGENTS.md) (dla osób rozwijających sam pakiet). Ten plik ma nauczyć Cię
podstaw na przykładach — czytaj go od góry do dołu.

## Spis treści

1. [Instalacja](#1-instalacja)
2. [Połączenie ze sklepem](#2-połączenie-ze-sklepem)
3. [Pierwsze zapytanie](#3-pierwsze-zapytanie)
4. [Wzorzec zasobów — jak działa każdy typ w SDK](#4-wzorzec-zasobów)
5. [Filtrowanie i sortowanie](#5-filtrowanie-i-sortowanie)
6. [Paginacja i pobieranie wszystkiego](#6-paginacja-i-pobieranie-wszystkiego)
7. [Tworzenie i aktualizacja danych](#7-tworzenie-i-aktualizacja-danych)
8. [Obsługa błędów](#8-obsługa-błędów)
9. [Typy specjalne: pola kodowane, bitmaski, dane niespójne](#9-typy-specjalne)
10. [Zasoby, które nie pasują do standardowego wzorca](#10-zasoby-które-nie-pasują-do-standardowego-wzorca)
11. [Mini-projekt: raport nieopłaconych zamówień](#11-mini-projekt-raport-nieopłaconych-zamówień)
12. [Co dalej](#12-co-dalej)

---

## 1. Instalacja

Dodaj pakiet do `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/MaciejGad/ShoperWebAPI.git", from: "1.0.0")
]
```

albo w Xcode: **File → Add Package Dependencies** i wklej adres repozytorium.

Wymagania: Swift 6.0+, iOS 15 / macOS 12+ (patrz `README.md` dla pełnej listy platform).

## 2. Połączenie ze sklepem

Wszystko zaczyna się od `Config` i `Client`. Są dwie opcje logowania:

**Opcja A — login i hasło** (SDK samo pobierze i odświeży token):

```swift
import ShoperWebAPI

let config = Config(
    shopURL: URL(string: "https://twoj-sklep.myshoper.pl")!,
    login: "login-webapi",
    password: "haslo-webapi"
)
let client = Client(config: config)
```

**Opcja B — masz już token OAuth** (np. Twoja aplikacja robi własny flow AppStore):

```swift
let config = Config(
    shopURL: URL(string: "https://twoj-sklep.myshoper.pl")!,
    accessToken: "istniejacy-token"
)
let client = Client(config: config)
```

Przydatne opcjonalne parametry `Config`:

```swift
Config(
    shopURL: ...,
    login: ..., password: ...,
    defaultLanguage: "pl_PL",   // domyślnie "pl_PL"
    verbose: true               // loguje każdy request/response — włącz sobie na czas nauki
)
```

> `client` przechowuje token i przedłuża go automatycznie — nie musisz się martwić o
> re-autoryzację między zapytaniami.

## 3. Pierwsze zapytanie

Sprawdźmy, czy wszystko działa, pobierając listę produktów:

```swift
let page = try await Product.list(client: client)
print("Łącznie produktów: \(page.count)")

for product in page.list {
    let name = product.translations["pl_PL"]?.name ?? "(brak nazwy)"
    print("\(product.productId ?? 0): \(name) — \(product.stock.stock) szt.")
}
```

`Product.list(client:)` zwraca jedną stronę wyników (`ResourceList<Product>`) z polami `.count`
(łączna liczba), `.pages` (liczba stron), `.page` (aktualna strona) i `.list` (tablica obiektów).

## 4. Wzorzec zasobów

To najważniejsza rzecz do zapamiętania: **każdy zasób w tym SDK (Product, ShopOrder, User,
PromotionCode, News, Auction...) działa dokładnie tym samym zestawem metod.** Nauczysz się
jednego, umiesz wszystkie:

```swift
let page   = try await Product.list(client: client)               // jedna strona
let all    = try await Product.listAll(client: client)             // wszystkie strony na raz, jako [Product]
let one    = try await Product.get(client: client, id: 36)          // pojedynczy rekord po id
let newId  = try await Product.create(client: client, payload: myCreatePayload)   // zwraca Int — nowe id
try await Product.update(client: client, id: 36, payload: myUpdatePayload)        // częściowa aktualizacja
let ok     = try await Product.delete(client: client, id: 36)       // Bool: czy coś faktycznie usunięto
```

Zamień `Product` na dowolny inny typ (`ShopOrder`, `User`, `PromotionCode`, `Redirect`, `News`...)
i kod wygląda identycznie. Typy payloadów do tworzenia/aktualizacji nazywają się `CreateX`/`UpdateX`
(np. `CreateProduct`, `UpdateProduct`).

> Część zasobów jest **tylko do odczytu** (np. `Tax`, `Currency`, `Delivery`) — `create`/`update`
> wciąż istnieją (bo tego wymaga wspólny interfejs), ale ich payload jest pusty i wywołanie nic nie
> zrobi. Pełna lista kto jest zapisywalny jest w [`USAGE.md`](USAGE.md).

## 5. Filtrowanie i sortowanie

Filtry i sortowanie to statyczne funkcje charakterystyczne dla danego zasobu — po prostu zacznij
pisać `.` wewnątrz tablicy `filters:`/`sort:`, a autouzupełnianie w Xcode podpowie Ci, co jest
dostępne dla danego typu.

```swift
// Filtrowanie
let sneakers = try await Product.list(client: client, filters: [
    .name("sneaker"),
    .stock(greaterThan: 0)
])

// Sortowanie
let sorted = try await Product.list(client: client, sort: [
    .stock(direction: .descending),
    .name(direction: .ascending)
])

// Można łączyć oba naraz
let both = try await Product.list(client: client, filters: [.stock(greaterThan: 0)], sort: [.name(direction: .ascending)])
```

Przykład na zamówieniach — wszystkie nieopłacone, posortowane od najnowszych:

```swift
let unpaid = try await ShopOrder.list(client: client,
    filters: [.paid(false)],
    sort: [.date(direction: .descending)]
)
```

> Zamówienia w tym SDK nazywają się `ShopOrder`, nie `Order` — nazwa `Order<Key>` jest zajęta przez
> wewnętrzny typ SDK odpowiedzialny za kierunek sortowania.

## 6. Paginacja i pobieranie wszystkiego

Ręczna paginacja:

```swift
let page2 = try await Product.list(client: client, page: 2, limit: 50)
print("Strona \(page2.page) z \(page2.pages), łącznie \(page2.count) produktów")
```

Jeśli chcesz mieć wszystko naraz i nie chce Ci się samodzielnie chodzić po stronach:

```swift
let allProducts = try await Product.listAll(client: client)   // przejdzie przez wszystkie strony za Ciebie
```

`listAll` działa też z filtrami/sortowaniem: `listAll(client:filters:sort:limit:maxPages:)`.

## 7. Tworzenie i aktualizacja danych

Przy tworzeniu zawsze podajesz osobny typ `CreateX` — ma inny (zwykle mniejszy) zestaw
wymaganych pól niż odczytany obiekt.

```swift
let payload = CreateProduct(
    categoryId: 19,
    code: "SKU-001",
    pkwiu: "",
    stock: CreateProductStock(price: 99.90, stock: 10),
    translations: ["pl_PL": CreateProductTranslation(name: "Nowy produkt")]
)
let newProductId = try await Product.create(client: client, payload: payload)
```

Aktualizacja jest **częściowa** — ustawiasz tylko te pola, które chcesz zmienić:

```swift
try await Product.update(client: client, id: newProductId, payload: UpdateProduct(
    stock: CreateProductStock(stock: 5)
))
```

Usuwanie zwraca `Bool` — informację, czy rekord faktycznie istniał i został skasowany:

```swift
let deleted = try await Product.delete(client: client, id: newProductId)
print(deleted ? "Usunięto" : "Nic nie było do usunięcia")
```

**Klonowanie istniejącego produktu** to częsty przypadek — SDK ma na to gotowy konstruktor:

```swift
let source = try await Product.get(client: client, id: sourceId)
var clonePayload = CreateProduct(copying: source)   // kopiuje zapisywalne pola, pomija tylko-do-odczytu
clonePayload.code = "SKU-002"
let clonedId = try await Product.create(client: client, payload: clonePayload)
```

## 8. Obsługa błędów

```swift
do {
    let products = try await Product.list(client: client)
} catch let error as ShoperError {
    switch error {
    case .invalidCredentials:
        print("Złe dane logowania")
    case .invalidResponse(let data, let response):
        let status = (response as? HTTPURLResponse)?.statusCode
        print("Serwer zwrócił błąd \(status ?? -1): \(String(data: data, encoding: .utf8) ?? "")")
    case .invalidURL:
        print("Błędny URL sklepu")
    }
} catch {
    print("Błąd sieciowy: \(error)")
}
```

Kilka zasobów wymaga specjalnych uprawnień aplikacji nadawanych przez Shoper i standardowo
zwracają HTTP 403 (`OrderRefund`, `OrderTransaction`, `PaymentChannel`) — to nie błąd Twojego kodu,
po prostu Twoja aplikacja nie ma przyznanego dostępu do tych zasobów.

## 9. Typy specjalne

API Shoper bywa niekonsekwentne co do typów danych na drucie (np. `"1"`/`"0"` zamiast `true`/
`false`). SDK to za Ciebie ukrywa — Ty widzisz zawsze porządne typy Swift:

**Pola kodowane** (enum zamiast surowego inta), z zabezpieczeniem na nieznane wartości:

```swift
switch redirect.type {
case .own: ...
case .product: ...
case .unknown(let code): print("nieznany kod przekierowania: \(code)")
default: break
}
```

**Bitmaski** jako `OptionSet`:

```swift
let payload = CreateAdditionalField(
    type: .select,
    locate: [.orderForm, .contactForm],   // można łączyć dowolną liczbę flag
    translations: ["pl_PL": .init(name: "Skąd się dowiedziałeś?", options: ["Google", "Znajomy"])]
)
```

## 10. Zasoby, które nie pasują do standardowego wzorca

Większość zasobów działa dokładnie tak jak `Product` z sekcji 4, ale jest kilka wyjątków wartych
znajomości:

**Zasoby-singleton** (bez listy, bez id) — dane o samym sklepie:

```swift
let version = try await ApplicationVersion.get(client: client)
let shopConfig = try await ApplicationConfig.get(client: client)
let stats = try await DashboardStat.get(client: client)
```

**Zasoby zagnieżdżone pod innym zasobem** — wymagają dodatkowego parametru zamiast zwykłego `id`:

```swift
let produktyKolekcji = try await CollectionProduct.list(client: client, collectionId: 3)
let kanalyPlatnosci = try await PaymentChannel.list(client: client, paymentId: 1)
```

**Drzewo kategorii** — zwraca płaską tablicę zamiast standardowej paginacji:

```swift
let parentMap = try await ShoperCategory.fetchParentMap(client: client)   // childId -> parentId
```

Pełną listę wyjątków (z wyjaśnieniem *dlaczego* dany zasób jest inny) znajdziesz w `USAGE.md`.

## 11. Mini-projekt: raport nieopłaconych zamówień

Złóżmy razem kilka rzeczy z tego samouczka w jeden mały, praktyczny skrypt:

```swift
import ShoperWebAPI

let config = Config(shopURL: URL(string: "https://twoj-sklep.myshoper.pl")!,
                     login: "login", password: "haslo")
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
    print("Zamówienie #\(orderId): \(items.count) pozycji, suma \(sum) zł, e-mail: \(order.email ?? "-")")
}
print("Łączna wartość nieopłaconych zamówień: \(total) zł")
```

## 12. Co dalej

- **[`USAGE.md`](USAGE.md)** — pełny katalog wszystkich ~65 zasobów (endpoint, czy zapisywalny),
  gotowe przepisy na konkretne zadania (upload zdjęcia, tworzenie webhooka, praca z CMS/blogiem,
  aukcjami) i tabela typów, z którymi będziesz się stykać najczęściej.
- **[`README.md`](README.md)** — krótkie wprowadzenie projektu, wymagania, jak uruchomić testy.
- **[`AGENTS.md`](AGENTS.md)** — jeśli chcesz rozwijać sam pakiet (dodawać nowe zasoby) albo
  zrozumieć niespójności między oficjalną dokumentacją API a tym, jak Shoper naprawdę odpowiada.
- Oficjalna dokumentacja Shoper API: <https://developers.shoper.pl/developers/api/getting-started>
