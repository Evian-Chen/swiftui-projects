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
    @Published var categoryObjcList: [String: Categoryobjc]
    @Published var categories: [String]
    
    let categoryFile = "../Preview Content/categoryList.txt"
    
    // 管理整個firestore的物件
    private var fsManager = FirestoreManager()
    private var locManager = LocationDataManager()
    
    init() {
        self.categoryObjcList = [:]
        self.categories = []
    }
    
    func asyncInit() async {
        // 賦值
        self.categories = readInCategories()
        self.categoryObjcList = await loadCategoryData()
    }
    
    // loop through self.categories 裡面所有的類別，將其存到一個obj list
    private func loadCategoryData() async -> [String: Categoryobjc] {
        var result: [String: Categoryobjc] = [:]
        var categoryData: QuerySnapshot? = nil
        
        for category in self.categories {
            // 製作該分類的物件
            let categoryObjc = Categoryobjc(categoryName: category, data: [])
            
            do {
                // categoryData 是 QuerySnapshot
                categoryData = try await fsManager.db.collection(category).getDocuments()

                print("load in data, fetch from: \(category)")
                
                for cityDoc in categoryData!.documents {
                    let city = cityDoc.documentID
                    
                    // 檢查該行政區有在該城市內
                    guard let districts = locManager.cityDistricts[city] else {
                        print("\(city) not exists")
                        continue
                    }
                    
                    //
                    for district in districts {
                        let districtRef = cityDoc.reference.collection(district)
                        let cafeDoc = try await districtRef.getDocuments()
                        
                        // cafeData.data() 可叫出單筆的咖啡廳資料
                        for cafeData in cafeDoc.documents {
                            categoryObjc.data.append(cafeData.data())
                        }
                    }
                }
            } catch {
                print("error getting document: \(error)")
            }
            
            // 將該分類的物件加入物件陣列
            categoryObjc.makeCleanData()
            result[category] = categoryObjc
        }
        
        return result
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
    
    /**
     參考：
     print("shop name: \(cafeData.documentID)")
     print("try address")
     print(cafeData.data()["formatted_address"] ?? "nothing")
     
     被呼叫時加入的是cafeData.data()
     cafeData.documentID是String
     cafeData.data()是Any
     []可以直接對資料取值
     */
    @Published var data: [[String : Any]]
    
    @Published var cleanCafeData: [CafeInfoObject]
    
    init(categoryName: String, data: [[String : Any]]) {
        self.categoryName = categoryName
        self.data = data
        self.cleanCafeData = []
    }
    
    func makeCleanData(){
        print("start to check data")
        
        var cafeInfoObjList: [CafeInfoObject] = []
        
        for cafe in self.data {
            let servicesDict = cafe["services"] as? [String: Bool] ?? [:]
            let servicesArray = [
                servicesDict["serves_beer"] ?? false,
                servicesDict["serves_breakfast"] ?? false,
                servicesDict["serves_brunch"] ?? false,
                servicesDict["serves_dinner"] ?? false,
                servicesDict["serves_lunch"] ?? false,
                servicesDict["serves_wine"] ?? false,
                servicesDict["takeout"] ?? false
            ]
            
            var cleanCafeInfoObjc = CafeInfoObject(
                shopName: cafe["name"] as! String,
                city: cafe["city"] as! String,
                district: cafe["district"] as! String,
                address: cafe["formatted_address"] as! String,
                phoneNumber: cafe["formatted_phone_number"] as? String ?? "no phone number avaliable",
                rating: (cafe["rating"] as? NSNumber)?.intValue ?? 0,
                services: servicesArray,
                types: cafe["types"] as! [String],
                weekdayText: cafe["weekday_text"] as? [String] ?? ["no business hours avaliable"])
            
            cafeInfoObjList.append(cleanCafeInfoObjc)
        }
        self.cleanCafeData = cafeInfoObjList
    }
}

