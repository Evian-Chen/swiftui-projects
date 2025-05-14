//
//  FavoritesView.swift
//  Bookworm
//
//  Created by hpclab on 2025/4/25.
//

import SwiftData
import SwiftUI

struct FavoritesView: View {
    @Query(filter: #Predicate<Book> { $0.isFavorite == true }) var favoriteBooks: [Book]

    var body: some View {
        NavigationStack {
            List {
                if favoriteBooks.isEmpty {
                    Text("You haven't favorited any books yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(favoriteBooks) { book in
                        NavigationLink(value: book) {
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationDestination(for: Book.self) { book in
                DetailView(book: book)
            }
        }
    }

}

#Preview {
    FavoritesView()
}

