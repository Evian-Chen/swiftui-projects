//
//  MapView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/9.
//

import SwiftUI
import GoogleMaps

struct GMSMapsView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> GMSMapView {
        let defaultCoordinate = coordinate ?? CLLocationCoordinate2D(latitude: 25.034012, longitude: 121.564461)
        let camera = GMSCameraPosition.camera(withTarget: defaultCoordinate, zoom: 15)
        let mapView = GMSMapView(frame: .zero, camera: camera)

        // 加上 marker
        let marker = GMSMarker()
        marker.position = defaultCoordinate
        marker.title = "目前位置"
        marker.snippet = "您所在的位置"
        marker.map = mapView

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        // 更新 marker（必要時加）
    }
}


struct MapView: View {
//    @EnvironmentObject var locationManager: LocationDataManager
    
    @State private var searchText = ""
    @State private var isEditing = false

    var body: some View {
        ZStack {
            // 地圖
//            GMSMapsView(coordinate: locationManager.userLocation)
//                .ignoresSafeArea()

            Color.gray.opacity(0.2).ignoresSafeArea()
            
            VStack(spacing: 20) {
                // 美化後的選擇列
                VStack(spacing: 12) {
                    TextField("Search...", text: $searchText)
                        .frame(height: 200)
                        .background(.white)
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
                        .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    MapView()
//        .environment(LocationDataManager())
}
