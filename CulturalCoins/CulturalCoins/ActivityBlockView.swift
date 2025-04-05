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


// 包含文字與scroll圖片
//struct TitleView: View {
//    var obj: activityType
//
//    var body: some View {
//        obj.titleText
//    }
//}

// 包含文字與scroll圖片
enum activityType: String, CaseIterable {
    case news = "news"
    case local = "local"
    case movie = "movie"
    
    // 文字顯示設定
    var titleText: TitleTextView {
        return TitleTextView(title: self.rawValue)
    }
    
    // 圖片滾動設定
    func activityScroll(showOption: Binding<Bool>) -> activityScrollView {
        return activityScrollView(title: self.rawValue, showOption: showOption)
    }
}

struct activityScrollView: View {
    var title: String
    @Binding var showOption: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                ForEach(0 ..< 5) { index in
                    ImageBlockView(showOption: $showOption)
                }
            }
        }
        .padding(.horizontal, 20)
        
    }
}

// 每一張圖片的設定
struct ImageBlockView: View {
    @Binding var showOption: Bool
    
    var body: some View {
        Button {
            showOption.toggle()
        } label: {
            VStack {
                Image("activitySample")
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 10)
                
                Text("內文內文內文")
                    .foregroundStyle(.gray)
            }
            .frame(width: 170, height: 230)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 5)
            .padding(.vertical, 10)
            .padding(.leading, 3)
        }
    }
}

// 標題的顯示設定視圖
struct TitleTextView: View {
    let title: String
    var subTitle: String {
        switch title {
        case "news": return "最新消息"
        case "local": return "在地精選"
        case "movie": return "經典電影"
        default: return "unknown"
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(subTitle)
                    .font(.title)
                
                Text(title)
                    .font(.title2)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
    }
}

struct ActivityBlockView: View {
    @State var showOption = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                ScrollView {
                    ForEach(activityType.allCases, id: \.self) { activity in
                        activity.titleText
                        activity.activityScroll(showOption: $showOption)
                    }
                }
            }
            
            OptionView(isShowingOptionView: $showOption)
        }
    }
}

