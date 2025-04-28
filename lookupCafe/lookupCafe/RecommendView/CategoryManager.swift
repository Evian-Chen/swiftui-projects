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
    
    // TODO: read in all categories
    private func readInCategories() -> [String] {
        return [""]
    }
    
    private func findAllCategory() {
        return
    }
    
    
}

class Categoryobjc {
    var categoryName: String
    var data: DocumentSnapshot?
    
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
