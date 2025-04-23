//
//  Result.swift
//  BucketList
//
//  Created by Mac25 on 2025/4/23.
//

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    var id: Int { pageid }
    var description: String {
        terms?["description"]?.first ?? "no further informtion"
    }
    
    static func <(lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
