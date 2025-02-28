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

struct Placement: View {
    var placementTapped = false
    
    var body: some View {
        VStack {
            HStack {
                // 下拉式選單直接選擇大樓（直接同步公尺）
                // 輸入公尺
            } //  HStack
        } //  VStack
    }
}

struct NormalUnitTransition: View {
    var body: some View {
        Text("Hello")
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
        .alert("Welcome!", isPresented: $showAlert) {
            Button("OK") {
                isAllowed = true
            }
            Button("No") {
                exit(0)
            }
        } message: {
            Text("Do you agree to use this app?")
        }
}

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
    }
}

#Preview {
    ContentView()
}
