//
//  P2MUser.swift
//  Points2Miles
//
//  Created by Intelivex Labs on 24/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import Foundation

@objc(User)
class User: NSObject, NSCoding {
    
    var userId: String

    var firstName: String = ""
    var lastName: String = ""
    var email: String
    var createdDate: String = ""

    var profilePicture: URL?
    var userTrips: [Trips] = [Trips]()
    
    /*
     {
     "userID": "8",
     "first_name": "Akshit",
     "last_name": "Zaveri",
     "email": "akshit.zaveri@gmail.com",
     "auth_token": "5adb3c6f094c2",
     "created_date": "2018-04-21 08:28:15",
     "user_trips": []
     }
    
     */
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.userId, forKey: "userID")
        aCoder.encode(self.firstName, forKey: "first_name")
        aCoder.encode(self.lastName, forKey: "last_name")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.createdDate, forKey: "created_date")
        
        if let profile = self.profilePicture {
            aCoder.encode(profile, forKey: "profile")
        }

        var tripsData: [[String: Any]] = [[:]]
        for trip in self.userTrips {
            tripsData.append(trip.getDictionary())
        }
        aCoder.encode(tripsData, forKey: "user_trips")
        
    }
    
    init?(with data: [String: Any]) {
        
        if let idString = data.stringValue(forkey: "userID"),
            let emailString = data.stringValue(forkey: "email") {
            
            self.userId = idString
            self.email = emailString
            if let nameString = data.stringValue(forkey: "first_name") {
                self.firstName = nameString
            }
            
            if let lastName = data.stringValue(forkey: "last_name") {
                self.lastName = lastName
            }
            
            if let createdDate = data.stringValue(forkey: "created_date") {
                self.createdDate = createdDate
            }

            if let urlString = data.stringValue(forkey: "profile"){
                var url = URL.init(string: urlString)
                if url == nil {
                    url = URL.init(string: (urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? "")
                }
                self.profilePicture = url
            }
            
            self.userTrips = [Trips]()
            if let trips = data["user_trips"] as? [[String: Any]] {
                for trip in trips {
                    
//                    if let hotel = NetworkServices.shared.getUserPastTripHotelList(by: trip["hotelID"] as! String) {
//                        trip["hotel"] = hotel
//                    }
                    if let objTrip =  Trips.init(with: trip) {
                        self.userTrips.append(objTrip)
                    }
                }
            }
        } else {
            return nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let idString = aDecoder.getStringValue(for: "userID"),
            let emailString = aDecoder.getStringValue(for: "email") {
            self.userId = idString
            self.email = emailString
            
            if let nameString = aDecoder.getStringValue(for: "first_name") {
                self.firstName = nameString
            }
            
            if let lastName = aDecoder.getStringValue(for: "last_name") {
                self.lastName = lastName
            }
            
            if let createdDate = aDecoder.getStringValue(for: "created_date") {
                self.createdDate = createdDate
            }
            
            if let profile = aDecoder.decodeObject(forKey: "profile") as? URL {
                self.profilePicture = profile
            }
            
            self.userTrips = [Trips]()
            if let trips =  aDecoder.decodeObject(forKey: "user_trips") as? [[String: Any]] {
                for trip in trips {
                    if let objTrip =  Trips.init(with: trip) {
                        self.userTrips.append(objTrip)
                    }
                }
            }
            
        } else {
            return nil
        }
    }
    
    func getRewardPoints() -> [RewardsPoint]{
        var arrRewards = [RewardsPoint]()
        for trip in self.userTrips {
            arrRewards.append(trip.convertToRewardsPoint())
        }
        return arrRewards
    }
    
}
