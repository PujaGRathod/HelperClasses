//
//  ProductListViewController.swift
//  Dishwasher
//
//  Created by Intelivex Labs on 23/06/18.
//  Copyright © 2018 Intelivex Labs. All rights reserved.
//

import UIKit

class ProductListViewController: UICollectionViewController {

    var listAdapter = CollectionViewAdapter()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let collection = self.collectionView {
            self.listAdapter.set(collectionView:collection)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
