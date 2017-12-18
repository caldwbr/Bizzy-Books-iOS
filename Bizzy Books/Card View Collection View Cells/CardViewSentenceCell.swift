//
//  CardViewSentenceCell.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/16/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit

class CardViewSentenceCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func configure(labelFlowItem: LabelFlowItem) {
        label.text = labelFlowItem.text
        label.textColor = labelFlowItem.color
    }
    
}
