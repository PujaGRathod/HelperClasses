//
//  SignupVC.swift
//  Points2Miles
//
//  Created by Intelivex Labs on 19/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignupVC: UIViewController {
    
    @IBOutlet var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet var txtLastName: SkyFloatingLabelTextField!
    @IBOutlet var txtFirstName: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onSignUpTap(_ sender: Any) {
        
        self.txtFirstName.resignFirstResponder()
        self.txtLastName.resignFirstResponder()
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
        
        guard let firstname = self.txtFirstName.text, !firstname.isEmpty else {
            self.showAlert("Required".localized, message: "Please enter First Name.".localized)
            { (action) in
                self.txtFirstName.becomeFirstResponder()
            }
            return
        }
        
        guard let lastname = self.txtLastName.text, !lastname.isEmpty else {
            self.showAlert("Required".localized, message: "Please enter Last Name.".localized)
            { (action) in
                self.txtLastName.becomeFirstResponder()
            }
            return
        }
        
        if let emailText = self.txtEmail.text,
            emailText.isValidEmail() {
            if let passText = self.txtPassword.text,
                !passText.isEmpty {
                self.doSignUp()
            } else {
                self.showAlert("Required".localized, message: "Please enter Password".localized){ (action) in
                    self.txtPassword.becomeFirstResponder()
                }
            }
        } else {
            self.showAlert("Required".localized, message: "Please enter valid email address".localized) { (action) in
                self.txtEmail.becomeFirstResponder()
            }
        }
    }
    
    func doSignUp() {
        self.showLoader()
        let request = NetworkServicesModels.signUp.request(first_name: self.txtFirstName.text, last_name: self.txtLastName.text, email: txtEmail.text, password: self.txtPassword.text, device_token: "")
        NetworkServices.shared.signUp(request: request) {(user, success, error) in
            if let error = error {
                self.hideLoader()
                self.showAlert("Points2Miles", message: error.localizedDescription)
                return
            }
            
            NetworkServices.shared.getHotelist { (hotel, error) in
                self.hideLoader()
                
                if let error = error {
                    self.showAlert("Points2Miles", message: error.localizedDescription)
                    return
                }
                
                self.performSegue(withIdentifier: "showDashboard", sender: self)
            }
        }
    }
}
