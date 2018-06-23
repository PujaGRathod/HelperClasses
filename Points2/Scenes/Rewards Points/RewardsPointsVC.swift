//
//  RewardsPointsVC.swift
//  Points2Miles
//
//  Created by Arjav Lad on 23/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit

class RewardsPointsVC: UIViewController {

    @IBOutlet weak var rewardsTable: UITableView!

    private let rewardsAdapter = RewardsPointsTableAdapter()
    private var rewards = [RewardsPoint]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.rewardsAdapter.delegate = self
        self.rewardsAdapter.set(self.rewardsTable)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onBackTap(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    func loadData() {
        if  let user = NetworkServices.shared.loginSession?.user {
            self.rewards = user.getRewardPoints()
        }
        self.rewardsAdapter.loadData(with: self.rewards)
        NetworkServices.shared.loginSession?.updateUserDetails ({
            DispatchQueue.main.async {
                if let user = NetworkServices.shared.loginSession?.user {
                    self.rewards = user.getRewardPoints()
                    self.rewardsAdapter.loadData(with: self.rewards)
                }
            }
        })
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
                self.loadData()
            } else {
                self.hideLoader()
                self.showAlert("Request Failed!", message: error?.localizedDescription ?? "Please try again later.")
            }
        }
    }

}

extension RewardsPointsVC: RewardsPointsTableAdapterDelegate {
    func changeRewardsPointRequest(for reward: RewardsPoint) {
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
}
