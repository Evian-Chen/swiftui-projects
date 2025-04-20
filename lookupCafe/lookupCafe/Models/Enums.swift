//
//  Enums.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/20.
//

// 定義每個篩選的內容物
enum FilterOptions: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case cities = "城市"
    case districts = "地區"
    case sockets = "插座"
    case wifi = "網路"
    case stayTime = "用餐時間"
    
    var optionsArr: [String] {
        switch self {
        case .cities:
            return ["全部", "台北市", "新北市", "嘉義市"]
        case .districts:
            return ["全部", "新店區", "大安區", "中山區"]
        case .sockets:
            return ["全部", "沒有插座", "少許插座", "很多插座"]
        case .wifi:
            return ["全部", "有wifi", "沒有wifi"]
        case .stayTime:
            return ["全部", "用餐時間有限制", "用餐時間無限制"]
        }
    }
    
    var defaultStr: String {
        return self.rawValue
    }
}

// RecommendView浮動header的種類
enum RecommendationCategory: String {
    case petCafe = "petCafe"
    case workCafe = "workCafe"
    case highRankCafe = "highRankCafe"
    
    var title: String {
        switch self {
        case .petCafe:
            return "超可愛寵物咖啡廳"
        case .workCafe:
            return "適合工作咖啡廳"
        case .highRankCafe:
            return "熱門咖啡廳"
        }
    }
}
