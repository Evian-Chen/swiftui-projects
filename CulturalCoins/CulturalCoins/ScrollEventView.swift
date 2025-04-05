//
//  ScrollEventView.swift
//  CulturalCoins
//
//  Created by Mac25 on 2025/3/19.
//

import SwiftUI

struct EventBlock: View {
    var body: some View {
        HStack {
            Image("testEventImage")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .padding(.trailing, 5)
            
            // 活動描述
            VStack(alignment: .leading) {
                Text("當代藝術博物館")
                    .bold()
                    .font(.headline)
                
                Spacer()
                
                HStack {
                    Text("2025/06/03~2026/12/08")
                        .font(.caption)
                    
                    Spacer()
                    
                    Image(systemName: "heart.circle")
                        .imageScale(.large)
                        .padding(.trailing, 20)
                        .foregroundColor(.orange)
                }
            } // VStack
            .padding(10)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(5)
        .shadow(radius: 5)
    }
}

struct ScrollEventView: View {
    var body: some View {
        VStack {
            ScrollView {
                ForEach(0 ..< 10) { number in
                    EventBlock()
                }
            }
        }
        .padding(.top, 20)
        .background(.white)
    }
}
