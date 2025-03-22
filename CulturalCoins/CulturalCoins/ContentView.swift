//
//  ContentView.swift
//  CulturalCoins
//
//  Created by mac03 on 2025/3/16.
//

import SwiftUI

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
            GoogleMapView()
                .tabItem { TabViewItem(type: .map) }
            // 我的帳戶
            AccountView()
                .tabItem { TabViewItem(type: .person) }
        }
        .accentColor(.orange)
    }
}

// loading page animation
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
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        
                        // 切換到 MainView
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
