//
//  Enums.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/20.
//
import SwiftUI

// MARK: - TabItemObj
/// 定義底部 TabView 的圖示與文字
enum TabItemObj: String {
    case recommend = "sparkle.magnifyingglass"
    case map = "map.fill"
    case profile = "person.crop.circle"
    
    /// 對應的 SF Symbol 圖示
    var image: Image {
        Image(systemName: self.rawValue)
    }
    
    /// Tab 的顯示文字
    var text: Text {
        switch self {
        case .recommend: return Text("探索")
        case .map: return Text("首頁")
        case .profile: return Text("我的帳號")
        }
    }
}

// MARK: - FilterOptions
/// 定義篩選項目類型及對應選項內容
enum FilterOptions: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case cities = "城市"
    case districts = "地區"
    case sockets = "插座"
    case wifi = "網路"
    case stayTime = "用餐時間"
    
    /// 該篩選類別對應的選項陣列
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
    
    /// 用於顯示的標題文字（中文）
    var defaultStr: String {
        self.rawValue
    }
}

// MARK: - RecommendationCategory
/// 探索頁面中的推薦分類類型
enum RecommendationCategory: String {
    case petCafe = "petCafe"
    case workCafe = "workCafe"
    case highRankCafe = "highRankCafe"
    
    /// 顯示在 UI 上的中文標題
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
