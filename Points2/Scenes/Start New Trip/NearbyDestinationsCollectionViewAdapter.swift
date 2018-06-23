//
//  NearbyDestinationsCollectionViewAdapter.swift
//  Points2Miles
//
//  Created by Akshit Zaveri on 14/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit

protocol NearbyDestinationCollectionViewAdapterDelegate {
    func selectedHotel(objHotel: Hotel)
}

class NearbyDestinationsCollectionViewAdapter: NSObject {

    fileprivate var nearbyDestinations = [Hotel]()
    fileprivate var collectionview: UICollectionView!
    var delegate:NearbyDestinationCollectionViewAdapterDelegate?

    func set(collectionview: UICollectionView) {
        self.collectionview = collectionview
        let nib = UINib(nibName: "HotelClnCell", bundle: nil)
        self.collectionview.register(nib, forCellWithReuseIdentifier: "cell")
        self.collectionview.delegate = self
        self.collectionview.dataSource = self
    }
    
    func reload(arrDestinations: [Hotel]) {
        self.nearbyDestinations = arrDestinations.filter({ (hotel) -> Bool in
            let distance = hotel.calculateDistance()
            return (distance <= 100)
        })
        self.collectionview.reloadData()
    }
    
}

extension NearbyDestinationsCollectionViewAdapter: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nearbyDestinations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HotelClnCell
        cell.setHotels(with: self.nearbyDestinations[indexPath.item])
        return cell
    }
}

extension NearbyDestinationsCollectionViewAdapter: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.selectedHotel(objHotel:self.nearbyDestinations[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("check now");
    }
}
