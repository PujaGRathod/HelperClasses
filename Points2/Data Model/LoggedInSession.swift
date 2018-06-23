//
//  LoggedInSession.swift
//  Points2Miles_Akshit
//
//  Created by Intelivex Labs on 23/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import Foundation
import UIKit
import MapKit
private let SessionKey: String = "LoginSession"

@objc(LoginSession)
class LoginSession: NSObject, NSCoding {

    private var deviceToken: String = ""
    var authToken: String
    var user: User

    init(authToken: String, user: User) {
        self.authToken = authToken
        self.user = user
    }

    required init?(coder aDecoder: NSCoder) {
        if let token = aDecoder.getStringValue(for: "auth_token"),
            let user:User = aDecoder.decodeObject(forKey: "user") as? User {
                self.user = user
                self.authToken = token

        } else {
            return nil
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.authToken, forKey: "auth_token")
        aCoder.encode(self.deviceToken, forKey: "device_token")
        aCoder.encode(self.user, forKey: "user")

    }

    func setToken(_ token: String) {
        self.authToken = token
        self.save()
    }
    
    func updateUserDetails(_ completion: (() -> Void)? = nil) {
        NetworkServices.shared.getUserDetail(for: self.user.userId, responseClosure: { (user, error) in
            if let fetchedUser = user {
                self.user = fetchedUser
                self.save()
                completion?()
            }
        })
    }

    func save() {
//        let data = NSKeyedArchiver.archivedData(withRootObject: self)
//        UserDefaults.standard.set(data, forKey: SessionKey)
//        UserDefaults.standard.synchronize()
        if let pathURL = getSessionStoragePath() {
            let success = NSKeyedArchiver.archiveRootObject(self, toFile: pathURL.path)
            if success {
                print("Login session saved at path: \(pathURL.path)")
            } else {
                assertionFailure("Session saving falied!")
            }
        }
    }

    func loadHotelList(_ completion: (() -> Void)? = nil) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            
            NetworkServices.shared.getHotelist { (hotels, error) in
                delegate.arrHotels = NetworkServices.shared.getLocalHotelList()
                completion?()
            }
            
            if let arrHotelList = NetworkServices.shared.getLocalHotelList() {
                if arrHotelList.count > 0 {
                    delegate.arrHotels = arrHotelList
                    completion?()
                }
            }
        }
        completion?()
    }

    func logout(_ completion: @escaping () -> Void) {
        let request = NetworkServicesModels.deleteDeviceToken.request(authToken: self.authToken, deviceToken: self.deviceToken)
        NetworkServices.shared.delegteDeviceToken(request: request) {(response) in
            if response.error != nil {
                print("error \(String(describing: response.error))")
            } else {
                print(response)
                LoginSession.clearLocalSession()
                UIApplication.shared.unregisterForRemoteNotifications()
            }
        }
    }

    class func createSession(with token: String, user: User) -> LoginSession {
        let session = LoginSession.init(authToken: token, user: user)
        session.save()
        return session
    }

    class func clearLocalSession() {
        if let pathURL = getSessionStoragePath() {
            if checkIfSessionExist(at: pathURL.path) {
                let fileManager = FileManager.default
                do {
                    try fileManager.removeItem(at: pathURL)
                } catch {
                    assertionFailure("Session deletion falied!")
                }
            }
        }
//        UserDefaults.standard.removeObject(forKey: SessionKey)
//        UserDefaults.standard.synchronize()
    }

    class func getLocalSession() -> LoginSession? {
        if let storageURL = getSessionStoragePath() {
            if checkIfSessionExist(at: storageURL.path) {
                if let sessionData = NSKeyedUnarchiver.unarchiveObject(withFile: storageURL.path) {
                    if let session = sessionData as? LoginSession {
                        return session
                    } else {
                        LoginSession.clearLocalSession()
                    }
                }
            }
        }
        return nil
    }
    
    func addDeviceToken(_ tokenString: String) {
        self.deviceToken = tokenString
        let request = NetworkServicesModels.addDeviceToken.request(authToken: self.authToken, deviceToken: self.deviceToken)
        NetworkServices.shared.addDeviceToken(request: request) {(response) in
                if response.error != nil {
                    print("error \(String(describing: response.error))")
                } else {
                    print(response)
                }
            }
        self.save()
    }
    
    class func setupLoginFlow() {
        func setRootController(_ vc: UINavigationController) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate,
                let window = delegate.window {
                window.rootViewController = vc
            }
        }
        if let loginSession = LoginSession.getLocalSession() {
            loginSession.loadHotelList {}
            let dashboardStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            setRootController(dashboardStoryboard.instantiateViewController(withIdentifier: "DashBoard") as! UINavigationController)
            return
            
        } else {
            LoginSession.clearLocalSession()
        }
    }
    
    class func setupLogoutFlow() {

    }
}

fileprivate func getSessionStoragePath() -> URL? {
    let fileManager = FileManager.default
    do {
        let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
        let fileURL = documentDirectory.appendingPathComponent(SessionKey)
        return fileURL
    } catch {
        print(error)
    }
    return nil
}

fileprivate func checkIfSessionExist(at path: String) -> Bool {
    let fileManager = FileManager.default
    return fileManager.fileExists(atPath: path)
}
