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
    
    private var db = Firestore.firestore()
    private var uid: String? {
        return Auth.auth().currentUser?.uid
    }
    
    private init() {
        fetchFavorites()
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
