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

let SamplePetCafes: [CafeInfoObject] = [
    CafeInfoObject(
        shopName: "毛孩樂園咖啡",
        city: "新北市",
        district: "新店區",
        address: "寶橋路123號",
        phoneNumber: "02-2912-3456",
        rating: 5,
        services: [true, true, false],
        types: ["pet", "garden", "family-friendly"],
        weekdayText: ["每日: 10:00–20:00"]
    ),
    CafeInfoObject(
        shopName: "狗狗日記咖啡廳",
        city: "台北市",
        district: "士林區",
        address: "天母東路66號",
        phoneNumber: "02-2831-9876",
        rating: 4,
        services: [true, false, true],
        types: ["pet", "brunch", "cozy"],
        weekdayText: ["週一至週五: 09:00–18:00", "週末: 10:00–19:00"]
    ),
    CafeInfoObject(
        shopName: "毛絨森林",
        city: "桃園市",
        district: "中壢區",
        address: "中央西路二段18號",
        phoneNumber: "03-4256-7788",
        rating: 4,
        services: [true, true, true],
        types: ["pet", "relax", "spacious"],
        weekdayText: ["每日: 11:00–20:00"]
    ),
    CafeInfoObject(
        shopName: "貓與咖啡",
        city: "台中市",
        district: "北區",
        address: "梅川西路三段99號",
        phoneNumber: "04-2233-1122",
        rating: 3,
        services: [true, false, false],
        types: ["pet", "instagrammable", "minimal"],
        weekdayText: ["平日: 10:00–18:00", "假日: 10:00–20:00"]
    ),
    CafeInfoObject(
        shopName: "萌寵咖啡屋",
        city: "高雄市",
        district: "左營區",
        address: "自由三路88號",
        phoneNumber: "07-312-5566",
        rating: 5,
        services: [true, true, true],
        types: ["pet", "child-friendly", "brunch"],
        weekdayText: ["週一至週五: 10:00–17:00", "週末: 09:00–18:00"]
    ),
    CafeInfoObject(
        shopName: "動物派對咖啡",
        city: "台南市",
        district: "中西區",
        address: "海安路二段11號",
        phoneNumber: "06-223-3344",
        rating: 4,
        services: [false, true, true],
        types: ["pet", "event", "themed"],
        weekdayText: ["每日: 12:00–22:00"]
    ),
    CafeInfoObject(
        shopName: "尾巴搖搖咖啡館",
        city: "新竹市",
        district: "東區",
        address: "光復路一段78號",
        phoneNumber: "03-567-1234",
        rating: 3,
        services: [true, false, true],
        types: ["pet", "casual", "light-meal"],
        weekdayText: ["週一至週日: 09:30–19:00"]
    )
]

// 用於查找篩選咖啡廳
struct FilterQuery {
    var keyword: [String] = [""]
    var cities: String = "全部"
    var districts: String = "全部"
    var sockets: String = "全部"
    var wifi: String = "全部"
    var stayTime: String = "全部"
}

//struct TagViewGroup

// 點進去之後出現該分類的每一間咖啡廳
struct HeaderDetailView: View {
    var categoryName: String
    @State private var showingSheetFilter = false
    @State var curFilterQuery: FilterQuery = FilterQuery()
    @State private var searchText = ""
    @State private var isEditing = false
    
    let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 10)
    ]
    
    var body: some View {
        NavigationStack {
            
            // 搜尋欄
            HStack {
                TextField("輸入關鍵字", text: $searchText)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .onTapGesture {
                        isEditing = true
                    }
                
                if isEditing {
                    Button("取消") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        isEditing = false
                        searchText = ""
                    }
                    .foregroundColor(.red)
                    
                    // 新增這個關鍵字，並增加到畫面上
                    Button("新增") {
                        curFilterQuery.keyword.append(searchText)
                    }
                } // if isEditing
            } // hstack
            .padding(.horizontal)
            
            // 印出篩選的內容
            LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                ForEach(Array(Mirror(reflecting: curFilterQuery).children.enumerated()), id: \.offset) { index, child in
                    if let label = child.label {
                        if ("\(child.value)" != "全部" && label != "keyword") {
                            Text("\(child.value)")
                                .bold()
                                .foregroundColor(.white)
                                .padding(7)
                                .background(.blue)
                                .cornerRadius(10)
                        }
                    }
                }
                
                ForEach(curFilterQuery.keyword.filter { !$0.isEmpty }, id: \.self) { word in
                    Text("\(word)")
                        .bold()
                        .foregroundColor(.white)
                        .padding(7)
                        .background(.blue)
                        .cornerRadius(10)
                }
            } // lazyVgrid
            .padding(20)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(0 ..< SamplePetCafes.count, id: \.self) { index in
                        CafeInfoCardView(cafeObj: SamplePetCafes[index])
                    }
                }
                .padding(.top)
            }
            .navigationTitle("這裡是 \(categoryName)")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSheetFilter = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                    }
                }
            }
            .sheet(isPresented: $showingSheetFilter) {
                FilterView(curFilterQuery: $curFilterQuery, isPrestend: $showingSheetFilter)
            }
        }
    }
}


// 定義每個header的外觀
struct SectionHeaderView: View {
    var categoryText: String
    
    var body: some View {
        NavigationLink(destination: HeaderDetailView(categoryName: categoryText)) {
            HStack {
                Text(categoryText)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
            )
            .padding(.horizontal, 20)
        }
        .buttonStyle(PlainButtonStyle())
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

struct CafeDetailView: View {
    var cafeObj: CafeInfoObject
    
    var body: some View {
        Text(cafeObj.shopName).font(.title)
    }
}

// struct CafeInfoView
struct CafeInfoCardView: View {
    var cafeObj: CafeInfoObject
    
    var body: some View {
        NavigationLink {
            CafeDetailView(cafeObj: cafeObj)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(cafeObj.shopName)
                        .font(.title3)
                        .bold()
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("\(cafeObj.city) \(cafeObj.district)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Text(cafeObj.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack(spacing: 2) {
                    ForEach(0 ..< cafeObj.rating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.footnote)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
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
        } header: {
            SectionHeaderView(categoryText: category.title)
        }
    }
}


struct RecommendView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 24, pinnedViews: .sectionHeaders) {
                    RecommendationSectionView(category: .petCafe)
                    RecommendationSectionView(category: .workCafe)
                    RecommendationSectionView(category: .highRankCafe)
                }
                .padding(.vertical)
            }
            .navigationTitle("推薦咖啡廳")
        }
    }
}


#Preview {
    RecommendView()
}

