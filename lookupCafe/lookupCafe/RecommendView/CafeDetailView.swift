//
//  CafeDetailView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/5/1.
//

import SwiftUI


// 每間咖啡廳的詳細資料（整個頁面）
struct CafeDetailView: View {
    // 所有資料都儲存在cafeinfoobject
    var cafeObj: CafeInfoObject
    
    /**
     參考有哪些服務
     let servicesArray = [
         servicesDict["serves_beer"] ?? false,
         servicesDict["serves_breakfast"] ?? false,
         servicesDict["serves_brunch"] ?? false,
         servicesDict["serves_dinner"] ?? false,
         servicesDict["serves_lunch"] ?? false,
         servicesDict["serves_wine"] ?? false,
         servicesDict["takeout"] ?? false
     ]
     */
    @ViewBuilder
    func serviceIcon() -> some View {
        if cafeObj.services[0] {
            Image(systemName: "wifi")
                .padding()
                .background(.gray.opacity(0.2))
                .cornerRadius(5)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(cafeObj.shopName).font(.largeTitle).bold()
            
            HStack {
                Image(systemName: "star.fill")
                Text(String(cafeObj.rating)).bold().font(.title3)
            }
            
            HStack {
                Text(cafeObj.address)
                Spacer()
                Text(cafeObj.phoneNumber)
            }
            
            // 有什麼樣的服務，參考 app store
            serviceIcon()
            // map view
            
            // 評論
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    CafeDetailView(cafeObj: CafeInfoObject(
        shopName: "日光微旅咖啡館",
        city: "台北市",
        district: "信義區",
        address: "信義路五段150號",
        phoneNumber: "02-1234-5678",
        rating: 5,
        services: [true, true, false, true, false, true, true], // ⬅️ 至少7個
        types: ["brunch", "work-friendly", "instagrammable"],
        weekdayText: [
            "週一: 10:00–20:00",
            "週二: 10:00–20:00",
            "週三: 10:00–20:00",
            "週四: 10:00–20:00",
            "週五: 10:00–21:00",
            "週六: 09:00–21:00",
            "週日: 09:00–18:00"
        ],
        comments: "這間店很適合假日來放鬆一下，甜點也不錯吃！"
    ))
}

