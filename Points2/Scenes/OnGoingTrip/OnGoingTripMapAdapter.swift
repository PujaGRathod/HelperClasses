//
//  OnGoingTripMapAdapter.swift
//  Points2Miles
//
//  Created by Intelivex Labs on 04/05/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit
import GoogleMaps
class OnGoingTripMapAdapter: NSObject {

    fileprivate var mapView: GMSMapView!
    fileprivate var mapPath: MapPathAddress?
    fileprivate var strMapPath :String?
    func set(map: GMSMapView,pathSource: MapPathAddress,strRoute:String) {
        self.mapView = map
        self.mapPath = pathSource
        self.strMapPath = strRoute
        
        self.mapView.isMyLocationEnabled = true
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "GoogleMapStyle", withExtension: "json") {
                self.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        guard let mapPath = mapPath else {
            return
        }
        
        guard let startLocation = mapPath.startLocation else {
            return
        }
        
        guard let endLocation = mapPath.endLocation else {
            return
        }
        
        let bounds = GMSCoordinateBounds(coordinate: startLocation, coordinate: endLocation)
        let insets = UIEdgeInsets(top: 100, left: 50, bottom: 150, right: 50)
        if let camera = mapView.camera(for: bounds, insets: insets) {
            self.mapView.camera = camera
        }
        
        let marker1 = GMSMarker(position: startLocation)
        marker1.title = mapPath.startAddress
        marker1.icon =  #imageLiteral(resourceName: "LocationPinWhite")
        marker1.map = mapView
        
        let marker2 = GMSMarker(position: endLocation)
        marker2.title = mapPath.endAddress
        marker2.icon = #imageLiteral(resourceName: "LocationPinIconGreenOval")
        marker2.map = mapView
        
        guard let polyline_map_path = self.strMapPath else {
            return
        }
        
        self.drawRoute(from: polyline_map_path)
    }
    
    func drawRoute(from strPoints:String) {
        let path = GMSPath(fromEncodedPath: strPoints)
        let line = GMSPolyline(path: path)
        line.strokeWidth = 4
        line.strokeColor = #colorLiteral(red: 0.3450980392, green: 0.768627451, blue: 0.6196078431, alpha: 1)
        line.map = self.mapView
        
    }
}
