//
//  ChangePasswordVC.swift
//  Points2Miles
//
//  Created by Akshit Zaveri on 03/05/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ChangePasswordVC: UIViewController {
    
    private var email: String!
    
    @IBOutlet weak var otpTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 123, height: 30.5))
//        imageView.image = #imageLiteral(resourceName: "AppLogo")
//        imageView.contentMode = .scaleAspectFit
//        self.navigationController?.navigationBar.topItem?.titleView = imageView
    }
    
    func setEmail(_ email: String) {
        self.email = email
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let email = self.email {
            self.showAlert("Points2Miles", message: "An email has been sent to \(email) with an OTP")
        }
    }
    
    @IBAction func btnChangePasswordTapped(_ sender: UIButton) {
        guard let otp = self.otpTextField.text, !otp.isEmpty else {
            self.showAlert("Forgot password", message: "OTP is required")
            return
        }
        
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            self.showAlert("Forgot password", message: "Password is required")
            return
        }
        
        guard let confirmPassword = self.confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            self.showAlert("Forgot password", message: "Confirm Password is required")
            return
        }
        
        if password != confirmPassword {
            self.showAlert("Forgot password", message: "Password and Confirm Password should match.")
            return
        }
        
        self.otpTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        self.confirmPasswordTextField.resignFirstResponder()
        
        guard let email = self.email else {
            return
        }
        self.changePassword(forEmail: email, password: password, otp: otp)
    }
    
    private func changePassword(forEmail email: String, password: String, otp: String) {
        let request = NetworkServicesModels.changePassword.request(email: email,
                                                                   password: password,
                                                                   otp: otp)
        
        self.showLoader()
        NetworkServices.shared.changePassword(request: request) { (response) in
            guard let response = response else {
                self.showAlert("Error", message: "")
                return
            }
            
            self.hideLoader()
            if response.isSuccess {
                self.dismiss(animated: true, completion: {
                    self.showAlert("Success", message: "Your password was changed successfully.")
                })
            } else {
                self.showAlert("Error", message: response.errorMessage ?? "Error occured")
            }
        }
    }
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
