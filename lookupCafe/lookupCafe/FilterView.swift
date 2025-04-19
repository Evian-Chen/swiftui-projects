//
//  FilterView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/18.
//
import SwiftUI

// 最後的套用按鈕要能夠回傳所有搜尋資料，回到前一個HeaderDetailView的時候，要能夠顯示過濾過的東西

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
            return ["全部", "有", "沒有"]
        case .stayTime:
            return ["全部", "有限制", "無限制"]
            
        }
    }
    
    var defaultStr: String {
        return self.rawValue
    }
}

struct filterPickerView: View {
    var filterOptionObj: FilterOptions
    @State private var selectedIndex = 0
    
    var body: some View {
        Picker(selection: $selectedIndex) {
            ForEach(filterOptionObj.optionsArr.indices) { index in
                Text(filterOptionObj.optionsArr[index])
            }
        } label: {
            Text(filterOptionObj.defaultStr)
                .font(.headline)
        }
    }
}

struct FilterView: View {
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var reset = false
    @State private var apply = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("篩選條件")
                .font(.title)
                .bold()
                .padding(.horizontal, 20)
            
            HStack {
                TextField("輸入關鍵字", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .onTapGesture {
                        isEditing = true
                    }
                
                if isEditing {
                    Button("Cancel") {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        isEditing = false
                        searchText = ""
                    }
                }
            } // hstack
            .padding(.horizontal)
            
            Text("一般篩選")
                .font(.title).bold()
                .padding([.leading, .top],  20)
            
            List {
                ForEach(FilterOptions.allCases) { option in
                    filterPickerView(filterOptionObj: option)
                }
            }
            .listStyle(.plain)
            .padding(.horizontal, 20)
        } // vstack
        .padding(.top)
        
        HStack(alignment: .center) {
            Button {
                // 還原所有選擇
            } label: {
                Text("重置")
                    .bold()
                    .font(.title2)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(10)
            
            Button {
                // 套用，關掉sheet，回傳所有資料
            } label: {
                Text("套用")
                    .bold()
                    .font(.title2)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(10)
        } // hstack\
        .padding(.horizontal, 20)
    }
}

#Preview {
    FilterView()
}
