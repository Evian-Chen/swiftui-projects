//
//  GMSMapView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/5/4.
//

import SwiftUI
import GoogleMaps

struct GoogleMapsView: UIViewRepresentable {
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
