//
//  RewardsPoint.swift
//  Points2Miles
//
//  Created by Arjav Lad on 23/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit
import Foundation

enum RewardsPointStatus: Int {
    case submissionPending = 1
    case approvalPending = 2
    case approved = 3
    case denied = 4

    var color: UIColor {
        switch self {
        case .approved:
            return UIColor.green

        case .denied:
            return UIColor.red

        default:
            return UIColor.yellow
        }
    }

    var text: String {
        switch self {
        case .approved:
            return "Approved"

        case .denied:
            return "Denied"

        case .submissionPending:
            return "Submission Pending"

        case .approvalPending:
            return "Approval Pending"
        }
    }

}

struct RewardsPoint {

    let tripID: Int
    let hotelName: String
    let hotelAdderss: String
    let points: Double
    let status: RewardsPointStatus

}
