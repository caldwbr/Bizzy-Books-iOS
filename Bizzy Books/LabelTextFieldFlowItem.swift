//
//  LabelTextFieldFlowItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 6/22/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import UIKit

struct LabelTextFieldFlowItem {
    let text : String
    let placeholder : String
    let color : UIColor
    let editable: Bool
    
    var displaySIze : CGSize {
        if editable {
            return CGSize(width: 150, height: 32)
        } else {
            
            // Calculate the size of the text
            var size = UIScreen.main.bounds.size
            size.height = 32.0
            size = (text as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin,
                                                   attributes: [
                                                    NSFontAttributeName : UIFont.systemFont(ofSize: 17.0)
                ], context: nil).size
            
            // Add the padding
            let padding : CGFloat = 16.0
            size.width = size.width + padding
            size.height = 32.0
            return size
        }
    }
    
    var cellIdentifier : String {
        if editable {
            return "TextFieldCollectionViewCell"
        } else {
            return "LabelCollectionViewCell"
        }
    }
}
