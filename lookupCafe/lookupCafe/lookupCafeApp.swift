//
//  lookupCafeApp.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/4.
//

import SwiftUI
import Firebase

@main
struct lookupCafeApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
