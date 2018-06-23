//
//  NetworkServices.swift
//  Points2Miles
//
//  Created by Intelivex Labs on 23/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit
import Alamofire

struct APIResponse {
    var error: Error?
    var result: [String: Any]?
}

//let BaseURLLive = "http://myrianntest.com/pr/points2miles/API/"
let BaseURLLive = "http://webexcellis.com/points2miles/API/"
class NetworkServices: NSObject {
    
    struct APIRequest {
        var request: DataRequest?
        func cancel() {
            self.request?.cancel()
        }
    }
    
    static let shared = NetworkServices()
    let reachablity = NetworkReachabilityManager()
    var loginSession: LoginSession?
    
    
    var isConnectedToInternet: Bool {
        if let isNetworkReachable = self.reachablity?.isReachable,
            isNetworkReachable == true {
            return true
        } else {
            return false
        }
    }
    
    override init() {
        self.loginSession = LoginSession.getLocalSession()
        super.init()
        self.reachablity?.startListening()
        self.reachablity?.listener = { status in
            if let isNetworkReachable = self.reachablity?.isReachable,
                isNetworkReachable == true {
                print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
                print("Internet Connected")
                print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
            } else {
                print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
                print("Internet Disconnected")
                print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
            }
        }
    }
    
    // MARK: - Base Methods
    func makeAPIPath(with requestString: String) -> String {
        return BaseURLLive.appending(requestString)
    }
    
    private func validateResponse(json: [String: Any]) -> String? {
        print("JSON: \(json)") // serialized json response
        if let error = json["error"] as? String {
            return error
        } else if let success = json["statuscode"] as? NSInteger,
            success != 200 {
            if let data = json.stringValue(forkey: "Responsebody"),
                data != "<null>" {
                return data
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func makePOSTRequest(with urlString: String, parameters: Parameters?, _ completion: @escaping (APIResponse) -> Void) {
        if !self.isConnectedToInternet {
            completion(APIResponse.init(error: NSError.error(with: "cannot connect to internet"), result: nil))

        }
        if urlString.isEmpty {
            completion(APIResponse.init(error: NSError.error(with: "request is invalid!"), result: nil))

        }
        
        func handleCorrectResponse(with data: [String: Any]) {
            if let data = data["Responsebody"] as? [String: Any] {
                completion(APIResponse.init(error: nil, result: data))
            } else {
                completion(APIResponse.init(error: nil, result: data))
            }
            return
        }
        
        func wrongResponse(with errorMessage: String?) {
            if let errorMessage = errorMessage {
                completion(APIResponse.init(error: NSError.error(with: errorMessage), result: nil))
            } else {
                completion(APIResponse.init(error: nil, result: nil))
            }
            return
        }
    
        var headers: HTTPHeaders? = [
            "Content-type": "multipart/form-data"
        ]
        if urlString != LoginURL ,
            urlString != SignUpURL,
            urlString != ForgotPasswordURL,
            urlString != ChangePassword {
            if let token = self.loginSession?.authToken {
                headers = [
                    "Authorization": token
                ]
            } else {
                completion(APIResponse.init(error: NSError.error(with: "request unauthorized!".localized), result: nil))
            }
        }
        
        
        let fullURL = self.makeAPIPath(with: urlString)
        print("Calling POST: \(fullURL)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            if let parameters = parameters {
                for (key, value) in parameters {
//                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    if let image = value as? UIImage {
                        if let imageData = UIImageJPEGRepresentation(image, 0.8) {
                            multipartFormData.append(imageData, withName: key, fileName: "\(Date().timeIntervalSinceReferenceDate).jpg", mimeType: "image/jpg")
                        }
                    } else {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                }
            }
            
        }, usingThreshold: UInt64.init(), to: fullURL, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let json = response.result.value as? [String: Any] {
                        print("JSON: \(json)") // serialized json response
                        if let error = self.validateResponse(json: json) {
                            wrongResponse(with: error)
                        } else {
                            handleCorrectResponse(with: json)
                        }
                    } else if let data = response.data {
                        let dataString = String(data: data, encoding: .utf8)
                        print("Data: \(String(describing: dataString))") // original server data as UTF8 string
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
                                if let error = self.validateResponse(json: json) {
                                    wrongResponse(with: error)
                                } else {
                                    handleCorrectResponse(with: json)
                                }
                            } else {
                                wrongResponse(with: nil)
                            }
                        } catch {
                            print("Error while converting to json: \(error.localizedDescription)")
                            wrongResponse(with: nil)
                        }
                    } else {
                        wrongResponse(with: nil)
                    }
                    
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                wrongResponse(with: nil)
            }
        }
    }
    
    func makeGETRequest(with urlString: String, parameters: Parameters? = nil, getDirectResponse: Bool = false, _ completion: @escaping (APIResponse) -> Void) -> APIRequest? {
        if !self.isConnectedToInternet {
            completion(APIResponse.init(error: NSError.error(with: "cannot connect to internet"), result: nil))
            return nil
        }
        
        if urlString.isEmpty {
            completion(APIResponse.init(error: NSError.error(with: "request is invalid!"), result: nil))
            return nil
        }
        
        func wrongResponse(with errorMessage: String?) {
            if let errorMessage = errorMessage {
                completion(APIResponse.init(error: NSError.error(with: errorMessage), result: nil))
            } else {
                completion(APIResponse.init(error: nil, result: nil))
            }
            return
        }
      
        var headers: HTTPHeaders? = [
            "Content-type":"application/json"
        ]
        if urlString != LoginURL ,
            urlString != SignUpURL,
            urlString != ForgotPasswordURL {
            if let token = self.loginSession?.authToken {
                headers = [
                    "Authorization": token
                ]
            } else {
                completion(APIResponse.init(error: NSError.error(with: "request unauthorized!".localized), result: nil))
            }
        }
        

        func handleCorrectResponse(with data: [String: Any]) {
            completion(APIResponse.init(error: nil, result: data))
            return
        }
        
        var fullURL = ""
        if  !urlString.contains(GetMapPath) {
            fullURL = self.makeAPIPath(with: urlString)
        } else {
            fullURL = urlString
        }
        
        var request = APIRequest()
        request.request = Alamofire.request(fullURL, method: .get, parameters: parameters, headers: headers).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                print("JSON: \(json)") // serialized json response
                if getDirectResponse {
                    completion(APIResponse.init(error: nil, result: json))
                    return
                }
                if let error = self.validateResponse(json: json) {
                    wrongResponse(with: error)
                } else {
                    if let data = json["Responsebody"] as? [String: Any] {
                        handleCorrectResponse(with: data)
                    } else {
                        handleCorrectResponse(with: json)
                    }
                }
            } else if let data = response.data {
                let dataString = String(data: data, encoding: .utf8)
                print("Data: \(String(describing: dataString))") // original server data as UTF8 string
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
                        if getDirectResponse {
                            completion(APIResponse.init(error: nil, result: json))
                            return
                        }
                        if let error = self.validateResponse(json: json) {
                            wrongResponse(with: error)
                        } else {
                            handleCorrectResponse(with: json)
                        }
                    } else {
                        wrongResponse(with: nil)
                    }
                } catch {
                    print("Error while converting to json: \(error.localizedDescription)")
                    wrongResponse(with: nil)
                }
            } else {
                wrongResponse(with: nil)
            }
        }
        return request
    }
    
    //Map changes
    func makeGETRoutesAPIRequest(with urlString: String, parameters: Parameters? = nil, getDirectResponse: Bool = false, _ completion: @escaping (APIResponse) -> Void) -> APIRequest? {
        if !self.isConnectedToInternet {
            completion(APIResponse.init(error: NSError.error(with: "cannot connect to internet"), result: nil))
            return nil
        }
        
        if urlString.isEmpty {
            completion(APIResponse.init(error: NSError.error(with: "request is invalid!"), result: nil))
            return nil
        }
        
        func wrongResponse(with errorMessage: String?) {
            if let errorMessage = errorMessage {
                completion(APIResponse.init(error: NSError.error(with: errorMessage), result: nil))
            } else {
                completion(APIResponse.init(error: nil, result: nil))
            }
            return
        }
        
        var headers: HTTPHeaders? = [
            "Content-type":"application/json"
        ]
        if urlString != LoginURL ,
            urlString != SignUpURL,
            urlString != ForgotPasswordURL {
            if let token = self.loginSession?.authToken {
                headers = [
                    "Authorization": token
                ]
            } else {
                completion(APIResponse.init(error: NSError.error(with: "request unauthorized!".localized), result: nil))
            }
        }
        
        
        func handleCorrectResponse(with data: [String: Any]) {
            completion(APIResponse.init(error: nil, result: data))
            return
        }
        
        let fullURL = self.makeAPIPath(with: urlString)
        print("Calling GET: \(fullURL)")
        
        var request = APIRequest()
        request.request = Alamofire.request(fullURL, method: .get, parameters: parameters, headers: headers).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                print("JSON: \(json)") // serialized json response
                if getDirectResponse {
                    completion(APIResponse.init(error: nil, result: json))
                    return
                }
                if let error = self.validateResponse(json: json) {
                    wrongResponse(with: error)
                } else {
                    if let data = json["Responsebody"] as? [String: Any] {
                        handleCorrectResponse(with: data)
                    } else {
                        handleCorrectResponse(with: json)
                    }
                }
            } else if let data = response.data {
                let dataString = String(data: data, encoding: .utf8)
                print("Data: \(String(describing: dataString))") // original server data as UTF8 string
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
                        if getDirectResponse {
                            completion(APIResponse.init(error: nil, result: json))
                            return
                        }
                        if let error = self.validateResponse(json: json) {
                            wrongResponse(with: error)
                        } else {
                            handleCorrectResponse(with: json)
                        }
                    } else {
                        wrongResponse(with: nil)
                    }
                } catch {
                    print("Error while converting to json: \(error.localizedDescription)")
                    wrongResponse(with: nil)
                }
            } else {
                wrongResponse(with: nil)
            }
        }
        return request
    }
    
    
    
    
}


