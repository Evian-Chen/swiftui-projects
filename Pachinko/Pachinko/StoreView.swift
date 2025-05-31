//
//  StoreView.swift
//  Pachinko
//
//  Created by mac03 on 2025/5/31.
//

import SwiftUI

struct StoreView: View {
    @EnvironmentObject var gameManager: GameDataManager
    @State private var showingBuyingAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("商店 - 金幣: \(gameManager.gameData.totalCoins)")
                .bold()
                .font(.title)
                .padding()

            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(allDinoPriceList) { item in
                        let dino = item.name
                        let price = item.price

                        VStack {
                            Image(dino)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .opacity(gameManager.gameData.ownedDino.contains(dino) ? 0.4 : 1)

                            Text("\(price) 金幣")
                                .font(.title2)
                                .bold()

                            Button {
                                if price > gameManager.gameData.totalCoins {
                                    showingBuyingAlert = true
                                } else if !gameManager.gameData.ownedDino.contains(dino) {
                                    gameManager.gameData.ownedDino.append(dino)
                                    gameManager.gameData.totalCoins -= price
                                    gameManager.save()
                                }
                            } label: {
                                Text(gameManager.gameData.ownedDino.contains(dino) ? "已購買" : "購買")
                                    .padding(10)
                                    .foregroundColor(.black)
                                    .background(.blue.opacity(0.3))
                                    .cornerRadius(10)
                            }
                        }
                        .frame(width: 120)
                    }
                }
                .padding(.horizontal)
            }
            .alert("沒有足夠的金幣", isPresented: $showingBuyingAlert) {
                Button("確定", role: .cancel) { }
            } message: {
                Text("還不趕快去多玩幾場 🦖")
            }
        }
        .padding()
    }
}
