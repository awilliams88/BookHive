//
// AddBookStoreTests.swift
// Created by Arpit Williams on 14/08/24.
// Copyright (c) 2024 StarKnights Technologies

@testable import BookHive
import ComposableArchitecture
import XCTest

final class AddBookStoreTests: XCTestCase {

  @MainActor
  func testReducer() async {
    let store = TestStore(initialState: AddBookStore.State(id: 0)) {
      AddBookStore()
    }

    // Create Book
    await store.send(.binding(.set(\.title, "title"))) {
      $0.title = "title"
    }
    await store.send(.binding(.set(\.author, "author"))) {
      $0.author = "author"
    }
    await store.send(.createBook)
    await store.receive(\.saveBook)
    await store.receive(\.dismiss)
  }
}
