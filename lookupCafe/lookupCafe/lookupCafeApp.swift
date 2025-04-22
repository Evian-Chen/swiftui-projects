//
//  lookupCafeApp.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/4.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct lookupCafeApp: App {
    
    //    init() {
    //        FirebaseApp.configure()
    //    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
