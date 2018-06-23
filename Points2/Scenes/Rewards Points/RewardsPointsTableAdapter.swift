//
//  RewardsPointsTableAdapter.swift
//  Points2Miles
//
//  Created by Arjav Lad on 23/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit

protocol RewardsPointsTableAdapterDelegate {
    func changeRewardsPointRequest(for trip: RewardsPoint)
}

class RewardsPointsTableAdapter: NSObject {

    fileprivate var rewardsTable: UITableView!
    fileprivate var rewardsHistory: [RewardsPoint] = []

    var delegate: RewardsPointsTableAdapterDelegate?

    func set(_ table: UITableView) {
        self.rewardsTable = table
        self.rewardsTable.allowsSelection = true
        self.rewardsTable.allowsMultipleSelection = false
        self.rewardsTable.delegate = self
        self.rewardsTable.dataSource = self
    }

    func loadData(with history: [RewardsPoint]) {
        self.rewardsHistory = history
        self.rewardsTable.reloadData()
    }
}

extension RewardsPointsTableAdapter: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rewardsHistory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RewardsTblCell", for: indexPath) as! RewardsTblCell
        cell.set(self.rewardsHistory[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let reward = self.rewardsHistory[indexPath.row]
        if reward.status == .submissionPending {
            self.delegate?.changeRewardsPointRequest(for: reward)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

