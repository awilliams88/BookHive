//
// AddBookStore.swift
// Created by Arpit Williams on 13/08/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AddBookStore {

  @Dependency(\.dependencies)
  var dependencies

  @ObservableState
  struct State: Equatable {
    let id: Int
    var title = ""
    var author = ""
    var description = ""
    var publishedDate = Date()

    var publishedISODate: String {
      let formatter = ISO8601DateFormatter()
      formatter.formatOptions.insert(.withFractionalSeconds)
      return formatter.string(from: publishedDate)
    }
  }

  enum Action: BindableAction {
    case createBook
    case saveBook(Book)
    case dismiss
    case binding(BindingAction<State>)
  }

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {

      case .createBook:
        guard state.title.isEmpty == false,
              state.author.isEmpty == false
        else { return .none }

        let book = Book(
          id: state.id, title: state.title,
          author: state.author, description: state.description,
          cover: "", publicationDate: state.publishedISODate
        )
        return .concatenate(.send(.saveBook(book)), .send(.dismiss))

      case .dismiss:
        return .run { _ in
          await self.dismiss(animation: .default)
        }

      case .binding, .saveBook:
        return .none
      }
    }
  }
}

// MARK: Mock Store

extension AddBookStore {

  static func mockStore() -> StoreOf<Self> {
    .init(initialState: State(id: 100)) {
      AddBookStore()
    }
  }
}
