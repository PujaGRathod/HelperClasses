//
//  ClothingsListAdapter.swift
//  YOOX_NET_PORTER
//
//  Created by Intelivex Labs on 19/06/18.
//  Copyright © 2018 Intelivex Labs. All rights reserved.
//

import Foundation
import UIKit

class ClothingsListAdapter: NSObject {
    
    fileprivate var clothingsList: UICollectionView!
    fileprivate var clothes: [Product] = []
    fileprivate var collectionViewLayout: CustomLayout!
    func set(collectionView: UICollectionView) {
        self.clothingsList = collectionView
        self.clothingsList.register(UINib.init(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: "ProductCell")
        collectionViewLayout = CustomLayout()
        collectionView.collectionViewLayout = collectionViewLayout
        self.clothingsList.delegate = self
        self.clothingsList.dataSource = self
        self.productList()
    }
    
    func productList() {
        NetworkServices.shared.getProductList { (product) in
            if let productList = product {
                self.loadData(with:productList)
            }
        }
    }
    
    func loadData(with Products: [Product]) {
        self.clothes = Products
        self.clothingsList.reloadData()
    }
}

extension ClothingsListAdapter : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clothes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ProductCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.setProduct(productDetail:clothes[indexPath.item])
        return cell
    }
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let numberOfSets = CGFloat(self.clothes.count)
//        let width = (collectionView.frame.size.width / numberOfSets) - 10
//        let height = collectionView.frame.size.height / 2
//        return CGSize(width: width, height: height)
//    }
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//
//        let cellWidthPadding = collectionView.frame.size.width / 140
//        let cellHeightPadding = collectionView.frame.size.height / 2
//        return UIEdgeInsets(top: cellHeightPadding,left: cellWidthPadding, bottom: cellHeightPadding,right: cellWidthPadding)
//    }
}
