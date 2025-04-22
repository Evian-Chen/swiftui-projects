//
//  GoogleAuthManager.swift
//  lookupCafe
//
//  Created by mac03 on 2025/4/22.
//

import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var isSignedIn: Bool = false
    
    func SignInByGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController
        else {
            print("There is no root view controller!")
            return
        }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
            if let err = error{
                print("sign in error: \(err)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            // 憑證
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let err = error {
                    print("sign in error: \(err)")
                    return
                }
                
                self.user = result?.user
                self.isSignedIn = true
            }
            
        }
    } // sign in
    
    func SignOutGoogle() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    } // sign out
}
