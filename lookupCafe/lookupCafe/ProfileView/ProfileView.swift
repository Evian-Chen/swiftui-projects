//
//  ProfileView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/9.
//

import SwiftUI

struct PickersView: View {@State private var selectedCity: String = ""
    @State private var selectedDistrict: String = ""
    @State private var searchInput: String = ""
    
    let cities = ["台北市", "新北市", "台中市"]
    let districts = [
        "台北市": ["中正區", "大安區", "信義區"],
        "新北市": ["板橋區", "新莊區"],
        "台中市": ["西屯區", "北屯區"]
    ]
    
    var body: some View {
        HStack(spacing: 10) {
            Picker(selection: $selectedCity, label: selectedCity.isEmpty ? Text("選擇城市") : Text(selectedCity)) {
                // 如果目前是“”空的
                Text("選擇城市").tag("")
                ForEach(cities, id: \.self) { city in
                    Text(city).tag(city)
                }
            } // picker
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            
            Picker(selection: $selectedDistrict, label: selectedDistrict.isEmpty ? Text("選擇地區") : Text(selectedDistrict)) {
                Text("選擇地區").tag("")
                if let options = districts[selectedCity] {
                    ForEach(options, id: \.self) { district in
                        Text(district).tag(district)
                    }
                }
            } // picker
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
            .onChange(of: selectedCity) {
                selectedDistrict = ""
            }
            
            Button {
                // 查東西
            } label: {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
            }
            .padding(8)
            .background(.white)
            .cornerRadius(10)
            
        } // hstack
        .padding(.horizontal, 20)
        .padding(.top, 40)
    }
}

struct ProfileView: View {
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            
            VStack {
                PickersView()
                
                Spacer()
            }
        }
    }
}



#Preview {
    ProfileView()
}
