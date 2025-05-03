//
//  MapView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/9.
//

import SwiftUI
import GoogleMaps

struct MapView: View {
    @EnvironmentObject var locationManager: LocationDataManager
    
    @State private var selectedCity = ""
    @State private var selectedDistrict = ""
    
    var body: some View {
        ZStack {
//            Color.white.ignoresSafeArea()
            GoogleMapsView()
            
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

struct GoogleMapsView: UIViewRepresentable {
    func makeUIView(context: Context) -> GMSMapView {
        print("makeUIView called")

        let camera = GMSCameraPosition.camera(withLatitude: 25.034012, longitude: 121.564461, zoom: 16)
        let options = GMSMapViewOptions()
        options.camera = camera

        let mapView = GMSMapView.init(options: options)

        // Marker
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 25.034012, longitude: 121.564461)
        marker.title = "Taipei 101"
        marker.snippet = "台北市信義區"
        marker.map = mapView
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {}
}

//#Preview {
//    ContentView()
//}
