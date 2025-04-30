//
//  RecommendView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/9.
//

import SwiftUI

// 點進去之後出現該分類的每一間咖啡廳
struct HeaderDetailView: View {
    var categoryName: String
    @State private var showingSheetFilter = false
    @State var curFilterQuery: FilterQuery = FilterQuery()
    @State private var searchText = ""
    @State private var showingDeleteAlert = false
    @State private var labelToDel: String? = ""
    @State private var keywordToDel: String? = nil
    @FocusState private var isFocued: Bool
    
    @EnvironmentObject private var categoryManager: CategoryManager
    
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
                    .focused($isFocued)
                
                if isFocued {
                    Button("取消") {
                        isFocued = false
                        searchText = ""
                    }
                    .foregroundColor(.red)
                    
                    // 新增這個關鍵字，並增加到畫面上
                    Button("新增") {
                        if !searchText.isEmpty {
                            curFilterQuery.keyword.append(searchText)
                            searchText = ""
                            isFocued = false
                        }
                    }
                } // if isEditing
            } // hstack
            .padding(.horizontal)
            
            // 印出篩選的內容
            LazyVGrid(columns: columns, alignment: .leading) {
                ForEach(Array(Mirror(reflecting: curFilterQuery).children.enumerated()), id: \.offset) { index, child in
                    if let label = child.label {
                        if ("\(child.value)" != "全部" && label != "keyword") {
                            Button {
                                showingDeleteAlert = true
                                labelToDel = label
                            } label: {
                                Text("\(child.value)")
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(7)
                                    .background(.blue)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                
                ForEach(curFilterQuery.keyword.filter { !$0.isEmpty }, id: \.self) { word in
                    Button {
                        showingDeleteAlert = true
                        labelToDel = "keyword"
                        keywordToDel = word
                    } label: {
                        Text("\(word)")
                            .bold()
                            .foregroundColor(.white)
                            .padding(7)
                            .background(.blue)
                            .cornerRadius(10)
                    }
                }
            } // lazyVgrid
            .padding(20)
            .alert("確定要刪除這個關鍵字嗎？", isPresented: $showingDeleteAlert) {
                Button("取消", role: .cancel) { }
                Button("刪除", role: .destructive) {
                    if labelToDel == "keyword" {
                        if let index = curFilterQuery.keyword.firstIndex(of: keywordToDel ?? "") {
                            curFilterQuery.keyword.remove(at: index)
                        }
                    } else {
                        switch labelToDel {
                        case "cities":
                            curFilterQuery.cities = "全部"
                        case "districts":
                            curFilterQuery.districts = "全部"
                        case "sockets":
                            curFilterQuery.sockets = "全部"
                        case "wifi":
                            curFilterQuery.wifi = "全部"
                        case "stayTime":
                            curFilterQuery.stayTime = "全部"
                        default:
                            break
                        }
                    }
                }
            }
            
            ScrollView {
                VStack(spacing: 16) {
                    // TODO: 改成使用 categoryManager 去顯示
                    
                    ForEach(categoryManager.categoryObjcList[categoryName]!.cleanCafeData, id: \.self) { cafeObj in
                        CafeInfoCardView(cafeObj: cafeObj)
                    }
                    
//                    ForEach(0 ..< SamplePetCafes.count, id: \.self) { index in
//                        CafeInfoCardView(cafeObj: SamplePetCafes[index])
//                    }
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
                        Image(systemName: "slider.horizontal.3")
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

