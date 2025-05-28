//
//  MainMenuView.swift
//  Pachinko
//
//  Created by mac03 on 2025/5/26.
//

import SwiftUI
import SwiftData

struct MainMenuView: View {
    @Query var gameData: [GameData]
    
    var body: some View {
        if let game = gameData.first {
            NavigationView {
                VStack(spacing: 32) {
                    Text("小恐龍大冒險")
                        .font(.largeTitle)
                        .padding()

                    NavigationLink("開始遊戲", destination: GameView())

                    NavigationLink("商店", destination: StoreView(gameData: game))

                    NavigationLink("我的小恐龍", destination: MyDinosaursView(gameData: game))

                    NavigationLink("排行榜", destination: RankingView(gameData: game))
                }
            }
        } else {
            Text("")
        }
        
    }
}
