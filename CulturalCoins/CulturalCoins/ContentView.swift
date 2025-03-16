//
//  ContentView.swift
//  CulturalCoins
//
//  Created by mac03 on 2025/3/16.
//

import SwiftUI

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
                        try await Task.sleep(nanoseconds: 1_000_000_000)
                        
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

struct ContentView: View {var body: some View {
    ZStack {
        LoadingView()
    }
}
} // ContentView

struct MainView: View {
    var body: some View {
        Text("Hello")
    }
}

#Preview {
    ContentView()
}


