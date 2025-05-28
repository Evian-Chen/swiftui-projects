//
//  RankingView.swift
//  Pachinko
//
//  Created by mac03 on 2025/5/26.
//

import SwiftUI
import SwiftData

struct RankingView: View {
    @Bindable var gameData: GameData

    var body: some View {
        VStack(spacing: 20) {
            Text("🏆 排行榜 TOP 5")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 10)

            if !gameData.top5Score.isEmpty {
                ForEach(Array(gameData.top5Score.enumerated()), id: \.offset) { index, score in
                    HStack {
                        Text(rankEmoji(for: index))
                            .font(.title)

                        VStack(alignment: .leading) {
                            Text("第 \(index + 1) 名")
                                .font(.headline)
                            Text("分數：\(score)")
                                .font(.subheadline)
                        }

                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.1)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
                }
            } else {
                Text("目前沒有遊玩紀錄")
                    .foregroundStyle(.gray)
            }
        }
        .padding()
    }

    // 🎖 Emoji 根據名次給不同獎章
    func rankEmoji(for index: Int) -> String {
        switch index {
        case 0: return "🥇"
        case 1: return "🥈"
        case 2: return "🥉"
        default: return "🎮"
        }
    }
}

#Preview("iPad 橫向", traits: .landscapeLeft) {
    do {
        // 使用 in-memory 來避免寫入磁碟
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: GameData.self, configurations: config)

        // 建立測試用資料
        let sample = GameData()
        sample.top5Score = [9870, 8200, 7000, 5800, 4200]
        try container.mainContext.insert(sample)

        return RankingView(gameData: sample)
            .modelContainer(container)
    } catch {
        return Text("預覽錯誤：\(error.localizedDescription)")
    }
}
