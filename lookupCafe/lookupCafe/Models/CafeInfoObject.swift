//
//  CafeInfoObject.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/21.
//

import Foundation

// 這個struct包含了要顯示出的咖啡廳的重要資訊
struct CafeInfoObject: Identifiable {
    var id = UUID()  // no need to add \.self when ForEach
    
    var shopName: String
    var city: String
    var district: String
    var address: String
    var phoneNumber: String
    
    // 評論等使用者點入之後再把資料抽出來，或者直接再用一次google API
    var rating: Int
    var services: [Bool]
    
    // 關鍵字
    var types: [String]
    
    // 營業時間
    var weekdayText: [String]
    
    var reviews: [Review]?
}

struct Review: Identifiable {
    var id = UUID()
    
    var review_time: String
    var reviewer_name: String
    var reviewer_rating: Int
    var reviewer_text: String
}
