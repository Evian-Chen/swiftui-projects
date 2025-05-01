//
//  RecommendationSectionView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/5/1.
//

import SwiftUI

// 定義每個section，包含header和咖啡廳的內容
struct RecommendationSectionView: View {
    var category: RecommendationCategory
    
    var body: some View {
        Section {
            // 從資料庫抓出對應資料裝入CafeInfoObject，再依序顯示，一次最多顯示五筆
            ForEach(0 ..< 5, id: \.self) { index in
                CafeInfoCardView(cafeObj: sampleCafes[index])
            }
        } header: {
            SectionHeaderView(category: category)
        }
    }
}
