//
//  GameApp.swift
//  Pachinko
//
//  Created by mac03 on 2025/5/31.
//

import SwiftUI
import SwiftData

@main
struct GameApp: App {
    let container: ModelContainer

    init() {
        do {
            let config = ModelConfiguration(for: GameData.self)
            container = try ModelContainer(for: GameData.self, configurations: config)
            
            // 將 context 傳給 GameDataManager（統一使用 shared 管理）
            let context = container.mainContext
            GameDataManager.shared.configure(context: context)
            
        } catch {
            fatalError("❌ 初始化 SwiftData 失敗：\(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environmentObject(GameDataManager.shared)
                .modelContainer(container)
        }
    }
}
