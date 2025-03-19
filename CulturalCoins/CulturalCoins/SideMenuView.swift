//
//  SideMenuView.swift
//  CulturalCoins
//
//  Created by mac03 on 2025/3/18.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.circle")
                .imageScale(.large)
                .foregroundColor(.white)
                .padding(5)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.vertical)
                
            Text("Hello User!")
                .bold()
                .font(.headline)
        }
    }
}

struct RowView: View {
    let option: SideBarOptions
    @Binding var selectedOption: SideBarOptions?
    
    var selected: Bool {
        return option == selectedOption
    }
    
    var body: some View {
        HStack {
            option.icon
                .imageScale(.medium)
                .padding(.trailing, 10)
            Text(option.titleText)
                .font(.subheadline)
        }
        .frame(width: 140, alignment: .leading)
        .padding(10)
        .background(selected ? .blue.opacity(0.2) : .white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .foregroundColor(.blue)
    }
}

enum SideBarOptions: Int, CaseIterable, Identifiable {
    case website
    case location
    case serviceCall
    case deleteAccount
    case rating
    case logOut
    
    var icon: Image {
        switch self {
        case .website: return Image(systemName: "iphone.crop.circle")
        case .location: return Image(systemName: "storefront.circle")
        case .serviceCall: return Image(systemName: "phone.circle")
        case .deleteAccount: return Image(systemName: "trash.circle")
        case .rating: return Image(systemName: "iphone.crop.circle")
        case .logOut: return Image(systemName: "square.and.arrow.up.circle")
        }
    }
    
    var titleText: String {
        switch self {
        case .website: return "官方網站"
        case .location: return "藝文消費點"
        case .serviceCall: return "客服專線"
        case .deleteAccount: return "刪除帳號"
        case .rating: return "APP評分"
        case .logOut: return "登出"
        }
    }
    
    var id: Int { return self.rawValue }
}

struct SideMenuView: View {
    // 控制畫面出現與否
    @Binding var isShowing: Bool
    @State private var selectedOption: SideBarOptions?
    
    @State private var isShowingOptionView = false
    
    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .opacity(0.1)
                    .ignoresSafeArea()
                
                // HStack 是為了結合底下的 Spacer，把畫面推到右邊
                HStack {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HeaderView()
                        ForEach(SideBarOptions.allCases) { option in
                            Button {
                                selectedOption = option
                                isShowingOptionView.toggle()
                            } label: {
                                RowView(option: option, selectedOption: $selectedOption)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .frame(width: 270, alignment: .leading)
                    .background(.white)
                }
//                .padding(.top, 30)
            }
            
            if isShowingOptionView {
                OptionView(isShowingOptionView: $isShowingOptionView)
            }
        } // ZStack
        .animation(.easeInOut, value: isShowing)
        .onChange(of: isShowing) { oldValue, newValue in
            if !newValue {
                selectedOption = nil // 側邊欄關閉時重設選擇
            }
        }
        .onTapGesture {
            isShowing = false
        }
        
    }
}

