//
//  BookwormApp.swift
//  Bookworm
//
//  Created by mac03 on 2025/4/30.
//

import SwiftUI
import SwiftData

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
