//
//  BookwormApp.swift
//  Bookworm
//
//  Created by hpclab on 2025/4/25.
//

import SwiftData
import SwiftUI

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchView()
        }
        .modelContainer(for: Book.self)
    }
}


struct LaunchView: View {
    @State private var isActive =  false
    @State private var opacity = 1.0
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                Image("Images")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Text("Welcome to my App")
                    .font(.headline)
                    .padding()
            }
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 3.0)) {
                    self.opacity = 0.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                    self.isActive = true
                }
            }
        }
    }
}
