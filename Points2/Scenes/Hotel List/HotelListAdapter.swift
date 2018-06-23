//
//  HotelListAdapter.swift
//  Points2Miles
//
//  Created by Intelivex Labs on 26/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit

protocol HotelListAdapterDelegate {
    func selectedHotelFromList(objHotel: Hotel)
}

class HotelListAdapter: NSObject {
    
    fileprivate var hotelListTable: UITableView!
    fileprivate var arrHotels: [Hotel] = []
    var delegate: HotelListAdapterDelegate! = nil
    var resultSearchController: UISearchController?
    var filteredTableData = [Hotel]()

    func dismissSearchController() {
        self.resultSearchController?.dismiss(animated:true, completion: nil)
    }
    
    func set(_ table: UITableView, searchController: UISearchController) {
        self.hotelListTable = table
        self.hotelListTable.separatorStyle = .none
        self.hotelListTable.register(UINib.init(nibName: "PastTripsTblCell", bundle: nil), forCellReuseIdentifier: "PastTripsTblCell")
        self.hotelListTable.delegate = self
        self.hotelListTable.dataSource = self
        self.resultSearchController = searchController
        if let textFieldInsideSearchBar = self.resultSearchController?.searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = #colorLiteral(red: 0.3215686275, green: 0.3803921569, blue: 0.4392156863, alpha: 1)
        }
    }

    func loadData(with hotels: [Hotel]) {
        self.arrHotels = hotels
//        for _ in 0...10 {
//            self.arrHotels.append(contentsOf: self.arrHotels)
//        }
        self.hotelListTable.reloadData()
    }

    func filterContentForSearchText(_ searchText: String) {
        if searchText.trimString() != "" {
            self.filteredTableData = self.arrHotels.filter({ (hotel) -> Bool in
                let name = hotel.name.lowercased().contains(searchText.lowercased()) 
                let add = hotel.address.lowercased().contains(searchText.lowercased())
                return name || add
            })
        } else {
            self.filteredTableData = self.arrHotels
        }
        self.hotelListTable.reloadData()
    }
}

extension HotelListAdapter: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filterContentForSearchText(searchController.searchBar.text ?? "")
    }
}


extension HotelListAdapter: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let searchController = self.resultSearchController,
            searchController.isActive {
            return self.filteredTableData.count
        }
        else {
            return self.arrHotels.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PastTripsTblCell", for: indexPath) as! PastTripsTblCell
        if let searchController = self.resultSearchController,
            searchController.isActive {
            cell.setHotel(self.filteredTableData[indexPath.row])
            return cell
        }
        else {
            cell.setHotel(self.arrHotels[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            if let searchController = self.resultSearchController,
                searchController.isActive,
                self.filteredTableData.count > 0 {
                searchController.dismiss(animated: false) {
                    delegate.selectedHotelFromList(objHotel: self.filteredTableData[indexPath.row])
                }
            } else {
                delegate.selectedHotelFromList(objHotel: self.arrHotels[indexPath.row])
            }
        }
    }
}

