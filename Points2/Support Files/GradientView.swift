//
//  GradientView.swift
//  Points2Miles
//
//  Created by Akshit Zaveri on 14/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var applyGradient: Bool = false {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isGradientHorizontal: Bool = true {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var firstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    @IBInspectable var secondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var showShadow: Bool = false {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .black {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 1 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 1 {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        if self.applyGradient {
            if let layer = self.layer as? CAGradientLayer {
                layer.colors = [firstColor, secondColor].map{$0.cgColor}
                if (self.isGradientHorizontal) {
                    layer.startPoint = CGPoint(x: 0, y: 0.5)
                    layer.endPoint = CGPoint (x: 1, y: 0.5)
                } else {
                    layer.startPoint = CGPoint(x: 0.5, y: 0)
                    layer.endPoint = CGPoint (x: 0.5, y: 1)
                }
            }
        }
        
        if self.showShadow {
            self.dropShadow(color: self.shadowColor, opacity: self.shadowOpacity, offSet: self.shadowOffset, radius: self.shadowRadius, scale: true)
        }
    }
    
    func dropShadow(color: UIColor, opacity: Float = 1, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
