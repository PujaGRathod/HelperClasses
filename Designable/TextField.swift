//
//  TextField.swift
//  PicDuel
//
//  Created by PujaRathod on 14/12/18.
//  Copyright © 2018 PujaRathod. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundTextField : UITextField {
    /*
    @IBInspectable var cornerRadius : CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
 */
    
    @IBInspectable var bgColor : UIColor? {
        didSet {
            backgroundColor = bgColor
        }
    }
    
    @IBInspectable var leftImage : UIImage? {
        didSet {
            if let image = leftImage{
                leftViewMode = .always
                let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
                imageView.image = image
                imageView.tintColor = tintColor
                let view = UIView(frame : CGRect(x: 0, y: 0, width: 25, height: 20))
                view.addSubview(imageView)
                leftView = view
            }else {
                leftViewMode = .never
            }
            
        }
    }
    
//    @IBInspectable var placeholderColor : UIColor? {
//        didSet {
//            let rawString = attributedPlaceholder?.string != nil ? attributedPlaceholder!.string : ""
//            let str = NSAttributedString(string: rawString, attributes: [
//                NSAttributedStringKey.foregroundColor: placeholderColor!])
//            attributedPlaceholder = str
//        }
//    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 50, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 50, dy: 5)
    }
    
}
