//
//  Basket.swift
//  GreenForest
//
//  Created by Hammed opejin on 1/30/20.
//  Copyright © 2020 Hammed opejin. All rights reserved.
//

import Foundation

class Basket {
    
    var id: String!
    var ownerId: String!
    var itemIds: [String]!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[CategoryKeys.kOBJECTID] as? String
        ownerId = _dictionary[BasketKeys.kOWNERID] as? String
        itemIds = _dictionary[BasketKeys.kITEMIDS] as? [String]
    }
}


//MARK: - Download items
func downloadBasketFromFirestore(_ ownerId: String, completion: @escaping (_ basket: Basket?)-> Void) {
    
    FirebaseReference(.Basket).whereField(BasketKeys.kOWNERID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(basket)
        } else {
            completion(nil)
        }
    }
}


//MARK: - Save to Firebase
func saveBasketToFirestore(_ basket: Basket) {
    
    FirebaseReference(.Basket).document(basket.id).setData(basketDictionaryFrom(basket) as! [String: Any])
}


//MARK: Helper functions

func basketDictionaryFrom(_ basket: Basket) -> NSDictionary {
    
    return NSDictionary(objects: [basket.id, basket.ownerId, basket.itemIds], forKeys: [CategoryKeys.kOBJECTID as NSCopying, BasketKeys.kOWNERID as NSCopying, BasketKeys.kITEMIDS as NSCopying])
}

//MARK: - Update basket
func updateBasketInFirestore(_ basket: Basket, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
    
    FirebaseReference(.Basket).document(basket.id).updateData(withValues) { (error) in
        completion(error)
    }
}
