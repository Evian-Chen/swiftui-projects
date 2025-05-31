//
//  GameData.swift
//  Pachinko
//
//  Created by mac03 on 2025/5/28.
//
import Foundation
import SwiftData

@Model
final class GameData {
    // 使用者擁有的小恐龍皮膚
    var ownedDino: [String]

    // 遊戲排行榜分數（Top 5）
    var top5Score: [Int]

    // 特殊獲得的小恐龍（目前保留欄位）
    var specialDino: [String]

    // 當前使用的恐龍皮膚名稱
    var selectedDino: String

    // 累積金幣
    var totalCoins: Int

    init() {
        self.ownedDino = ["default_dino"]
        self.top5Score = [0, 0, 0, 0, 0]
        self.specialDino = []
        self.selectedDino = "default_dino"
        self.totalCoins = 0
    }

    func sortScore(score: Int) {
        top5Score.append(score)
        top5Score.sort(by: >)
        if top5Score.count > 5 {
            top5Score = Array(top5Score.prefix(5))
        }
    }

    static let defaultValue = GameData()
}

// 不進資料庫，用來顯示可購買恐龍的價格與名稱
struct DinoPrice: Identifiable {
    var id: String { name }
    let name: String
    let price: Int
}

let allDinoPriceList: [DinoPrice] = [
    DinoPrice(name: "default_dino", price: 0),
    DinoPrice(name: "super_dino", price: 100),
    DinoPrice(name: "Xmas_dino", price: 200)
]
