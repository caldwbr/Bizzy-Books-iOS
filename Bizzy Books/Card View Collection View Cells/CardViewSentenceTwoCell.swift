//
//  CardViewSentenceTwoCell.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/21/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit

class CardViewSentenceTwoCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func configure(labelFlowItem: LabelFlowItem) {
        label.text = labelFlowItem.text
        label.textColor = labelFlowItem.color
    }
    
}
