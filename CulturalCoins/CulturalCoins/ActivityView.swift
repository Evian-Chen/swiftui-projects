//
//  ActivityView.swift
//  CulturalCoins
//
//  Created by Mac25 on 2025/3/19.
//

import SwiftUI

struct ActivityView: View {
    var body: some View {
        ZStack {
            Image("mainBackground")
                .resizable()
                .opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 190)
                        .padding(20)
                        .foregroundColor(.orange)
                        .padding(.bottom, 10)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .frame(height: 170)
                        .padding(30)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.bottom, 10)
                    
                    HStack {
                        Image("activityBanner")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 200)
                            .padding(.trailing, 10)
                        
                        VStack {
                            Text("開啟文藝新體驗")
                            Text("114.01.01 發放")
                        }
                        .bold()
                    }
                    
                }
                ActivityBlockView()
            }
        }
    }
}
