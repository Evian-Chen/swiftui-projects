//
//  StoreView.swift
//  Pachinko
//
//  Created by mac03 on 2025/5/26.
//

import SwiftUI
import SwiftData

struct StoreView: View {
    @Bindable var gameData: GameData
    @State var showingBuyingAlert: Bool = false

    var body: some View {
        let priceTags = gameData.allDinoPriceTag

        // 把內容拆出來成 View
        let dinoButtons = ForEach(Array(priceTags), id: \.key) { item in
            let dino = item.key
            let price = item.value

            VStack {
                Image(dino)
                    .opacity(gameData.ownedDino.contains(dino) ? 0.4 : 1)

                Text("\(price)")
                    .font(.title2)
                    .bold()

                Button {
                    if price > gameData.totalCoins {
                        showingBuyingAlert = true
                    } else if !gameData.ownedDino.contains(dino) {
                        gameData.ownedDino.append(dino)
                        gameData.totalCoins -= price
                        try? modelContext.save()
                    }
                } label: {
                    Text(gameData.ownedDino.contains(dino) ? "已購買" : "購買")
                        .padding(10)
                        .foregroundColor(.black)
                        .background(.blue.opacity(0.3))
                        .cornerRadius(10)
                }
            }
            .alert("沒有足夠的金幣", isPresented: $showingBuyingAlert) {
            } message: {
                Text("還不趕快去多玩幾場")
            }
        }

        // 回傳 View
        return VStack(alignment: .leading, spacing: 30) {
            Text("商店 - 分數: \(gameData.totalCoins)")
                .bold()
                .font(.title)
                .padding()

            ScrollView(.horizontal) {
                HStack {
                    dinoButtons
                }
            }
        }
        .padding()
    }

}


//#Preview("iPad 橫向", traits: .landscapeLeft) {
//    do {
//        let config = ModelConfiguration(isStoredInMemoryOnly: true) // 不寫入磁碟
//        let container = try ModelContainer(for: GameData.self, configurations: config)
//
//        // 插入一筆假的 GameData
//        let sample = GameData()
//        sample.totalCoins = 150
//        sample.ownedDino = ["default_dino"]
//        try container.mainContext.insert(sample)
//
//        return StoreView()
//            .modelContainer(container)
//    } catch {
//        return Text("預覽錯誤：\(error.localizedDescription)")
//    }
//}
