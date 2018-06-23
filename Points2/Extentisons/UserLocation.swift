//
//  UserLocation.swift
//  remone
//
//  Created by Arjav Lad on 09/01/18.
//  Copyright © 2018 Inheritx. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps


struct MapPathAddress {
    var startLocation: CLLocationCoordinate2D?
    var startAddress: String?
    var endLocation: CLLocationCoordinate2D?
    var endAddress: String?
    
    init(startLocation:CLLocationCoordinate2D?,startAddress:String?,endLocation:CLLocationCoordinate2D?,endAddress:String?) {
        self.startLocation = startLocation
        self.startAddress = startAddress
        self.endLocation = endLocation
        self.endLocation = endLocation
    }
}

struct locationDetails {
    var formattedAddress:String?
    var city: String?
    var state: String?
    var country: String?
    var postalCode: String?
    var location: CLLocationCoordinate2D?
    
    init(address:String,city:String?,state:String?,country:String?,code:String?,loc:CLLocationCoordinate2D?) {
        self.formattedAddress = address
        self.city = city
        self.state = state
        self.country = country
        self.postalCode = code
        self.location = loc
    }
}

class UserLocation: NSObject, CLLocationManagerDelegate {

    enum UserLocationError: Error {
        case didFail
        case didRefuse
    }

    private var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var locationUpdatedBlock: ((locationDetails?,UserLocation?, UserLocationError?) -> Void)?
    var getRealTimeUpates: Bool = false

    var hasValidLocation: Bool {
        get {
            if let location = currentLocation {
                return CLLocationCoordinate2DIsValid(location)
            }
            return false
        }
    }

    override init() {
        super.init()
        setupLocationManager()
    }

    init(locationUpdatedBlock: @escaping ((locationDetails?,UserLocation?, UserLocationError?) -> Void)) {
        super.init()
        self.locationUpdatedBlock = locationUpdatedBlock
        self.locationManager.distanceFilter = 20
        self.setupLocationManager()
    }

    override var description: String {
        return "Object: \(super.description), Latitude: \( currentLocation?.latitude ?? 0 ),Longitude: \( currentLocation?.longitude ?? 0 )"
    }

    func setupLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            self.getUserlocation()
            print("location requested")
        } else {
            print("location services is disabled")
            if self.locationUpdatedBlock != nil {
                locationUpdatedBlock!(nil,nil, UserLocationError.didRefuse)
            }
        }
    }
    
    func initiateAuthorization() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func getUserlocation() {
        let authStatus = CLLocationManager.authorizationStatus()
        if CLLocationManager.locationServicesEnabled() {
            if authStatus == .denied ||
                authStatus == .restricted {
                if self.locationUpdatedBlock != nil {
                    locationUpdatedBlock!(nil,nil, UserLocationError.didRefuse)
                }
            } else {
                self.initiateAuthorization()
                self.locationManager.startUpdatingLocation()
            }
        } else {
            if self.locationUpdatedBlock != nil {
                locationUpdatedBlock!(nil,nil, UserLocationError.didRefuse)
            }
        }
    }

    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D)  {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(),
                let lines = address.lines else {
                return
            }
            let strAddress = lines.joined(separator: ",")
            let locationObj = locationDetails.init(address:strAddress, city: address.locality, state: address.administrativeArea, country: address.country, code:address.postalCode, loc: coordinate)
            
            if self.locationUpdatedBlock != nil {
                self.locationUpdatedBlock!(locationObj,self, nil)
            }
            
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if !self.getRealTimeUpates {
            self.locationManager.stopUpdatingLocation()
        }
        
        print("Location fetched")
        
        if let current = self.currentLocation,
            let firstLocation = locations.first?.coordinate {
            if current.isEqual(to: firstLocation) {
                if let locationUpdatedBlock = self.locationUpdatedBlock {
                    locationUpdatedBlock(nil,self, nil)
                }
                return
            }
        }

        self.currentLocation = locations.first?.coordinate;
        guard let currentLocation = self.currentLocation else {
            if let locationUpdatedBlock = self.locationUpdatedBlock {
                locationUpdatedBlock(nil,self, UserLocationError.didFail)
            }
            return
        }

        let long = currentLocation.longitude;
        let lat = currentLocation.latitude;
        print(long);
        print(lat);

        if CLLocationCoordinate2DIsValid(currentLocation) {
            self.reverseGeocodeCoordinate(currentLocation)
            
            if let locationUpdatedBlock = self.locationUpdatedBlock {
                locationUpdatedBlock(nil,self, nil)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error")
        print(error)
        if !CLLocationManager.locationServicesEnabled() {

        }
        if self.locationUpdatedBlock != nil {
            locationUpdatedBlock!(nil,nil, UserLocationError.didFail)
        }
    }

}

extension CLLocationCoordinate2D {
    func isEqual(to other: CLLocationCoordinate2D) -> Bool {
        let loc1 = CLLocation.init(latitude: self.latitude, longitude: self.longitude)
        let loc2 = CLLocation.init(latitude: other.latitude, longitude: other.longitude)
        let distance = loc1.distance(from: loc2)
        if distance <= 20 {
            return true
        }
        return false
    }

    func distance(from other: CLLocationCoordinate2D) -> Double {
        let loc1 = CLLocation.init(latitude: self.latitude, longitude: self.longitude)
        let loc2 = CLLocation.init(latitude: other.latitude, longitude: other.longitude)
        let distance = loc1.distance(from: loc2)
        return distance
    }
}
