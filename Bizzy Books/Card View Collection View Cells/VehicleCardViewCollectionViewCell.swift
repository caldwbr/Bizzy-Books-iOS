//
//  VehicleCardViewCollectionViewCell.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/16/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit

class VehicleCardViewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vehicleFuelTypeLabel: UILabel!
    @IBOutlet weak var vehicleDateLabel: UILabel!
    @IBOutlet weak var vehicleNameLabel: UILabel!
    @IBOutlet weak var trifectaView: UIView!
    @IBOutlet weak var licensePlateView: UIView!
    @IBOutlet weak var licensePlateLabel: UILabel!
    @IBOutlet weak var vinView: UIView!
    @IBOutlet weak var vinLabel: UILabel!
    @IBOutlet weak var picView: UIView!
    @IBOutlet weak var picLabel: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    let stringifyAnInt: StringifyAnInt = StringifyAnInt()
    
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
        if let vehicleItem = multiversalItemViewModel as? VehicleItem {
            trifectaView.isHidden = false
            licensePlateView.isHidden = false
            vinView.isHidden = false
            picView.isHidden = false
            vehicleNameLabel.text = vehicleItem.color + " " + vehicleItem.year + " " + vehicleItem.make + " " + vehicleItem.model
            if let timeStampAsDouble: Double = vehicleItem.timeStamp as? Double {
                let timeStampAsString = convertTimestamp(serverTimestamp: timeStampAsDouble)
                vehicleDateLabel.text = timeStampAsString
            }
            vehicleFuelTypeLabel.text = vehicleItem.fuelString
            if (vehicleItem.licensePlateNumber == "") && (vehicleItem.vehicleIdentificationNumber == "") && (vehicleItem.placedInCommissionDate == "") {
                trifectaView.isHidden = true
            }
            if vehicleItem.licensePlateNumber == "" {
                licensePlateView.isHidden = true
            }
            if vehicleItem.vehicleIdentificationNumber == "" {
                vinView.isHidden = true
            }
            if vehicleItem.placedInCommissionDate == "" {
                picView.isHidden = true
            }
            licensePlateLabel.text = vehicleItem.licensePlateNumber
            vinLabel.text = vehicleItem.vehicleIdentificationNumber
            picLabel.text = vehicleItem.placedInCommissionDate
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
