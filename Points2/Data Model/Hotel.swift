//
//  Hotel.swift
//  Points2Miles
//
//  Created by Akshit Zaveri on 14/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct Hotel {
    
    /*
     address = "adress line1122";
     city = Atlanta;
     "created_by" = 1;
     "created_date" = "2018-04-16 07:10:00";
     hotelID = 2;
     image = "<null>";
     latitude = 0;
     longitude = 0;
     name = "Holiday Inn 22";
     state = Georgia;
     zip = ""; */
    
    var hotelID :  String = ""
    var name :     String = ""
    var address :  String = ""
    var city :     String = ""
    var state:     String = ""
    var image:      URL?
    var createdDate:String = ""
    var createdBy:   String = ""
    var latitude: Double?
    var longitude: Double?
    var zip: String = ""
    var distance: Double?

    init?(data:[String :Any]) {
        if let hotelId = data["hotelID"] as? String {
            self.hotelID = hotelId
            
            if let add = data["address"] as? String {
                self.address = add
            }
            
            if let name = data["name"] as? String {
                self.name = name
            }
            
            if let city = data["city"] as? String {
                self.city = city
            }
            
            if let state = data["state"] as? String {
                self.state = state
            }
            
            if let image = data["image"] as? String,
                let url = URL.init(string: image) {
                self.image = url
            }
            
            if let craetedDate = data["created_date"] as? String {
                self.createdDate = craetedDate
            }
            
            if let craetedBy = data["created_by"] as? String {
                self.createdBy = craetedBy
            }
            
            if let lat = data["latitude"] as? String {
                self.latitude = Double.init(lat)
            }
            
            if let lon = data["longitude"] as? String {
                self.longitude = Double.init(lon)
            }
            
            if let zip = data["zip"] as? String {
                self.zip = zip
            }
            
            self.distance = self.calculateDistance()

        } else {
            return nil
        }
    }
    
    func calculateDistance() -> Double {
        var val:Double = 0.0;
        self.getDistance { (distanceValue) in
            if let distance = distanceValue {
                val = distance
            }
        }
        return val
    }
    
    func getDistance(responseClosure: @escaping (Double?) -> Void) {
        if let lat = self.latitude,
            let lon = self.longitude {
            let hotelLocation = CLLocationCoordinate2D(latitude: lat, longitude:lon)
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                if let location = delegate.currentLocation {
                    print("lat \(lat)and lon:\(lon) current lat :\(location.latitude) current lon: \(location.longitude)")
                    let distance = location.distance(from: hotelLocation)
                    responseClosure(distance/1609.34)
                }else {
                    responseClosure(0.0)
                }
            }
        } else {
            responseClosure(0.0)
        }
        
    }
    
    static func sortHotelsWithDistance(list: [Hotel],currentLocation:CLLocationCoordinate2D?) -> [Hotel]? {
        if let objCurrentLocation = currentLocation {
            let hotelListSorted = list.sorted {
                var distanceFrom1: CLLocationDistance = 200000000000
                var distanceFrom2: CLLocationDistance = 200000000000
                if let lat1 = $0.latitude,let lon1 = $0.longitude ,
                    let lat2 = $1.latitude,let lon2 = $1.longitude  {
                    distanceFrom1 = objCurrentLocation.distance(from: CLLocationCoordinate2D(latitude:lat1 , longitude: lon1))
                    distanceFrom2 = objCurrentLocation.distance(from: CLLocationCoordinate2D(latitude:lat2 , longitude: lon2))
                }
                return distanceFrom1 < distanceFrom2
            }
            return hotelListSorted
        }
        return list
    }
    
}

extension NetworkServices {
    
    func getHotelist(responseClosure: @escaping ([[String:Any]]?, Error?) -> Void) {
        self.makePOSTRequest(with: GetHotelList, parameters: [:]) { (response) in
            if response.error != nil {
                responseClosure(nil,response.error)
            }
            else {
                if let res = response.result {
                    if let arrHotelList = res["Responsebody"] as? [[String:Any]] {
                        self.saveHotelList(arrHotelList: arrHotelList)
                        responseClosure(arrHotelList,nil)
                    }
                } else {
                    responseClosure(nil,response.error)
                }
            }
        }
    }
    
    func saveHotelList (arrHotelList : [[String:Any]]) {
        let data = NSKeyedArchiver.archivedData(withRootObject: arrHotelList)
        UserDefaults.standard.set(data, forKey: "HotelListSessionKey")
        UserDefaults.standard.synchronize()
    }
    
    func getLocalHotelList() -> [Hotel]? {
        if let data = UserDefaults.standard.value(forKey: "HotelListSessionKey") as? Data {
            if let arrHotelList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String:Any]] {
                var hotelList:[Hotel] = []
                for dic in arrHotelList {
                    if let hotel = Hotel.init(data: dic) {
                        hotelList.append(hotel)
                    }
                }
                
                return hotelList
            }
        }
        return nil
    }
    
    
    func getUserPastTripHotelList(by hotelId:String) -> Hotel? {
        
        if let data = UserDefaults.standard.value(forKey: "HotelListSessionKey") as? Data {
            if let arrHotelList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[String:Any]] {
                
                let foundItems = arrHotelList.filter { (dic) -> Bool in
                    return dic["hotelID"] as? String == hotelId
                }
                
                return Hotel.init(data:foundItems[0])
            }
        }
        return nil
    }
    
}
