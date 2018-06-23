//
//  PastTripsListAdapter.swift
//  Points2Miles
//
//  Created by Intelivex Labs on 26/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit

protocol PastTripsListAdapterDelegate {
    func showTripDetails(for trip: Trips)
}

class PastTripsListAdapter: NSObject {

    fileprivate var pastTripsTable: UITableView!
    fileprivate var pastTripsHistory: [Trips] = []

    var delegate: PastTripsListAdapterDelegate?

    func set(_ table: UITableView) {
        self.pastTripsTable = table
        self.pastTripsTable.register(UINib.init(nibName: "PastTripsTblCell", bundle: nil), forCellReuseIdentifier: "PastTripsTblCell")
        self.pastTripsTable.delegate = self
        self.pastTripsTable.dataSource = self
        self.pastTripsTable.backgroundColor = .clear

        self.pastTripsTable.reloadData()
    }

    func loadData(with trips: [Trips]) {
        self.pastTripsHistory = trips
        self.pastTripsTable.reloadData()
    }
}

extension PastTripsListAdapter: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pastTripsHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PastTripsTblCell", for: indexPath) as! PastTripsTblCell
        cell.set(self.pastTripsHistory[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let trip = self.pastTripsHistory[indexPath.row]
        self.delegate?.showTripDetails(for: trip)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
   
}
