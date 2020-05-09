//
//  AddEstimateItemCell.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 1/21/20.
//  Copyright © 2020 Caldwell Contracting LLC. All rights reserved.
//

import UIKit


protocol AddEstimateItemCellDelegate: class {
    func didAddEstimateItem()
}


class AddEstimateItemCell: UIView {

    weak var delegate: AddEstimateItemCellDelegate?
    
    @IBAction func addEstimateItemPressed(_ sender: UIButton) {
        delegate?.didAddEstimateItem()
    }
}
