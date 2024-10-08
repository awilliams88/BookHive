//
// AppDelegate.swift
// Created by Arpit Williams on 13/08/24.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

    // Configure URLCache
    let memoryCapacity = 10 * 1024 * 1024 // 10 MB
    let diskCapacity = 50 * 1024 * 1024 // 50 MB
    let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity)
    URLCache.shared = cache

    return true
  }
}
