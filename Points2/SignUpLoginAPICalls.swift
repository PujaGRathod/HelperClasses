//
//  SignUpLoginAPICalls.swift
//  Points2Miles_Akshit
//
//  Created by Intelivex Labs on 23/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit


extension NetworkServices:UNUserNotificationCenterDelegate {
    
    func registerForNotifcation() {
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound, .badge]) { (granted: Bool, error: Error?) in
            if (error != nil) {
                print("Failed to request authorization")
                return
            }
            if granted {
                DispatchQueue.main.async {
                    UNUserNotificationCenter.current().delegate = self
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("The user refused the push notification")
            }
        }
    }
    
    public typealias Parameters = [String: Any]
    
    func signUp(request: NetworkServicesModels.signUp.request,
                responseClosure: (@escaping (User?, Bool, Error?) ->Void)) {
        
        let param: [String : String] = [
            "first_name": request.first_name ?? "",
            "last_name": request.last_name ?? "",
            "email": request.email ?? "",
            "password": request.password ?? "",
            "device_token": request.device_token ?? "",
            ]
        
        self.makePOSTRequest(with: SignUpURL, parameters: param, { (response) in
            DispatchQueue.main.async {
                if let error = response.error {
                    responseClosure(nil, false, error)
                } else {
                    if let token = response.result?.stringValue(forkey:  "auth_token"),
                        let user = User.init(with: response.result!) {
//                        self.registerForNotifcation()
                        self.loginSession = LoginSession.createSession(with: token, user: user)
                        self.loginSession?.loadHotelList({})
                        NetworkServices.shared.loginSession?.updateUserDetails()
                        responseClosure(self.loginSession?.user, true, nil)
                        
                    } else if let msg = response.result?.stringValue(forkey:  "msg") {
                        self.loginSession = nil
                        responseClosure(nil, false, NSError.error(with: msg))
                    }
                    else {
                        self.loginSession = nil
                        responseClosure(nil, false, response.error)
                    }
                }
            }
        })
    }
    
    func logIn(request: NetworkServicesModels.logIn.request,
               responseClosure: (@escaping (User?, Bool, Error?) ->Void)) {
        
        let param: [String : String] = [
            "email": request.email ?? "",
            "password": request.password ?? "",
            "device_token": request.device_token ?? "",
            ]
        
        self.makePOSTRequest(with: LoginURL, parameters: param, { (response) in
            DispatchQueue.main.async {
                if let error = response.error {
                    responseClosure(nil, false, error)
                } else {
                    if let token = response.result?.stringValue(forkey:  "auth_token"),
                        let user = User.init(with: response.result!) {
//                        self.registerForNotifcation()
                        self.loginSession = LoginSession.createSession(with: token, user: user)
                        self.loginSession?.loadHotelList({})
                        NetworkServices.shared.loginSession?.updateUserDetails()
                        responseClosure(self.loginSession?.user, true, nil)
                        
                    } else if let msg = response.result?.stringValue(forkey:  "msg") {
                        self.loginSession = nil
                        responseClosure(nil, false, NSError.error(with: msg))
                    }
                    else {
                        self.loginSession = nil
                        responseClosure(nil, false, response.error)
                    }
                }
            }
        })
    }
    func addDeviceToken(request: NetworkServicesModels.addDeviceToken.request,
                        responseClosure: @escaping ((APIResponse)->Void)) {
        
        let param: [String : String] = [
            "auth_token": request.authToken ?? "",
            "device_token": request.deviceToken ?? "",
            ]
        
        self.makePOSTRequest(with: "users/DoaddDeviceToken", parameters: param, { (response) in
            print(response)
            if response.error != nil { }
            // else if let result = response.result?["Responsebody"] as? [String: Any] {}
        })
    }
    
    func delegteDeviceToken(request: NetworkServicesModels.deleteDeviceToken.request,
                            responseClosure: @escaping ((APIResponse)->Void)) {
        
        let param: [String : String] = [
            "auth_token": request.authToken ?? "",
            "device_token": request.deviceToken ?? "",
            ]
        
        self.makePOSTRequest(with: "users/DodeleteDeviceToken", parameters: param, { (response) in
            print(response)
            if response.error != nil { }
            responseClosure(response)
            // else if let result = response.result?["Responsebody"] as? [String: Any] {}
        })
    }
    
    func forgotPassword(request: NetworkServicesModels.forgotPassword.request,
                        responseClosure: @escaping ((NetworkServicesModels.forgotPassword.response)->Void)) {
        
        let param: [String : String] = [
            "email": request.email ?? "",
            ]
        
        self.makePOSTRequest(with: ForgotPasswordURL, parameters: param, { (rawResponse) in
            var response = NetworkServicesModels.forgotPassword.response()
            if let error = rawResponse.error {
                response.errorMessage = error.localizedDescription
            } else {
                if let result = rawResponse.result,
                    let status = result["status"] as? String , status.lowercased() == "success" {
                    response.isSuccess = true
                } else if let msg = rawResponse.result?.stringValue(forkey:  "msg") {
                    response.errorMessage = msg
                } else {
                    response.errorMessage = rawResponse.error?.localizedDescription
                }
            }
            responseClosure(response)
        })
    }
}

