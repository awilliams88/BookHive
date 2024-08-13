//
// BookServiceMock.swift
// Created by Arpit Williams on 13/08/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

final class BookServiceMock: BookServiceProtocol {
  func getAllBooks() async throws -> [Book] { [.mockRemote] }
  func getBook(for id: Int) async throws -> Book { .mockRemote }
}
