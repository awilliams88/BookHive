//
// BookService.swift
// Created by Arpit Williams on 12/08/24.
//

import Foundation

final class BookService: BookServiceProtocol {

  private let decoder = JSONDecoder()
  private let session = URLSession.shared

  func getAllBooks() async throws -> [Book] {
    guard let url = URL(string: "/cutamar/mock/books", relativeTo: baseUrl) else { throw ApiError.invalidUrl }
    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
    let (data, _) = try await session.data(for: request)
    let books = try decoder.decode([Book].self, from: data)
    return books
  }

  func getBook(for id: Int) async throws -> Book {
    guard let url = URL(string: "/cutamar/mock/books/\(id)", relativeTo: baseUrl) else { throw ApiError.invalidUrl }
    let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
    let (data, _) = try await session.data(for: request)
    let book = try decoder.decode(Book.self, from: data)
    return book
  }
}
