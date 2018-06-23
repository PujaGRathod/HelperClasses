//
//  GetStartedVC.swift
//  Points2Miles
//
//  Created by Akshit Zaveri on 16/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit

class GetStartedVC: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let fontBold = UIFont(name: "SanFranciscoDisplay-Bold", size: 22)
        let fontThin = UIFont(name: "SanFranciscoDisplay-Thin", size: 22)
        
        let boldAttribures: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font: fontBold as Any,
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        
        let lightAttribures = [
            NSAttributedStringKey.font: fontThin as Any,
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        
        let att = NSMutableAttributedString(string: "Earn ", attributes: lightAttribures)
        att.append(NSAttributedString(string: "IHG Rewards points", attributes: boldAttribures))
        att.append(NSAttributedString(string: " every \ntime drive to a participating \n", attributes: lightAttribures))
        att.append(NSAttributedString(string: "IHG Hotel", attributes: boldAttribures))
        self.label.attributedText = att
    }
}
