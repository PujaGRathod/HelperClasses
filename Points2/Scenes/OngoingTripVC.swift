//
//  OngoingTripVC.swift
//  Points2Miles
//
//  Created by Akshit Zaveri on 16/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit
import GoogleMaps
class OngoingTripVC: UIViewController {
    
    @IBOutlet var btnEndTrip: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet var lblFromAddress: UILabel!    
    @IBOutlet var lblToAddress: UILabel!
    
    var pathDetails: MapPathAddress?
    var hotelLocation:CLLocationCoordinate2D?
    var strMapPath:String?
    let mapAdapter = OnGoingTripMapAdapter()
    var trip: Trips!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let tripObj = self.pathDetails,
            let path = self.strMapPath {
            self.mapAdapter.set(map: self.mapView, pathSource: tripObj, strRoute: path)
            self.hotelLocation = tripObj.endLocation
            if let startAddress = tripObj.startAddress {
                self.lblFromAddress.text = startAddress
            }
            
            if let destAddress = tripObj.endAddress {
                self.lblToAddress.text = destAddress
            }
        }
        self.btnAccount.imageView?.contentMode = .scaleAspectFit
    }
    
    @IBAction func btnEndTripTapped(_ sender: UIButton) {
        if self.shouldAllowToEndTrip() {
//            self.btnEndTrip.isUserInteractionEnabled = false
            self.endTrip()
        } else {
            let alert = UIAlertController(title: "Points2Miles", message: "You have not reached your destination yet. What would you like to do?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel trip", style: .destructive) { (action) in
                self.cancelTrip()
            })
            alert.addAction(UIAlertAction(title: "Continue trip", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func shouldAllowToEndTrip() -> Bool {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            if let currentLoc = delegate.currentLocation,
                let hotelLoc = self.hotelLocation {
                let distance = currentLoc.distance(from: hotelLoc)
                if distance > 100 {
                    return false
                }
            }
        }
        return true
    }
    
    func endTrip() {
        self.showLoader()
        let request = NetworkServicesModels.endTrip.request(tripId: "\(self.trip.tripId)", distance: self.trip.distance)
        NetworkServices.shared.endTrip(request: request) { (response) in
            self.hideLoader()
            if response.isSuccess {
                self.showAlert("Points2Miles", message: "Trip ended successfully.")
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showAlert("Points2Miles", message: "Error while ending your trip.")
            }
        }
    }
    
    func cancelTrip() {
        self.showLoader()
        let request = NetworkServicesModels.deleteTrip.request(tripId: "\(self.trip.tripId)")
        NetworkServices.shared.deleteTrip(request: request) { (response) in
            self.hideLoader()
            if response.isSuccess {
                self.showAlert("Points2Miles", message: "Trip cancelled successfully.")
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showAlert("Points2Miles", message: "Error while cancelling your trip.")
            }
        }
    }
}
