//
// BookView.swift
// Created by Arpit Williams on 13/08/24.
//

import ComposableArchitecture
import SwiftUI

struct BookView: View {

  let book: Book

  @State var isFavorite = false
  var setFavorite: ((Bool) -> Void)?

  var body: some View {
    VStack(spacing: 16) {
      HStack(spacing: 8) {
        coverImage
        bookInfo
        favoriteView
      }
      Divider()
    }
    .padding(.top, 8)
    .padding(.horizontal, 16)
  }

  var coverImage: some View {
    AsyncImage(
      url: URL(string: book.cover),
      content: { $0.resizable() },
      placeholder: {
        Image(systemName: "books.vertical")
          .resizable()
          .padding(12)
          .background(
            LinearGradient(
              colors: [Color(.tangerine), Color(.cantaloupe)],
              startPoint: .bottom, endPoint: .top
            )
          )
      }
    )
    .cornerRadius(8)
    .padding(4)
    .shadow(radius: 8, x: 2, y: 8)
    .frame(width: 80, height: 80)
  }

  var bookInfo: some View {
    VStack(alignment: .leading, spacing: 4) {
      Group {
        Text(book.title)
          .font(.headline)
          .fontWeight(.medium)

        Text("Author: " + book.author)
          .font(.subheadline)
          .fontWeight(.light)

        Text("Published: " + publishedDate)
          .font(.caption)
          .fontWeight(.thin)
      }
      .lineLimit(1)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  var favoriteView: some View {
    Image(systemName: isFavorite ? "heart.fill" : "heart")
      .resizable()
      .frame(maxWidth: 30, maxHeight: 30)
      .foregroundStyle(isFavorite ? Color(.tangerine) : Color(.salmon))
      .onTapGesture {
        isFavorite.toggle()
        setFavorite?(isFavorite)
      }
  }

  var publishedDate: String {
    guard let date = isoDateFormatter.date(from: book.publicationDate) else { return "" }
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
  BookView(book: .mockRemote)
    .previewLayout(.sizeThatFits)
}

#Preview {
  BookView(book: .mockLocal)
    .previewLayout(.sizeThatFits)
}
