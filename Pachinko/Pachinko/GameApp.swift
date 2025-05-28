//
//  GameApp.swift
//  Pachinko
//
//  Created by Mac25 on 2025/3/19.
//

import SwiftUI
import SwiftData

@main
struct DinoGameApp: App {
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .modelContainer(for: GameData.self)
        }
    }
}

