//
//  Item.swift
//  GreenForest
//
//  Created by Hammed opejin on 1/30/20.
//  Copyright © 2020 Hammed opejin. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchClient

class Item {
    
    var id: String!
    var categoryId: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        
        id = _dictionary[CategoryKeys.kOBJECTID] as? String
        categoryId = _dictionary[ItemKeys.kCATEGORYID] as? String
        name = _dictionary[CategoryKeys.kNAME] as? String
        description = _dictionary[ItemKeys.kDESCRIPTION] as? String
        price = _dictionary[ItemKeys.kPRICE] as? Double
        imageLinks = _dictionary[ItemKeys.kIMAGELINKS] as? [String]
    }
}


//MARK: Save items func

func saveItemToFirestore(_ item: Item) {
    
    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String : Any])
}


//MARK: Helper functions

func itemDictionaryFrom(_ item: Item) -> NSDictionary {
    
    return NSDictionary(objects: [item.id, item.categoryId, item.name, item.description, item.price, item.imageLinks], forKeys: [CategoryKeys.kOBJECTID as NSCopying, ItemKeys.kCATEGORYID as NSCopying, CategoryKeys.kNAME as NSCopying, ItemKeys.kDESCRIPTION as NSCopying, ItemKeys.kPRICE as NSCopying, ItemKeys.kIMAGELINKS as NSCopying])
}


//MARK: Download Func
func downloadItemsFromFirebase(_ withCategoryId: String, completion: @escaping (_ itemArray: [Item]) -> Void) {
    
    var itemArray: [Item] = []
    
    FirebaseReference(.Items).whereField(ItemKeys.kCATEGORYID, isEqualTo: withCategoryId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(itemArray)
            return
        }
        
        if !snapshot.isEmpty {
            
            for itemDict in snapshot.documents {
                
                itemArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
            }
        }
        
        completion(itemArray)
    }
    
}

func downloadItems(_ withIds: [String], completion: @escaping (_ itemArray: [Item]) ->Void) {
    
    var count = 0
    var itemArray: [Item] = []
    
    if withIds.count > 0 {
        
        for itemId in withIds {

            FirebaseReference(.Items).document(itemId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else {
                    completion(itemArray)
                    return
                }

                if snapshot.exists {

                    itemArray.append(Item(_dictionary: snapshot.data()! as NSDictionary))
                    count += 1
                }
                
                if count == withIds.count {
                    completion(itemArray)
                }
                
            }
        }
    } else {
        completion(itemArray)
    }
}
