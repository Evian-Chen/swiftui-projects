//
//  MyDinosaursView.swift
//  Pachinko
//
//  Created by mac03 on 2025/5/26.
//

import SwiftUI

struct MyDinosaursView: View {
    @Bindable var gameData: GameData

    var body: some View {
        HStack {
            ForEach(gameData.ownedDino, id: \.self) { dino in
                VStack {
                    Image(dino)
                        .opacity(gameData.selectedDino == dino ? 0.3 : 1)
                    Text(dino)
                        .font(.title2)
                        .bold()
                    
                    Button {
                        gameData.selectedDino = dino
                    } label: {
                        Text(gameData.selectedDino == dino ? "使用中" : "選擇")
                            .padding(10)
                            .foregroundColor(.black)
                            .background(.blue.opacity(0.3))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}
