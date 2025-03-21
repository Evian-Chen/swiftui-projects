//
//  AppDelegate.swift
//  GoogleMapTest
//
//  Created by mac03 on 2025/3/21.
//

import UIKit
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String {
            GMSServices.provideAPIKey(apiKey)
            print("✅ Google Maps API Key provided: \(apiKey)")
        } else {
            fatalError("❌ API Key missing in Info.plist")
        }

        return true
    }
}
