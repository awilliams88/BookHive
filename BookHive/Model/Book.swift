//
// Book.swift
// Created by Arpit Williams on 12/08/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

struct Book: Codable, Equatable, Identifiable {
  let id: Int
  let title: String
  let author: String
  let description: String
  let cover: String
  let publicationDate: String
}

extension Book {
  static let mockRemote = Book(
    id: 1,
    title: "To Kill a Mockingbird",
    author: "Harper Lee",
    description: "A classic of modern American literature that has been celebrated for its finely crafted characters.",
    cover: "https://m.media-amazon.com/images/I/51IXWZzlgSL._SX330_BO1,204,203,200_.jpg",
    publicationDate: "1960-07-11T00:00:00.000Z"
  )

  static let mockLocal = Book(
    id: 100,
    title: "Title",
    author: "Author",
    description: "Description",
    cover: "https://test.com/image.jpg",
    publicationDate: "2024-01-01T00:00:00.000Z"
  )
}
