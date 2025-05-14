//
//  ContentView.swift
//  Bookworm
//
//  Created by hpclab on 2025/4/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("fontSize") private var fontSize = "medium"

    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "books.vertical")
                }
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .font(fontForSize(fontSize))
    }
    
    func fontForSize(_ size: String) -> Font {
        switch size {
        case "small": return .caption
        case "large": return .title3
        default: return .body
        }
    }
}

#Preview {
    ContentView()
}

