//
//  ViewController.swift
//  Points2Miles
//
//  Created by Akshit Zaveri on 14/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit
import GoogleMaps

class StartNewTripVC: UIViewController,NearbyDestinationCollectionViewAdapterDelegate, HotelListVCDelegate {
    
    func selectedHotelFromList(objHotel: Hotel) {
        print(objHotel.name)
        self.selectedHotel = objHotel
        self.destinationTextField.text = objHotel.name
        
    }
    
    var selectedHotel:Hotel?
    var userlocation: UserLocation?
    var currentLocationAddress: locationDetails?
    var strMapPathPoints = ""
    var distance: Double = 0
    private var nearbyDestinationsAdapter = NearbyDestinationsCollectionViewAdapter()
    fileprivate var nearbyDestinations = [Hotel]()
    
    @IBOutlet weak var btnAccount: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var startTripView: UIView!
    @IBOutlet weak var startTripButton: UIButton!
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var nearbyDestinationsCollectionView: UICollectionView!
    @IBOutlet weak var lblCurrentLocationAddress: UILabel!
    
    override func loadView() {
        super.loadView()
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
        
        self.destinationTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 36.5, height: 50))
        self.destinationTextField.leftViewMode = .always
        
        self.destinationTextField.clipsToBounds = true
        self.destinationTextField.layer.cornerRadius = 10
        if #available(iOS 11.0, *) {
            self.destinationTextField.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
        } else {
            let rectShape = CAShapeLayer()
            rectShape.bounds = self.destinationTextField.frame
            rectShape.position = self.destinationTextField.center
            rectShape.path = UIBezierPath(roundedRect: self.destinationTextField.bounds, byRoundingCorners: [.bottomLeft , .topLeft], cornerRadii: CGSize(width: 10, height: 10)).cgPath
            self.destinationTextField.layer.mask = rectShape
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nearbyDestinationsAdapter.set(collectionview: self.nearbyDestinationsCollectionView)
        self.nearbyDestinationsAdapter.delegate = self
        self.btnAccount.imageView?.contentMode = .scaleAspectFit
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didRecognizeTapGesture(_:)))
        self.destinationTextField.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.startTripButton.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        NetworkServices.shared.registerForNotifcation()
        self.userlocation = UserLocation.init()
        self.userlocation?.getRealTimeUpates = true
        self.showCurrentLocation()
        self.getHotelList()
    }
    
    @objc private dynamic func didRecognizeTapGesture(_ gesture: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "ShowHotelList", sender: self)
    }
    
    func getHotelList() {
        NetworkServices.shared.loginSession?.loadHotelList({
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                if let arr = delegate.arrHotels {
                    if let arrSorted = Hotel.sortHotelsWithDistance(list:arr, currentLocation: self.userlocation?.currentLocation) {
                        self.nearbyDestinations = arrSorted
                    } else {
                        self.nearbyDestinations = arr
                    }
                    self.nearbyDestinationsAdapter.reload(arrDestinations: self.nearbyDestinations)
                }
            }
        })
    }
    
    func showCurrentLocation() {
        if let currentLoc = self.userlocation {
            currentLoc.getUserlocation()
        }
        self.userlocation?.locationUpdatedBlock = { (address,location, error) in
            if let _ = error {}
            else if let address = address {
                self.lblCurrentLocationAddress.text = address.formattedAddress
                self.currentLocationAddress = address
            }
            else if let location = location?.currentLocation {
                print(location)
                if let delegate = UIApplication.shared.delegate as? AppDelegate {
                    print("==========================")
                    print("Location updated: \(location)")
                    print("==========================")
                    delegate.currentLocation = location
                    self.getHotelList()
                }
            } else {
                print("location not found")
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.startTripView.layer.cornerRadius = 17.5
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func selectedHotel(objHotel: Hotel) {
        self.selectedHotel = objHotel
        self.destinationTextField.text = self.selectedHotel?.name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let hotelListVC = segue.destination as? HotelListVC {
            hotelListVC.delegate = self
            hotelListVC.arrHotels = self.nearbyDestinations
        } else if let endTripVC = segue.destination as? OngoingTripVC {
            if let currentLat = self.currentLocationAddress?.location?.latitude,
                let currentLon = self.currentLocationAddress?.location?.longitude,
                let endLat = self.selectedHotel?.latitude,
                let endLon = self.selectedHotel?.longitude,
                let trip = sender as? Trips {
                
                trip.distance = self.distance
                endTripVC.trip = trip
                endTripVC.strMapPath = self.strMapPathPoints
                endTripVC.pathDetails = MapPathAddress(startLocation:CLLocationCoordinate2D(latitude: currentLat, longitude: currentLon), startAddress: self.currentLocationAddress?.formattedAddress, endLocation: CLLocationCoordinate2D(latitude: endLat, longitude: endLon), endAddress: self.selectedHotel?.address)
                
                self.currentLocationAddress = nil
                self.selectedHotel = nil
            }
        }
    }
    
    @IBAction func onStartNewTripTap(_ sender: UIButton) {
        if let str = self.destinationTextField.text,
            str.trimString() != "" {
            self.getRoutePath()
        } else {
            self.startTripButton.isUserInteractionEnabled = true
            self.showAlert("Points2Miles", message: "Please choose destination to start trip.")
        }
    }
    
    func getRoutePath()  {
        if let apiRequest = self.validateMapPathInputData() {
            self.showLoader()
            NetworkServices.shared.getMapPathToDraw(request: apiRequest) { (jsonData, error) in
                if let responseData = jsonData {
                    if let strMpaPath = self.getRoute(from: responseData) {
                        let distance = self.getRouteDistance(from: responseData)
                        self.distance = distance * 0.000621371 // Meter to Miles
                        
                        self.strMapPathPoints = strMpaPath
                        self.startNewTrip()
                    } else if let errorMsg = responseData["error_message"] as? String {
                        self.hideLoader()
                        self.showAlert("Points2Miles", message: errorMsg)
                    }
                }
            }
        }
    }
    
    //TODO: google api key need to pass
    func validateMapPathInputData() -> NetworkServicesModels.drawMapPath.request? {
        guard let startLoc = self.currentLocationAddress?.location else {
            self.showAlert("Points2Miles", message: "Current location is not fetched yet.")
            return nil
        }
        
        guard let endLat = self.selectedHotel?.latitude, let endLon = self.selectedHotel?.longitude else {
            self.showAlert("Points2Miles", message: "You can't use this hotel yet.")
            return nil
        }
        
        let destination = CLLocationCoordinate2D(latitude: endLat, longitude: endLon)
        return NetworkServicesModels.drawMapPath.request.init(rootLocation:startLoc,
                                                              destinationLocation: destination,
                                                              googleApiKey: "AIzaSyA4Wk1FDImoCSPpBYttl15nltjhPwYyBMs")
    }
    
    
    private func getRoute(from responseObject:[String:Any]) -> String? {
        if let route = responseObject["routes"] as? [[String:Any]],
            let overview_polyline = route.first?["overview_polyline"] as? [String:Any],
            let points = overview_polyline["points"] as? String {
            return points
        }
        return nil
    }
    
    private func getRouteDistance(from responseObject: [String:Any]) -> Double {
        if let route = responseObject["routes"] as? [[String:Any]],
            let legs = route.first?["legs"] as? [[String:Any]],
            let distance = legs.first?["distance"] as? [String:Any],
            let value = distance["value"] as? Double {
            return value
        }
        return 0
    }
    
    
    func startNewTrip() {
        if let apiRequest = self.validateInputData() {
            NetworkServices.shared.startUserTrip(request: apiRequest) { (trip, error) in
                self.hideLoader()
                if let trip = trip {
                    self.destinationTextField.text = ""
                    self.performSegue(withIdentifier: "showEndTripDetail", sender: trip)
                } else {
                    self.startTripButton.isUserInteractionEnabled = true
                    if let error = error {
                        self.showAlert("Error!", message: error.localizedDescription)
                    } else {
                        self.showAlert("Error!", message: "request failed!")
                    }
                }
            }
        }
    }
    
    func validateInputData() -> NetworkServicesModels.createTrip.request? {
        if let lat = self.userlocation?.currentLocation?.latitude,
            let lon = self.userlocation?.currentLocation?.longitude,
            let hotelId = self.selectedHotel?.hotelID {
            let  request = NetworkServicesModels.createTrip.request.init(startLocationLatitude: String(lat),
                                                                         startLocationLongitude: String(lon),
                                                                         hotelId: hotelId,
                                                                         startLocationAddress: self.lblCurrentLocationAddress.text,
                                                                         startLocationCity: self.currentLocationAddress?.city,
                                                                         startLocationState: self.currentLocationAddress?.state,
                                                                         startLocationZip: self.currentLocationAddress?.postalCode, locationPoints: self.strMapPathPoints)
            return request
        }
        self.showAlert("Points2Miles", message: "Please allow location permissions to access current location.")
        self.startTripButton.isUserInteractionEnabled = true
        return nil
    }
}

