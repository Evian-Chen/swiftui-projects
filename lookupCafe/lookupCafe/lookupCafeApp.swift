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
        
        // 初始化登入者（無論是否有登入，先初始化）
        _ = UserDataManager.shared
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


