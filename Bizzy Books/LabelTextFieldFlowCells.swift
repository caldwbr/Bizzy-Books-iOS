//
//  LabelTextFieldFlowCells.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 6/22/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import UIKit

protocol LabelTextFieldFlowCell {
    func configure(item: LabelTextFieldFlowItem)
}

class TextFieldCollectionViewCell : UICollectionViewCell, LabelTextFieldFlowCell {
    
    @IBOutlet weak var textField: UITextField!
    
    func configure(item: LabelTextFieldFlowItem) {
        textField.text = item.text
        textField.placeholder = item.placeholder
        textField.textColor = item.color
    }
}

class LabelCollectionViewCell : UICollectionViewCell, LabelTextFieldFlowCell {
    
    
    @IBOutlet weak var label: UILabel!
    
    func configure(item: LabelTextFieldFlowItem) {
        label.text = item.text
        label.textColor = item.color
    }
}

//Is this good with the video?


class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
}
