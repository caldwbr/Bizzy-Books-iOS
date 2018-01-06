//
//  UniversalCardViewCollectionViewCell.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/16/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import KTCenterFlowLayout
import Firebase

class UniversalCardViewCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = universalCardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "CardViewSentenceCell", for: indexPath) as! CardViewSentenceCell
        if let theFlowItem = dataSource.items[indexPath.row] as? LabelFlowItem {
            cell.configure(labelFlowItem: theFlowItem)
        }
        return cell
    }

    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var universalCardViewItemTypeLabel: UILabel!
    @IBOutlet weak var universalCardViewStatusLabel: UILabel!
    @IBOutlet weak var universalCardViewDateLabel: UILabel!
    @IBOutlet weak var universalCardViewProjectNameLabel: UILabel!
    @IBOutlet weak var universalCardViewNotesLabel: UILabel!
    @IBOutlet weak var universalCardViewCollectionView: UICollectionView!
    @IBOutlet weak var universalCardViewAccountLabel: UILabel!
    @IBOutlet weak var universalCardViewBalAfterLabel: UILabel!
    @IBOutlet weak var universalCardViewAccountImageView: UIImageView!
    @IBOutlet weak var universalCardViewImageView: CustomImageView!
    private let dataSource = CardViewLabelFlowCollectionViewDataSource()
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
        universalCardViewCollectionView.collectionViewLayout = KTCenterFlowLayout()
        universalCardViewCollectionView.register(UINib.init(nibName: "CardViewSentenceCell", bundle: nil), forCellWithReuseIdentifier: "CardViewSentenceCell")
        if let universalCardViewFlowLayout = universalCardViewCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            universalCardViewFlowLayout.estimatedItemSize = CGSize(width: 80, height: 30)
        }
        universalCardViewCollectionView.dataSource = self
    }
    
    func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {}
    
    func configure(i: Int) {
        universalCardViewImageViewHeightConstraint.constant = 1
        imageView.image = nil
        universalCardViewAccountImageView.image = nil
        universalCardViewImageView.image = nil //HERE IT IS we were nilling the wrong imageview! (the tiny one) now we are nilling the big image view that was getting recycled and screwing everything up!!
        let universalItem: UniversalItem
        if MIProcessor.sharedMIP.mipORsip == 0 {
            universalItem = MIProcessor.sharedMIP.mIP[i] as! UniversalItem
        } else {
            universalItem = MIProcessor.sharedMIP.sIP[i] as! UniversalItem
        }
        universalCardViewImageViewHeightConstraint.constant = (CGFloat(universalItem.picAspectRatio) / 1000) * widthConstraint.constant
        if universalItem.picUrl != "" {
            universalCardViewImageView.loadImageUsingUrlString(universalItem.picUrl)
        }
        switch universalItem.universalItemType {
        case 1:
            universalCardViewStatusLabel.isHidden = true
            imageView.image = UIImage(named: "personal")
            universalCardViewItemTypeLabel.text = "Personal"
            universalCardViewProjectNameLabel.text = ""
            universalCardViewStatusLabel.text = ""
            if let timeStampAsDouble: Double = universalItem.timeStamp as? Double {
                let timeStampAsString = convertTimestamp(serverTimestamp: timeStampAsDouble)
                universalCardViewDateLabel.text = timeStampAsString
            }
            universalCardViewNotesLabel.text = universalItem.notes
            dataSource.items = [
                LabelFlowItem(text: universalItem.whoName, color: UIColor.BizzyColor.Blue.Who, action: nil),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                LabelFlowItem(text: stringifyAnInt.stringify(theInt: universalItem.what), color: UIColor.BizzyColor.Green.What, action: nil),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: universalItem.whomName, color: UIColor.BizzyColor.Purple.Whom, action: nil),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                LabelFlowItem(text: universalItem.personalReasonName, color: UIColor.BizzyColor.Magenta.TaxReason, action: nil)
            ]
            universalCardViewCollectionView.reloadData()
            universalCardViewCollectionView.layoutIfNeeded()
            universalCardViewAccountLabel.text = universalItem.accountOneName
            universalCardViewBalAfterLabel.text = universalItem.balOneAfterString
            updateAccountImage(universalItem: universalItem)
        case 2:
            universalCardViewStatusLabel.isHidden = false
            imageView.image = UIImage(named: "mixed")
            universalCardViewItemTypeLabel.text = "Mixed"
            universalCardViewProjectNameLabel.text = universalItem.projectItemName
            if let timeStampAsDouble: Double = universalItem.timeStamp as? Double {
                let timeStampAsString = convertTimestamp(serverTimestamp: timeStampAsDouble)
                universalCardViewDateLabel.text = timeStampAsString
            }
            universalCardViewNotesLabel.text = universalItem.notes
            universalCardViewStatusLabel.text = MIProcessor.sharedMIP.mIPUniversals[i].projectStatusString
            let percBusiness = Int(Double(universalItem.what) * Double(universalItem.percentBusiness)/100)
            let percPersonal = Int(Double(universalItem.what) * Double(100 - universalItem.percentBusiness)/100)
            let stringifyAnInt = StringifyAnInt()
            let percBusinessString = stringifyAnInt.stringify(theInt: percBusiness)
            let percPersonalString = stringifyAnInt.stringify(theInt: percPersonal)
            dataSource.items = [
                LabelFlowItem(text: "At", color: .gray, action: nil),
                LabelFlowItem(text: (stringifyAnInt.stringify(theInt: universalItem.percentBusiness, theNumberStyle: .none , theGroupingSeparator: false) + "%"), color: UIColor.BizzyColor.Yellow.ProjectStatus, action: nil),
                LabelFlowItem(text: "business,", color: .gray, action: nil),
                LabelFlowItem(text: universalItem.whoName, color: UIColor.BizzyColor.Blue.Who, action: nil),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                LabelFlowItem(text: stringifyAnInt.stringify(theInt: universalItem.what), color: UIColor.BizzyColor.Green.What, action: nil),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: universalItem.whomName, color: UIColor.BizzyColor.Purple.Whom, action: nil),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                LabelFlowItem(text: (universalItem.personalReasonName + " (" + percPersonalString + ")"), color: UIColor.BizzyColor.Magenta.TaxReason, action: nil),
                LabelFlowItem(text: "and", color: .gray, action: nil),
                LabelFlowItem(text: (universalItem.taxReasonName + " (" + percBusinessString + ")"), color: UIColor.BizzyColor.Magenta.TaxReason, action: nil)
            ]
            switch universalItem.taxReasonId {
            case 2:
                dataSource.items.append(LabelFlowItem(text: universalItem.workersCompName, color: UIColor.BizzyColor.Orange.WC, action: nil ))
            case 5:
                dataSource.items.append(LabelFlowItem(text: universalItem.vehicleName, color: UIColor.BizzyColor.Orange.Vehicle, action: nil ))
            case 6:
                dataSource.items.append(LabelFlowItem(text: universalItem.advertisingMeansName, color: UIColor.BizzyColor.Orange.AdMeans, action: nil ))
            default:
                break
            }
            universalCardViewCollectionView.reloadData()
            universalCardViewCollectionView.layoutIfNeeded()
            universalCardViewAccountLabel.text = universalItem.accountOneName
            universalCardViewBalAfterLabel.text = universalItem.balOneAfterString
            updateAccountImage(universalItem: universalItem)
        case 3:
            universalCardViewStatusLabel.isHidden = true
            imageView.image = UIImage(named: "fuel")
            universalCardViewItemTypeLabel.text = "Fuel"
            if let timeStampAsDouble: Double = universalItem.timeStamp as? Double {
                let timeStampAsString = convertTimestamp(serverTimestamp: timeStampAsDouble)
                universalCardViewDateLabel.text = timeStampAsString
            }
            universalCardViewProjectNameLabel.text = ""
            universalCardViewNotesLabel.text = universalItem.notes
            var ppG = Int((Double(universalItem.what)/Double(universalItem.howMany)) * 1000)
            dataSource.items = [
                LabelFlowItem(text: "At", color: .gray, action: nil),
                LabelFlowItem(text: String(universalItem.odometerReading), color: UIColor.BizzyColor.Blue.Who, action: nil),
                LabelFlowItem(text: "miles, you paid", color: .gray, action: nil),
                LabelFlowItem(text: stringifyAnInt.stringify(theInt: universalItem.what), color: UIColor.BizzyColor.Blue.Project, action: nil),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: universalItem.whomName, color: UIColor.BizzyColor.Purple.Whom, action: nil),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                LabelFlowItem(text: stringifyAnInt.stringify(theInt: universalItem.howMany, theNumberStyle: .decimal, theGroupingSeparator: true), color: UIColor.BizzyColor.Green.What, action: nil),
                LabelFlowItem(text: "gallons of", color: .gray, action: nil),
                LabelFlowItem(text: universalItem.fuelTypeName, color: UIColor.BizzyColor.Orange.WC, action: nil),
                LabelFlowItem(text: "in your", color: .gray, action: nil),
                LabelFlowItem(text: universalItem.vehicleName, color: UIColor.BizzyColor.Magenta.TaxReason, action: nil),
                LabelFlowItem(text: ("(" + stringifyAnInt.stringify(theInt: ppG) + "/gal)"), color: UIColor.BizzyColor.Green.Account, action: nil)
            ]
            universalCardViewCollectionView.reloadData()
            universalCardViewCollectionView.layoutIfNeeded()
            universalCardViewAccountLabel.text = universalItem.accountOneName
            universalCardViewBalAfterLabel.text = universalItem.balOneAfterString
            updateAccountImage(universalItem: universalItem)
        default: // I.e., case 0, the most frequent!
            universalCardViewStatusLabel.isHidden = false
            imageView.image = UIImage(named: "business")
            universalCardViewItemTypeLabel.text = "Business"
            if let timeStampAsDouble: Double = universalItem.timeStamp as? Double {
                let timeStampAsString = convertTimestamp(serverTimestamp: timeStampAsDouble)
                universalCardViewDateLabel.text = timeStampAsString
            }
            universalCardViewProjectNameLabel.text = universalItem.projectItemName
            universalCardViewNotesLabel.text = universalItem.notes
            universalCardViewStatusLabel.text = universalItem.projectStatusString
            dataSource.items = [
                LabelFlowItem(text: universalItem.whoName, color: UIColor.BizzyColor.Blue.Who, action: nil),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                LabelFlowItem(text: stringifyAnInt.stringify(theInt: universalItem.what), color: UIColor.BizzyColor.Green.What, action: nil),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: universalItem.whomName, color: UIColor.BizzyColor.Purple.Whom, action: nil),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                LabelFlowItem(text: universalItem.taxReasonName, color: UIColor.BizzyColor.Magenta.TaxReason, action: nil)
            ]
            switch universalItem.taxReasonId {
            case 2:
                dataSource.items.append(LabelFlowItem(text: universalItem.workersCompName, color: UIColor.BizzyColor.Orange.WC, action: nil ))
            case 5:
                dataSource.items.append(LabelFlowItem(text: universalItem.vehicleName, color: UIColor.BizzyColor.Orange.Vehicle, action: nil ))
            case 6:
                dataSource.items.append(LabelFlowItem(text: universalItem.advertisingMeansName, color: UIColor.BizzyColor.Orange.AdMeans, action: nil ))
            default:
                break
            }
            universalCardViewCollectionView.reloadData()
            universalCardViewCollectionView.layoutIfNeeded()
            universalCardViewAccountLabel.text = universalItem.accountOneName
            universalCardViewBalAfterLabel.text = universalItem.balOneAfterString
            updateAccountImage(universalItem: universalItem)
        }
    }
    
    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy\nh:mma"
        return formatter.string(from: date as Date)
    }
    
    func updateAccountImage(universalItem: UniversalItem) {
        switch universalItem.accountOneType {
        case 0:
            universalCardViewAccountImageView.image = UIImage(named: "bank")
        case 1:
            universalCardViewAccountImageView.image = UIImage(named: "credit")
        case 2:
            universalCardViewAccountImageView.image = UIImage(named: "cash")
        case 3:
            universalCardViewAccountImageView.image = UIImage(named: "storecredit")
        default:
            universalCardViewAccountImageView.image = UIImage(named: "bank")
        }
    }
    
    func reloadCardCollectionView() {
        universalCardViewCollectionView.delegate = dataSource
        universalCardViewCollectionView.dataSource = dataSource
        universalCardViewCollectionView.reloadData()
    }
    
    //Try to clear out the idiot fields before reuse!
    override func prepareForReuse() {
        super.prepareForReuse()
        //hide or reset anything you want hereafter, for example
        clearFields()
    }
    
    func clearFields() {
        universalCardViewStatusLabel.text = ""
        imageView.image = nil
        universalCardViewItemTypeLabel.text = ""
        universalCardViewProjectNameLabel.text = ""
        universalCardViewDateLabel.text = ""
        universalCardViewNotesLabel.text = ""
        dataSource.items.removeAll()
        universalCardViewAccountImageView.image = nil
        universalCardViewImageView.image = nil
        universalCardViewAccountLabel.text = ""
        universalCardViewBalAfterLabel.text = ""
    }
    
    @IBOutlet weak var universalCardViewImageViewHeightConstraint: NSLayoutConstraint!

}
