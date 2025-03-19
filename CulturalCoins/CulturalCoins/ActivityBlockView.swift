//
//  ActivityBlockView.swift
//  CulturalCoins
//
//  Created by Mac25 on 2025/3/19.
//

import SwiftUI



//struct textView: View {
//    var text: String
//    var body: some View {
//        Text(text)
//            .font(.largeTitle)
//    }
//}

//enum activityType: String {
//    case news = "news"
//    case local = "local"
//    case movie = "movie"
//    
//    var titleText: AnyView {
//        return textView(text: self.rawValue)
//    }
//}

// 包含文字與scroll圖片
//struct TitleView: View {
//    var obj: activityType
//    
//    var body: some View {
//        obj.titleText
//    }
//}

struct ActivityBlockView: View {
    let activities = ["news", "local", "movie"]
    
    var body: some View {
        VStack {
            ForEach(activities.indices, id: \.self) { index in
//                TitleView(obj: activities[index])
                Text(activities[index])
            }
        }
    }
}

#Preview {
    ActivityBlockView()
}
