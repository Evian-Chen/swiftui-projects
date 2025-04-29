//
//  main.swift
//  testLookUpCafe
//
//  Created by mac03 on 2025/4/29.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

func initializeFirebase() {
    let filePath = "./GoogleService-Info.plist"

    guard let fileopts = FirebaseOptions(contentsOfFile: filePath) else {
        fatalError("找不到 GoogleService-Info.plist！")
    }
    FirebaseApp.configure(options: fileopts)
}

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
    @Published var cityDistricts: [String: [String]]
    
    let categoryFile = "categoryFile"
    
    // 管理整個firestore的物件
    private var fsManager = FirestoreManager()
    
    init() async {
        self.categories = []
        self.cityDistricts = [:]
        self.categoryObjcList = await loadCategoryData()
        
        loadCityDistrictData()
        self.categories = readInCategories()
    }
    
    private func loadCityDistrictData() {
        guard let url = Bundle.main.url(forResource: "cityDistrict", withExtension: "json") else {
            print("city_district.json not found")
            return
        }
        do {
            print("city_district json found")
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([String: [String]].self, from: data)
            self.cityDistricts = decoded
        } catch {
            print("error: \(error)")
        }
    }
    
    // TODO: loop through self.categories 裡面所有的類別，將其存到一個obj list
    func loadCategoryData() async -> [String: Categoryobjc]? {
        for category in self.categories {
            do {
                // categoryData 是 QuerySnapshot
                let categoryData = try await fsManager.db.collection(category).getDocuments()
                
                print("load in data, fetch from: \(category)")
                
                for cityDoc in categoryData.documents {
                    let city = cityDoc.documentID
                    
                    guard let districts = self.cityDistricts[city] else {
                        print("\(city) not exists")
                        continue
                    }
                    
                    for district in districts {
                        let districtRef = cityDoc.reference.collection(district)
                        
                        let cafeDoc = try await districtRef.getDocuments()
                        for cafeData in cafeDoc.documents {
                            print("shop name: \(cafeData.documentID)")
                            print("data: \(cafeData.data())")
                            print("====")
                        }
                    }
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
}


func main() async {
    initializeFirebase()
    
    let categoryManager = await CategoryManager()
//    print("\(categoryManager.categories)")
    _ = await categoryManager.loadCategoryData()
    
//    for (city, district) in categoryManager.cityDistricts {
//        print(city)
//    }
}

await main()


/**
 firestore讀出來的東西如下
 
 
 shop name: Cafe'Zwischen咖啡之間_ChIJI5cd04sxaTQRz_HRKza5If4
 data: ["vicinity": , "rating": 4.8, "user_rating_total": 0, "weekday_text": <__NSArrayM 0x6000015f9200>(
 not provided
 )
 , "services": {
     "serves_beer" = 0;
     "serves_breakfast" = 0;
     "serves_brunch" = 0;
     "serves_dinner" = 0;
     "serves_lunch" = 0;
     "serves_wine" = 0;
     takeout = 0;
 }, "district": 南投市, "city": 南投縣, "updatedAt": 2025-03-11T08:24:12.991Z, "formatted_address": 540台灣南投縣南投市民權街204號, "createdAt": 2025-03-11T08:24:12.991Z, "name": Cafe' Zwischen 咖啡之間, "formatted_phone_number": 0983 930 923, "types": <__NSArrayM 0x6000015f9410>(
 cafe,
 point_of_interest,
 food,
 establishment
 )
 , "reviews": <__NSArrayM 0x6000015f9230>(
 {
     "_id" = 67cff32c8e6f78e5061e6b8f;
     "review_text" = "\U5403\U5b8c\U610f\U9eb5\U62d0\U500b\U5f2f\U4f86\U5047\U65e5\U71df\U696d\U7684\U4e0d\U932f\U5496\U5561\U5e97\Uff0c\U559d\U676f\U5e74\U8f15\U5e97\U4e3b\U7684\U6e29\U9187\U62ff\U9435\Uff0c\U5feb\U610f\U8212\U670d\Uff01";
     "review_time" = "2 \U9031\U524d";
     "reviewer_name" = "\U5f35\U57f9\U68ee";
     "reviewer_rating" = 5;
 },
 {
     "_id" = 67cff32c8e6f78e5061e6b90;
     "review_text" = "\U5f88\U591a\U8c46\U5b50\U53ef\U4ee5\U9078\Uff0c\U91cd\U9ede\U50f9\U683c\U5f88\U4f5b\U7cfb\Uff01 CP\U503c\U8d85\U9ad8 \U63a8\U63a8";
     "review_time" = "1 \U500b\U6708\U524d";
     "reviewer_name" = "YuXuan Zhao";
     "reviewer_rating" = 5;
 },
 {
     "_id" = 67cff32c8e6f78e5061e6b91;
     "review_text" = "\U53ea\U958b\U5047\U65e5\U7684\U8f49\U89d2\U5496\U5561\Uff0cLinepay\U53ef\Uff0c\U6c23\U6c1b\U8212\U9069\U3002 \U62ff\U9435\U7684\U725b\U5976\U8d85\U6fc3\U90c1\Uff0c\U51fa\U676f\U662f\U6f02\U4eae\U7684\U6f38\U5c64\U3002 \U624b\U6c96\U6709\U5f88\U591a\U652f\U8c46\U5b50\U53ef\U4ee5\U9078\Uff0c\U540c\U6642\U80fd\U559d\U5230\U51b0\U8ddf\U71b1\U7684\U98a8\U5473\Uff0c\U8d85\U6709\U6c34\U6e96\U7684\U5496\U5561\U7adf\U7136\U9084\U662f\U4f5b\U5fc3\U50f9\Uff0c\U760b\U6389\Uff0c\U503c\U5f97\U7279\U5730\U904e\U4f86\U559d\U4e00\U676f\Uff01";
     "review_time" = "6 \U500b\U6708\U524d";
     "reviewer_name" = bbb612;
     "reviewer_rating" = 5;
 },
 {
     "_id" = 67cff32c8e6f78e5061e6b92;
     "review_text" = "\U5728\U5357\U6295\U8857\U5df7\U9593 \U7684\U8f49\U89d2\U5496\U5561\U5ef3 \U611f\U89ba\U662f\U5728\U81ea\U5bb6\U6a13\U4e0b\U7684\U9a0e\U6a13 \U7a7a\U9593\U8a2d\U8a08\U7684\U5341\U5206\U8212\U670d \U6709\U8a31\U591a\U7684\U82b1\U8349\U64fa\U8a2d\U9694\U7d55\U4e86\U76f8\U9130\U7684\U9053\U8def \U540c\U6642 \U4e5f\U53ef\U4ee5\U4eab\U53d7\U7167\U6620\U9032\U7684\U592a\U967d \U96d6\U7136\U7a7a\U9593\U4e0d\U5927 \U537b\U4e0d\U611f\U5230\U64c1\U64e0 \U5e97\U88e1\U9084\U64ad\U8457\U97f3\U6a02 \U771f\U7684\U5f88\U611c\U610f\U263b #\U767e\U6155\U9054\U70e4\U5410\U53f8 \U70e4\U5230\U525b\U525b\U597d\U7684\U8106\U5ea6 \U914d\U4e0a\U5c0f\U584a\U5976\U6cb9 \U8ddf\U9ed1\U5496\U5561\U5b8c\U7f8e\U642d\U914d\U2615\Ufe0f \U9ed1\U5496\U5561$60 \U70e4\U571f\U53f8$30";
     "review_time" = "3 \U5e74\U524d";
     "reviewer_name" = "\U738b\U54c1\U5112";
     "reviewer_rating" = 5;
 },
 {
     "_id" = 67cff32c8e6f78e5061e6b93;
     "review_text" = "\U5357\U6295\U5df7\U5f04\U8f49\U89d2\U516d\U65e5\U9650\U5b9a\U5496\U5561 \U624b\U6c96\U5f88\U8b9a\Uff5e \U53ef\U4ee5\U544a\U8a34\U8001\U95c6\U60f3\U8981\U4ec0\U9ebc\U5473\U9053\U7684\U5496\U5561 \U4e5f\U53ef\U4ee5\U81ea\U5df1\U9078\U64c7 \U51b0\U78da\U62ff\U9435\U6162\U6162\U5316\U6389\U91cb\U653e\U7684\U5496\U5561\U5f88\U6fc3\U90c1 \U8001\U95c6\U8ddf\U677f\U5a18\U5f88\U71b1\U60c5\U89aa\U5207";
     "review_time" = "3 \U5e74\U524d";
     "reviewer_name" = ying;
     "reviewer_rating" = 5;
 }
 )
 ]
 
 
 */
