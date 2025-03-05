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
                Color(.systemGray6) // 背景色（淺灰色）
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
    @State private var height = 0
    let buildings = ["自定義", "台北101", "高雄85大樓", "聯邦銀行大廈", "哈里發塔", "默迪卡118", "東京晴空塔", "上海中心大廈", "廣州塔", "加拿大國家電視塔"]
    let buildingHeight = [0, 509, 378, 310, 828, 679, 634, 632, 604, 553]
    let planet = ["地球", "火星", "金星", "木星", "土星"]
    let gravities = [9.81, 3.7278, 9.6138, 25.8984, 11.2815]
    
    func calFalling() -> (Double, Double) {
        let fallHeight = Double(height)
        let g = gravities[planetIndex]
        let speed = sqrt(g * fallHeight * 2)
        let time = sqrt((2 * fallHeight) / g)
        return (time, speed)
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
                                    height = buildingHeight[buildingIndex]
                                }
                                .padding(.bottom, 5)

                                TextField("高度（公尺）", value: $height, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .padding(.vertical, 5)
                                    .onChange(of: height) {
                                        if !buildingHeight.contains(height) {
                                            buildingIndex = 0
                                        } else {
                                            buildingIndex = buildingHeight.firstIndex(of: height) ?? 0
                                        }
                                    }
                            }
                            .padding(.vertical, 5)
                        }
                        .keyboardType(.decimalPad)

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

                                Text("當前重力加速度: **\(gravities[planetIndex], specifier: "%.2f") m/s²**")
                                    .foregroundColor(.blue)
                                    .font(.subheadline)
                                    .padding(.top, 5)
                            }
                        }

                        // 顯示計算結果
                        Section(header: Text("📊 落點分析結果").font(.headline)) {
                            let (time, speed) = calFalling()
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
                        Section(header: Text("💀 您的下場").font(.headline)) {
                            Text("hi")
                        }
                    } // Form
                } // VStack
            } // ZStack
            .navigationTitle("落點轉換器")
            .navigationBarTitleDisplayMode(.large)
        } // NavigationStack
    }

} // Placement

struct NormalUnitTransition: View {
    @State private var showAlert = false
    @State private var curTempIndex = 0
    @State private var nextTempIndex = 0
    @State private var curUnit = ""
    @State private var nextUnit = ""
    let tempUnits = ["攝氏（Ｃ）", "華氏（F）", "克爾文（K）"]
    
    func transition() -> Double {
        return 0.0
    }
    
    var body: some View {
        NavigationStack() {
            VStack() {
                Color(.systemGray4).ignoresSafeArea()
                
                VStack() {
                    Section(header: Text("選擇欲轉換的溫度單位").font(.headline)) {
                        Picker("轉換前單位", selection: $curTempIndex) {
                            ForEach(tempUnits.indices, id: \.self) { index in
                                Text(tempUnits[index])
                            }
                        }
                    } // Section
                    .border(.black)
                    
                } // VStack
            }
        } // VStack
        .onAppear {
            showAlert = true
        }
        .alert("這是一個普通的溫度轉換器", isPresented: $showAlert) {
            Button("好窩會有分數的ouob", role: .cancel){}
        } message: {
            Text("以防萬一那個落點轉換器不被當成單位轉換所以還是寫了一個溫度轉換器來保作業一的分數")
        }
    }
}

#Preview {
    NormalUnitTransition()
}
