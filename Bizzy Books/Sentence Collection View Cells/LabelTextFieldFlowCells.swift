//
//  LabelTextFieldFlowCells.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 6/22/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import UIKit

protocol FlowItemConfigurable {
    func configure(item: FlowItem)
}


class TextFieldCollectionViewCell : UICollectionViewCell, FlowItemConfigurable {
    
    @IBOutlet weak var textField: AllowedCharsTextField!
    @IBAction func textFieldEditingChanged(_ sender: AllowedCharsTextField) {
        //AddUniversal.updateSliderValues(AddUniversal.thePercent)
        
    }
    
    func configure(item: FlowItem) {
        if let item = item as? TextFieldFlowItem {
            textField.text = item.text
            textField.attributedPlaceholder = NSAttributedString(string: item.placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.BizzyColor.Green.What])
            textField.textColor = item.color
            textField.keyboardType = item.keyboardType
            textField.allowedChars = item.allowedCharsString
            textField.formatter.numberStyle = item.formatterStyle
            textField.numberKind = item.numberKind
            textField.identifier = item.identifier // 0 for default, 1 for how many gallons on fuel type
        }
    }

}

class LabelCollectionViewCell : UICollectionViewCell, FlowItemConfigurable {
    
    @IBOutlet weak var label: UILabel!
    private var action : (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Create the tap gesture for the label
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LabelCollectionViewCell.labelTapped))
        label.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func labelTapped() {
        // Perform the action of the item
        action?()
    }
    
    func configure(item: FlowItem) {
        if let item = item as? LabelFlowItem {
            label.text = item.text
            label.textColor = item.color
            action = item.action
        }
    }

}
