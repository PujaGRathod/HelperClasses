//
//  PastTripsTblCell.swift
//  Points2Miles
//
//  Created by Arjav Lad on 02/05/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit
import SDWebImage

class PastTripsTblCell: UITableViewCell {

    
    @IBOutlet var distance: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet var tripName: UILabel!
    @IBOutlet var imgTrip: UIImageView!
    @IBOutlet weak var viewContent: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupView() {
        self.viewContent.layer.cornerRadius = 15
        self.viewContent.clipsToBounds = true
    }

    func set(_ tripDetail: Trips) {
        if let imgURL = tripDetail.hotelImage {
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
        self.tripName.text = tripDetail.name
        self.address.text = tripDetail.address
        self.distance.text = "\(tripDetail.distance.formattedString) miles"
    }

    func setHotel(_ hotelDetail: Hotel) {
        if let imgURL = hotelDetail.image {
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
        self.tripName.text = hotelDetail.name
        self.address.text = hotelDetail.address
        self.distance.text = "\((hotelDetail.distance ?? 0).formattedString) miles"
    }

}
