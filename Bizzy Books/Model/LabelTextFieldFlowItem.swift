//
//  LabelTextFieldFlowItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 6/22/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import UIKit

protocol FlowItem {
    var displaySize : CGSize {get}
    var cellIdentifier : String {get}
}


/**
 A dropdown with a list of icons
 */
struct DropdownFlowItem : FlowItem {
    struct Option {
        let title : String
        let iconName : String
        var icon : UIImage? {
            return UIImage(named: iconName)
        }
    }
    
    let options : [Option]
    var displaySize : CGSize {
        return CGSize(width: 120, height: 32)
    }
    
    var cellIdentifier : String {
        return "DropdownFlowCollectionViewCell"
    }
}


struct LabelFlowItem : FlowItem {
    let text : String
    let color : UIColor
    let action : (()->Void)?
    
    var displaySize : CGSize {
        // Calculate the size of the text
        var size = UIScreen.main.bounds.size
        size.height = 44.0
        size = (text as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin,
                                               attributes: [
                                                NSFontAttributeName : UIFont.systemFont(ofSize: 17.0)
            ], context: nil).size
        
        // Add the padding
        let padding : CGFloat = 20.0
        size.width = size.width + padding
        size.height = 32.0
        return size
    }
    
    var cellIdentifier : String {
        return "LabelCollectionViewCell"
    }
}




struct TextFieldFlowItem : FlowItem {
    let text : String
    let placeholder : String
    let color : UIColor
    
    var displaySize : CGSize {
        return CGSize(width: 120, height: 32)
    }
    
    var cellIdentifier : String {
        return "TextFieldCollectionViewCell"
    }
}

