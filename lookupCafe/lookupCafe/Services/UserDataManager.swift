//
//  UserDataManager.swift
//  lookupCafe
//
//  Created by mac03 on 2025/5/9.
//

import Firebase
import FirebaseFirestore
import FirebaseAuth

class UserDataManager: ObservableObject {
    // 整個 APP 只會有一個 UserDataManager 的物件，叫做 shared
    static let shared = UserDataManager()
    
    @Published var favoriteCafeIds: [String] = []
    @Published var email: String = "loading..."
    @Published var createdAt: String = "loading..."
    
    private var db = Firestore.firestore()
    private var uid: String? {
        return Auth.auth().currentUser?.uid
    }
    
    private init() {
        fetchFavorites()
    }
    
    /**
     let userData: [String: Any] = [
         "email": user.email ?? "",
         "createdAt": FieldValue.serverTimestamp(),
         "favorites": []
     ]
     */
    func fetchUserData() {
        guard let uid = uid else { return }
        db.collection("users").document(uid).getDocument { doc, error in
            if let data = doc?.data() {
                self.email = data["email"] as? String ?? "無資料"
                
                if let timestamp = data["createdAt"] as? Timestamp {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .short
                    self.createdAt = formatter.string(from: timestamp.dateValue())
                }
            }
        }
    }

    
    func fetchFavorites() {
        guard let uid = uid else { return }
        db.collection("users").document(uid).getDocument { doc, error in
            if let data = doc?.data() {
                self.favoriteCafeIds = data["favorites"] as? [String] ?? []
            }
        }
    }
    
    func toggleFavorite(cafeId: String) {
        guard let uid = uid else { return }
        let userRef = db.collection("users").document(uid)
        
        if favoriteCafeIds.contains(cafeId) {
            // remove
            userRef.updateData([
                "favorites": FieldValue.arrayRemove([cafeId])
            ])
            favoriteCafeIds.removeAll { $0 == cafeId }
        } else {
            favoriteCafeIds.append(cafeId)
            userRef.setData([
                "favorites": FieldValue.arrayUnion([cafeId])
            ], merge: true)
        }
    }
    
    func isFavorite(cafeId: String) -> Bool {
        return favoriteCafeIds.contains(cafeId)
    }
}
