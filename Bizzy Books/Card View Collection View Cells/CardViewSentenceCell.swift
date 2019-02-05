//
//  CardViewSentenceCell.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/16/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit

class CardViewSentenceCell: UICollectionViewCell, FlowItemConfigurable {
    
    @IBOutlet weak var label: UILabel!
    
    func configure(labelFlowItem: LabelFlowItem) {
        label.text = labelFlowItem.text
        label.textColor = labelFlowItem.color
    }
    
    func configure(item: FlowItem) {
        if let labelFlowItem = item as? LabelFlowItem {
            configure(labelFlowItem: labelFlowItem)
        }
    }
    
}
