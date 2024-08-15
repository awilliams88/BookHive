//
// BooksManagerTests.swift
// Created by Arpit Williams on 13/08/24.
//

@testable import BookHive
import XCTest

final class BooksManagerTests: XCTestCase {

  var sut: BooksManager!
  let mock = BookServiceMock()

  override func setUpWithError() throws {
    clearDB(booksDb)
    clearDB(favoritesDb)
    sut = BooksManager(bookService: mock)
  }

  override func tearDownWithError() throws {}

  func testCreateBook() async throws {
    let book = Book.mockLocal
    try await sut.create(book)
    let books = try await sut.getAllBooks()
    XCTAssert(books.contains(book))
  }

  func testRemoveBook() async throws {
    let book = Book.mockLocal
    try await sut.create(book)
    try await sut.remove(book)
    let books = try await sut.getAllBooks()
    XCTAssert(books.contains(book) == false)
  }

  func testUpdateBook() async throws {
    let localbook = Book.mockLocal
    try await sut.create(localbook)
    var book = try await sut.getBook(with: localbook.id)
    XCTAssert(book.title == localbook.title)
    let updatedBook = Book(
      id: localbook.id, title: "Update Title",
      author: localbook.author, description: localbook.description,
      cover: localbook.cover, publicationDate: localbook.publicationDate
    )
    try await sut.update(updatedBook)
    book = try await sut.getBook(with: localbook.id)
    XCTAssert(book.title == updatedBook.title)
  }

  func testGetBookWithId() async throws {
    let localbook = Book.mockLocal
    try await sut.create(localbook)
    var book = try await sut.getBook(with: localbook.id)
    XCTAssert(book.id == localbook.id)
    XCTAssert(book.title == localbook.title)
    let remoteBook = Book.mockRemote
    book = try await sut.getBook(with: remoteBook.id)
    XCTAssert(book.id == remoteBook.id)
    XCTAssert(book.title == remoteBook.title)
  }

  func testGetAllBooks() async throws {
    let localbook = Book.mockLocal
    try await sut.create(localbook)
    let books = try await sut.getAllBooks()
    XCTAssert(books.count == 2)
    XCTAssert(books.isEmpty == false)
  }

  func testAddFavorite() async throws {
    let remoteBook = Book.mockRemote
    try await sut.addFavorite(remoteBook)
    let favorites = try await sut.getAllFavoriteBooks()
    XCTAssert(favorites.contains(remoteBook.id))
  }

  func testRemoveFavorite() async throws {
    let localBook = Book.mockLocal
    let remoteBook = Book.mockRemote
    try await sut.addFavorite(localBook)
    try await sut.addFavorite(remoteBook)
    try await sut.removeFavorite(localBook)
    let favorites = try await sut.getAllFavoriteBooks()
    XCTAssert(favorites.contains(localBook.id) == false)
  }

  func testIsBookEditable() async throws {
    let localbook = Book.mockLocal
    try await sut.create(localbook)
    let books = try await sut.getAllBooks()
    let userBookIds = try await sut.getAllUserBookIds()
    let isLocalBookEditable = userBookIds.contains(books[0].id)
    let isRemoteBookEditable = userBookIds.contains(books[1].id)
    XCTAssert(isLocalBookEditable)
    XCTAssert(isRemoteBookEditable == false)
  }
}

// MARK: Private Helpers

private extension BooksManagerTests {

  func clearDB(_ fileName: String) {
    if let fileUrl = try? FileManager.default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent(fileName) {
      try? FileManager.default.removeItem(at: fileUrl)
    }
  }
}
