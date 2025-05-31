//
//  GameDataManager.swift
//  Pachinko
//
//  Created by mac03 on 2025/5/31.
//

import Foundation
import SwiftData

class GameDataManager: ObservableObject {
    static let shared = GameDataManager()

    @Published var gameData: GameData!
    var modelContext: ModelContext?

    private init() {}

    func configure(context: ModelContext) {
        self.modelContext = context

        Task {
            do {
                let result = try context.fetch(FetchDescriptor<GameData>())
                if let existing = result.first {
                    await MainActor.run {
                        self.gameData = existing
                    }
                } else {
                    let newData = GameData()
                    context.insert(newData)
                    try context.save()
                    await MainActor.run {
                        self.gameData = newData
                    }
                }
            } catch {
                print("❌ Failed to load GameData: \(error)")
            }
        }
    }

    func save() {
        guard let context = modelContext else { return }
        Task {
            do {
                try context.save()
            } catch {
                print("❌ Failed to save GameData: \(error)")
            }
        }
    }

    func resetGameData() {
        guard let context = modelContext else { return }
        Task {
            let newData = GameData()
            context.insert(newData)
            try? context.save()
            await MainActor.run {
                self.gameData = newData
            }
        }
    }
}
