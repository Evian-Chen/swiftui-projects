//
//  ContentView.swift
//  Bookworm
//
//  Created by mac03 on 2025/4/30.
//

import SwiftUI
import SwiftData

struct emojiRatingView: View {
    let rating: Int
    
    var body: some View {
        switch rating {
        case 1:
            Text("。")
        case 2:
            Text("。。")
        case 3:
            Text("。。。")
        case 4:
            Text("。。。。")
        case 5:
            Text("。。。。。")
        default:
            Text("X")
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\Book.title)]) var books: [Book]
    
    @State private var showingAddScreen = false
    @State private var sortType = SortType.title
    
    enum SortType {
        case title, author, rating
    }
    
    var filterBooks: [Book] {
        if searchText.isEmpty {
            return sortedBook
        } else {
            return sortedBook.filter { book in
                book.title.localizedStandardContains(searchText) ||
                book.author.localizedStandardContains(searchText)
            }
        }
    }
    
    var sortedBook: [Book] {
        switch sortType {
        case .title:
            return books.sorted { $0.title < $1.title }
            
        case .author:
            return books.sorted { $0.author < $1.author }
        case .rating:
            return books.sorted { $0.rating < $1.rating }
        }
    }
    
    var body: some View {
        Text(String(books.count))
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            emojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                Text(book.author)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .navigationDestination(for: Book.self) { book in
                DetailView(book: book)
            }
            .toolbar {
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
                        Image("arrow.up.arrow.down")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add book", systemImage: "plus") {
                        showingAddScreen.toggle()
                    }
                }
                List {
                    if books.isEmpty {
                        Text("there's no book yet")
                            .foregroundStyle(.secondary)
                            .padding()
                    } else if filterBooks.isEmpty {
                        Text("no result")
                            .foregroundStyle(.secondary)
                            .padding()
                    } else {
                        ForEach(filterBooks) { book in
                            
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
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
    ContentView()
}
