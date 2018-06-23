//
//  ProductAPICall.swift
//  Dishwasher
//
//  Created by Intelivex Labs on 19/06/18.
//  Copyright © 2018 Intelivex Labs. All rights reserved.
//

import Foundation

extension NetworkServices {
    func getProductList(responseClosure: (@escaping ([Product]?) ->Void)) {
        _ = self.makeGETRequest(with: "https://api.johnlewis.com/v1/products/search?q=dishwasher&key=Wu1Xqn3vNrd1p7hqkvB6hEu0G9OrsYGb&pageSize=20") { (response) in
            if let res = response.result {
                let manager = ProductManager()
                if let products = manager.GetProductList(data: res) {
                    responseClosure(products)
                }
            }
        }
    }
}
