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
    
    @AppStorage("selectedGenre") private var selectedGenre = "All"
    @AppStorage("sortType") private var sortTypeRaw = "title"
    @AppStorage("showEmojiRating") private var showEmojiRating = true
    @AppStorage("booksPerPage") private var booksPerPage = "all"

    var sortedType: SortType {
        get {
            switch sortTypeRaw {
            case "author": return .author
            case "rating": return .rating
            default: return .title
            }
        }
        set {
            switch newValue {
            case .title: sortTypeRaw = "title"
            case .author: sortTypeRaw = "author"
            case .rating: sortTypeRaw = "rating"
            }
        }
    }

    
    var pagedBooks: [Book] {
        let result = filteredBooks
        switch booksPerPage {
        case "5":
            return Array(result.prefix(5))
        case "10":
            return Array(result.prefix(10))
        default:
            return result
        }
    }


    enum SortType {
        case title, author, rating
    }

    var body: some View {
        NavigationStack {
            Menu {
                Picker("Select Genre", selection: $selectedGenre) {
                    Text("All").tag("All")
                    ForEach(["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"], id: \.self) {
                        Text($0).tag($0)
                    }
                }
            } label: {
                HStack {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                    Text("Genre: \(selectedGenre)")
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 1, x: 0, y: 1)
                .padding(.horizontal)
            }

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
                    ForEach(pagedBooks) { book in
                        NavigationLink(value: book) {
                            HStack {
                                if showEmojiRating {
                                    EmojiRatingView(rating: book.rating)
                                        .font(.largeTitle)
                                } else {
                                    RatingView(rating: .constant(book.rating))
                                        .frame(width: 100)
                                }
                                VStack(alignment: .leading) {
                                    Text(book.title)
                                        .font(.headline)
                                    Text(book.author)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.horizontal, 20)
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
        let genreFiltered = selectedGenre == "All"
            ? sortedBooks
            : sortedBooks.filter { $0.genre == selectedGenre }

        if searchText.isEmpty {
            return genreFiltered
        } else {
            return genreFiltered.filter { book in
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
