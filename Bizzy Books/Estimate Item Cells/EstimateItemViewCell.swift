//
//  EstimateItemViewCell.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 1/21/20.
//  Copyright © 2020 Caldwell Contracting LLC. All rights reserved.
//

import UIKit

protocol EstimateItemViewCellDelegate: class {
    func didRemoveEstimateItem(_ item: EstimateItem, atCell cell: EstimateItemViewCell)
}

class EstimateItemViewCell: UITableViewCell {
    
    private var item: EstimateItem!
    weak var delegate: EstimateItemViewCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var unitPriceLabel: UILabel?
    @IBOutlet weak var quantityLabel: UILabel?
    @IBOutlet weak var totalPriceLabel: UILabel?
    
    func configure(item: EstimateItem) {
        self.item = item
        
        // Populate the EstimateItem data to labels
        titleLabel?.text = item.title
        descriptionLabel?.text = item.description
        unitPriceLabel?.text = item.unitPrice.toString()
        quantityLabel?.text = item.quantity.description
        totalPriceLabel?.text = item.totalPrice.description
    }
    
    @IBAction func removeEstimateItemPressed(_ sender: UIButton) {
        delegate?.didRemoveEstimateItem(item, atCell: self)
    }
    
}
