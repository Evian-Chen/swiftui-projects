//
//  GoogleMapTestApp.swift
//  GoogleMapTest
//
//  Created by mac03 on 2025/3/21.
//

import SwiftUI

@main
struct GoogleMapTestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        print("✅ App started")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

