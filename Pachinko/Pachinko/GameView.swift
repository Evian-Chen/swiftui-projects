//
//  GameView.swift
//  Pachinko
//
//  Created by mac03 on 2025/5/31.
//
import SwiftUI
import SpriteKit

struct GameView: View {
    @EnvironmentObject var gameManager: GameDataManager

    var body: some View {
        GeometryReader { geometry in
            SpriteView(scene: {
                let newScene = GameScene()

                if let gameData = gameManager.gameData,
                   let context = gameManager.modelContext {
                    newScene.configure(gameData: gameData, context: context)
                } else {
                    print("⚠️ GameData 或 modelContext 尚未初始化")
                }

                newScene.size = geometry.size
                newScene.scaleMode = .resizeFill
                return newScene
            }())
            .ignoresSafeArea()
        }
    }
}
