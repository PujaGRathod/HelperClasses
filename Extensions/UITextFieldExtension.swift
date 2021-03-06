//
//  UITextFieldExtension.swift
//  remone
//
//  Created by Arjav Lad on 25/12/17.
//  Copyright © 2017 Inheritx. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    func setLeftImage(_ image : UIImage, withPadding padding: CGSize, tintColor : UIColor?) {
        var leftFrame : CGRect = self.frame
        leftFrame.origin = .zero
        leftFrame.size.width = leftFrame.size.height
        let leftImageViewContainer = UIView.init(frame: leftFrame)
        
        var imageFrame : CGRect = leftImageViewContainer.frame
        imageFrame.size.width -= padding.width * 2
        imageFrame.size.height -= padding.height * 2
    
        let imageView = UIImageView.init(frame: imageFrame)
        if let tint = tintColor {
            imageView.tintColor = tint
            imageView.image = image.withRenderingMode(.alwaysTemplate)
        } else {
            imageView.image = image
        }
        imageView.contentMode = .scaleAspectFit
        
        leftImageViewContainer.addSubview(imageView)
        imageView.center = leftImageViewContainer.center
        self.leftViewMode = .always
        self.leftView = leftImageViewContainer
    }
    
    func setClearTextButton(with image : UIImage, withPadding padding: CGSize, tintColor : UIColor) {
        var rightFrame : CGRect = self.frame
        rightFrame.origin = .zero
        rightFrame.size.width = rightFrame.size.height

        let rightImageViewContainer = UIView.init(frame: rightFrame)
        
        var clearButtonFrame = rightImageViewContainer.frame
        clearButtonFrame.size.width -= padding.width * 2
        clearButtonFrame.size.height -= padding.height * 2
        
        let clearButton = UIButton.init(type: .system)
        clearButton.frame = clearButtonFrame
        clearButton.addTarget(self, action: #selector(clearTextField(_:)), for: .touchUpInside)
        clearButton.setImage(image, for: .normal)
        clearButton.imageView?.contentMode = .scaleAspectFit
        clearButton.tintColor = tintColor
        
        rightImageViewContainer.addSubview(clearButton)
        clearButton.center = rightImageViewContainer.center
        
        self.rightViewMode = .whileEditing
        self.rightView = rightImageViewContainer
    }
    
    enum TextFieldViewSide {
        case rightSide, leftSide
    }
    
    func add(padding : CGFloat, viewMode : TextFieldViewSide) {
        var paddingFrame : CGRect = self.frame
        paddingFrame.origin = .zero
        paddingFrame.size.width = padding
        
        let paddingView = UIView.init(frame: paddingFrame)
        switch viewMode {
        case .rightSide:
            self.rightView = paddingView
            self.rightViewMode = .always
            
        default:
            self.leftView = paddingView
            self.leftViewMode = .always
        }
    }
    
    @objc fileprivate func clearTextField(_ sender: UIButton) {
        var clear = true
        if let del = self.delegate {
            guard let _ = del.textFieldShouldClear(_:) else {
                self.text = ""
                return
            }
            clear = del.textFieldShouldClear!(self)
        }
        if clear {
            self.text = ""
        }
    }
}
