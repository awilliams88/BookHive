//
// BookHiveApp.swift
// Created by Arpit Williams on 12/08/24.
//

import SwiftUI

@main
struct BookHiveApp: App {

  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      BookListView(store: BookListStore.loadStore())
    }
  }
}
