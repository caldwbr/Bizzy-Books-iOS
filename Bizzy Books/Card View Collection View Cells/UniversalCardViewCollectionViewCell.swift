//
//  UniversalCardViewCollectionViewCell.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/16/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit

class UniversalCardViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        if screenWidth > 374.0 {
            widthConstraint.constant = 350.0
        } else {
            widthConstraint.constant = screenWidth - (2 * 12)
        }
    }
    
    
    func configure(_ multiversalItemViewModel: MultiversalItem) {
        /*if let myMulti = multiversalItemViewModel as? EntityItem {
            entityCardViewNameLabel.text = myMulti.name
            entityCardViewPhoneNumberLabel.text = myMulti.phoneNumber
            entityCardViewEmailLabel.text = myMulti.email
            entityCardViewStreetLabel.text = myMulti.street
            entityCardViewCityStateLabel.text = String(myMulti.city + ", " + myMulti.state)
            entityCardViewSSNLabel.text = myMulti.ssn
            entityCardViewEINLabel.text = myMulti.ein
        }
        */
    }
    


}
