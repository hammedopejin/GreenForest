//
//  Constants.swift
//  GreenForest
//
//  Created by Hammed opejin on 2/3/20.
//  Copyright © 2020 Hammed opejin. All rights reserved.
//

import Foundation

enum Constants {
    static let publishableKey = ""
    static let baseURLString = "https://" //"http://localhost:3000/"
    static let defaultCurrency = "usd"
    static let defaultDescription = "Purchase"
}

//IDS and Keys
struct Algolia {
    public static let kFILEREFERENCE = "gs://"
    public static let kALGOLIA_APP_ID = ""
    public static let kALGOLIA_SEARCH_KEY = ""
    public static let kALGOLIA_ADMIN_KEY = ""
}

//Firebase Headers
struct FirebaseKeys {
    public static let kUSER_PATH = "User"
    public static let kCATEGORY_PATH = "Category"
    public static let kITEMS_PATH = "Items"
    public static let kBASKET_PATH = "Basket"
}

//Category
struct CategoryKeys {
    public static let kNAME = "name"
    public static let kIMAGENAME = "imageName"
    public static let kOBJECTID = "objectId"
}

//Item
struct ItemKeys {
    public static let kCATEGORYID = "categoryId"
    public static let kDESCRIPTION = "description"
    public static let kPRICE = "price"
    public static let kIMAGELINKS = "imageLinks"
}

//Basket
struct BasketKeys {
    public static let kOWNERID = "ownerId"
    public static let kITEMIDS = "itemIds"
}

//User
struct UserKeys {
    public static let kEMAIL = "email"
    public static let kFIRSTNAME  = "firstName"
    public static let kLASTNAME  = "lastName"
    public static let kFULLNAME  = "fullName"
    public static let kCURRENTUSER  = "currentUser"
    public static let kFULLADDRESS  = "fullAddress"
    public static let kONBOARD  = "onBoard"
    public static let kPURCHASEDITEMIDS  = "purchasedItemIds"
}
