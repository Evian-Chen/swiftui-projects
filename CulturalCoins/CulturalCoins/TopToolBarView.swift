//
//  TopToolBarView.swift
//  CulturalCoins
//
//  Created by Mac25 on 2025/3/19.
//

import SwiftUI

struct TopToolBarView: View {
    @Binding var showingOption: Bool
    @Binding var showingMenu: Bool
    
    var body: some View {
        ZStack {
            HStack {
                HStack(spacing: 20) {
                    Button {
                        showingOption.toggle()
                    } label: {
                        Image(systemName: "bell.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.blue)
                    }
                    
                    Button {
                        showingOption.toggle()
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
                    showingMenu.toggle()
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
