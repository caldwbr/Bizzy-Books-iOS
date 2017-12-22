//
//  EntityCardViewCollectionViewCell.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/13/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit

class EntityCardViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var entityCardViewNameLabel: UILabel!
    @IBOutlet weak var entityCardViewLineBreakView: UIView!
    @IBOutlet weak var entityCardViewPhoneNumberView: UIView!
    @IBOutlet weak var entityCardViewPhoneNumberLabel: UILabel!
    @IBOutlet weak var entityCardViewEmailView: UIView!
    @IBOutlet weak var entityCardViewEmailLabel: UILabel!
    @IBOutlet weak var entityCardViewAddressView: UIView!
    @IBOutlet weak var entityCardViewStreetLabel: UILabel!
    @IBOutlet weak var entityCardViewCityStateLabel: UILabel!
    @IBOutlet weak var entityCardViewSSNLabel: UILabel!
    @IBOutlet weak var entityCardViewEINLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var entityCardViewPhoneEmailGeoView: UIView!
    
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
    
    func configure(i: Int) {
        if let myMulti = MIProcessor.sharedMIP.mIP[i] as? EntityItem {
            entityCardViewPhoneNumberView.isHidden = false
            entityCardViewEmailView.isHidden = false
            entityCardViewAddressView.isHidden = false
            if myMulti.phoneNumber == "" {
                entityCardViewPhoneNumberView.isHidden = true
            }
            if myMulti.email == "" {
                entityCardViewEmailView.isHidden = true
            }
            if myMulti.street == "" {
                entityCardViewAddressView.isHidden = true
            }
            entityCardViewNameLabel.text = myMulti.name
            entityCardViewPhoneNumberLabel.text = myMulti.phoneNumber
            entityCardViewEmailLabel.text = myMulti.email
            entityCardViewStreetLabel.text = myMulti.street
            if (myMulti.city == "") || (myMulti.state == "") {
                entityCardViewCityStateLabel.text = ""
            } else {
                entityCardViewCityStateLabel.text = String(myMulti.city + ", " + myMulti.state)
            }
            entityCardViewSSNLabel.text = myMulti.ssn
            entityCardViewEINLabel.text = myMulti.ein
            entityCardViewPhoneEmailGeoView.isHidden = false
            if (myMulti.phoneNumber == "") && (myMulti.email == "") && (myMulti.street == "") {
                entityCardViewPhoneEmailGeoView.isHidden = true
            }
        }
        
    }
    
}
