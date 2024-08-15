//
// BookServiceMock.swift
// Created by Arpit Williams on 13/08/24.
//

import Foundation

final class BookServiceMock: BookServiceProtocol {
  func getAllBooks() async throws -> [Book] { [.mockRemote] }
  func getBook(for id: Int) async throws -> Book { .mockRemote }
}
