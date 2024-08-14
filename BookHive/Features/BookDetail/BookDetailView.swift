//
// BookDetailView.swift
// Created by Arpit Williams on 14/08/24.
// Copyright (c) 2024 StarKnights Technologies

import ComposableArchitecture
import SwiftUI

struct BookDetailView: View {

  @Perception.Bindable var store: StoreOf<BookDetailStore>
  init(store: StoreOf<BookDetailStore>) {
    self.store = store
  }

  var body: some View {
    WithPerceptionTracking {
      NavigationView {
        ScrollView {
          VStack(spacing: 16) {
            coverImage
            authorView
            titleView
            descriptionView
          }
          .padding(.horizontal, 20)
          .onAppear { store.send(.loadBook) }
          .navigationBarTitle("Book Info 📗")
          .toolbar {
            BookDetailToolBar(
              isEditable: store.isEditable,
              edit: { store.send(.editBook) },
              close: { store.send(.dismiss) },
              remove: { store.send(.removeBook) }
            )
          }
        }
      }
    }
  }

  var authorView: some View {
    VStack(alignment: .trailing, spacing: 4) {
      Text("Author: " + (store.book?.author ?? ""))
        .font(.callout)
      Text("Published: " + publishedDate)
        .font(.caption.weight(.light))
    }.frame(maxWidth: .infinity, alignment: .trailing)
  }

  var titleView: some View {
    Text(store.book?.title ?? "")
      .font(.title2.weight(.semibold))
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  var descriptionView: some View {
    Text(store.book?.description ?? "")
      .font(.body)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  var coverImage: some View {
    AsyncImage(
      url: URL(string: store.book?.cover ?? ""),
      content: { $0.resizable() },
      placeholder: {
        Image(systemName: "books.vertical")
          .resizable()
          .padding(40)
          .background(
            LinearGradient(
              colors: [Color(.tangerine), Color(.cantaloupe)],
              startPoint: .bottom, endPoint: .top
            )
          )
      }
    )
    .aspectRatio(1, contentMode: .fit)
    .cornerRadius(20)
    .padding(40)
    .shadow(radius: 8, x: 4, y: 20)
  }

  var publishedDate: String {
    guard let date = isoDateFormatter.date(from: store.book?.publicationDate ?? "") else { return "" }
    return dateFormatter.string(from: date)
  }

  private let isoDateFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions.insert(.withFractionalSeconds)
    return formatter
  }()

  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
  }()
}

#Preview {
  BookDetailView(
    store: BookDetailStore.mockStore()
  )
}
