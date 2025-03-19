//
//  TopToolBarView.swift
//  CulturalCoins
//
//  Created by Mac25 on 2025/3/19.
//

import SwiftUI

struct TopToolBarView: View {
    var body: some View {
        ZStack {
            HStack {
                HStack(spacing: 20) {
                    Button {

                    } label: {
                        Image(systemName: "bell.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.blue)
                    }
                    
                    Button {
                        
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
        }
    }
}
