//
//  CategoryManager.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/28.
//

import Foundation
import FirebaseFirestore

class FirestoreManager {
    @Published var db: Firestore
    
    init() {
        self.db = Firestore.firestore()
    }
}

class CategoryManager: ObservableObject {
    // 每個對應的類別名稱，裡面都有一個那個分類的物件
    @Published var categoryObjcList: [String: Categoryobjc]?
    @Published var categories: [String]
    
    let categoryFile = "../Preview Content/categoryList.txt"
    
    // 管理整個firestore的物件
    private var fsManager = FirestoreManager()
    private var locManager = LocationDataManager()
    
    init(categoryObjcList: [String: Categoryobjc]?) async {
        self.categories = []
        self.categoryObjcList = await loadCategoryData()
        
        self.categories = readInCategories()
    }
    
    // TODO: loop through self.categories 裡面所有的類別，將其存到一個obj list
    private func loadCategoryData() async -> [String: Categoryobjc]? {
        for category in self.categories {
            do {
                let categoryData = try await fsManager.db.collection(category).getDocuments()
                
                // TODO: test
                for document in categoryData.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            } catch {
                print("error getting document: \(error)")
            }
            
            return nil
        }
        
        return nil
    }
    
    // 讀取txt檔案中所有的分類名稱（資料庫的）
    private func readInCategories() -> [String] {
        if let file = Bundle.main.url(forResource: categoryFile, withExtension: "txt") {
            do {
                let data = try String(contentsOf: file, encoding: .utf8)
                let lines = data.split(separator: "\n")
                return lines.map {String($0)}
            } catch {
                print("reading categoryFile error: \(error)")
            }
        }
        return []
    }
    
    private func findAllCategory() {
        return
    }
    
    
}

class Categoryobjc: ObservableObject {
    @Published var categoryName: String
    @Published var data: DocumentSnapshot?
    
    init() {
        self.categoryName = "nan"
        self.data = nil
    }
    
    // TODO: 在某個特定的分類底下，接收篩選條件，回傳篩選後的資料
//    private func findCategortCafe(category: String, filters: [String]) {
//        var category = category
//        var filters = filters
//    }
}
