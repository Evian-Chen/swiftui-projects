//
//  ContentView.swift
//  CulturalCoins
//
//  Created by mac03 on 2025/3/16.
//

import SwiftUI

struct TestView: View {
    var body: some View { Text("test view") }
}

struct CustomButtonData {
    let iconImageFile: String
    let text: String
    let destinationView: AnyView  // View 是一個 protocol，不能直接寫 View
}

// 常用工具按鈕 外觀設定
struct ToolButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 110, height: 120)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.orange, lineWidth: 3)
            )
    }
}

struct ActivityView: View {
    // 使用陣列管理常用工具按鈕
    private var toolButtons: [CustomButtonData] = [
        CustomButtonData(iconImageFile: "coinIcon", text: "文化禮金", destinationView: AnyView(TestView())),
        CustomButtonData(iconImageFile: "receipt", text: "消費明細", destinationView: AnyView(TestView())),
        CustomButtonData(iconImageFile: "calendar", text: "活動收藏", destinationView: AnyView(TestView())),
        CustomButtonData(iconImageFile: "star", text: "加碼查詢", destinationView: AnyView(TestView())),
        CustomButtonData(iconImageFile: "chekcIn", text: "我要打卡", destinationView: AnyView(TestView()))
    ]
    
    var body: some View {
        // LazyVGrid
        let columns = Array(repeating: GridItem(.flexible()), count: 3)
        
        NavigationView {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                
                // 功能服務
                VStack(alignment: .leading, spacing: 20) {
                    // frequently used tools
                    Text("功能服務")
                        .bold()
                        .font(.title2)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(toolButtons.indices, id: \.self) { index in
                            NavigationLink {
                                toolButtons[index].destinationView
                            } label: {
                                VStack {
                                    Image(toolButtons[index].iconImageFile)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .padding(.bottom, 10)
                                    Text(toolButtons[index].text)
                                        .bold()
                                        .foregroundColor(.black)
                                }
                            }
                            .buttonStyle(ToolButtonStyle())
                        }
                    } // LazyVGrid
                }
            }
        }
    }
}

struct EventView: View {
    var body: some View {
        Text("EventView")
    }
}

struct ConsumeView: View {
    var body: some View {
        Text("ConsumeView")
        // 可以使用 ScrollView 實作滾動查看
    }
}

struct AccountView: View {
    var body: some View {
        Text("AccountView")
    }
}

// 列舉，包含一張圖示和一串文字
enum TabViewItemType: String {
    // 四種情況
    case flame = "flame.fill"
    case calendar = "calendar"
    case map = "map.fill"
    case person = "person.crop.circle"
    
    // 圖示
    var image: Image {
        return Image(systemName: self.rawValue)
    }
    
    // 文字
    var text: Text {
        switch self {
        case .flame: return Text("最HOT活動")
        case .calendar: return Text("藝文活動")
        case .map: return Text("藝文消費點")
        case .person: return Text("我的帳戶")
        }
    }
}

// TabItem 的視圖
struct TabViewItem: View {
    // 根據指定的type內容製作物件
    var type: TabViewItemType
    
    var body: some View {
        VStack {
            type.image
                .renderingMode(.template)
            type.text
        }
    }
}

struct MainView: View {
    var body: some View {
        TabView {
            // 最HOT活動
            ActivityView()
                .tabItem { TabViewItem(type: .flame) }
            // 藝文活動
            EventView()
                .tabItem { TabViewItem(type: .calendar) }
            // 藝文消費點
            ConsumeView()
                .tabItem { TabViewItem(type: .map) }
            // 我的帳戶
            AccountView()
                .tabItem { TabViewItem(type: .person) }
        }
        .accentColor(.orange)
    }
}

// loading page
struct LoadingView: View {
    @State private var opacityState: Double = 0
    @State private var isLoading = false
    @State private var yOffsetState: CGFloat = -100
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            Image("loadingLogo")
                .resizable()
                .scaledToFit()
                .padding(50)
                .opacity(opacityState)
                .offset(y: yOffsetState)
                .onAppear {
                    // 利用Task管理動畫排程
                    Task {
                        // 透明度 0->1
                        withAnimation(.easeIn(duration: 0.3)) {
                            opacityState = 1
                        }
                        try await Task.sleep(nanoseconds: 500_000_000)  // 等待0.5
                        
                        // 從y=-100動畫到y=0
                        withAnimation(.interpolatingSpring(stiffness: 200, damping: 5)) {
                            yOffsetState = 0
                        }
                        try await Task.sleep(nanoseconds: 2_000_000_000)
                        
                        // 淡出
                        withAnimation(.easeOut(duration: 1)) {
                            opacityState = 0
                        }
                        try await Task.sleep(nanoseconds: 500_000_000)
                        
                        // 4. 切換到 MainView
                        isLoading = true
                    }
                }
        }
        .fullScreenCover(isPresented: $isLoading) {
            MainView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        ZStack {
            LoadingView()
        }
    }
}

#Preview {
    ActivityView()
}


