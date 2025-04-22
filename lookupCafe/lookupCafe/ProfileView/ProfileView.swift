//
//  ProfileView.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/9.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    
    var body: some View {
        if authViewModel.isSignedIn {
            Text("sign in")
        } else  {
            Button {
                authViewModel.SignInByGoogle()
            } label: {
                Text("Sign in by Google")
                    .padding(10)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(7)
            }
        }
    }
}


