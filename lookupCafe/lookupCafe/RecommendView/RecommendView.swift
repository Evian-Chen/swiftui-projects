//
//  RecommendView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/9.
//

import SwiftUI
import SwiftUICore

struct RecommendView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 24, pinnedViews: .sectionHeaders) {
                    RecommendationSectionView(category: .petCafe)
                    RecommendationSectionView(category: .workCafe)
                    RecommendationSectionView(category: .highRatings)
                }
                .padding(.vertical)
            }
            .navigationTitle("推薦咖啡廳")
        }
    }
}


struct CafeDetailView: View {
    var cafeObj: CafeInfoObject
    
    var body: some View {
        Text(cafeObj.shopName).font(.title)
    }
}

#Preview {
    RecommendView()
}

