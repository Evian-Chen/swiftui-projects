//
//  GoogleMapView.swift
//  GoogleMapTest
//
//  Created by mac03 on 2025/3/21.
//

import SwiftUI
import GoogleMaps

struct GoogleMapView: View {
    @State private var input = ""
    var body: some View {
        ZStack(alignment: .top) {
            MapView()
                .ignoresSafeArea()
            
            TextField("請出入地點", text: $input)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.horizontal, 20)
        }
    }
}


struct MapView: UIViewRepresentable {
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
