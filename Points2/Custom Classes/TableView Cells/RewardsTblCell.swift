//
//  RewardsTblCell.swift
//  Points2Miles
//
//  Created by Arjav Lad on 23/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit

class RewardsTblCell: UITableViewCell {

    @IBOutlet weak var lblRewardsStatus: UILabel!
    @IBOutlet weak var lblRewardPoints: UILabel!
    @IBOutlet weak var lblHotelAddress: UILabel!
    @IBOutlet weak var lblHotelName: UILabel!
    @IBOutlet weak var viewContainer: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let selectedBackground = UIView.init(frame: self.bounds)
        selectedBackground.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.3803921569, blue: 0.4392156863, alpha: 1)
        self.selectedBackgroundView = selectedBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func set(_ rewardPoint: RewardsPoint) {
//        if rewardPoint.status == .submissionPending {
//            self.selectionStyle = .default
//        } else {
//            self.selectionStyle = .none
//        }
        self.lblHotelName.text = rewardPoint.hotelName
        self.lblHotelAddress.text = rewardPoint.hotelAdderss
        self.lblRewardPoints.text = rewardPoint.points.formattedString
        self.lblRewardsStatus.text = rewardPoint.status.text
        self.lblRewardsStatus.textColor = rewardPoint.status.color
    }

}
