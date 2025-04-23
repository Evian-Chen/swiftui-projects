//
//  ContentView.swift
//  BucketList
//
//  Created by hpclab on 2025/4/1.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.0141089, longitude: 121.5413613),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    )
    
    @State private var locations = [Location]()
    @State private var selected: Location?
    
    var body: some View {
        MapReader { proxy in
            Map(position: $position) {
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())
                            .simultaneousGesture(LongPressGesture(minimumDuration: 1).onEnded { _ in
                                selected = location
                            })
                    }
                }
            }
            .onTapGesture { tapPoint in
                if let coordinate = proxy.convert(tapPoint, from: .local) {
                    let newLocation = Location(
                        id: UUID(),
                        name: "New location",
                        description: "",
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude
                    )
                    locations.append(newLocation)
                    withAnimation {
                        position = .region(
                            MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
                        )
                    }
                }
            }
            .sheet(item: $selected) { place in
                EditView(location: place) { newLocation in
                    if let index = locations.firstIndex(of: place) {
                        locations[index] = newLocation
                    }
                }
            }
        }
    }

}

#Preview {
    ContentView()
}
