//
//  MapView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/9.
//

import SwiftUI
import GoogleMaps

struct GMSMapsView: UIViewRepresentable {
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(
            withLatitude: 25.034012,  // 台北101
            longitude: 121.564461,
            zoom: 15
        )
        let mapView = GMSMapView(frame: .zero)
        mapView.camera = camera

        // 加一個 marker 做示範
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 25.034012, longitude: 121.564461)
        marker.title = "Taipei 101"
        marker.snippet = "台北市信義區"
        marker.map = mapView

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // 這裡暫時不需要寫
    }
}



struct MapView: View {
    @EnvironmentObject var locationManager: LocationDataManager
    
    @State private var selectedCity = ""
    @State private var selectedDistrict = ""
    
    var body: some View {
        ZStack {
            //            Color.white.ignoresSafeArea()
            GMSMapsView()
                .frame(height: 300)  // 自訂顯示高度
                .cornerRadius(12)
                .padding()
            
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
