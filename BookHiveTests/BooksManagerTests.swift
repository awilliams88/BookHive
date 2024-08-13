//
// BooksManagerTests.swift
// Created by Arpit Williams on 13/08/24.
// Copyright (c) 2024 StarKnights Technologies

@testable import BookHive
import XCTest

final class BooksManagerTests: XCTestCase {

  var sut: BooksManager!
  let mock = BookServiceMock()

  override func setUpWithError() throws {
    sut = BooksManager(bookService: mock)

    /// Clear books db
    let fileUrl = try FileManager.default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent("books.data")
    try? FileManager.default.removeItem(at: fileUrl)
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
}
