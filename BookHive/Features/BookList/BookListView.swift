//
// BookListView.swift
// Created by Arpit Williams on 13/08/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import SwiftUI

struct BookListView: View {

  @Perception.Bindable var store: StoreOf<BookListStore>
  init(store: StoreOf<BookListStore>) {
    self.store = store
  }

  var body: some View {
    WithPerceptionTracking {
      NavigationView {
        listView
          .navigationTitle("BooK HiVe 🐝")
          .toolbar { addBookButton }
      }
      .navigationViewStyle(.stack)
      .onAppear { store.send(.loadBooks) }
      .sheet(item: $store.scope(state: \.addBookView, action: \.addBookView)) {
        AddBookView(store: $0)
      }
      .sheet(item: $store.scope(state: \.bookDetailView, action: \.bookDetailView)) {
        BookDetailView(store: $0)
      }
    }
  }

  var addBookButton: some View {
    Button("", systemImage: "plus") {
      store.send(.addBooks)
    }
  }

  var listView: some View {
    List(store.books) { book in
      BookView(
        book: book,
        isFavorite: store.favorites.contains(book.id),
        setFavorite: { store.send($0 ? .addFavorite(book) : .removeFavorite(book)) }
      )
      .listRowSeparator(.hidden)
      .listRowInsets(.init(.zero))
      .listRowBackground(Color.clear)
      .onTapGesture { store.send(.showBookDetail(book)) }
    }
    .listStyle(.plain)
    .background(Color.clear)
  }
}

#Preview {
  BookListView(
    store: BookListStore.mockStore()
  )
}
