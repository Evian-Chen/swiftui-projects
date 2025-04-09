//
//  MapView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/9.
//

import SwiftUI

struct MapView: View {
    @EnvironmentObject var locationManager: LocationDataManager
    
    @State private var selectedCity = ""
    @State private var selectedDistrict = ""
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                HStack {
                    Picker("選擇城市", selection: $selectedCity) {
                        Text("選擇城市")
                        ForEach(Array(locationManager.cityDistricts.keys), id: \.self) { city in
                            Text(city)
                        }
                    } // picker city
                    
                    Spacer()
                    
                    Picker("選擇行政區", selection: $selectedDistrict) {
                        Text("選擇行政區")
                        if let distrcits = locationManager.cityDistricts[selectedCity] {
                            ForEach(distrcits, id: \.self) { district in
                                Text(district)
                            }
                        }
                    } //Picker district
                    
                } // picker district
                .frame(maxWidth: .infinity)
                .background(.red)
                .padding([.top, .horizontal], 20)
                
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
