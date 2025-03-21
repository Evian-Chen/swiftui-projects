//
//  ContentView.swift
//  GoogleMapTest
//
//  Created by mac03 on 2025/3/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("📍 台北 101 地圖")
                .font(.headline)
                .padding()

            GoogleMapView()
                .frame(height: 400)
                .cornerRadius(12)
                .shadow(radius: 5)

            Spacer()
        }
        .padding()
    }
}
