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

@main
struct lookupCafeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
        FirebaseApp.configure()
        
        // 初始化這位使用者
        _ = UserDataManager.shared
        
        Task {
            let fixer = FirestoreFixer()
            await fixer.fixAllCategories(categories: [
                "serves_beer",
                "serves_brunch",
                "serves_dinner",
                "takeout",
                "highRatings"
            ])
        }

    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


