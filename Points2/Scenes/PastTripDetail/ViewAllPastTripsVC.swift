//
//  ViewAllPastTripsVC.swift
//  Points2Miles
//
//  Created by Intelivex Labs on 26/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit

class ViewAllPastTripsVC: UIViewController {

    @IBOutlet var tblPastTrips: UITableView!

    let tripAdapter = PastTripsListAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tripAdapter.set(self.tblPastTrips)
        self.tripAdapter.delegate = self
        if let user = NetworkServices.shared.loginSession?.user {
            self.tripAdapter.loadData(with: user.userTrips)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NetworkServices.shared.loginSession?.updateUserDetails ({
            DispatchQueue.main.async {
                if let user = NetworkServices.shared.loginSession?.user {
                    self.tripAdapter.loadData(with: user.userTrips)
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackTap(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueShowPastTripDetailsVC" {
            if let vc = segue.destination as? PastTripDetailVC,
                let hotel = sender as? Trips {
                vc.hotelsDetail = hotel
            }
        }
    }


}

extension ViewAllPastTripsVC: PastTripsListAdapterDelegate {
    func showTripDetails(for trip: Trips) {
        self.performSegue(withIdentifier: "segueShowPastTripDetailsVC", sender: trip)
    }
}
