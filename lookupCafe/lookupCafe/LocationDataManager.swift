//
//  LocationDataManager.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/5.
//

import Foundation

/**
 此class產生一個可負責監聽cityDistricts的物件（json檔案若有更新的話，會連動所有相關UI）
 self.cityDistricts格式如下：
 {
   "台北市": ["中正區", "大安區"],
   "新北市": ["板橋區", "新莊區"]
 }
 */
class LocationDataManager: ObservableObject {
    // 監聽該物件的所有資料更改
    @Published var cityDistricts: [String: [String]] = [:]
    
    init() {
        loadCityDistrictData()
    }
    
    private func loadCityDistrictData() {
        guard let url = Bundle.main.url(forResource: "city_district", withExtension: "json") else {
            print("city_district.json not found")
            return
        }
        do {
            print("json found")
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([String: [String]].self, from: data)
            self.cityDistricts = decoded
        } catch {
            print("error: \(error)")
        }
    }
}
