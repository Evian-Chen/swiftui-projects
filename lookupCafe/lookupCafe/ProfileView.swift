//
//  ProfileView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/9.
//

import SwiftUI

struct ProfileView: View {
    @State private var selectedCity: String = ""
    @State private var selectedDistrict: String = ""

    let cities = ["台北市", "新北市", "台中市"]
    let districts = [
        "台北市": ["中正區", "大安區", "信義區"],
        "新北市": ["板橋區", "新莊區"],
        "台中市": ["西屯區", "北屯區"]
    ]

    var body: some View {
        HStack(spacing: 16) {
            // 城市 Picker
            Picker(selection: $selectedCity, label: pickerLabel(text: selectedCity.isEmpty ? "選擇城市" : selectedCity)) {
                Text("選擇城市").tag("")
                ForEach(cities, id: \.self) { city in
                    Text(city).tag(city)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.6)))
            
            // 地區 Picker
            Picker(selection: $selectedDistrict, label: pickerLabel(text: selectedDistrict.isEmpty ? "選擇行政區" : selectedDistrict)) {
                Text("選擇行政區").tag("")
                if let options = districts[selectedCity] {
                    ForEach(options, id: \.self) { district in
                        Text(district).tag(district)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.6)))
        }
        .padding()
    }

    // 自訂 Picker 外觀 Label（模擬下拉選單框）
    func pickerLabel(text: String) -> some View {
        Text(text)
            .foregroundColor(text.contains("選擇") ? .gray : .black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
    }
}

#Preview {
    ProfileView()
}
