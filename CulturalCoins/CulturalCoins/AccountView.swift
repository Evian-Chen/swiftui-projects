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
    
    @State private var showMenu = false
    @State private var showOptionView = false
    
    var body: some View {
        // LazyVGrid
        let columns = Array(repeating: GridItem(.flexible()), count: 3)
        
        NavigationView {
            ZStack {
                Color(.white)
                    .ignoresSafeArea()
                
                // 整個畫面的layout
                VStack {
                    // hello user 畫面
                    RoundedRectangle(cornerRadius: 15)
                        .frame(maxWidth: .infinity)
                        .frame(height: 130)
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 10)
                        .opacity(0.3)
                    
                    // 掃碼＋付款碼
                    ZStack {
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color.green.opacity(0.1))
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                            .padding([.leading, .trailing], 30)

                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.green, lineWidth: 3)
                            .frame(maxWidth: .infinity)
                            .frame(height: 100)
                            .padding(20)
                    }
                    
                    // 功能服務
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("功能服務")
                                .bold()
                                .font(.title2)
                                .padding(.horizontal, 20)
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
                                                .frame(width: 105, height: 120)
                                                .padding(.horizontal, 30)
                                                .padding(.vertical, 5)
                                                .overlay {
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(.orange, lineWidth: 3)
                                                        .padding(.horizontal, 25)
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
                                        } // ZStack
                                    }
                                } // ForEach
                            } // LazyVGrid
                            .padding(.horizontal, 20)
                        } // VStack
                        
                        // 底部資訊
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color.blue.opacity(0.1))
                            .padding([.horizontal, .top], 20)
                            .frame(height: 150)
                    }
                    
                } // VStack
                
                SideMenuView(isShowing: $showMenu)
                OptionView(isShowingOptionView: $showOptionView)
            } // ZStack
            .toolbar() {
                // bell
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showOptionView = true
                    } label: {
                        Image(systemName: "bell.circle")
                            .resizable()
                            .scaleEffect(1.3)
                    }
                    .padding(.leading, 20)
                }
                
                // barcode
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showOptionView = true
                    } label: {
                        Image(systemName: "barcode.viewfinder")
                            .resizable()
                            .scaleEffect(1.3)
                    }
                }
                
                // side menu
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showMenu.toggle()
                    } label: {
                        Image(systemName: showMenu ? "x.circle" : "line.3.horizontal.circle")
                            .resizable()
                            .scaleEffect(1.3)
                            .padding(.trailing, 20)
                    }
                }
            } // toolbar
            
        } // navigationView
        
        
    }
}

#Preview {
    AccountView()
}
