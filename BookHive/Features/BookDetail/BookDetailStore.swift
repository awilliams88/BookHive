//
// BookDetailStore.swift
// Created by Arpit Williams on 14/08/24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct BookDetailStore {

  @Dependency(\.dependencies)
  var dependencies

  @ObservableState
  struct State: Equatable {
    let id: Int
    let isEditable: Bool
    var book: Book?
    @Presents var addBookView: AddBookStore.State?

    var publishedISODate: Date {
      let formatter = ISO8601DateFormatter()
      formatter.formatOptions.insert(.withFractionalSeconds)
      return formatter.date(from: book?.publicationDate ?? "") ?? Date()
    }
  }

  enum Action: BindableAction {
    case loadBook
    case editBook
    case removeBook
    case reloadBooks
    case dismiss
    case binding(BindingAction<State>)
    case addBookView(PresentationAction<AddBookStore.Action>)
  }

  @Dependency(\.dismiss) var dismiss

  var body: some Reducer<State, Action> {
    BindingReducer()

    // swiftlint:disable:next closure_body_length
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

      case .editBook:
        guard let book = state.book else { return .none }
        state.addBookView = .init(
          id: book.id, title: book.title, author: book.author,
          description: book.description, publishedDate: state.publishedISODate
        )
        return .none

      case .removeBook:
        return .run { [book = state.book] send in
          guard let book else { return }
          try await dependencies.manager.remove(book)
          await send(.dismiss)
          await send(.reloadBooks)
        }

      case let .addBookView(.presented(.saveBook(book))):
        return .run { send in
          do {
            try await dependencies.manager.update(book)
            await send(.binding(.set(\.book, book)))
            await send(.reloadBooks)
          } catch {
            print(error)
          }
        }

      case .dismiss:
        return .run { _ in
          await self.dismiss(animation: .default)
        }

      case .binding, .reloadBooks, .addBookView:
        return .none
      }
    }
    .ifLet(\.$addBookView, action: \.addBookView) {
      AddBookStore()
    }
  }
}

// MARK: Mock Store

extension BookDetailStore {

  static func mockStore() -> StoreOf<Self> {
    .init(initialState: State(id: 1, isEditable: true)) {
      BookDetailStore()
    }
  }
}
