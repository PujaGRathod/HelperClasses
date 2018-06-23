//
//  CollectionViewAdapter.swift
//  Dishwasher
//
//  Created by Intelivex Labs on 23/06/18.
//  Copyright © 2018 Intelivex Labs. All rights reserved.
//

import UIKit

class CollectionViewAdapter: NSObject {
    
    fileprivate var productsList: UICollectionView!
    fileprivate var products: [Product] = []
    
    func set(collectionView: UICollectionView) {
        self.productsList = collectionView
        self.productsList.delegate = self
        self.productsList.dataSource = self
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
        self.products = Products
        self.productsList.reloadData()
    }
}

extension CollectionViewAdapter : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ProductCell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCell
        cell.setProduct(products[indexPath.item])
        return cell
    }
}
