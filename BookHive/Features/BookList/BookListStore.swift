//
// BookListStore.swift
// Created by Arpit Williams on 13/08/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import Foundation

@Reducer
struct BookListStore {

  @Dependency(\.dependencies)
  var dependencies

  @ObservableState
  struct State: Equatable {
    var books = [Book]()
    var favorites = [Int]()
    @Presents var addBookView: AddBookStore.State?
  }

  enum Action: BindableAction {
    case loadBooks
    case loadFavorites
    case addBooks
    case addFavorite(Book)
    case removeFavorite(Book)
    case binding(BindingAction<State>)
    case addBookView(PresentationAction<AddBookStore.Action>)
  }

  var body: some Reducer<State, Action> {
    BindingReducer()

    // swiftlint:disable:next closure_body_length
    Reduce { state, action in
      switch action {

      case .loadBooks:
        return .run { send in
          do {
            await send(.loadFavorites)
            let books = try await dependencies.manager.getAllBooks()
            await send(.binding(.set(\.books, books)))
          } catch {
            print(error)
          }
        }

      case .loadFavorites:
        return .run { send in
          do {
            let favorites = try await dependencies.manager.getAllFavoriteBooks()
            await send(.binding(.set(\.favorites, favorites)))
          } catch {
            print(error)
          }
        }

      case .addBooks:
        let id = state.books.map(\.id).max() ?? 0
        state.addBookView = .init(id: id + 1)
        return .none

      case let .addBookView(.presented(.saveBook(book))):
        return .run { send in
          do {
            try await dependencies.manager.create(book)
            await send(.loadBooks)
          } catch {
            print(error)
          }
        }

      case let .addFavorite(book):
        state.favorites.append(book.id)
        return .run { _ in try? await dependencies.manager.addFavorite(book) }

      case let .removeFavorite(book):
        state.favorites.removeAll { $0 == book.id }
        return .run { _ in try? await dependencies.manager.removeFavorite(book) }

      case .binding, .addBookView:
        return .none
      }
    }
    .ifLet(\.$addBookView, action: \.addBookView) {
      AddBookStore()
    }
  }
}

// MARK: Load Store

extension BookListStore {

  static func loadStore() -> StoreOf<Self> {
    .init(initialState: State()) {
      BookListStore()
    }
  }

  static func mockStore() -> StoreOf<Self> {
    .init(initialState: State(books: [.mockLocal, .mockRemote])) {
      BookListStore()
    }
  }
}
