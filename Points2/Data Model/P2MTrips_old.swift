//
//  P2MTrips.swift
//  Point2Miles
//
//  Created by Intelivex Labs on 24/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import Foundation
class Trips: NSObject,NSCoding {
    
    /*
     "user_trips": [{
     "tripID": "4",
     "hotelID": "1",
     "start_location": "lko",
     "distance": "20.00",
     "reward_points": "100",
     "trip_image": "testingImgURL",
     "trip_date": "2018-04-17 09:04:24",
     "userID": "1",
     "statusID": "1",
     "created_date": "2018-04-17 09:04:24",
     "first_name": "Priyanka",
     "last_name": "Test",
     "name": "Holiday Inn"
     }]
     */
    var tripId: String
    var hotelId: String
    var startLocation: String = ""
    var distance: String = ""
    var rewardPoints: String = ""
    var tripImage: URL?
    var tripDate: String = ""
    var userId: String
    var statusId: String = ""
    var createdDate: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var name: String = ""
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.tripId, forKey:"tripID")
        aCoder.encode(self.hotelId, forKey:"hotelID")
        aCoder.encode(self.startLocation, forKey:"start_location")
        aCoder.encode(self.distance, forKey:"distance")
        aCoder.encode(self.rewardPoints, forKey:"reward_points")
        if let img = self.tripImage {
            aCoder.encode(img, forKey: "trip_image")
        }
        aCoder.encode(self.tripDate, forKey:"trip_date")
        aCoder.encode(self.userId, forKey: "userID")
        aCoder.encode(self.statusId, forKey: "statusID")
        aCoder.encode(self.createdDate, forKey: "created_date")
        aCoder.encode(self.firstName, forKey: "first_name")
        aCoder.encode(self.lastName, forKey: "last_name")
        aCoder.encode(self.name, forKey: "name")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        
        if let idString = aDecoder.getStringValue(for: "tripID"),
            let hotelId = aDecoder.getStringValue(for: "hotelID"),
            let userId = aDecoder.getStringValue(for: "userID") {
            
            self.tripId = idString
            self.hotelId = hotelId
            self.userId = userId
            if let locString = aDecoder.getStringValue(for: "start_location") {
                self.startLocation = locString
            }
            
            if let distanceString = aDecoder.getStringValue(for: "distance") {
                self.distance = distanceString
            }
            
            if let rewardString = aDecoder.getStringValue(for: "reward_points") {
                self.rewardPoints = rewardString
            }
            
            if let urlString = aDecoder.getStringValue(for: "trip_image"){
                var url = URL.init(string: urlString)
                if url == nil {
                    url = URL.init(string: (urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? "")
                }
                self.tripImage = url
            }
            
            if let tripDateString = aDecoder.getStringValue(for: "trip_date") {
                self.tripDate = tripDateString
            }
            
            if let statusIdString = aDecoder.getStringValue(for: "statusID") {
                self.statusId = statusIdString
            }
            
            if let createdDate = aDecoder.getStringValue(for: "created_date") {
                self.createdDate = createdDate
            }
            
            if let nameString = aDecoder.getStringValue(for: "first_name") {
                self.firstName = nameString
            }
            
            if let lastName = aDecoder.getStringValue(for: "last_name") {
                self.lastName = lastName
            }
            
            if let nameStr = aDecoder.getStringValue(for: "name") {
                self.name = nameStr
            }
            
        } else {
            return nil
        }
    }
    
    func getDictionary() -> [String: Any] {
        var rawData: [String: Any] = [:]
        rawData["tripID"] = self.tripId
        rawData["hotelID"] = self.hotelId
        rawData["start_location"] = self.startLocation
        rawData["distance"] = self.distance
        rawData["reward_points"] = self.rewardPoints
        rawData["trip_image"] = self.tripImage
        rawData["trip_date"] = self.tripDate
        rawData["userID"] = self.userId
        rawData["statusID"] = self.statusId
        rawData["created_date"] = self.createdDate
        rawData["first_name"] = self.firstName
        rawData["last_name"] = self.lastName
        rawData["name"] = self.name
        return rawData
    }
    
    init?(with data: [String: Any]) {
        
        if let idString = data.stringValue(forkey: "tripID"),
            let hotelId = data.stringValue(forkey: "hotelID"),
            let usrId = data.stringValue(forkey: "userID") {
            
            self.tripId = idString
            self.hotelId = hotelId
            self.userId = usrId
            
            if let locString = data.stringValue(forkey: "start_location") {
                self.startLocation = locString
            }
            
            if let distanceString = data.stringValue(forkey: "distance") {
                self.distance = distanceString
            }
            
            if let rewardString = data.stringValue(forkey: "reward_points") {
                self.rewardPoints = rewardString
            }
            
            if let urlString = data.stringValue(forkey: "trip_image"){
                var url = URL.init(string: urlString)
                if url == nil {
                    url = URL.init(string: (urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? "")
                }
                self.tripImage = url
            }
            
            if let tripDateString = data.stringValue(forkey: "trip_date") {
                self.tripDate = tripDateString
            }
            
            if let statusIdString = data.stringValue(forkey: "statusID") {
                self.statusId = statusIdString
            }
            
            if let createdDate = data.stringValue(forkey: "created_date") {
                self.createdDate = createdDate
            }
            
            if let nameString = data.stringValue(forkey: "first_name") {
                self.firstName = nameString
            }
            
            if let lastName = data.stringValue(forkey: "last_name") {
                self.lastName = lastName
            }
            
            if let nameStr = data.stringValue(forkey: "name") {
                self.name = nameStr
            }
            
        } else {
            return nil
        }
    }
}
