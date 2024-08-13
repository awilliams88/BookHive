//
// BookServiceProtocol.swift
// Created by Arpit Williams on 12/08/24.
// Copyright (c) 2024 StarKnights Technologies

import Foundation

protocol BookServiceProtocol {
  func getAllBooks() async throws -> [Book]
  func getBook(for id: Int) async throws -> Book
}
