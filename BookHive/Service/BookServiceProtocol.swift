//
// BookServiceProtocol.swift
// Created by Arpit Williams on 12/08/24.
//

import Foundation

protocol BookServiceProtocol {
  func getAllBooks() async throws -> [Book]
  func getBook(for id: Int) async throws -> Book
}
