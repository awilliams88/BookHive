//
// BookHiveUITestsLaunchTests.swift
// Created by Arpit Williams on 12/08/24.
// Copyright (c) 2024 StarKnights Technologies

import XCTest

final class BookHiveUITestsLaunchTests: XCTestCase {
  // swiftlint:disable:next static_over_final_class
  override class var runsForEachTargetApplicationUIConfiguration: Bool {
    true
  }

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  func testLaunch() throws {
    let app = XCUIApplication()
    app.launch()
    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = "Launch Screen"
    attachment.lifetime = .keepAlways
    add(attachment)
  }
}
