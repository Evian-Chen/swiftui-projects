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
    @State private var container: ModelContainer!
    
    init() {
        do {
            let config = ModelConfiguration(for: GameData.self)
            container = try ModelContainer(for: GameData.self, configurations: config)
            
            let context = container.mainContext
            
            // 嘗試抓資料
            let existing = try context.fetch(FetchDescriptor<GameData>())
            if existing.isEmpty {
                // 初始化第一筆資料
                let newData = GameData()
                context.insert(newData)
                try context.save()
                print("初始 GameData 建立完成")
            } else {
                print("已存在 GameData，不需重建")
                print(existing)
            }
            
        } catch {
            print("初始化 SwiftData 發生錯誤：\(error)")
        }
    }
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .modelContainer(container)
        }
    }
}

