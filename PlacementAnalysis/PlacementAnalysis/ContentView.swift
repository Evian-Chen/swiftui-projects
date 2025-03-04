//
//  ContentView.swift
//  PlacementAnalysis
//
//  Created by mac03 on 2025/2/28.
//

import SwiftUI

struct button: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 40))
            .fontWeight(.semibold)
            .background(Color.green)
            .cornerRadius(10)
            .padding(15.0)
            .clipShape(Capsule())
    }
}

struct ContentView: View {
    @State private var isAllowed = false
    @State private var showAlert = true
    
    var body: some View {
        VStack {
            if isAllowed {
                MainView()
            } else {
                Color.white.ignoresSafeArea()
            }
        }
        .alert("歡迎使用真·落點轉換器！", isPresented: $showAlert) {
            Button("是，繼續", role: .cancel) {
                isAllowed = true
            }
            Button("否，退出", role: .destructive) {
                exit(0)
            }
            .background(Color.orange)
        } message: {
            Text("🚨警告\n本應用程式涉及墜落過程模擬與描述，使用過程中可能感到心理不適，您確認使用此應用程式嗎？\n愛護生命，生命專線1995")
        }
    }
} // ContentView

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("落點分析") {
                    Placement()
                }
                .buttonStyle(button())
                
                NavigationLink("一般單位轉換") {
                    NormalUnitTransition()
                }
                .buttonStyle(button())
                
            } // VStack
            .navigationTitle("Main")
            .border(Color.red)
            
            
        } // NavigationStack
        .border(Color.red)
    }
}  // MainView

struct Placement: View {
    var placementTapped = false
    @State private var buildingIndex = 0
    @State private var planetIndex = 0
    @State private var height = 0
    @State private var weight = 0
    let buildings = ["自定義", "台北101", "高雄85大樓", "聯邦銀行大廈", "哈里發塔", "默迪卡118", "東京晴空塔", "上海中心大廈", "廣州塔", "加拿大國家電視塔"]
    let buildingHeight = [0, 509, 378, 310, 828, 679, 634, 632, 604, 553]
    let planet = ["地球", "火星", "金星", "木星", "土星"]
    
    var body: some View {
        NavigationStack {
            Section(header: Text("選擇建築或輸入高度（公尺）")) {
                Form {
                    Picker("建築", selection: $buildingIndex) {
                        ForEach(buildings.indices, id: \.self) {
                            index in Text(buildings[index])
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: buildingIndex) {
                        height = buildingHeight[buildingIndex]
                        
                    }
                    
                    TextField("高度（公尺）", value: $height, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        .onChange(of: height) {
                            if (!buildingHeight.contains(height)) {
                                buildingIndex = 0
                            } else {
                                buildingIndex = buildingHeight.firstIndex(of: height) ?? 0
                            }
                        }
                } // HStack
                .padding()
                
            } // Section, get height (meter)
            
            Section(header: Text("請輸入您的體重（公斤）")) {
                TextField("您的體重（公斤）", value: $weight, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .padding()
            } // Section, get weight
            
            Section(header: Text("選擇目前居住地")) {
                Picker("您的居住地", selection: $planetIndex) {
                    Text("null")
                }
                .padding()
            } // Section, get planet
        } // NavigationStack
    }
} // Placement

struct NormalUnitTransition: View {
    var body: some View {
        Text("Hello")
    }
}

#Preview {
    ContentView()
}
