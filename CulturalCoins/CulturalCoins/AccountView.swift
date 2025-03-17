//
//  AccountView.swift
//  CulturalCoins
//
//  Created by mac03 on 2025/3/17.
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

struct AccountView: View {
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
                    Text("功能服務")
                        .bold()
                        .font(.title2)
                        .padding(.horizontal)
                        .foregroundColor(.green)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(toolButtons.indices, id: \.self) { index in
                            NavigationLink {
                                toolButtons[index].destinationView
                            } label: {
                                
                                // 按鈕本身
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.orange.opacity(0.1))
                                        .frame(width: 110, height: 120)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(.orange, lineWidth: 3)
                                        }
                                    
                                    // 按鈕上面的文字和圖片
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
                            }
                        } // ForEach
                    } // LazyVGrid
                } // VStack
            }
        }
    }
}

#Preview {
    AccountView()
}
