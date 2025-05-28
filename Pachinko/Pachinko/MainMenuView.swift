//
//  MainMenuView.swift
//  Pachinko
//
//  Created by mac03 on 2025/5/26.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Text("小恐龍大冒險")
                    .font(.largeTitle)
                    .padding()

                NavigationLink("開始遊戲", destination: GameView())

                NavigationLink("商店", destination: StoreView())

                NavigationLink("我的小恐龍", destination: MyDinosaursView())

                NavigationLink("排行榜", destination: RankingView())
            }
        }
    }
}
