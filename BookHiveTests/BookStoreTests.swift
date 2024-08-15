//
// BookStoreTests.swift
// Created by Arpit Williams on 13/08/24.
//

@testable import BookHive
import ComposableArchitecture
import XCTest

final class BookStoreTests: XCTestCase {

  @MainActor
  func testReducer() async {
    let store = TestStore(initialState: BookListStore.State()) {
      BookListStore()
    }

    // Load Books
    await store.send(.loadBooks)
    await store.receive(\.loadFavorites)
    await store.receive(\.binding.books) {
      $0.books = [.mockRemote]
    }
    await store.receive(\.binding.favorites)

    // Add Favorite
    await store.send(.addFavorite(.mockLocal)) {
      $0.favorites = [Book.mockLocal.id]
    }
    await store.send(.addFavorite(.mockRemote)) {
      $0.favorites = [Book.mockLocal.id, Book.mockRemote.id]
    }

    // Remove Favorite
    await store.send(.removeFavorite(.mockLocal)) {
      $0.favorites = [Book.mockRemote.id]
    }
    await store.send(.removeFavorite(.mockRemote)) {
      $0.favorites = []
    }
  }
}
