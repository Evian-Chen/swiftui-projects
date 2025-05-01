//
//  CafeDetailView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/5/1.
//

import SwiftUI

// 每間咖啡廳的詳細資料（整個頁面）
struct CafeDetailView: View {
    var cafeObj: CafeInfoObject
    
    var body: some View {
        Text(cafeObj.shopName).font(.title)
    }
}
