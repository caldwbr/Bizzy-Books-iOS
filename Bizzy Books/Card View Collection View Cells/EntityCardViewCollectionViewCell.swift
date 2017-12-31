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
    @IBOutlet weak var entityCardViewDateLabel: UILabel!
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
        if let entityItem = MIProcessor.sharedMIP.mIP[i] as? EntityItem {
            if let timeStampAsDouble: Double = entityItem.timeStamp as? Double {
                let timeStampAsString = convertTimestamp(serverTimestamp: timeStampAsDouble)
                entityCardViewDateLabel.text = timeStampAsString
            }
            if entityItem.phoneNumber == "" {
                entityCardViewPhoneNumberView.isHidden = true
            } else {
                entityCardViewPhoneNumberView.isHidden = false
            }
            if entityItem.email == "" {
                entityCardViewEmailView.isHidden = true
            } else {
                entityCardViewEmailView.isHidden = false
            }
            if entityItem.street == "" {
                entityCardViewAddressView.isHidden = true
            } else {
                entityCardViewAddressView.isHidden = false
            }
            entityCardViewNameLabel.text = entityItem.name
            entityCardViewPhoneNumberLabel.text = entityItem.phoneNumber
            entityCardViewEmailLabel.text = entityItem.email
            entityCardViewStreetLabel.text = entityItem.street
            if (entityItem.city == "") || (entityItem.state == "") {
                entityCardViewCityStateLabel.text = ""
            } else {
                entityCardViewCityStateLabel.text = String(entityItem.city + ", " + entityItem.state)
            }
            entityCardViewSSNLabel.text = entityItem.ssn
            entityCardViewEINLabel.text = entityItem.ein
            if (entityItem.phoneNumber == "") && (entityItem.email == "") && (entityItem.street == "") {
                entityCardViewPhoneEmailGeoView.isHidden = true
            } else {
                entityCardViewPhoneEmailGeoView.isHidden = false
            }
        }
    }
    
    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy\nh:mma"
        return formatter.string(from: date as Date)
    }
    
}
