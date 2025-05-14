//
//  SettingsView.swift
//  Bookworm
//
//  Created by hpclab on 2025/4/25.
//

import SwiftData
import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("fontSize") private var fontSize = "medium"
    @AppStorage("showEmojiRating") private var showEmojiRating = true
    @AppStorage("booksPerPage") private var booksPerPage = "all"

    
    @Environment(\.modelContext) private var modelContext
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Display Mode")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                Section(header: Text("Font Size")) {
                    Picker("Font Size", selection: $fontSize) {
                        Text("Small").tag("small")
                        Text("Medium").tag("medium")
                        Text("Large").tag("large")
                    }
                    .pickerStyle(.segmented)
                }
                Section("Display Options") {
                    Toggle("Show Emoji Ratings", isOn: $showEmojiRating)
                }
                Section("單頁顯示數量") {
                    Picker("Books per Page", selection: $booksPerPage) {
                        Text("All").tag("all")
                        Text("5").tag("5")
                        Text("10").tag("10")
                    }
                    .pickerStyle(.segmented)
                }
                Button("Clear Data", role: .destructive) {
                    showingDeleteAlert = true
                }
            }
            .navigationTitle("Settings")
            .alert("Delete All Books?", isPresented: $showingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    Task {
                        do {
                            let descriptor = FetchDescriptor<Book>()
                            let books = try modelContext.fetch(descriptor)
                            for book in books {
                                modelContext.delete(book)
                            }
                            try modelContext.save()
                        } catch {
                            print("Failed to delete all books")
                        }
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }
}

#Preview {
    SettingsView()
}
