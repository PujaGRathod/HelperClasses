//
//  DoubleExtension.swift
//  Points2Miles
//
//  Created by Arjav Lad on 27/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import Foundation

extension Double {
    var formattedString: String {
        let formatter = NumberFormatter.init()
        formatter.numberStyle = .decimal
        formatter.positiveFormat = "###0.##"
        return formatter.string(from: NSNumber.init(value: self)) ?? "\(self)"
    }
}
