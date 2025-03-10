//
//  ContentView.swift
//  PlacementAnalysis
//
//  Created by mac03 on 2025/2/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Text("功能選單")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 20)
                    
                    NavigationLink("落點分析") {
                        AlertView()
                    }
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .padding(.horizontal, 40)

                    NavigationLink("一般單位轉換") {
                        NormalUnitTransition()
                    }
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .padding(.horizontal, 40)

                    Spacer()
                } // VStack
                .padding(.top, 50)
            } // ZStack
        } // NavigationStack
    }
} // ContentView

struct AlertView: View {
    @State private var isAllowed = false
    @State private var showAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            if isAllowed {
                Placement()
            }
        }
        .onAppear {
            showAlert = true
        }
        .alert("歡迎使用真·落點轉換器！", isPresented: $showAlert) {
            Button("是，繼續", role: .cancel) {
                isAllowed = true
            }
            Button("否，退出", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("🚨警告\n本應用程式涉及墜落過程模擬與描述，使用過程中可能感到心理不適，您確認使用此應用程式嗎？\n愛護生命，生命專線1995")
        }
    }
} // AlertView

struct Placement: View {
    
    var placementTapped = false
    @State private var buildingIndex = 0
    @State private var planetIndex = 0
    @State private var height = 0.0
    @FocusState private var heightFocused: Bool
    
    let buildings = ["自定義", "台北101", "高雄85大樓", "聯邦銀行大廈", "哈里發塔", "默迪卡118", "東京晴空塔", "上海中心大廈", "廣州塔", "加拿大國家電視塔"]
    let buildingHeight = [0, 509, 378, 310, 828, 679, 634, 632, 604, 553]
    let planet = ["地球", "火星", "金星", "木星", "土星"]
    let gravities = [9.81, 3.7278, 9.6138, 25.8984, 11.2815]
    
    @State var comments: [(ClosedRange<Double>, String)] = []
    @State private var time: Double = 0.0
    @State private var speed: Double = 0.0
    @State private var comment: String = "還活得好好的。"
    
    func calFalling() -> (Double, Double) {
        let fallHeight = height
        let g = gravities[planetIndex]
        let speed = sqrt(g * fallHeight * 2)
        let time = sqrt((2 * fallHeight) / g)
        return (time, speed)
    }
    
    func loadComments() -> [(ClosedRange<Double>, String)] {
        if let path = Bundle.main.path(forResource: "fallingComments", ofType: "txt") {
            var result: [(ClosedRange<Double>, String)] = []
            if let content = try? String(contentsOfFile: path) {
                let lines = content.components(separatedBy: "\n")
                
                for line in lines {
                    let parts = line.components(separatedBy: ", ")
                    if parts.count == 2 {
                        let rangeParts = parts[0].split(separator: "-").compactMap{ Double($0) }
                        if rangeParts.count == 2 {
                            let range = rangeParts[0]...rangeParts[1]
                            let comment = parts[1]
                            result.append((range, comment))
                        }
                    }
                }
            }
            return result
        }
        return []
    }
        
    func getFallingComment(for speed: Double) -> String {
        if comments.isEmpty {
            comments = loadComments()
        }
        for (range, comment) in comments {
            if range.contains(speed) {
                print("current range: \(range) ,comment: \(comment)")
                return comment
            }
        }
        if (speed > 442.94) {
            return "基本上人類到不了這種高度，除非從火箭掉出來。"
        }
        return ""
    }
    
    func updateFallingData() {
        (time, speed) = calFalling()
        comment = getFallingComment(for: speed)
    }
        
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea() // 設定背景顏色
                VStack {
                    Text("給您最實用的落點分析")
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 19.0)
                    
                    Form {
                        // 選擇建築或輸入高度
                        Section(header: Text("🏢 選擇建築或輸入高度").font(.headline)) {
                            VStack {
                                Picker("建築", selection: $buildingIndex) {
                                    ForEach(buildings.indices, id: \.self) { index in
                                        Text(buildings[index])
                                    }
                                }
                                .pickerStyle(.menu)
                                .onChange(of: buildingIndex) {
                                    height = Double(buildingHeight[buildingIndex])
                                }
                                .padding(.bottom, 5)
                                
                                TextField("高度（公尺）", value: $height, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .padding(.vertical, 5)
                                    .keyboardType(.decimalPad)
                                    .focused($heightFocused)
                                    .onChange(of: height) { _ in
                                        let roundedHeight = Int(height.rounded())
                                        if !buildingHeight.contains(Int(roundedHeight)) {
                                            buildingIndex = 0
                                        } else {
                                            buildingIndex = buildingHeight.firstIndex(of: roundedHeight) ?? 0
                                        }
                                        updateFallingData()
                                    }
                            }
                            .padding(.vertical, 5)
                        }
                        
                        // 選擇行星（重力影響）
                        Section(header: Text("🌍 選擇目前居住地").font(.headline)) {
                            VStack {
                                Picker("您的居住地", selection: $planetIndex) {
                                    ForEach(planet.indices, id: \.self) { index in
                                        Text(planet[index])
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding(.vertical, 5)
                                .onChange(of: planetIndex) { _ in
                                    updateFallingData()
                                }
                                
                                Text("當前重力加速度: **\(gravities[planetIndex], specifier: "%.2f") m/s²**")
                                    .foregroundColor(.blue)
                                    .font(.subheadline)
                                    .padding(.top, 5)
                            }
                        }
                        
                        // 顯示計算結果
                        Section(header: Text("📊 落點分析結果").font(.headline)) {
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("墜落時間: **\(time, specifier: "%.2f") 秒**")
                                    .font(.title2)
                                    .foregroundColor(.red)
                                
                                Text("墜地前速度: **\(speed, specifier: "%.2f") m/s**")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                            }
                            .padding(.vertical, 5)
                        }
                        
                        // 顯示結果分析
                        Section(header: Text("💀 下場").font(.headline)) {
                            Text(comment)
                        }
                    } // Form
                } // VStack
            } // ZStack
            .navigationTitle("落點轉換器")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if heightFocused {
                    Button("Done") {
                        heightFocused = false
                    }
                }
            }
        } // NavigationStack
    }
    
        
    } // Placement
    
struct NormalUnitTransition: View {
    @State private var showAlert = false
    @State private var curTempIndex = 0
    @State private var nextTempIndex = 0
    @State private var curUnit = ""
    @State private var nextUnit = ""
    @State private var curTemp = 0.0
    @State private var nextTemp = 0.0
    @FocusState private var focused: Bool
    let tempUnits = ["攝氏（Ｃ）", "華氏（F）", "克爾文（K）"]
    
    func transition() -> Double {
        switch curTempIndex {
        case 0:
            if (nextTempIndex == 1) { // C -> F
                return curTemp * (9 / 5) + 32
            } else if (nextTempIndex == 2) { // C -> K
                return curTemp + 273.15
            } else {
                return curTemp
            }
        case 1:
            if (nextTempIndex == 0) { // F -> C
                return (curTemp - 32) * (5 / 9)
            } else if (nextTempIndex == 2) { // F -> K
                return (curTemp - 32) * (5 / 9) + 273.15
            } else {
                return curTemp
            }
        case 2:
            if (nextTempIndex == 0) { // K -> C
                return curTemp - 273.15
            } else if (nextTempIndex == 1) { // K -> F
                return (curTemp - 273.15) * (9 / 5) + 32
            } else {
                return curTemp
            }
        default:
            return nextTemp
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white).ignoresSafeArea()
                
                VStack {
                    Section(header: Text("轉換前溫度").font(.headline)) {
                        HStack {
                            Picker("轉換前單位", selection: $curTempIndex) {
                                ForEach(tempUnits.indices, id: \.self) { index in
                                    Text(tempUnits[index])
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(width: 150, alignment: .leading)
                            .padding(.leading, 20)
                            
                            TextField("輸入溫度", value: $curTemp, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .focused($focused)
                                .padding(.trailing, 5)
                                .frame(width: 150)
                            
                            Stepper("", value: $curTemp, step: 1)
                                .labelsHidden()
                                .padding(.trailing, 10)
                        } // HStack
                        .padding(.vertical, 5)
                    } // Section
                    
                    Section(header: Text("轉換後溫度")) {
                        HStack {
                            Picker("轉換後單位", selection: $nextTempIndex) {
                                ForEach(tempUnits.indices, id: \.self) { index in
                                    Text(tempUnits[index])
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(width: 150, alignment: .leading)
                            .padding(.leading, 20)
                            
                            Text("\(nextTemp, specifier: "%.2f")")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                                .padding(.horizontal, 5)
                                .frame(width: 150, alignment: .leading)
                                .onChange(of: curTemp) {
                                    nextTemp = transition()
                                }
                                .onChange(of: nextTempIndex) {
                                    nextTemp = transition()
                                }
                                .onChange(of: curTempIndex) {
                                    nextTemp = transition()
                                }
                            
                        } // HStack
                        .frame(maxWidth: .infinity, alignment: .leading)
                    } // Section
                    
                } // VStack
            }
        } // VStack
        .navigationTitle("溫度轉換器")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if focused {
                Button("Done") {
                    focused = false
                }
            }
        }
        .onAppear {
            showAlert = true
        }
        .alert("這是一個普通的溫度轉換器", isPresented: $showAlert) {
            Button("好窩會有分數的ouob", role: .cancel){}
        } message: {
            Text("以防萬一那個落點轉換器不被當成單位轉換所以還是寫了一個溫度轉換器來保作業一的分數")
        }
    } // NavigationStack
}
    
#Preview {
    ContentView()
}
