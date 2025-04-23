//
//  Location.swift
//  BucketList
//
//  Created by hpclab on 2025/4/1.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    
    static let example = Location(id: UUID(), name: "NTUST 3rd Restaurant", description: "Restaurant in the Second Teaching Building", latitude: 25.0119407, longitude: 121.5405389)
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

