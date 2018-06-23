//
//  PastTripDetailVC.swift
//  Points2Miles
//
//  Created by Intelivex Labs on 19/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit
import GoogleMaps

class PastTripDetailVC: UIViewController {

    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var scrollview: UIScrollView!
    @IBOutlet var imgTrip: UIImageView!
    @IBOutlet var lblTripName: UILabel!
    @IBOutlet var lblTripAddress: UILabel!
    @IBOutlet var lblDistance: UILabel!
    @IBOutlet var lblRewardPoint: UILabel!
    @IBOutlet var lblTripDate: UILabel!

    let mapAdapter = MapViewAdapter()
    var hotelsDetail:Trips?

//    weak var weakHotelsDetail:Trips?
//    unowned var check:MapViewAdapter = MapViewAdapter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        unowned var check:Trips?
//        weak var weakHotelsDetail:Trips?
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        
        self.scrollview.delegate = self
        if #available(iOS 11.0, *) {
            self.scrollview.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if let tripObj = self.hotelsDetail {
            self.mapAdapter.set(map: self.mapView, pathSource: tripObj.getMapPathData(),strMapPath: tripObj.mapPoints)
        }

        if self.hotelsDetail?.statusId == RewardsPointStatus.submissionPending.rawValue {
            let rewardsTapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.onRewardsPointsTap(_:)))
            rewardsTapGesture.numberOfTapsRequired = 1
            rewardsTapGesture.numberOfTouchesRequired = 1
            self.lblRewardPoint.isUserInteractionEnabled = true
            self.lblRewardPoint.addGestureRecognizer(rewardsTapGesture)
        }

        self.setTripDetails()
    }
    
    func setTripDetails() {
        if let name = hotelsDetail?.name {
            self.lblTripName.text = name
        }
        
        if let address = hotelsDetail?.address {
            self.lblTripAddress.text = address
        }
        
        if let distance = hotelsDetail?.distance.formattedString {
            self.lblDistance.text = "\(distance) miles"
        }
        
        if let reward = hotelsDetail?.rewardPoints.formattedString,
            let rewards = hotelsDetail?.convertToRewardsPoint() {
            self.lblRewardPoint.text = "\(reward) Points (\(rewards.status.text))"
        }
        
        if let strDate = hotelsDetail?.tripDate {
            if let formattedDate = strDate.stringToDate() {
                self.lblTripDate.text = formattedDate
            }
        }
        
        if let imgURL = hotelsDetail?.hotelImage {
            self.imgTrip.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "imgHotelPlaceHolder"), options:.retryFailed ) { (image, _, _, _) in
                if let image = image {
                    self.imgTrip.image = image
                    let size = image.size
                    if size.width / size.height == 1 {
                        self.imgTrip.contentMode = .scaleAspectFit
                    } else {
                        self.imgTrip.contentMode = .scaleAspectFill
                    }
                }
            }
        } else {
            self.imgTrip.image = #imageLiteral(resourceName: "imgHotelPlaceHolder")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackClickTap(_ sender: Any) {
        if self.navigationController?.viewControllers.first is PastTripDetailVC {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc func onRewardsPointsTap(_ recognizer: UITapGestureRecognizer) {
        guard let reward = hotelsDetail?.convertToRewardsPoint()  else { return }
        let alertCheckoutID = UIAlertController.init(title: "Please enter hotel checkout id in order to submit rewards points.", message: nil, preferredStyle: .alert)

        alertCheckoutID.addTextField { (textFiled) in
            textFiled.placeholder = "Hotel Checkout ID"
        }

        alertCheckoutID.addAction(UIAlertAction.init(title: "Claim", style: .default, handler: { (action) in
            if let textField = alertCheckoutID.textFields?.first,
                let checkoutID = textField.text?.trimString(),
                checkoutID != "" {
                let request = NetworkServicesModels.rewardsPoints.request.init(tripID: "\(reward.tripID)", hotelCheckoutID: checkoutID)
                self.checkout(with: request)
            } else {
                self.showAlert("Invalid Checkout ID!", message: "Please enter a valid Checkout ID.")
            }
        }))

        alertCheckoutID.addAction(UIAlertAction.init(title: "No Thanks!", style: .default, handler: { (action) in

        }))

        self.present(alertCheckoutID, animated: true, completion: nil)
    }

    func checkout(with request: NetworkServicesModels.rewardsPoints.request) {
        self.showLoader()
        NetworkServices.shared.hotelCheckout(request: request) { (updatedTrip, error) in
            if let updatedTrip = updatedTrip {
                if  let user = NetworkServices.shared.loginSession?.user {
                    if let tripIndex = user.userTrips.index(where: { (trip) -> Bool in return trip.tripId == updatedTrip.tripId }) {
                        user.userTrips[tripIndex] = updatedTrip
                        NetworkServices.shared.loginSession?.save()
                        NetworkServices.shared.loginSession?.updateUserDetails()
                    }
                }
                self.hideLoader()
                self.hotelsDetail?.statusId = RewardsPointStatus.approvalPending.rawValue
                self.setTripDetails()
            } else {
                self.hideLoader()
                self.showAlert("Request Failed!", message: error?.localizedDescription ?? "Please try again later.")
            }
        }
    }
}

extension PastTripDetailVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screenHeight = self.view.frame.height
        let currentOffsetY: CGFloat = scrollview.contentOffset.y
        let colorOpacity = (10000*currentOffsetY) / (27*screenHeight)
        self.navigationController?.navigationBar.alpha = 1-(colorOpacity/100)
    }
}
