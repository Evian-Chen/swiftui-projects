//
//  GameData.swift
//  Pachinko
//
//  Created by mac03 on 2025/5/28.
//

import SwiftData

@Model
final class GameData: Identifiable, Hashable {
    var allDinoPriceTag: [String: Int]
    var ownedDino: [String]
    var top5Score: [Int]
    var totalCoins: Int
    
    init() {
        self.allDinoPriceTag = ["default_dino": 0, "super_dino": 100, "Xmas_dino": 200]
        self.ownedDino = []
        self.top5Score = [0, 0, 0, 0, 0]
        self.totalCoins = 0
    }
}
