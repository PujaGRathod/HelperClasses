//
//  MapViewAdapter.swift
//  Points2Miles
//
//  Created by Intelivex Labs on 19/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewAdapter: NSObject {
    
    fileprivate var mapView: GMSMapView!
    fileprivate var mapPath: MapPathAddress?
    fileprivate var mapRoute: String?
    func set(map: GMSMapView,pathSource: MapPathAddress,strMapPath:String) {
        self.mapView = map
        self.mapPath = pathSource
        self.mapRoute = strMapPath
        
        let camera = GMSCameraPosition.camera(withLatitude: 33.714061, longitude: -84.399311, zoom: 10)
        self.mapView.camera = camera
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
        
        if let mapPath = self.mapPath {
            
            var position1:CLLocationCoordinate2D?
            if let startLoc = mapPath.startLocation {
                position1 = startLoc
            } else {
                position1 = CLLocationCoordinate2D(latitude: 33.762047, longitude: -84.384139)
            }
            
            if let position = position1 {
                let marker1 = GMSMarker(position: position)
                marker1.title = mapPath.startAddress
                marker1.icon =  #imageLiteral(resourceName: "LocationPinWhite")
                marker1.map = mapView
            }
            
            var position2:CLLocationCoordinate2D?
            if let endLoc = mapPath.endLocation {
                position2 = endLoc
            } else {
                position2 = CLLocationCoordinate2D(latitude: 33.658470, longitude: -84.434391)
            }
            
            if let position = position2 {
                let marker2 = GMSMarker(position: position)
                marker2.title = mapPath.endAddress
                marker2.icon = #imageLiteral(resourceName: "LocationPinIconGreenOval")
                marker2.map = mapView
            }
            self.setMapViewCornerRadius()
            self.drawRoute(from: strMapPath)
        }
    }
   private func drawRoute(from strPoints:String){
        let path = GMSPath(fromEncodedPath: strPoints)
        let line = GMSPolyline(path: path)
        line.strokeWidth = 4
        line.strokeColor = #colorLiteral(red: 0.3450980392, green: 0.768627451, blue: 0.6196078431, alpha: 1)
        line.map = self.mapView
    }
    
    private func setMapViewCornerRadius() {
        self.mapView.layer.cornerRadius = 20
        self.mapView.layer.masksToBounds = true
        self.mapView.clipsToBounds = true
    }

}
