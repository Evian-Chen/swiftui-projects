//
//  OptionView.swift
//  CulturalCoins
//
//  Created by mac03 on 2025/3/18.
//

import SwiftUI

struct OptionView: View {
    @Binding var isShowingOptionView: Bool
    
    var body: some View {
        if isShowingOptionView {
            ZStack {
                Color.black.opacity(0.3).ignoresSafeArea()

                VStack(spacing: 20) {
                    Image("loadingLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 180)
                        .padding(.top, 10)
                    
                    Text("我不會插入外部連結 ouob")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .multilineTextAlignment(.center)
                    
                    Button {
                        isShowingOptionView = false
                    } label: {
                        Text("關閉畫面")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.85))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(radius: 5)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(20)
                .frame(width: 280, height: 360)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
                .transition(.scale)
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isShowingOptionView)
            } // ZStack
        }
        
    }
}
