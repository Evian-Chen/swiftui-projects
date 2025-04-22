//
//  ProfileView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/9.
//

import SwiftUI
import GoogleSignIn

struct ProfileView: View {
    weak var signInButton: GIDSignInButton!
    
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea()
            
            Text("hi")
        }
    }
}



#Preview {
    ProfileView()
}
