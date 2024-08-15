//
// BookError.swift
// Created by Arpit Williams on 13/08/24.
//

import Foundation

enum BookError: Error {
  case invalidBookId
  case bookIdAlreadyFavortie
  case bookIdAlreadyNotFavortie
}
