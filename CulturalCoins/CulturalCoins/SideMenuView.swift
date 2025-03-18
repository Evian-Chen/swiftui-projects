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
    var body: some View {
        Text("")
    }
}

struct SideMenuView: View {
    // 控制畫面出現與否
    @Binding var isShowing: Bool
    
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
                        
                        Spacer()
                    }
                    .padding()
                    .frame(width: 270, alignment: .leading)
                    .background(.white)
                }
            }
        } // ZStack
        .animation(.easeInOut, value: isShowing)
    }
}
//
//#Preview {
//    SideMenuView(isShowing: .constant(true))
//}
