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
    
    // loop through self.categories 裡面所有的類別，將其存到一個obj list
    private func loadCategoryData() async -> [String: Categoryobjc]? {
        var result: [String: Categoryobjc] = [:]
        
        for category in self.categories {
            // 製作該分類的物件
            var categoryObjc = Categoryobjc(categoryName: category, data: [])
            
            do {
                // categoryData 是 QuerySnapshot
                let categoryData = try await fsManager.db.collection(category).getDocuments()
                
                print("load in data, fetch from: \(category)")
                
                for cityDoc in categoryData.documents {
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
    
    init(categoryName: String, data: [[String : Any]]) {
        self.categoryName = categoryName
        self.data = data
    }
}



/**
 firestore讀出來的東西如下
 
 shop name: Cafe'Zwischen咖啡之間_ChIJI5cd04sxaTQRz_HRKza5If4
 decoded data:
 {
   "district" : "南投市",
   "rating" : 4.7999999999999998,
   "formatted_phone_number" : "0983 930 923",
   "formatted_address" : "540台灣南投縣南投市民權街204號",
   "name" : "Cafe' Zwischen 咖啡之間",
   "vicinity" : "",
   "createdAt" : "2025-03-11T08:24:12.991Z",
   "updatedAt" : "2025-03-11T08:24:12.991Z",
   "user_rating_total" : 0,
   "services" : {
     "serves_dinner" : false,
     "serves_breakfast" : false,
     "serves_beer" : false,
     "takeout" : false,
     "serves_brunch" : false,
     "serves_lunch" : false,
     "serves_wine" : false
   },
   "types" : [
     "cafe",
     "point_of_interest",
     "food",
     "establishment"
   ],
   "weekday_text" : [
     "not provided"
   ],
   "city" : "南投縣",
   "reviews" : [
     {
       "review_time" : "2 週前",
       "_id" : "67cff32c8e6f78e5061e6b8f",
       "reviewer_name" : "張培森",
       "reviewer_rating" : 5,
       "review_text" : "吃完意麵拐個弯來假日營業的不錯咖啡店，喝杯年輕店主的温醇拿鐵，快意舒服！"
     },
     {
       "review_time" : "1 個月前",
       "_id" : "67cff32c8e6f78e5061e6b90",
       "reviewer_name" : "YuXuan Zhao",
       "reviewer_rating" : 5,
       "review_text" : "很多豆子可以選，重點價格很佛系！ CP值超高 推推"
     },
     {
       "review_time" : "6 個月前",
       "_id" : "67cff32c8e6f78e5061e6b91",
       "reviewer_name" : "bbb612",
       "reviewer_rating" : 5,
       "review_text" : "只開假日的轉角咖啡，Linepay可，氣氛舒適。 拿鐵的牛奶超濃郁，出杯是漂亮的漸層。 手沖有很多支豆子可以選，同時能喝到冰跟熱的風味，超有水準的咖啡竟然還是佛心價，瘋掉，值得特地過來喝一杯！"
     },
     {
       "review_time" : "3 年前",
       "_id" : "67cff32c8e6f78e5061e6b92",
       "reviewer_name" : "王品儒",
       "reviewer_rating" : 5,
       "review_text" : "在南投街巷間 的轉角咖啡廳 感覺是在自家樓下的騎樓 空間設計的十分舒服 有許多的花草擺設隔絕了相鄰的道路 同時 也可以享受照映進的太陽 雖然空間不大 卻不感到擁擠 店裡還播著音樂 真的很愜意☻ #百慕達烤吐司 烤到剛剛好的脆度 配上小塊奶油 跟黑咖啡完美搭配☕️ 黑咖啡$60 烤土司$30"
     },
     {
       "review_time" : "3 年前",
       "_id" : "67cff32c8e6f78e5061e6b93",
       "reviewer_name" : "ying",
       "reviewer_rating" : 5,
       "review_text" : "南投巷弄轉角六日限定咖啡 手沖很讚～ 可以告訴老闆想要什麼味道的咖啡 也可以自己選擇 冰磚拿鐵慢慢化掉釋放的咖啡很濃郁 老闆跟板娘很熱情親切"
     }
   ]
 }
 
 
 */
