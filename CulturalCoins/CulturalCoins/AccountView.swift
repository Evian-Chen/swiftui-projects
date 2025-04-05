//
//  AccountView.swift
//  CulturalCoins
//
//  Created by mac03 on 2025/3/17.
//

import SwiftUI

struct TestView: View {
    var body: some View { Text("某個外部連結").bold().font(.title) }
}

struct CustomButtonData {
    let iconImageFile: String
    let text: String
    let destinationView: AnyView  // View 是一個 protocol，不能直接寫 View
}

struct BottomView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.blue.opacity(0.1))
            .frame(height: 100)
            .padding(20)
            .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
            .overlay(
                HStack(spacing: 15) {
                    Image(systemName: "phone.bubble")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("客服專線")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.black)
                        
                        Text("02-412-5252")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 15)
                }
            )
    }
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
                Image("mainBackground")
                    .resizable()
                    .ignoresSafeArea(.all, edges: .all)
                ScrollView {
                    // 整個畫面的layout
                    VStack {
                        // toolbar
                        HStack {
                            HStack(spacing: 20) {
                                Button {
                                    showOptionView = true
                                } label: {
                                    Image(systemName: "bell.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 28, height: 28)
                                        .foregroundColor(.blue)
                                }
                                
                                Button {
                                    showOptionView = true
                                } label: {
                                    Image(systemName: "barcode.viewfinder")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 28, height: 28)
                                        .foregroundColor(.blue)
                                }
                            }
                            
                            Spacer()
                            
                            Button {
                                showMenu.toggle()
                            } label: {
                                Image(systemName: "line.3.horizontal.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 35)
                        .frame(height: 50)
                        
                        // hello user
                        Text("Hello User!")
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)
                        
                        // 顯示剩餘金錢
                        HStack {
                            Image("coinIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 60)
                            
                            Text("$ 1200")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                            
                            Image(systemName: "arrowtriangle.forward.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 5)
                        .padding(.horizontal, 20)
                        .onTapGesture {
                            showOptionView = true
                        }
                        .padding(.bottom, 20)
                        
                        // 掃碼＋付款碼
                        HStack {
                            Button {
                                showOptionView = true
                            } label: {
                                Image(systemName: "qrcode.viewfinder")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 60)
                                    .padding(10)
                                Text("掃碼")
                                    .font(.headline)
                            }
                            .foregroundColor(.blue)
                            
                            
                            Image(systemName: "line.diagonal")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 50)
                                .rotationEffect(Angle(degrees: -40))
                                .foregroundColor(.blue)
                            
                            Button {
                                showOptionView = true
                            } label: {
                                Image(systemName: "qrcode")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 60)
                                    .padding(10)
                                Text("付款碼")
                                    .font(.headline)
                            }
                            .foregroundColor(.blue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 5)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                        
                        // 功能服務
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
                                                .fill(Color.orange.opacity(0.2))
                                                .frame(width: 110, height: 125)
                                                .shadow(color: Color.orange.opacity(0.3), radius: 5, x: 0, y: 3)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15)
                                                        .stroke(Color.orange, lineWidth: 3)
                                                )
                                            
                                        
                                            VStack {
                                                Image(toolButtons[index].iconImageFile)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 50, height: 50)
                                                    .padding(.bottom, 8)

                                                Text(toolButtons[index].text)
                                                    .bold()
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    }
                                } // ForEach
                            } // LazyVGrid
                            .padding(.horizontal, 20)
                        } // VStack
                        
                        // 底部資訊
                        BottomView()
                        
                    } // VStack
                }
                
                
                SideMenuView(isShowing: $showMenu)
                OptionView(isShowingOptionView: $showOptionView)
            } // ZStack
        } // navigationView
    }
}
