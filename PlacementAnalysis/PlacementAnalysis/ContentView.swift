//
//  ContentView.swift
//  PlacementAnalysis
//
//  Created by mac03 on 2025/2/28.
//

import SwiftUI

struct button: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 40))
            .fontWeight(.semibold)
            .background(Color.orange) // Background color of the square
            .cornerRadius(10) // Optional: Round the corners of the square
            .padding(10)
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Button("落點分析") {}
                    .buttonStyle(button())
                
                Button("一般單位轉換") {}
                    .buttonStyle(button())
            } // VStack
            .border(Color.red)
            
        } // NavigationStack
    }
}

#Preview {
    ContentView()
}
