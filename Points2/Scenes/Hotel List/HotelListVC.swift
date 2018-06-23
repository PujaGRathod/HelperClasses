//
//  HotelListVC.swift
//  Points2Miles
//
//  Created by Arjav Lad on 03/05/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol HotelListVCDelegate {
    func selectedHotelFromList(objHotel: Hotel)
}

class HotelListVC: UIViewController {

    var delegate: HotelListVCDelegate?

    @IBOutlet weak var viewSearchBarContainer: UIView!
    var arrHotels: [Hotel] = []
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    var filteredTableData = [Hotel]()
    let hotelAdapter = HotelListAdapter()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblHotelList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        self.hotelAdapter.delegate = self
        self.hotelAdapter.set(self.tblHotelList, searchController: self.searchController)
        self.customizeSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.hotelAdapter.loadData(with: self.arrHotels)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }

    @IBAction func onBackTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func customizeSearchBar() {
        self.searchController.searchResultsUpdater = self.hotelAdapter
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "search hotel"
        self.searchController.searchBar.tintColor = .white
        self.searchController.searchBar.barTintColor = #colorLiteral(red: 0.3215686275, green: 0.3803921569, blue: 0.4392156863, alpha: 1)
        self.searchController.searchResultsController?.view.backgroundColor = .clear
        self.navigationController?.hidesBarsWhenKeyboardAppears = false
//        self.tblHotelList.tableHeaderView = self.searchController.searchBar
        self.viewSearchBarContainer.addSubview(self.searchController.searchBar)
        self.definesPresentationContext = true
    }
}

extension HotelListVC: HotelListAdapterDelegate {
    func selectedHotelFromList(objHotel: Hotel) {
        self.delegate?.selectedHotelFromList(objHotel: objHotel)
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        }
    }
}
