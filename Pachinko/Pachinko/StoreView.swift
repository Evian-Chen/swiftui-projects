//
//  StoreView.swift
//  Pachinko
//
//  Created by mac03 on 2025/5/26.
//

import SwiftUI
import SwiftData

struct StoreView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var gameData: [GameData]

    @State var showingBuyingAlert: Bool = false

    var body: some View {
        guard let game = gameData.first else {
            return AnyView(Text("尚無遊戲資料"))
        }

        let priceTags = game.allDinoPriceTag

        return AnyView(
            VStack {
                Text("商店 - 分數: \(game.totalCoins)")
                ScrollView(.horizontal) {
                    ForEach(Array(priceTags), id: \.key) { item in
                        let dino = item.key
                        let price = item.value

                        HStack {
                            Image(dino)
                                .opacity(game.ownedDino.contains(dino) ? 0.4 : 1)

                            Text("\(price)")
                                .font(.title2)
                                .bold()

                            Button {
                                if price > game.totalCoins {
                                    showingBuyingAlert = true
                                } else if !game.ownedDino.contains(dino) {
                                    game.ownedDino.append(dino)
                                    game.totalCoins -= price
                                    try? modelContext.save()
                                }
                            } label: {
                                Text(game.ownedDino.contains(dino) ? "已購買" : "購買")
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
                }
            }
            .padding()
        )
    }
}


#Preview("iPad 橫向", traits: .landscapeLeft) {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true) // 不寫入磁碟
        let container = try ModelContainer(for: GameData.self, configurations: config)

        // 插入一筆假的 GameData
        let sample = GameData()
        sample.totalCoins = 150
        sample.ownedDino = ["default_dino"]
        try container.mainContext.insert(sample)

        return StoreView()
            .modelContainer(container)
    } catch {
        return Text("預覽錯誤：\(error.localizedDescription)")
    }
}
