//
// BookDetailToolBar.swift
// Created by Arpit Williams on 14/08/24.
// Copyright (c) 2024 StarKnights Technologies

import SwiftUI

public struct BookDetailToolBar: ToolbarContent {

  let isEditable: Bool
  var edit: (() -> Void)?
  var close: (() -> Void)?
  var remove: (() -> Void)?

  public var body: some ToolbarContent {
    ToolbarItem(
      placement: .topBarLeading,
      content: {
        if isEditable {
          Button("", systemImage: "trash") { remove?() }
        } else {
          EmptyView()
        }
      }
    )
    ToolbarItem(
      placement: .topBarTrailing,
      content: {
        if isEditable {
          Button("Edit") { edit?() }
        } else {
          EmptyView()
        }
      }
    )
    ToolbarItem(
      placement: .topBarTrailing,
      content: { Button("", systemImage: "xmark.circle.fill") { close?() } }
    )
  }
}

#Preview(body: {
  NavigationView {
    VStack {}
      .toolbar {
        BookDetailToolBar(isEditable: false)
      }
  }
})
