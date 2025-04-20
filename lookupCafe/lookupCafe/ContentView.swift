//
//  ContentView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/4.
//

import SwiftUI

struct TabItemView: View {
    var obj: TabItemObj
    
    var body: some View {
        VStack {
            obj.image
            obj.text
        }
    }
}

struct ContentView: View {
    // 呼叫物件去管理城市行政區的資料
//    @StateObject var cityDistrictManager = LocationDataManager()
    
    @State private var city = ""
    @State private var district = ""
    
    var body: some View {
        TabView {
            RecommendView()
                .tabItem{ TabItemView(obj: .recommend) }
            
            MapView()
                .tabItem{ TabItemView(obj: .map) }
                .environmentObject(LocationDataManager())
            
            ProfileView()
                .tabItem{ TabItemView(obj: .profile) }
        }
    }
}

//#Preview {
//    ContentView()
//}
