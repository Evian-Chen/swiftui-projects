//
//  StatsView.swift
//  Bookworm
//
//  Created by hpclab on 2025/4/25.
//

import SwiftData
import SwiftUI

struct StatsView: View {
    @Query var books: [Book]
    
    var genreStats: [String: (count: Int, avgRating: Double)] {
        let grouped = Dictionary(grouping: books, by: { $0.genre })
        var stats: [String: (Int, Double)] = [:]
        
        for (genre, booksInGenre) in grouped {
            let count = booksInGenre.count
            let totalRating = booksInGenre.map { $0.rating }.reduce(0, +)
            let avgRating = Double(totalRating) / Double(count)
            stats[genre] = (count, avgRating)
        }
        
        return stats
    }
    
    var mostReadGenre: String? {
        genreStats.max { $0.value.count < $1.value.count }?.key
    }

    var body: some View {
        NavigationStack {
            List {
                if books.isEmpty {
                    Text("No books to analyze yet.")
                        .foregroundStyle(.secondary)
                } else {
                    Section("Most Read Genre") {
                        if let top = mostReadGenre {
                            Text("🏆 \(top)")
                        }
                    }

                    Section("Genre Stats") {
                        ForEach(genreStats.sorted(by: { $0.key < $1.key }), id: \.key) { genre, stat in
                            VStack(alignment: .leading) {
                                Text(genre)
                                    .font(.headline)
                                Text("Books: \(stat.count), Avg Rating: \(String(format: "%.1f", stat.avgRating))")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
            .navigationTitle("Stats")
        }
    }
}

