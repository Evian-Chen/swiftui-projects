//
//  ContentView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/4.
//

import SwiftUI

enum TabItemObj: String {
    case recommend = "sparkle.magnifyingglass"
    case map = "map.fill"
    case profile = "person.crop.circle"
    
    var image: Image {
        return Image(systemName: self.rawValue)
    }
    
    var text: Text {
        switch self {
        case .recommend: return Text("探索")
        case .map: return Text("首頁")
        case .profile: return Text("我的帳號")
        }
    }
}

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

/**
 lookupCafe/
 │
 ├── Models/
 │   └── FilterQuery.swift          // 篩選條件 struct
 │   └── CafeInfoObject.swift       // 咖啡廳資料模型
 │   └── Enums.swift                // FilterOptions、TabItemObj 等 enum
 │
 ├── Views/
 │   ├── Common/
 │   │   ├── TabItemView.swift
 │   │   ├── CafeInfoCardView.swift
 │   │   └── TagViewGroup.swift
 │   │
 │   ├── Recommend/
 │   │   ├── RecommendView.swift
 │   │   ├── SectionHeaderView.swift
 │   │   ├── HeaderDetailView.swift
 │   │   └── FilterView.swift
 │   │
 │   ├── Map/
 │   │   ├── MapView.swift
 │   │   └── LocationDataManager.swift
 │   │
 │   └── Profile/
 │       └── ProfileView.swift
 │
 ├── Resources/
 │   └── Assets.xcassets/
 │   └── Preview Content/
 │
 ├── Utilities/
 │   └── Extensions.swift           // 可能的 View 擴充或 Binding 工具
 │
 └── ContentView.swift              // TabView 主畫面入口

 */
