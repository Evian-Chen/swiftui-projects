//
//  MyDinosaursView.swift
//  Pachinko
//
//  Created by mac03 on 2025/5/26.
//
import SwiftUI

struct MyDinosaursView: View {
    @EnvironmentObject var gameManager: GameDataManager

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("我的小恐龍")
                .font(.largeTitle)
                .bold()
                .padding(.top)

            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(allDinoPriceList.filter { gameManager.gameData.ownedDino.contains($0.name) }) { dino in
                        VStack {
                            Image(dino.name)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(gameManager.gameData.selectedDino == dino.name ? Color.blue : Color.clear, lineWidth: 4)
                                )

                            Text(dino.name)
                                .font(.title2)
                                .bold()

                            Button {
                                gameManager.gameData.selectedDino = dino.name
                                gameManager.save()
                            } label: {
                                Text(gameManager.gameData.selectedDino == dino.name ? "使用中" : "選擇")
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
        }
        .padding()
    }
}
