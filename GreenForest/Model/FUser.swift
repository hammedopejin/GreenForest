//
//  FUser.swift
//  GreenForest
//
//  Created by Hammed opejin on 1/31/20.
//  Copyright © 2020 Hammed opejin. All rights reserved.
//

import Foundation
import FirebaseAuth

class FUser {
    
    let objectId: String
    var email: String
    var firstName: String
    var lastName: String
    var fullName: String
    var purchasedItemIds: [String]
    
    var fullAddress: String?
    var onBoard: Bool
    
    
    //MARK: - Initializers
    
    init(_objectId: String, _email: String, _firstName: String, _lastName: String) {
        
        objectId = _objectId
        email = _email
        firstName = _firstName
        lastName = _lastName
        fullName = _firstName + " " + _lastName
        fullAddress = ""
        onBoard = false
        purchasedItemIds = []
    }

    init(_dictionary: NSDictionary) {
        
        objectId = _dictionary[CategoryKeys.kOBJECTID] as! String
        
        if let mail = _dictionary[UserKeys.kEMAIL] {
            email = mail as! String
        } else {
            email = ""
        }
        
        if let fname = _dictionary[UserKeys.kFIRSTNAME] {
            firstName = fname as! String
        } else {
            firstName = ""
        }
        if let lname = _dictionary[UserKeys.kLASTNAME] {
            lastName = lname as! String
        } else {
            lastName = ""
        }
        
        fullName = firstName + " " + lastName
        
        if let faddress = _dictionary[UserKeys.kFULLADDRESS] {
           fullAddress = faddress as! String
        } else {
           fullAddress = ""
        }
        
        if let onB = _dictionary[UserKeys.kONBOARD] {
          onBoard = onB as! Bool
        } else {
          onBoard = false
        }

        if let purchaseIds = _dictionary[UserKeys.kPURCHASEDITEMIDS] {
         purchasedItemIds = purchaseIds as! [String]
       } else {
         purchasedItemIds = []
       }
    }
    
    
    //MARK: - Return current user
    
    class func currentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> FUser? {
        
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: UserKeys.kCURRENTUSER) {
                return FUser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        
        return nil
    }
    
    //MARK: - Login func
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error == nil {
                
                if authDataResult!.user.isEmailVerified {
                    
                    downloadUserFromFirestore(userId: authDataResult!.user.uid, email: email)
                    completion(error, true)
                } else {
                    
                    print("email is not varified")
                    completion(error, false)
                }
                
            } else {
                completion(error, false)
            }
        }
    }

    
    //MARK: - Register user
    
    class func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) ->Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            completion(error)
            
            if error == nil {
                
                //send email verification
                authDataResult!.user.sendEmailVerification { (error) in
                    print("auth email verification error : ", error?.localizedDescription)
                }
            }
        }
    }

    
    //MARK: - Resend link methods

    class func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    class func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                print(" resend email error: ", error?.localizedDescription)
                
                completion(error)
            })
        })
    }
    
    class func logOutCurrentUser(completion: @escaping (_ error: Error?) -> Void) {
        
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: UserKeys.kCURRENTUSER)
            UserDefaults.standard.synchronize()
            completion(nil)

        } catch let error as NSError {
            completion(error)
        }
        
        
    }

}//end of class

//MARK: - DownloadUser

func downloadUserFromFirestore(userId: String, email: String) {
    
    FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
        
        guard let snapshot = snapshot else { return }
        
        if snapshot.exists {
            print("download current user from firestore")
            saveUserLocally(mUserDictionary: snapshot.data()! as NSDictionary)
        } else {
            //there is no user, save new in firestore
            
            let user = FUser(_objectId: userId, _email: email, _firstName: "", _lastName: "")
            saveUserLocally(mUserDictionary: userDictionaryFrom(user: user))
            saveUserToFirestore(fUser: user)
        }
    }
    

}





//MARK: - Save user to firebase

func saveUserToFirestore(fUser: FUser) {
    
    FirebaseReference(.User).document(fUser.objectId).setData(userDictionaryFrom(user: fUser) as! [String : Any]) { (error) in
        
        if error != nil {
            print("error saving user \(error!.localizedDescription)")
        }
    }
}


func saveUserLocally(mUserDictionary: NSDictionary) {
    
    UserDefaults.standard.set(mUserDictionary, forKey: UserKeys.kCURRENTUSER)
    UserDefaults.standard.synchronize()
}


//MARK: - Helper Function

func userDictionaryFrom(user: FUser) -> NSDictionary {
    
    return NSDictionary(objects: [user.objectId, user.email, user.firstName, user.lastName, user.fullName, user.fullAddress ?? "", user.onBoard, user.purchasedItemIds], forKeys: [CategoryKeys.kOBJECTID as NSCopying, UserKeys.kEMAIL as NSCopying, UserKeys.kFIRSTNAME as NSCopying, UserKeys.kLASTNAME as NSCopying, UserKeys.kFULLNAME as NSCopying, UserKeys.kFULLADDRESS as NSCopying, UserKeys.kONBOARD as NSCopying, UserKeys.kPURCHASEDITEMIDS as NSCopying])
}

//MARK: - Update user

func updateCurrentUserInFirestore(withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
    
    if let dictionary = UserDefaults.standard.object(forKey: UserKeys.kCURRENTUSER) {
        
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        
        FirebaseReference(.User).document(FUser.currentId()).updateData(withValues) { (error) in
            
            completion(error)
            
            if error == nil {
                saveUserLocally(mUserDictionary: userObject)
            }
        }
    }
}
