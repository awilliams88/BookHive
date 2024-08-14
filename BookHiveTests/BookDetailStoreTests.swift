//
// BookDetailStoreTests.swift
// Created by Arpit Williams on 14/08/24.
// Copyright (c) 2024 StarKnights Technologies

@testable import BookHive
import ComposableArchitecture
import XCTest

final class BookDetailStoreTests: XCTestCase {

  @MainActor
  func testReducer() async {
    let store = TestStore(initialState: BookDetailStore.State(
      id: 0, isEditable: true
    )) {
      BookDetailStore()
    }

    // Load Book
    await store.send(.loadBook)
    await store.receive(\.binding.book) {
      $0.book = Book.mockRemote
    }

    // Edit Book
    await store.send(.editBook) {
      let book = Book.mockRemote
      $0.addBookView = .init(
        id: book.id, title: book.title,
        author: book.author, description: book.description,
        publishedDate: self.publishedISODate(from: book.publicationDate)
      )
    }

    // Update Book
    let book = Book.mockLocal
    await store.send(.addBookView(.presented(.saveBook(book))))
    await store.receive(\.binding.book) {
      $0.book = book
    }
    await store.receive(\.reloadBooks)

    // Remove Book
    await store.send(.removeBook)
    await store.receive(\.dismiss)
    await store.receive(\.reloadBooks)
  }
}

// MARK: Private Helpers

private extension BookDetailStoreTests {

  func publishedISODate(from string: String) -> Date {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions.insert(.withFractionalSeconds)
    return formatter.date(from: string) ?? Date()
  }
}
