//
//  main.swift
//  testLookUpCafe
//
//  Created by mac03 on 2025/4/29.
//

import Foundation

// TODO: read in all categories
func readInCategories() -> [String] {
    let filePath = "./categoryFile.txt"
    
    do {
        let data = try String(contentsOfFile: filePath, encoding: .utf8)
        let lines = data.split(separator: "\n")
        return lines.map {String($0)}
    } catch {
        print("reading categoryFile error: \(error)")
    }
    
    return []
}

let categories = readInCategories()
print(categories)
