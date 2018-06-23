//
//  PastTripsCollectionViewAdapter.swift
//  Points2Miles
//
//  Created by Arjav Lad on 16/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit

protocol PastTripsCollectionViewAdapterDelegate{
    func selectedHotel(objHotel: Trips)
}

class PastTripsCollectionViewAdapter: NSObject {

    fileprivate var pastDestinations = [Trips]()
    fileprivate var collectionview: UICollectionView!
    var delegate: PastTripsCollectionViewAdapterDelegate! = nil

    func set(collectionview: UICollectionView) {
        self.collectionview = collectionview
        let nib = UINib(nibName: "HotelClnCell", bundle: nil)
        self.collectionview.register(nib, forCellWithReuseIdentifier: "cell")

        self.collectionview.delegate = self
        self.collectionview.dataSource = self
    }

    func loadData(with trips: [Trips]) {
        self.pastDestinations = trips
        self.collectionview.reloadData()
    }
    
//    func getPastTripHotels() -> [Trips] {
//        var arrPastTripsDetails:[Trips] = []
//        if let trips = NetworkServices.shared.loginSession?.user.userTrips {
//            for tr in trips {
//                if var hotel = NetworkServices.shared.getUserPastTripHotelList(by: String(tr.hotelId)) {
//                    arrPastTripsDetails.append(hotel)
//                }
//            }
//        }
//        return arrPastTripsDetails
//    }

}

extension PastTripsCollectionViewAdapter: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = self.pastDestinations.count
        if count > 10 {
            count = 10
        }
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HotelClnCell
        cell.setTrips(with: self.pastDestinations[indexPath.item])
        return cell
    }
}

extension PastTripsCollectionViewAdapter: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate!.selectedHotel(objHotel:self.pastDestinations[indexPath.item])
    }
}
