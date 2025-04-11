//
//  RecommendView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/9.
//

import SwiftUI

// global testing data
let sampleCafes: [CafeInfoObject] = [
    CafeInfoObject(
        shopName: "喵喵森林咖啡",
        city: "台北市",
        district: "中山區",
        address: "中山北路二段33號",
        phoneNumber: "02-1234-5678",
        rating: 5,
        services: [true, true, false],
        types: ["pet", "relax", "instagrammable"],
        weekdayText: ["週一至週五: 10:00–20:00", "週末: 09:00–21:00"]
    ),
    CafeInfoObject(
        shopName: "森林工作咖啡廳",
        city: "台北市",
        district: "大安區",
        address: "和平東路一段77號",
        phoneNumber: "02-9876-5432",
        rating: 4,
        services: [true, false, true],
        types: ["work", "wifi", "quiet"],
        weekdayText: ["每日: 08:00–22:00"]
    ),
    CafeInfoObject(
        shopName: "咖啡喵星球",
        city: "新北市",
        district: "板橋區",
        address: "文化路二段188號",
        phoneNumber: "02-3344-5566",
        rating: 3,
        services: [true, true, true],
        types: ["pet", "work", "spacious"],
        weekdayText: ["週一至週日: 10:00–19:00"]
    ),
    CafeInfoObject(
        shopName: "悠然時光咖啡",
        city: "台中市",
        district: "西區",
        address: "公益路100號",
        phoneNumber: "04-2255-3344",
        rating: 4,
        services: [true, false, false],
        types: ["relax", "brunch"],
        weekdayText: ["平日: 09:00–18:00", "假日: 10:00–20:00"]
    ),
    CafeInfoObject(
        shopName: "光合作用書咖啡",
        city: "台南市",
        district: "東區",
        address: "東門路一段88號",
        phoneNumber: "06-2255-6677",
        rating: 5,
        services: [true, true, true],
        types: ["work", "study", "quiet"],
        weekdayText: ["每日: 08:30–21:30"]
    ),
    CafeInfoObject(
        shopName: "Daily Beans",
        city: "台北市",
        district: "信義區",
        address: "松山路10巷5號",
        phoneNumber: "02-5566-7788",
        rating: 4,
        services: [true, false, true],
        types: ["hipster", "instagrammable", "brunch"],
        weekdayText: ["週一至週五: 09:00–17:00", "週末公休"]
    ),
    CafeInfoObject(
        shopName: "Chill Corner Cafe",
        city: "新竹市",
        district: "北區",
        address: "北門街60號",
        phoneNumber: "03-3456-7890",
        rating: 3,
        services: [false, true, false],
        types: ["pet", "casual", "local"],
        weekdayText: ["每日: 10:00–18:00"]
    )
]



// 定義每個header的外觀
struct SectionHeaderView: View {
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.title2)
                .bold()
                
            Spacer()
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBlue)))
        .padding(.horizontal, 20)
    }
}

// 浮動header的種類
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

// 這個struct包含了要顯示出的咖啡廳的重要資訊
struct CafeInfoObject {
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
}

// struct CafeInfoView
struct CafeInfoCardView: View {
    var cafeObj: CafeInfoObject
    
    var body: some View {
        Button {
            // 點擊後連接到該咖啡廳的詳細資料，包含評論和地圖等等
        } label: {
            HStack {
                // 左側文字排列
                VStack(alignment: .leading) {
                    Text(cafeObj.shopName).font(.title).bold()
                    
                    HStack {
                        Text(cafeObj.address)
                        
                        Spacer()//star.leadinghalf.filled
                        
                        ForEach(0 ..< cafeObj.rating, id: \.self) { index in
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                        }
                    }
                }
                .multilineTextAlignment(.leading)
                .padding(.leading, 10)
                .foregroundColor(.black)
                
                Spacer()
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(5)
            .padding(.horizontal, 20)
        }
    }
}

// 定義每個section，包含header和咖啡廳的內容
struct RecommendationSectionView: View {
    var category: RecommendationCategory
    
    var body: some View {
        Section {
            // 從資料庫抓出對應資料裝入CafeInfoObject，再依序顯示，一次最多顯示五筆
            ForEach(0 ..< 5, id: \.self) { index in
                CafeInfoCardView(cafeObj: sampleCafes[index])
            }
            
            // 要增加按鈕，點擊可以看更多店家，應該要連接到另一個View
            
        } header: {
            SectionHeaderView(text: category.title)
        }
    }
}


struct RecommendView: View {
    var body: some View {
        // 上方應該補上一片的空白，可能適用navigationView
        
        ScrollView {
            LazyVStack(pinnedViews: .sectionHeaders) {
                RecommendationSectionView(category: .petCafe)
                RecommendationSectionView(category: .workCafe)
                RecommendationSectionView(category: .highRankCafe)
            }
        }
    }
}


#Preview {
    RecommendView()
}
