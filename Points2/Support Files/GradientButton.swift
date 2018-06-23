//
//  GradientButton.swift
//  Points2Miles
//
//  Created by Akshit Zaveri on 14/04/18.
//  Copyright © 2018 Akshit Zaveri. All rights reserved.
//

import UIKit

@IBDesignable
class GradientButton: UIButton {
    
    @IBInspectable var startPoint: CGPoint = .zero {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var endPoint: CGPoint = .zero {
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
    
    @IBInspectable var topLeftRadius: Bool = false {
        didSet {
            updateView()
        }
    }
    @IBInspectable var bottomLeftRadius: Bool = false {
        didSet {
            updateView()
        }
    }
    @IBInspectable var topRightRadius: Bool = false {
        didSet {
            updateView()
        }
    }
    @IBInspectable var bottomRightRadius: Bool = false {
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
    
    @IBInspectable var cornerRadius: Double = 0 {
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
        let layer = self.layer as! CAGradientLayer
//        let layer = CAGradientLayer.init(layer: self.layer)
        layer.colors = [firstColor, secondColor].map{$0.cgColor}
        layer.startPoint = self.startPoint
        layer.endPoint = self.endPoint
        
        var corners: UIRectCorner = []
        if self.topLeftRadius {
            corners.insert(.topLeft)
        }
        if self.topRightRadius {
            corners.insert(.topRight)
        }
        if self.bottomRightRadius {
            corners.insert(.bottomRight)
        }
        if self.bottomLeftRadius {
            corners.insert(.bottomLeft)
        }
        if corners.isEmpty == false {
            let shapeLayer = self.shapeLayer(for: corners, cornerRadiiSize: CGSize(width: cornerRadius, height: cornerRadius))
            self.layer.mask = shapeLayer
        }
        
//        if self.showShadow {
//            self.dropShadow(color: self.shadowColor, opacity: self.shadowOpacity, offSet: self.shadowOffset, radius: self.shadowRadius, scale: true)
//        }
    }
    
    private func shapeLayer(for corners: UIRectCorner, cornerRadiiSize: CGSize) -> CAShapeLayer {
        let cornerRadiusShapeLayer = CAShapeLayer()
        cornerRadiusShapeLayer.bounds = self.frame
        cornerRadiusShapeLayer.position = self.center
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: cornerRadiiSize).cgPath
        cornerRadiusShapeLayer.path = path
        
        return cornerRadiusShapeLayer
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
