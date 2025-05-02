//
//  CafeDetailView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/5/1.
//

import SwiftUI

extension Image {
    func iconModifier() -> some View {
        self
            .padding()
            .frame(width: 50, height: 50)
            .background(.gray.opacity(0.2))
            .cornerRadius(5)
    }
}

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
        HStack {
            if cafeObj.services[1] {
                VStack {
                    Image(systemName: "cup.and.saucer.fill")
                        .iconModifier()
                    Text("早餐")
                }
            }
            if cafeObj.services[2] {
                VStack {
                    Image(systemName: "mug.fill")
                        .iconModifier()
                    Text("早午餐")
                }
            }
            if cafeObj.services[4] {
                VStack {
                    Image(systemName: "fork.knife")
                        .iconModifier()
                    Text("午餐")
                }
            }
            if cafeObj.services[3] {
                VStack {
                    Image(systemName: "moon.haze.fill")
                        .iconModifier()
                    Text("晚餐")
                }
            }
            if cafeObj.services[3] || cafeObj.services[0] {
                VStack {
                    Image(systemName: "wineglass.fill")
                        .iconModifier()
                    Text("酒精")
                }
            }
            if cafeObj.services[6] {
                VStack {
                    Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                        .iconModifier()
                    Text("外帶")
                }
            }
        }
    }
    
    /**
     評論參考：
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
     */
    @ViewBuilder
    func reviewCard() -> some View {
        if let reviews = cafeObj.reviews {
            ForEach(reviews) { review in
                HStack {
                    Text(review.reviewer_name).font(.headline)
                    ForEach(0 ..< 3) { _ in
                        Image(systemName: "star")
                    }
                }
            }
        } else {
            Text("no reviews yet")
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(cafeObj.shopName).font(.largeTitle).bold()
                .padding(.vertical)
            
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
            
            // 一條灰色的橫線
            
            // 評論
            Text("Reviews").bold().font(.title)
            reviewCard()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    CafeDetailView(cafeObj: CafeInfoObject(
        shopName: "Daily Beans",
        city: "台北市",
        district: "信義區",
        address: "松山路10巷5號",
        phoneNumber: "02-5566-7788",
        rating: 4,
        services: [true, false, true],
        types: ["hipster", "instagrammable", "brunch"],
        weekdayText: ["週一至週五: 09:00–17:00", "週末公休"],
        reviews: [
            Review(review_time: "2025-04-06", reviewer_name: "Jack", reviewer_rating: 3, reviewer_text: "非常適合打卡拍照的早午餐店。")
        ])
    )
}

