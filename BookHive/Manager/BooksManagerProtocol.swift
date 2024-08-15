//
// BooksManagerProtocol.swift
// Created by Arpit Williams on 12/08/24.
//

import Foundation

protocol BooksManagerProtocol {
  var bookService: BookServiceProtocol { get }
  func create(_ book: Book) async throws
  func update(_ book: Book) async throws
  func remove(_ book: Book) async throws
  func getAllBooks() async throws -> [Book]
  func getBook(with id: Int) async throws -> Book
  func addFavorite(_ book: Book) async throws
  func removeFavorite(_ book: Book) async throws
  func getAllFavoriteBooks() async throws -> [Int]
  func getAllUserBookIds() async throws -> [Int]
}
