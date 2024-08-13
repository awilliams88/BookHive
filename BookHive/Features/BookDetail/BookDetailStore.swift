//
// BookDetailStore.swift
// Created by Arpit Williams on 14/08/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import Foundation

@Reducer
struct BookDetailStore {

  @Dependency(\.dependencies)
  var dependencies

  @ObservableState
  struct State: Equatable {
    let id: Int
    var book: Book!
  }

  enum Action: BindableAction {
    case loadBook
    case dismiss
    case binding(BindingAction<State>)
  }

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {

      case .loadBook:
        return .run { [id = state.id] send in
          do {
            let book = try await dependencies.manager.getBook(with: id)
            await send(.binding(.set(\.book, book)))
          } catch {
            await send(.dismiss)
          }
        }

      case .dismiss:
        return .run { _ in
          await self.dismiss(animation: .default)
        }

      case .binding:
        return .none
      }
    }
  }
}

// MARK: Load Store

extension BookDetailStore {

  static func loadStore(id: Int) -> StoreOf<Self> {
    .init(initialState: State(id: id)) {
      BookDetailStore()
    }
  }

  static func mockStore() -> StoreOf<Self> {
    .init(initialState: State(id: 1)) {
      BookDetailStore()
    }
  }
}
