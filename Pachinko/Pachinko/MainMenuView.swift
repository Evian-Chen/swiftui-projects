//
//  MainMenuView.swift
//  Pachinko
//
//  Created by mac03 on 2025/5/31.
//
import SwiftUI
import SwiftData

struct MainMenuView: View {
    @StateObject private var gameManager = GameDataManager.shared
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Text("小恐龍大冒險")
                    .font(.largeTitle)
                    .padding()

                if let _ = gameManager.gameData {
                    NavigationLink("開始遊戲") {
                        GameView()
                            .environmentObject(gameManager)
                    }

                    NavigationLink("商店") {
                        StoreView()
                            .environmentObject(gameManager)
                    }

                    NavigationLink("我的小恐龍") {
                        MyDinosaursView()
                            .environmentObject(gameManager)
                    }

                    NavigationLink("排行榜") {
                        RankingView()
                            .environmentObject(gameManager)
                    }
                } else {
                    ProgressView("載入中...")
                        .padding()
                }
            }
            .padding()
            .onAppear {
                if gameManager.modelContext == nil {
                    gameManager.configure(context: context)
                }
            }
        }
    }
}
