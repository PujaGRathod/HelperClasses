//
//  HotelClnCell.swift
//  Points2Miles
//
//  Created by Akshit Zaveri on 14/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit
import SDWebImage
class HotelClnCell: UICollectionViewCell {

    @IBOutlet weak var hotelImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 7.5
    }

    func setTrips(with trips: Trips) {
        if let imgURL = trips.hotelImage {
             self.hotelImageView.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "imgHotelPlaceHolder"), options:.retryFailed ) { (image, _, _, _) in
                if let image = image {
                  self.hotelImageView.image = image
                    let size = image.size
                    if size.width / size.height == 1 {
                        self.hotelImageView.contentMode = .scaleAspectFit
                    } else {
                        self.hotelImageView.contentMode = .scaleAspectFill
                    }
                }
            }
        } else {
            self.hotelImageView.image = #imageLiteral(resourceName: "imgHotelPlaceHolder")
        }
        self.nameLabel.text = trips.name
        self.addressLabel.text = trips.address
        self.distanceLabel.text = "\(trips.distance.formattedString) miles"
    }
    
    func setHotels(with hotel: Hotel) {
        var hotel = hotel
        if let imgURL = hotel.image {
            self.hotelImageView.sd_setImage(with: imgURL, placeholderImage: #imageLiteral(resourceName: "imgHotelPlaceHolder"), options:.retryFailed ) { (image, _, _, _) in
                if let image = image {
                    self.hotelImageView.image = image
                    let size = image.size
                    if size.width / size.height == 1 {
                        self.hotelImageView.contentMode = .scaleAspectFit
                    } else {
                        self.hotelImageView.contentMode = .scaleAspectFill
                    }
                }
            }
        } else {
            self.hotelImageView.image = #imageLiteral(resourceName: "imgHotelPlaceHolder")
        }
        
        self.nameLabel.text = hotel.name
        self.addressLabel.text = hotel.address
        
        hotel.distance = hotel.calculateDistance()
        self.distanceLabel.text = "\((hotel.distance ?? 0).formattedString) miles"
    }
}
