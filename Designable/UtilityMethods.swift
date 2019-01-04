//
//  UtilityConstants.swift
//  PicDuel
//
//  Created by PujaRathod on 14/12/18.
//  Copyright © 2018 PujaRathod. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Hex Value to Color
func Color_Hex(hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//MARK:- Generate rounded corner image
func generateRoundCornerImage(image : UIImage , radius : CGFloat) -> UIImage {
    let imageLayer = CALayer()
    imageLayer.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
    imageLayer.contents = image.cgImage
    imageLayer.masksToBounds = true
    imageLayer.cornerRadius = radius
    imageLayer.borderColor = UIColor.white.cgColor
    imageLayer.borderWidth = 1.0
    UIGraphicsBeginImageContext(image.size)
    imageLayer.render(in: UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return roundedImage!
}


//MARK:- Get UI screen width
public func SCREENWIDTH() -> CGFloat {
    let screenSize = UIScreen.main.bounds
    return screenSize.width
}

//MARK:- Get UI screen height
public func SCREENHEIGHT() -> CGFloat {
    let screenSize = UIScreen.main.bounds
    return screenSize.height
}

//MARK:- Get storyboard by name
public func getStoryboard(storyboardName: String) -> UIStoryboard {
    return UIStoryboard(name: storyboardName, bundle: nil)
}

//MARK:- Load viewcontroller from storyboard
public func loadVC(strStoryboardId: String, strVCId: String) -> UIViewController {
    let vc = getStoryboard(storyboardName: strStoryboardId).instantiateViewController(withIdentifier: strVCId)
    return vc
}
