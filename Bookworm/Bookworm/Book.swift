//
//  Book.swift
//  Bookworm
//
//  Created by Mac25 on 2025/4/30.
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

    init(title: String, author: String, genre: String, Rreview: String, rating: Int) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = Rreview
        self.rating = rating
    }
}
