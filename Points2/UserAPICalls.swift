//
//  UserAPICalls.swift
//  Points2Miles
//
//  Created by Intelivex Labs on 24/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import Foundation
import Alamofire

extension NetworkServices {
    func getUserDetail(for userid: String, responseClosure: @escaping (User?, Error?) -> Void) {
        
        _ = self.makeGETRequest(with: GetUserDetail.appending(userid)) { (response) in
            if response.error != nil {
                responseClosure(nil, response.error)
            } else {
                if let res = response.result {
                    if let user = User.init(with:res) {
                        responseClosure(user,nil)
                    } else if let msg = response.result?.stringValue(forkey:  "msg") {
                        responseClosure(nil, NSError.error(with: msg))
                    }
                } else {
                    responseClosure(nil,response.error)
                }
            }
        }
    }
    
    func updateProfileImage(with request: NetworkServicesModels.userProfileImage.request,
                            responseClosure: (@escaping (User?, Error?) ->Void)) {
        let param: Parameters = [ "userID": request.userid,
                                  "profile_image": request.image ]
        
        self.makePOSTRequest(with: UpdateUserProfileImage, parameters: param, { (response) in
            DispatchQueue.main.async {
                if let error = response.error {
                    responseClosure(nil, error)
                } else {
                    if let result = response.result,
                        let user = User.init(with: result) {
                        NetworkServices.shared.loginSession?.user = user
                        NetworkServices.shared.loginSession?.save()
                        responseClosure(user, nil)
                    } else if let msg = response.result?.stringValue(forkey:  "msg") {
                        responseClosure(nil, NSError.error(with: msg))
                    } else {
                        responseClosure(nil, response.error)
                    }
                }
            }
        })
    }
    
    func updateUserDetails(request: NetworkServicesModels.user.request,
                           responseClosure: (@escaping (User?, Error?) ->Void)) {
        
        let param: [String : String] = [ "email": request.email,
                                         "userID": request.userid,
                                         "first_name": request.firstName,
                                         "last_name": request.lastName ]
        
        self.makePOSTRequest(with: UpdateUserDetails, parameters: param, { (response) in
            DispatchQueue.main.async {
                if let error = response.error {
                    responseClosure(nil, error)
                } else {
                    if let result = response.result,
                        let user = User.init(with: result) {
                        NetworkServices.shared.loginSession?.user = user
                        NetworkServices.shared.loginSession?.save()
                        responseClosure(user, nil)
                    } else if let msg = response.result?.stringValue(forkey:  "msg") {
                        responseClosure(nil, NSError.error(with: msg))
                    } else {
                        responseClosure(nil, response.error)
                    }
                }
            }
        })
    }
    
    func startUserTrip(request: NetworkServicesModels.createTrip.request,
                       responseClosure: (@escaping (Trips?, Error?) ->Void)) {
        
        
        let param: [String : String] = [ "start_location_latitude": request.startLocationLatitude,
                                         "start_location_longitude": request.startLocationLongitude,
                                         "hotelID": request.hotelId,
                                         "start_location_address": request.startLocationAddress ?? "",
                                         "start_location_city": request.startLocationCity ?? "" ,
                                         "start_location_state": request.startLocationState ?? "",
                                         "start_location_zip": request.startLocationZip ?? "",
                                         "polyline_map_points" : request.locationPoints ?? ""
        ]
        
        self.makePOSTRequest(with: CreateTrip, parameters: param, { (response) in
            DispatchQueue.main.async {
                if let error = response.error {
                    responseClosure(nil, error)
                } else {
                    if let result = response.result,
                        let trip = Trips.init(currentTripData: result) {
                        trip.saveCurrentTripSession()
                        responseClosure(trip, nil)
                    } else if let msg = response.result?.stringValue(forkey:  "msg") {
                        responseClosure(nil, NSError.error(with: msg))
                    } else {
                        responseClosure(nil, response.error)
                    }
                }
            }
        })
    }
    
    func endTrip(request:NetworkServicesModels.endTrip.request,
                 responseClosure: (@escaping (NetworkServicesModels.endTrip.response)->Void)) {
        
        let param = [
            "tripID": request.tripId,
            "distance" : "\(request.distance)"
        ]
        
        self.makePOSTRequest(with: UpdateTrip, parameters: param, { (rawResponse) in
            DispatchQueue.main.async {
                var response = NetworkServicesModels.endTrip.response(isSuccess: false)
                if let result = rawResponse.result,
                    let tripId = result["tripID"] as? String,
                    tripId == request.tripId {
                    response.isSuccess = true
                }
                responseClosure(response)
            }
        })
    }
    
    func deleteTrip(request: NetworkServicesModels.deleteTrip.request,
                    responseClosure: (@escaping (NetworkServicesModels.deleteTrip.response) ->Void)) {
        
        let param = [ "tripID" : request.tripId ]
        
        self.makePOSTRequest(with: DeleteTrip, parameters: param, { (rawResponse) in
            DispatchQueue.main.async {
                var response = NetworkServicesModels.deleteTrip.response(isSuccess: false)
                if let result = rawResponse.result,
                    let status = result["status"] as? String , status.lowercased() == "success" {
                    response.isSuccess = true
                }
                responseClosure(response)
            }
        })
    }
    
    func getMapPathToDraw(request: NetworkServicesModels.drawMapPath.request,responseClosure: (@escaping ([String:Any]?, Error?) ->Void)) {
        
        _ = self.makeGETRequest(with:"\(GetMapPath)json?origin=\(request.rootLocation.latitude),\(request.rootLocation.longitude)&destination=\(request.destinationLocation.latitude),\(request.destinationLocation.longitude)&key=") { (response) in
            if response.error != nil {
                responseClosure(nil, response.error)
            } else {
                if let res = response.result {
                    responseClosure(res,nil)
                } else {
                    responseClosure(nil,response.error)
                }
            }
        }
    }
    
    
    func hotelCheckout(request: NetworkServicesModels.rewardsPoints.request,
                       responseClosure: (@escaping (Trips?, Error?) ->Void)) {
        
        let param: [String: Any] = ["tripID": request.tripID,
                                    "hotelCheckoutID": request.tripID]
        
        self.makePOSTRequest(with: HotelCheckout, parameters: param, { (response) in
            DispatchQueue.main.async {
                if let error = response.error {
                    responseClosure(nil, error)
                } else {
                    if let result = response.result,
                        let trip = Trips.init(currentTripData: result) {
                        trip.saveCurrentTripSession()
                        responseClosure(trip, nil)
                    } else if let msg = response.result?.stringValue(forkey: "msg") {
                        responseClosure(nil, NSError.error(with: msg))
                    } else {
                        responseClosure(nil, response.error)
                    }
                }
            }
        })
    }
    
    func changePassword(request: NetworkServicesModels.changePassword.request,
                        responseClosure: @escaping ((NetworkServicesModels.changePassword.response?)->Void)) {
        let params = [
            "email": request.email,
            "password": request.password,
            "otp": request.otp
        ]
        self.makePOSTRequest(with: ChangePassword, parameters: params) { (rawResponse) in
            DispatchQueue.main.async {
                var response = NetworkServicesModels.changePassword.response()
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
            }
        }
    }
}


