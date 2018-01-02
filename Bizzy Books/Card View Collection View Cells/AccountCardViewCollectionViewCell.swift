//
//  AccountCardViewCollectionViewCell.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/16/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit

class AccountCardViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var accountTrifecta: UIView!
    @IBOutlet weak var accountTypeImageView: UIImageView!
    @IBOutlet weak var accountTypeLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountDate: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountPhoneView: UIView!
    @IBOutlet weak var accountEmailView: UIView!
    @IBOutlet weak var accountGeoView: UIView!
    @IBOutlet weak var accountPhoneLabel: UILabel!
    @IBOutlet weak var accountEmailLabel: UILabel!
    @IBOutlet weak var accountStreetLabel: UILabel!
    @IBOutlet weak var accountCityStateLabel: UILabel!

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
        accountTypeImageView.image = nil
        let accountItem: AccountItem
        if MIProcessor.sharedMIP.mipORsip == 0 {
            accountItem = MIProcessor.sharedMIP.mIP[i] as! AccountItem
        } else {
            accountItem = MIProcessor.sharedMIP.sIP[i] as! AccountItem
        }
        accountNameLabel.text = accountItem.name
        switch accountItem.accountTypeId {
        case 0:
            accountTypeLabel.text = "Bank Account"
            accountTypeImageView.image = UIImage(named: "bank")
        case 1:
            accountTypeLabel.text = "Credit Account"
            accountTypeImageView.image = UIImage(named: "credit")
        case 2:
            accountTypeLabel.text = "Cash Account"
            accountTypeImageView.image = UIImage(named: "cash")
        default: //I.e. case 3
            accountTypeLabel.text = "Store Credit Account"
            accountTypeImageView.image = UIImage(named: "storecredit")
        }
        if let timeStampAsDouble: Double = accountItem.timeStamp as? Double {
            let timeStampAsString = convertTimestamp(serverTimestamp: timeStampAsDouble)
            accountDate.text = timeStampAsString
        }
        accountTrifecta.isHidden = false
        accountPhoneView.isHidden = false
        accountEmailView.isHidden = false
        accountGeoView.isHidden = false
        if (accountItem.phoneNumber == "") && (accountItem.email == "") && (accountItem.street == "") {
            accountTrifecta.isHidden = true
        }
        if accountItem.phoneNumber == "" {
            accountPhoneView.isHidden = true
        }
        if accountItem.email == "" {
            accountEmailView.isHidden = true
        }
        if (accountItem.street == "") || (accountItem.city == "") || (accountItem.state == "") {
            accountGeoView.isHidden = true
        }
        accountPhoneLabel.text = accountItem.phoneNumber
        accountEmailLabel.text = accountItem.email
        accountStreetLabel.text = accountItem.street
        accountCityStateLabel.text = accountItem.city + " " + accountItem.state
    }

    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy\nh:mma"
        return formatter.string(from: date as Date)
    }
    
}
