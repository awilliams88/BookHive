//
// Register.swift
// Created by Arpit Williams on 13/08/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    Resolver.defaultScope = .shared
    register { FileManager.default }
    register { BookService() }.implements(BookServiceProtocol.self)
    register { BooksManager(bookService: resolve()) }.implements(BooksManagerProtocol.self)
    register { Dependencies(service: resolve(), manager: resolve()) }.implements(DependenciesProtocol.self)
  }
}
