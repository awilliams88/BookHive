//
// BooksManagerMock.swift
// Created by Arpit Williams on 13/08/24.
//

import Foundation

final class BooksManagerMock: BooksManagerProtocol {
  let bookService: BookServiceProtocol = BookServiceMock()
  func create(_ book: Book) async throws {}
  func update(_ book: Book) async throws {}
  func remove(_ book: Book) async throws {}
  func getAllBooks() async throws -> [Book] { try await bookService.getAllBooks() }
  func getBook(with id: Int) async throws -> Book { try await bookService.getBook(for: id) }
  func addFavorite(_ book: Book) async throws {}
  func removeFavorite(_ book: Book) async throws {}
  func getAllFavoriteBooks() async throws -> [Int] { [] }
  func getAllUserBookIds() async throws -> [Int] { [] }
}
