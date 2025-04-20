import SwiftUI



struct FilterPickerView: View {
    var filterOptionObj: FilterOptions
    
    @State private var selectedIndex = 0
    
    @Binding var selected: String
    
    var body: some View {
        Picker(selection: $selected) {
            ForEach(filterOptionObj.optionsArr, id: \.self) { opt in
                Text(opt)
            }
        } label: {
            Text(filterOptionObj.defaultStr)
                .font(.title3)
        }
    }
}

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

struct FilterView: View {
    @Binding var curFilterQuery: FilterQuery
    @Binding var isPrestend: Bool
    
    @State private var reset = false
    @State private var apply = false
    @State private var newFilterQuery = FilterQuery()
    
    // 用FilterOptions type抓出對應的FilterQuery裡面的值
    func binding(for option: FilterOptions) -> Binding<String> {
        switch option {
        case .cities:
            return $newFilterQuery.cities
        case .districts:
            return $newFilterQuery.districts
        case .sockets:
            return $newFilterQuery.sockets
        case .wifi:
            return $newFilterQuery.wifi
        case .stayTime:
            return $newFilterQuery.stayTime
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                
                // Picker 區塊
                List {
                    ForEach(FilterOptions.allCases) { option in
                        FilterPickerView(filterOptionObj: option, selected: binding(for: option))
                    }
                }
                
                // 按鈕區
                HStack(spacing: 16) {
                    Button {
                        // 重置邏輯
                        reset.toggle()
                        newFilterQuery = FilterQuery()
                    } label: {
                        Text("重置")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(12)
                    }
                    
                    Button {
                        // 套用邏輯
                        curFilterQuery = newFilterQuery
                        isPrestend.toggle()
                    } label: {
                        Text("套用")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.top, 30)
                .padding(.horizontal)
                .padding(.bottom, 40)
                
                Spacer()
            }
            .navigationTitle("條件篩選")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    RecommendView()
}
