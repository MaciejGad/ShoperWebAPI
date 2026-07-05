import Testing
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import ShoperWebAPI

// CMS resources (blog + static pages) against a live Shoper store (see
// SHOPER_DOMAIN/USERNAME/PASSWORD env vars). Responses are saved as new mocks via MOCK_PATH for
// future offline test runs.

@Test func testFetchAboutpages() async throws {
    let client = try makeClient()
    let pages = try await Aboutpage.list(client: client)
    print("Aboutpages count: \(pages.count)")
    for page in pages.list.prefix(5) {
        print(" * #\(page.pageId) \(page.name ?? "") active:\(String(describing: page.active))")
    }
}

@Test func testCreateAboutpageRoundTrip() async throws {
    let client = try makeClient()
    let uniqueName = "shoperwebapi-test-\(Int(Date().timeIntervalSince1970))"
    let payload = CreateAboutpage(name: uniqueName, langId: 1, content: "Test content")
    let pageId = try await Aboutpage.create(client: client, payload: payload)
    print("Created aboutpage id: \(pageId)")

    let fetched = try await Aboutpage.get(client: client, id: pageId)
    #expect(fetched.name?.hasPrefix("shoperwebapi-test-") == true)

    let deleted = try await Aboutpage.delete(client: client, id: pageId)
    print("Deleted: \(deleted)")
}

@Test func testFetchNewsTags() async throws {
    let client = try makeClient()
    let tags = try await NewsTag.list(client: client)
    print("NewsTags count: \(tags.count)")
    for tag in tags.list.prefix(5) {
        print(" * #\(tag.tagId) \(tag.name ?? "")")
    }
}

@Test func testCreateNewsTagRoundTrip() async throws {
    let client = try makeClient()
    let uniqueName = "shoperwebapi-test-\(Int(Date().timeIntervalSince1970))"
    let tagId = try await NewsTag.create(client: client, payload: CreateNewsTag(name: uniqueName, langId: 1))
    print("Created news tag id: \(tagId)")

    let fetched = try await NewsTag.get(client: client, id: tagId)
    #expect(fetched.name?.hasPrefix("shoperwebapi-test-") == true)

    let deleted = try await NewsTag.delete(client: client, id: tagId)
    print("Deleted: \(deleted)")
}

@Test func testFetchNewsCategories() async throws {
    let client = try makeClient()
    let categories = try await NewsCategory.list(client: client)
    print("NewsCategories count: \(categories.count)")
    for category in categories.list.prefix(5) {
        print(" * #\(category.categoryId) \(category.name ?? "")")
    }
}

@Test func testCreateNewsCategoryRoundTrip() async throws {
    let client = try makeClient()
    let uniqueName = "shoperwebapi-test-\(Int(Date().timeIntervalSince1970))"
    let categoryId = try await NewsCategory.create(client: client, payload: CreateNewsCategory(name: uniqueName, langId: 1))
    print("Created news category id: \(categoryId)")

    let fetched = try await NewsCategory.get(client: client, id: categoryId)
    #expect(fetched.name?.hasPrefix("shoperwebapi-test-") == true)

    let deleted = try await NewsCategory.delete(client: client, id: categoryId)
    print("Deleted: \(deleted)")
}

@Test func testFetchNews() async throws {
    let client = try makeClient()
    let list = try await News.list(client: client)
    print("News count: \(list.count)")
    for item in list.list.prefix(5) {
        print(" * #\(item.newsId) \(item.name ?? "") tags:\(item.tags.count)")
    }
}

@Test func testCreateNewsRoundTrip() async throws {
    let client = try makeClient()
    let uniqueName = "shoperwebapi-test-\(Int(Date().timeIntervalSince1970))"
    let payload = CreateNews(name: uniqueName, content: "Test content", date: "2026-07-04 00:00:00", langId: 1)
    let newsId = try await News.create(client: client, payload: payload)
    print("Created news id: \(newsId)")

    let fetched = try await News.get(client: client, id: newsId)
    #expect(fetched.name?.hasPrefix("shoperwebapi-test-") == true)

    let deleted = try await News.delete(client: client, id: newsId)
    print("Deleted: \(deleted)")
}

@Test func testFetchNewsComments() async throws {
    let client = try makeClient()
    let comments = try await NewsComment.list(client: client)
    print("NewsComments count: \(comments.count)")
    for comment in comments.list.prefix(5) {
        print(" * #\(comment.commId) newsId:\(String(describing: comment.newsId)) \(comment.content ?? "")")
    }
}

@Test func testCreateNewsCommentRoundTrip() async throws {
    let client = try makeClient()
    let news = try await News.list(client: client)
    guard let newsId = news.list.first?.newsId else {
        print("No news on this store — skipping.")
        return
    }
    let payload = CreateNewsComment(
        newsId: newsId,
        content: "shoperwebapi-test-\(Int(Date().timeIntervalSince1970))",
        langId: 1,
        userName: "ShoperWebAPI test"
    )
    let commentId = try await NewsComment.create(client: client, payload: payload)
    print("Created news comment id: \(commentId)")

    let fetched = try await NewsComment.get(client: client, id: commentId)
    #expect(fetched.content?.hasPrefix("shoperwebapi-test-") == true)

    let deleted = try await NewsComment.delete(client: client, id: commentId)
    print("Deleted: \(deleted)")
}

@Test func testFetchNewsFiles() async throws {
    let client = try makeClient()
    let files = try await NewsFile.list(client: client)
    print("NewsFiles count: \(files.count)")
    for file in files.list.prefix(5) {
        print(" * #\(file.fileId) \(file.name ?? "")")
    }
}

@Test func testCreateNewsFileRoundTrip() async throws {
    let client = try makeClient()
    let news = try await News.list(client: client)
    guard let newsId = news.list.first?.newsId else {
        print("No news on this store — skipping.")
        return
    }
    let uniqueName = "shoperwebapi-test-\(Int(Date().timeIntervalSince1970)).txt"
    let payload = CreateNewsFile.file(content: Data("test file content".utf8), name: uniqueName, newsId: newsId)
    let fileId = try await NewsFile.create(client: client, payload: payload)
    print("Created news file id: \(fileId)")

    let fetched = try await NewsFile.get(client: client, id: fileId)
    #expect(fetched.name?.hasPrefix("shoperwebapi-test-") == true)

    let deleted = try await NewsFile.delete(client: client, id: fileId)
    print("Deleted: \(deleted)")
}
