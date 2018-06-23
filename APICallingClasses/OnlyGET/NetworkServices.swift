//
//  NetworkServices.swift
//  Dishwasher
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

class NetworkServices: NSObject {
    
    struct APIRequest {
        var request: DataRequest?
        func cancel() {
            self.request?.cancel()
        }
    }
    
    static let shared = NetworkServices()
    let reachablity = NetworkReachabilityManager()
    let manager = ProductManager()
    var isConnectedToInternet: Bool {
        if let isNetworkReachable = self.reachablity?.isReachable,
            isNetworkReachable == true {
            return true
        } else {
            return false
        }
    }
    
    override init() {
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
    

        func handleCorrectResponse(with data: [String: Any]) {
            completion(APIResponse.init(error: nil, result: data))
            return
        }
        
        
        var request = APIRequest()
        request.request = Alamofire.request(urlString, method: .get, parameters: parameters, headers: headers).responseJSON { response in
            if let json = response.result.value as? [String: Any] {
                print("JSON: \(json)") // serialized json response
                if let error = self.manager.validResponse(json: json) {
                    if let errMsg = error.1 {
                        wrongResponse(with: errMsg)
                    } else if let jsonDic = error.0 {
                        handleCorrectResponse(with: jsonDic)
                    } else {
                        handleCorrectResponse(with: json)
                    }
                }
                
//                if getDirectResponse {
//                    completion(APIResponse.init(error: nil, result: json))
//                    return
//                }
                
            } else if let data = response.data {
                let dataString = String(data: data, encoding: .utf8)
                print("Data: \(String(describing: dataString))") // original server data as UTF8 string
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
                        if getDirectResponse {
                            completion(APIResponse.init(error: nil, result: json))
                            return
                        }
                        if let error = self.manager.validResponse(json: json) {
                            if let errMsg = error.1 {
                                wrongResponse(with: errMsg)
                            } else if let jsonDic = error.0 {
                                handleCorrectResponse(with: jsonDic)
                            } else {
                                handleCorrectResponse(with: json)
                            }
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


