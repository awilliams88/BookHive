//
// Dependencies.swift
// Created by Arpit Williams on 13/08/24.
//

import Dependencies
import Foundation
import Resolver

protocol DependenciesProtocol {
  var service: BookServiceProtocol { get }
  var manager: BooksManagerProtocol { get }
  var mainQueue: AnySchedulerOf<DispatchQueue> { get }
}

struct Dependencies: DependenciesProtocol {
  var service: any BookServiceProtocol
  var manager: any BooksManagerProtocol
  var mainQueue: AnySchedulerOf<DispatchQueue> = .main
}

extension Dependencies: DependencyKey {
  static let liveValue: DependenciesProtocol = Resolver.resolve()
  static let testValue: DependenciesProtocol = Dependencies.mock()
  static let previewValue: DependenciesProtocol = Dependencies.mock()
}

extension DependencyValues {
  var dependencies: DependenciesProtocol {
    get { self[Dependencies.self] }
    set { self[Dependencies.self] = newValue }
  }
}

// MARK: - Mock

extension Dependencies {
  static func mock() -> Self {
    .init(
      service: BookServiceMock(),
      manager: BooksManagerMock()
    )
  }
}
