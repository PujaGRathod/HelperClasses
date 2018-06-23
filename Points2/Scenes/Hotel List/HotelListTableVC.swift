//
//  HotelListTableVC.swift
//  Points2Miles
//
//  Created by Intelivex Labs on 27/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit

protocol HotelListTableVCDelegate {
    func selectedHotelFromList(objHotel: Hotel)
}

class HotelListTableVC: UITableViewController,HotelListAdapterDelegate {

    var delegate: HotelListTableVCDelegate! = nil
    var arrHotels: [Hotel] = []
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    var filteredTableData = [Hotel]()
    let hotelAdapter = HotelListAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hotelAdapter.delegate = self
        self.hotelAdapter.set(self.tableView, searchController: self.searchController)
        self.customizeSearchBar()
        self.customizeNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.hotelAdapter.loadData(with: self.arrHotels)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onBackTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func customizeSearchBar() {
        self.searchController.searchResultsUpdater = self.hotelAdapter
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search by name"
        self.searchController.searchBar.barStyle = .blackTranslucent
        self.searchController.searchBar.tintColor = .white
//        self.searchController.searchBar.barTintColor = .white
        self.definesPresentationContext = true
    }


    func customizeNavigationBar() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.searchController = self.searchController
            self.navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
    }

    func selectedHotelFromList(objHotel: Hotel) {
        self.delegate.selectedHotelFromList(objHotel: objHotel)
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
}
