import SwiftUI

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

struct FilterPickerView: View {
    var filterOptionObj: FilterOptions
    @State private var selectedIndex = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(filterOptionObj.defaultStr)
                .font(.subheadline)
                .foregroundColor(.gray)

            Picker(selection: $selectedIndex) {
                ForEach(filterOptionObj.optionsArr.indices, id: \.self) { index in
                    Text(filterOptionObj.optionsArr[index])
                }
            } label: {
                EmptyView()
            }
            .pickerStyle(.menu)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

struct FilterView: View {
    @State private var searchText = ""
    @State private var isEditing = false
    @State private var reset = false
    @State private var apply = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // 標題
                    Text("篩選條件")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)

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
                        }
                    }
                    .padding(.horizontal)

                    // 標題
                    Text("一般篩選")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)

                    // Picker 區塊
                    ZStack(spacing: 20) {
                        ForEach(FilterOptions.allCases) { option in
                            FilterPickerView(filterOptionObj: option)
                        }
                    }
                }

                // 按鈕區
                HStack(spacing: 16) {
                    Button {
                        // 重置邏輯
                        reset.toggle()
                        searchText = ""
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
                        apply.toggle()
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
            }
            .navigationTitle("條件篩選")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FilterView()
}
