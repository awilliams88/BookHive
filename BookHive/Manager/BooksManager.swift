//
// BooksManager.swift
// Created by Arpit Williams on 12/08/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

final class BooksManager: BooksManagerProtocol {

  let bookService: BookServiceProtocol
  init(bookService: any BookServiceProtocol) {
    self.bookService = bookService
  }

  func create(_ book: Book) async throws {
    var books = try await getLocalBooks()
    books.append(book)
    try await updateLocalBooks(books)
  }

  func update(_ book: Book) async throws {
    var books = try await getLocalBooks()
    guard let index = books.firstIndex(where: { $0.id == book.id }) else { return }
    books[index] = book
    try await updateLocalBooks(books)
  }

  func remove(_ book: Book) async throws {
    var books = try await getLocalBooks()
    guard let index = books.firstIndex(where: { $0.id == book.id }) else { return }
    books.remove(at: index)
    try await updateLocalBooks(books)
  }

  func getBook(with id: Int) async throws -> Book {
    let books = try await getAllBooks()
    guard let book = books.first(where: { $0.id == id }) else {
      throw BookError.invalidBookId
    }
    return book
  }

  func getAllBooks() async throws -> [Book] {
    let localBooks = try await getLocalBooks()
    let remoteBooks = try await bookService.getAllBooks()
    return localBooks + remoteBooks
  }

  func addFavorite(_ book: Book) async throws {
    var favorites = try await getFavoriteBookIds()
    guard favorites.contains(book.id) == false else { throw BookError.bookIdAlreadyFavortie }
    favorites.append(book.id)
    try await updateFavoriteBookIds(favorites)
  }

  func removeFavorite(_ book: Book) async throws {
    var favorites = try await getFavoriteBookIds()
    guard favorites.contains(book.id) else { throw BookError.bookIdAlreadyNotFavortie }
    favorites.removeAll { $0 == book.id }
    try await updateFavoriteBookIds(favorites)
  }

  func isFavorite(_ book: Book) async throws -> Bool {
    let favorites = try await getFavoriteBookIds()
    return favorites.contains(book.id)
  }
}

// MARK: Read/Write Books

private extension BooksManager {

  static func booksUrl() throws -> URL {
    try FileManager.default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent(booksDb)
  }

  func getLocalBooks() async throws -> [Book] {
    try await Task<[Book], Error> {
      let fileUrl = try Self.booksUrl()
      guard let data = try? Data(contentsOf: fileUrl) else { return [] }
      return try JSONDecoder().decode([Book].self, from: data)
    }.value
  }

  func updateLocalBooks(_ books: [Book]) async throws {
    try await Task {
      let data = try JSONEncoder().encode(books)
      let fileUrl = try Self.booksUrl()
      try data.write(to: fileUrl)
    }.value
  }
}

// MARK: Set/UnSet Favorite Books

private extension BooksManager {

  static func favoriteBooksUrl() throws -> URL {
    try FileManager.default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent(favoritesDb)
  }

  func getFavoriteBookIds() async throws -> [Int] {
    try await Task<[Int], Error> {
      let fileUrl = try Self.favoriteBooksUrl()
      guard let data = try? Data(contentsOf: fileUrl) else { return [] }
      return try JSONDecoder().decode([Int].self, from: data)
    }.value
  }

  func updateFavoriteBookIds(_ ids: [Int]) async throws {
    try await Task {
      let data = try JSONEncoder().encode(ids)
      let fileUrl = try Self.favoriteBooksUrl()
      try data.write(to: fileUrl)
    }.value
  }
}
