//
//  BookwormApp.swift
//  Bookworm
//
//  Created by hpclab on 2025/4/25.
//

import SwiftData
import SwiftUI

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
