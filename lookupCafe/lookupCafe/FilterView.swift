//
//  FilterView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/18.
//
import SwiftUI

let cities = ["所有城市", "台北市", "新北市", "嘉義市"]
let districts = ["所有地區", "新店區", "大安區", "中山區"]
let sockets = ["插座", "沒有插座", "少許插座", "很多插座"]
let wifi = ["網路", "有", "沒有"]
let stayTime = ["用餐時間", "有限制", "無限制"]

// 最後的套用按鈕要能夠回傳所有搜尋資料，回到前一個HeaderDetailView的時候，要能夠顯示過濾過的東西

enum filterOption {
    case cities
    case districts
    case sockets
    case wifi
    case statTime
    
    var optionsArr: [String] {
        switch self {
        case .cities:
            return ["所有城市", "台北市", "新北市", "嘉義市"]
        case .districts:
            return ["所有地區", "新店區", "大安區", "中山區"]
        case .sockets:
            return ["插座", "沒有插座", "少許插座", "很多插座"]
        case .wifi:
            return ["網路", "有", "沒有"]
        case .statTime:
            return ["用餐時間", "有限制", "無限制"]
        }
    
        var defalutStr: String {
            return self.optionsArr[0]
    }
}

struct filterPickerView: View {
//    Picker(selection: $selectedCity) {
//        ForEach(cities, id: \.self) { city in
//            Text(city)
//        }
//    } label: {
//        Text("選擇城市")
//            .font(.headline)
//    }
//
    @Binding var selectedString: String
    
    
    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

struct FilterView: View {
    @State private var searchText = ""
    @State private var isEditing = false
    
    @State private var selectedCity = "所有城市"
    @State private var selectedDistrict = "所有地區"
    @State private var selectedSocket = "插座"
    @State private var selectedWifi = "網路"
    @State private var selectedStayTime = "用餐時間"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("篩選條件")
                .font(.title)
                .bold()
                .padding(.horizontal)
            
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
                .font(.headline)
                .padding(10)
            
            List() {
                Picker(selection: $selectedCity) {
                    ForEach(cities, id: \.self) { city in
                        Text(city)
                    }
                } label: {
                    Text("選擇城市")
                        .font(.headline)
                }
                
                Picker(selection: $selectedDistrict) {
                    ForEach(districts, id: \.self) { d in
                        Text(d)
                    }
                } label: {
                    Text("選擇地區")
                        .font(.headline)
                }
                
                Picker(selection: $selectedSocket) {
                    ForEach(sockets, id: \.self) { s in
                        Text(s)
                    }
                } label: {
                    Text("插座使用")
                        .font(.headline)
                }
                
                Picker(selection: $selectedWifi) {
                    ForEach(wifi, id: \.self) { w in
                        Text(w)
                    }
                } label: {
                    Text("網路")
                        .font(.headline)
                }
                
                Picker(selection: $selectedStayTime) {
                    ForEach(stayTime, id: \.self) { time in
                        Text(time)
                    }
                } label: {
                    Text("用餐時間")
                        .font(.headline)
                }
            } // list
            
        } // vstack
        .padding(.top)
        
        Spacer()
    }
}

#Preview {
    FilterView()
}
