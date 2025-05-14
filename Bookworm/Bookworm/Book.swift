//
//  Book.swift
//  Bookworm
//
//  Created by hpclab on 2025/4/25.
//

import Foundation
import SwiftData

@Model
class Book {
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int
    var isFavorite: Bool = false

    init(title: String, author: String, genre: String, review: String, rating: Int) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
        self.isFavorite = false
    }
}
