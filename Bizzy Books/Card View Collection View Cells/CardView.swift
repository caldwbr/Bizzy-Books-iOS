//
//  CardView.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/13/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 2.0
    @IBInspectable var shadowOffsetWidth: CGFloat = 0.0
    @IBInspectable var shadowOffsetHeight: CGFloat = 5.0
    @IBInspectable var shadowColor: UIColor = UIColor.black
    @IBInspectable var shadowOpacity: CGFloat = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowOffset.width = shadowOffsetWidth
        layer.shadowOffset.height = shadowOffsetHeight
        layer.shadowColor = shadowColor.cgColor
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
    }
    
}
