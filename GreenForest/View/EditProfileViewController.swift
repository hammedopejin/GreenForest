//
//  EditProfileViewController.swift
//  GreenForest
//
//  Created by Hammed opejin on 2/14/20.
//  Copyright © 2020 Hammed opejin. All rights reserved.
//

import UIKit
import JGProgressHUD

class EditProfileViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    //MARK: - Vars
    let hud = JGProgressHUD(style: .dark)

    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserInfo()
    }
    
    
    //MARK: - IBActions
    
    @IBAction func saveBarButtonPressed(_ sender: Any) {
        
        dismissKeyboard()
        
        if textFieldsHaveText() {
            
            let withValues = [UserKeys.kFIRSTNAME : nameTextField.text!, UserKeys.kLASTNAME : surnameTextField.text!, UserKeys.kFULLNAME : (nameTextField.text! + " " + surnameTextField.text!), UserKeys.kFULLADDRESS : addressTextField.text!]
            
            updateCurrentUserInFirestore(withValues: withValues) { (error) in
                
                if error == nil {
                    self.hud.textLabel.text = "Updated!"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    
                } else {
                    print("erro updating user ", error!.localizedDescription)
                   self.hud.textLabel.text = error!.localizedDescription
                   self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                   self.hud.show(in: self.view)
                   self.hud.dismiss(afterDelay: 2.0)
                }
            }
            
        } else {
            hud.textLabel.text = "All fields are required!"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            
        }
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        logOutUser()
    }
    
    
    //MARK: - UpdateUI
    
    private func loadUserInfo() {
        
        if FUser.currentUser() != nil {
            let currentUser = FUser.currentUser()!
            
            nameTextField.text = currentUser.firstName
            surnameTextField.text = currentUser.lastName
            addressTextField.text = currentUser.fullAddress
        }
    }

    //MARK: - Helper funcs
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }

    private func textFieldsHaveText() -> Bool {
        
        return (nameTextField.text != "" && surnameTextField.text != "" && addressTextField.text != "")
    }
    
    private func logOutUser() {
        FUser.logOutCurrentUser { (error) in
            
            if error == nil {
                print("logged out")
                self.navigationController?.popViewController(animated: true)
            }  else {
                print("error login out ", error!.localizedDescription)
            }
        }
        
    }
    
}
