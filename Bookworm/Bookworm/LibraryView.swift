//
//  ContentView.swift
//  Bookworm
//
//  Created by hpclab on 2025/4/25.
//

import SwiftData
import SwiftUI

struct LibraryView: View {
    @Environment(\.modelContext) var modelContext
    @Query var books: [Book]

    @State private var showingAddScreen = false
    @State private var sortType = SortType.title
    @State private var searchText = ""

    enum SortType {
        case title, author, rating
    }

    var body: some View {
        NavigationStack {
            List {
                if books.isEmpty {
                    Text("There are no books yet. Tapping the plus (+) button in the top to add one.")
                        .foregroundStyle(.secondary)
                        .padding()
                } else if filteredBooks.isEmpty {
                    Text("No results found.")
                        .foregroundStyle(.secondary)
                        .padding()
                } else {
                    ForEach(filteredBooks) { book in
                        NavigationLink(value: book) {
                            HStack {
                                EmojiRatingView(rating: book.rating)
                                    .font(.largeTitle)
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                        .font(.headline)
                                    Text(book.author)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                book.isFavorite.toggle()
                            } label: {
                                Label(book.isFavorite ? "Unfavorite" : "Favorite", systemImage: book.isFavorite ? "star.slash" : "star")
                            }
                            .tint(.yellow)
                        }
                    }
                    .onDelete(perform: deleteBooks)
                }
            }
            .navigationTitle("Bookworm")
            .navigationDestination(for: Book.self) { book in
                DetailView(book: book)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .principal) {
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Book", systemImage: "plus") {
                        showingAddScreen.toggle()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            sortType = .title
                        } label: {
                            Label("Title", systemImage: "textformat")
                        }
                        Button {
                            sortType = .author
                        } label: {
                            Label("Author", systemImage: "person")
                        }
                        Button {
                            sortType = .rating
                        } label: {
                            Label("Rating", systemImage: "star")
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
    
    var sortedBooks: [Book] {
        switch sortType {
        case .title:
            return books.sorted { $0.title < $1.title }
        case .author:
            return books.sorted { $0.author < $1.author }
        case .rating:
            return books.sorted { $0.rating > $1.rating }
        }
    }
    
    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return sortedBooks
        } else {
            return sortedBooks.filter { book in
                book.title.localizedCaseInsensitiveContains(searchText) ||
                book.author.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            modelContext.delete(book)
        }
    }
}

#Preview {
    LibraryView()
}
