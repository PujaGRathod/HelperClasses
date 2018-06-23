//
//  P2MTrips.swift
//  Points2Miles
//
//  Created by Intelivex Labs on 24/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import Foundation
import MapKit
private let tripSessionKey: String = "curretTrip"

@objc(Trips)
class Trips: NSObject,NSCoding {
    
    /*
     "tripID": "9",
     "hotelName": "Holiday Inn Express & Suites\nAtlanta Downtown",
     "hotelAddress": "111 Cone Street NW",
     "hotelCity": "Atlanta",
     "hotelState": "Georgia",
     "hotelZip": "30303",
     "hotellatitude": "33.7525",
     "hotellongitude": "-84.3888",
     "hotelimage": "https:\/\/ihg.scene7.com\/is\/image\/ihg\/holiday-inn-express-and-suites-atlanta-4304929160-4x3?wid=1200&fit=constrain",
     "distance": null,
     "reward_points": null,
     "trip_image": null,
     "trip_date": "2018-05-02 05:59:16",
     "statusID": "1"
     */
        
    var rewardPoint:RewardsPoint?
    var tripId: Int = 0
    var hotelId: Int = 0
    var startLocationAddress = ""
    var startLocationCity = ""
    var startLocationState = ""
    var startLocationZip = ""
    var startLocationLat:Double = 0
    var startLoctaionLon:Double = 0

    var distance: Double = 0
    var rewardPoints: Double = 0
    var tripImage: URL?
    var tripDate: String = ""
    var userId: String
    var statusId: Int = 0
    var createdDate: String = ""
    var address : String = ""
    var city : String = ""
    var state :String = ""
    var destinationLat:Double = 0
    var destinationLon:Double = 0
    var hotelImage :URL?
    var firstName: String = ""
    var lastName: String = ""
    var name: String = ""
    var zip: String = ""
    var hotel: Hotel?
    var mapPoints:String = ""
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.tripId, forKey:"tripID")
        aCoder.encode(self.hotelId, forKey:"hotelID")
        aCoder.encode(self.distance, forKey: "distance")
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
        
        aCoder.encode(self.hotel, forKey:"hotel")
        
        aCoder.encode(self.startLoctaionLon, forKey:"start_location_longitude")
        aCoder.encode(self.startLocationLat, forKey:"start_location_latitude")
        aCoder.encode(self.startLocationZip, forKey:"start_location_zip")
        aCoder.encode(self.startLocationState, forKey:"start_location_state")
        aCoder.encode(self.startLocationCity, forKey:"start_location_city")
        aCoder.encode(self.startLocationAddress, forKey:"start_location_address")
        
        aCoder.encode(self.address, forKey:"address")
        aCoder.encode(self.city, forKey:"city")
        aCoder.encode(self.state, forKey:"state")
        aCoder.encode(self.destinationLat, forKey:"latitude")
        aCoder.encode(self.destinationLon, forKey:"longitude")
        aCoder.encode(self.mapPoints, forKey:"polyline_map_points")
        
        
        if let img = self.hotelImage {
            aCoder.encode(img, forKey: "image")
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let idString = aDecoder.getStringValue(for: "tripID"),
            let hotelId = aDecoder.getStringValue(for: "hotelID"),
            let userId = aDecoder.getStringValue(for: "userID") {
            
            if let hotel = NetworkServices.shared.getUserPastTripHotelList(by: hotelId) {
                self.hotel = hotel
            }
            self.tripId = Int(idString) ?? 0
            self.hotelId = Int(hotelId) ?? 0
            self.userId = userId
            self.distance = aDecoder.decodeDouble(forKey: "distance")
            self.rewardPoints = aDecoder.decodeDouble(forKey: "reward_points")

            
            if let urlString = aDecoder.getStringValue(for: "trip_image"){
                var url = URL.init(string: urlString)
                if url == nil {
                    url = URL.init(string: (urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? "")
                }
                self.tripImage = url
            }
            
            if let strMapPoints = aDecoder.getStringValue(for: "polyline_map_points") {
                self.mapPoints = strMapPoints
            }
            
            if let tripDateString = aDecoder.getStringValue(for: "trip_date") {
                self.tripDate = tripDateString
            }
            
            if let statusIdString = aDecoder.getStringValue(for: "statusID") {
                self.statusId = Int(statusIdString) ?? 0
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
            
            if let urlString = aDecoder.getStringValue(for: "image"){
                var url = URL.init(string: urlString)
                if url == nil {
                    url = URL.init(string: (urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? "")
                }
                self.hotelImage = url
            }
            
            if let nameStr = aDecoder.getStringValue(for: "start_location_longitude") {
                self.startLoctaionLon = Double(nameStr) ?? 0
            }
            
            if let nameStr = aDecoder.getStringValue(for: "start_location_longitude") {
                self.startLoctaionLon = Double(nameStr) ?? 0
            }
            
            if let nameStr = aDecoder.getStringValue(for: "start_location_zip") {
                self.startLocationZip = nameStr
            }
            
            if let nameStr = aDecoder.getStringValue(for: "start_location_state") {
                self.startLocationState = nameStr
            }
            
            if let nameStr = aDecoder.getStringValue(for: "start_location_city") {
                self.startLocationCity = nameStr
            }
            
            if let nameStr = aDecoder.getStringValue(for: "start_location_address") {
                self.startLocationAddress = nameStr
            }
            
            if let nameStr = aDecoder.getStringValue(for: "latitude") {
                self.destinationLat = Double(nameStr) ?? 0
            }
            
            if let nameStr = aDecoder.getStringValue(for: "longitude") {
                self.destinationLon = Double(nameStr) ?? 0
            }
            
            if let nameStr = aDecoder.getStringValue(for: "address") {
                self.address = nameStr
            }
            
            if let nameStr = aDecoder.getStringValue(for: "city") {
                self.city = nameStr
            }
            
            if let nameStr = aDecoder.getStringValue(for: "state") {
                self.state = nameStr
            }
            
        } else {
            return nil
        }
    }
    
    init?(currentTripData:[String : Any]) {
        if let idString = currentTripData.stringValue(forkey: "tripID") {
            self.tripId = Int(idString) ?? 0
            self.userId = ""
            var Lat: Double = 0
            if let distanceString = currentTripData.stringValue(forkey: "hotellatitude") {
                Lat = Double(distanceString) ?? 0
            } else if let di = currentTripData["hotellatitude"] as? Double {
                Lat = di
            }
            self.destinationLat = Lat
            
            var Lon: Double = 0
            if let distanceString = currentTripData.stringValue(forkey: "hotellongitude") {
                Lon = Double(distanceString) ?? 0
            } else if let di = currentTripData["hotellongitude"] as? Double {
                Lon = di
            }
            
            self.destinationLon = Lon
            
            if let strMapPoints = currentTripData.stringValue(forkey: "polyline_map_points") {
                self.mapPoints = strMapPoints
            }
            
            if let tripDateString = currentTripData.stringValue(forkey: "hotelAddress") {
                self.address = tripDateString
            }
            
            if let tripDateString = currentTripData.stringValue(forkey: "hotelCity") {
                self.city = tripDateString
            }
            
            if let tripDateString = currentTripData.stringValue(forkey: "hotelState") {
                self.state = tripDateString
            }
            
            if let tripDateString = currentTripData.stringValue(forkey: "hotelZip") {
                self.zip = tripDateString
            }
            
            if let tripDateString = currentTripData.stringValue(forkey: "hotelName") {
                self.name = tripDateString
            }
            
            if let urlString = currentTripData.stringValue(forkey: "hotelimage"){
                var url = URL.init(string: urlString)
                if url == nil {
                    url = URL.init(string: (urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? "")
                }
                self.hotelImage = url
            }
            
            if let urlString = currentTripData.stringValue(forkey: "trip_image"){
                var url = URL.init(string: urlString)
                if url == nil {
                    url = URL.init(string: (urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? "")
                }
                self.tripImage = url
            }
            
            var dist: Double = 0
            if let distanceString = currentTripData.stringValue(forkey: "distance") {
                dist = Double(distanceString) ?? 0
            } else if let di = currentTripData["distance"] as? Double {
                dist = di
            }
            self.distance = dist
            
            var points: Double = 0
            if let pointsString = currentTripData.stringValue(forkey: "reward_points") {
                points = Double(pointsString) ?? 0
            } else if let point = currentTripData["reward_points"] as? Double {
                points = point
            }
            self.rewardPoints = points
            
            if let tripDateString = currentTripData.stringValue(forkey: "trip_date") {
                self.tripDate = tripDateString
            }
            
            if let statusIdString = currentTripData.stringValue(forkey: "statusID") {
                self.statusId = Int(statusIdString) ?? 0
            }
        } else {
            return nil
        }
        
    }
    
    init?(with data: [String: Any]) {
        
        if let idString = data.stringValue(forkey: "tripID"),
            let hotelId = data.stringValue(forkey: "hotelID"),
            let usrId = data.stringValue(forkey: "userID") {
            
            var Lat: Double = 0
            if let distanceString = data.stringValue(forkey: "latitude") {
                Lat = Double(distanceString) ?? 0
            } else if let di = data["latitude"] as? Double {
                Lat = di
            }
            self.destinationLat = Lat
            
            var Lon: Double = 0
            if let distanceString = data.stringValue(forkey: "longitude") {
                Lon = Double(distanceString) ?? 0
            } else if let di = data["longitude"] as? Double {
                Lon = di
            }
            
            self.destinationLon = Lon
            
            if let strMapPoints = data.stringValue(forkey: "polyline_map_points") {
                self.mapPoints = strMapPoints
            }
            
            if let tripDateString = data.stringValue(forkey: "address") {
                self.address = tripDateString
            }
            
            if let tripDateString = data.stringValue(forkey: "city") {
                self.city = tripDateString
            }
            
            if let tripDateString = data.stringValue(forkey: "state") {
                self.state = tripDateString
            }
            
            if let hotel = data["hotel"] as? Hotel {
                self.hotel = hotel
            }
            
            if let tripDateString = data.stringValue(forkey: "start_location_address") {
                self.startLocationAddress = tripDateString
            }
            
            if let tripDateString = data.stringValue(forkey: "start_location_city") {
                self.startLocationCity = tripDateString
            }
            
            if let tripDateString = data.stringValue(forkey: "start_location_state") {
                self.startLocationState = tripDateString
            }
            
            if let tripDateString = data.stringValue(forkey: "start_location_zip") {
                self.startLocationZip = tripDateString
            }
            
            var startLat: Double = 0
            if let distanceString = data.stringValue(forkey: "start_location_latitude") {
                startLat = Double(distanceString) ?? 0
            } else if let di = data["start_location_latitude"] as? Double {
                startLat = di
            }
            self.startLocationLat = startLat
            
            var startLon: Double = 0
            if let distanceString = data.stringValue(forkey: "start_location_longitude") {
                startLon = Double(distanceString) ?? 0
            } else if let di = data["start_location_longitude"] as? Double {
                startLon = di
            }
            self.startLoctaionLon = startLon
            
            if let urlString = data.stringValue(forkey: "image"){
                var url = URL.init(string: urlString)
                if url == nil {
                    url = URL.init(string: (urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? "")
                }
                self.hotelImage = url
            }
            
            
            self.tripId = Int(idString) ?? 0
            self.hotelId = Int(hotelId) ?? 0
            self.userId = usrId
            

            var dist: Double = 0
            if let distanceString = data.stringValue(forkey: "distance") {
                dist = Double(distanceString) ?? 0
            } else if let di = data["distance"] as? Double {
                dist = di
            }
            self.distance = dist

            var points: Double = 0
            if let pointsString = data.stringValue(forkey: "reward_points") {
                points = Double(pointsString) ?? 0
            } else if let point = data["reward_points"] as? Double {
                points = point
            }

            self.rewardPoints = points

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
                self.statusId = Int(statusIdString) ?? 0
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
    
    func getDictionary() -> [String: Any] {
        var rawData: [String: Any] = [:]
        /*
         "tripID": "4",
         "hotelID": "1",
         "start_location_address": null,
         "start_location_city": null,
         "start_location_state": null,
         "start_location_zip": null,
         "start_location_latitude": "0",
         "start_location_longitude": "0",
         "distance": "20.00",
         "reward_points": "100",
         "trip_image": "testingImgURL",
         "trip_date": "2018-04-17 09:04:24",
         "userID": "1",
         "statusID": "1",
         "created_date": "2018-04-17 09:04:24",
         "name": "Holiday Inn Express & Suites\nAtlanta Downtown",
         "address": "111 Cone Street NW",
         "city": "Atlanta",
         "state": "Georgia",
         "latitude": "33.7525",
         "longitude": "-84.3888",
         "image": "https:\/\/ihg.scene7.com\/is\/image\/ihg\/holiday-inn-express-and-suites-atlanta-4304929160-4x3?wid=1200&fit=constrain",
         "first_name": "Priyanka",
         "last_name": "Test"
 */

        rawData["tripID"] = self.tripId
        rawData["hotelID"] = self.hotelId
        rawData["start_location_address"] = self.startLocationAddress
        rawData["start_location_city"] = self.startLocationCity
        rawData["start_location_state"] = self.startLocationState
        rawData["start_location_zip"] = self.startLocationZip
        rawData["start_location_latitude"] = self.startLocationLat
        rawData["start_location_longitude"] = self.startLoctaionLon
        rawData["hotel"] = self.hotel
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
        rawData["address"] = self.address
        rawData["city"] = self.city
        rawData["state"] = self.state
        rawData["latitude"] = self.destinationLat
        rawData["longitude"] = self.destinationLon
        rawData["image"] = self.hotelImage
        rawData["polyline_map_points"] = self.mapPoints
        
        return rawData
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? Trips {
            if self.tripId == other.tripId {
                return true
            }
        }
        return false
    }
    
    func getMapPathData() -> MapPathAddress {
        let objMapPath = MapPathAddress.init(startLocation:CLLocationCoordinate2D(latitude: self.startLocationLat, longitude: self.startLoctaionLon), startAddress: self.startLocationAddress, endLocation: CLLocationCoordinate2D(latitude: self.destinationLat, longitude: self.self.destinationLon), endAddress: self.address)
        return objMapPath
    }
    
    func saveCurrentTripSession() {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: tripSessionKey)
        UserDefaults.standard.synchronize()
    }
    
    class func getCurrentTripSession() -> Trips? {
        if let data = UserDefaults.standard.value(forKey: tripSessionKey) as? Data {
            if let session = NSKeyedUnarchiver.unarchiveObject(with: data) {
                return session as? Trips
            }
        }
        return nil
    }

    func convertToRewardsPoint() -> RewardsPoint {
        let status = RewardsPointStatus.init(rawValue: self.statusId) ?? .denied
        let objReward = RewardsPoint.init(tripID: self.tripId, hotelName: self.name, hotelAdderss: self.address, points: self.rewardPoints, status: status)
        return objReward
    }
    
}
