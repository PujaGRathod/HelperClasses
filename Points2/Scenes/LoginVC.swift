//
//  LoginVC.swift
//  Points2Miles
//
//  Created by Akshit Zaveri on 16/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginVC: UIViewController {
    
    @IBOutlet var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet var txtPassword: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onLoginTap(_ sender: Any) {
        self.resignTextFieldResponders()
        if let emailText = self.txtEmail.text,
            emailText.isValidEmail() {
            if let passText = self.txtPassword.text,
                !passText.isEmpty {
                self.doLogIn()
            } else {
                self.showAlert("Required".localized, message: "Please enter Password.".localized) { (action) in
                    self.txtPassword.becomeFirstResponder()
                }
            }
        } else {
            self.showAlert("Required".localized, message: "Please enter valid email address".localized) { (action) in
                self.txtEmail.becomeFirstResponder()
            }
        }
    }
    
    func doLogIn() {
        self.showLoader()
        let request = NetworkServicesModels.logIn.request(email:self.txtEmail.text, password: self.txtPassword.text, device_token: "")
        NetworkServices.shared.logIn(request: request) {(user, success, error) in

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
    
    @IBAction func onRegisterNowTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onForgotPasswordTap(_ sender: Any) {
        self.resignTextFieldResponders()
        
        let alert = UIAlertController(title: "Forgot password", message: "Please enter your email address", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textfield) in
            textfield.keyboardType = .emailAddress
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.default, handler: { (action) in
            if let emailTextField = alert.textFields?.first,
                let email = emailTextField.text,
                email.isValidEmail() {
                self.doForgotPassword(email: email)
            } else {
                self.showAlert("Required".localized, message: "Please enter valid email address".localized) { (action) in
                    self.txtEmail.becomeFirstResponder()
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func doForgotPassword(email: String) {
        self.showLoader()
        let request = NetworkServicesModels.forgotPassword.request(email: email)
        NetworkServices.shared.forgotPassword(request: request) { (response)  in
            self.hideLoader()
            if response.isSuccess {
                self.performSegue(withIdentifier: "segueForgotPassword", sender: email)
            } else {
                self.showAlert("Points2Miles", message: response.errorMessage ?? "An error occured")
            }
        }
    }
    
    func resignTextFieldResponders() {
        self.txtEmail.resignFirstResponder()
        self.txtPassword.resignFirstResponder()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueForgotPassword",
            let vc = segue.destination as? ChangePasswordVC,
            let email = sender as? String {
            vc.setEmail(email)
        }
    }
}
