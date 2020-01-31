//
//  FirebaseReference.swift
//  GreenForest
//
//  Created by Hammed opejin on 1/30/20.
//  Copyright © 2020 Hammed opejin. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Category
    case Items
    case Basket
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
