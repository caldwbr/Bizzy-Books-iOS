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
    @IBOutlet weak var universalCardViewImageView: UIImageView!
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
        if let universalItem = MIProcessor.sharedMIP.mIP[i] as? UniversalItem {
            switch universalItem.universalItemType {
            case 1:
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
                universalCardViewAccountLabel.text = universalItem.accountOneName
                universalCardViewBalAfterLabel.text = universalItem.balOneAfterString
                updateAccountImage(universalItem: universalItem)
            case 2:
                imageView.image = UIImage(named: "mixed")
                universalCardViewItemTypeLabel.text = "Mixed"
                universalCardViewProjectNameLabel.text = universalItem.projectItemName
                if let timeStampAsDouble: Double = universalItem.timeStamp as? Double {
                    let timeStampAsString = convertTimestamp(serverTimestamp: timeStampAsDouble)
                    universalCardViewDateLabel.text = timeStampAsString
                }
                universalCardViewNotesLabel.text = universalItem.notes
                DispatchQueue.main.async {
                    //Get project status
                    let projectsRef = Database.database().reference().child("users").child(userUID).child("projects")
                    if universalItem.projectItemKey == "0" {
                        self.universalCardViewStatusLabel.text = ""
                        self.universalCardViewCollectionView.reloadData()
                    } else {
                        projectsRef.observe(.value) { (snapshot) in
                            for item in snapshot.children {
                                let firebaseProject = ProjectItem(snapshot: item as! DataSnapshot)
                                if firebaseProject.key == universalItem.projectItemKey {
                                    self.universalCardViewStatusLabel.text = firebaseProject.projectStatusName
                                    self.universalCardViewCollectionView.reloadData()
                                }
                            }
                        }
                    }
                }
                //universalCardViewStatusLabel.text = universalItem.projectStatusString
                let percBusiness = Int(Double(universalItem.what) * Double(universalItem.percentBusiness)/100)
                let percPersonal = Int(Double(universalItem.what) * Double(100 - universalItem.percentBusiness)/100)
                let stringifyAnInt = StringifyAnInt()
                let percBusinessString = stringifyAnInt.stringify(theInt: percBusiness)
                let percPersonalString = stringifyAnInt.stringify(theInt: percPersonal)
                dataSource.items = [
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
                universalCardViewAccountLabel.text = universalItem.accountOneName
                universalCardViewBalAfterLabel.text = universalItem.balOneAfterString
                updateAccountImage(universalItem: universalItem)
            case 3:
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
                    LabelFlowItem(text: "miles, you put", color: .gray, action: nil),
                    LabelFlowItem(text: stringifyAnInt.stringify(theInt: universalItem.howMany, theNumberStyle: .decimal, theGroupingSeparator: true), color: UIColor.BizzyColor.Green.What, action: nil),
                    LabelFlowItem(text: "gallons of", color: .gray, action: nil),
                    LabelFlowItem(text: universalItem.fuelTypeName, color: UIColor.BizzyColor.Orange.WC, action: nil),
                    LabelFlowItem(text: "fuel in your", color: .gray, action: nil),
                    LabelFlowItem(text: universalItem.vehicleName, color: UIColor.BizzyColor.Magenta.TaxReason, action: nil),
                    LabelFlowItem(text: "for", color: .gray, action: nil),
                    LabelFlowItem(text: stringifyAnInt.stringify(theInt: universalItem.what), color: UIColor.BizzyColor.Blue.Project, action: nil),
                    LabelFlowItem(text: ("(" + stringifyAnInt.stringify(theInt: ppG) + "/gal)"), color: UIColor.BizzyColor.Green.Account, action: nil)
                ]
                universalCardViewAccountLabel.text = universalItem.accountOneName
                universalCardViewBalAfterLabel.text = universalItem.balOneAfterString
                updateAccountImage(universalItem: universalItem)
            default: // I.e., case 0, the most frequent!
                imageView.image = UIImage(named: "business")
                universalCardViewItemTypeLabel.text = "Business"
                if let timeStampAsDouble: Double = universalItem.timeStamp as? Double {
                    let timeStampAsString = convertTimestamp(serverTimestamp: timeStampAsDouble)
                    universalCardViewDateLabel.text = timeStampAsString
                }
                universalCardViewProjectNameLabel.text = universalItem.projectItemName
                universalCardViewNotesLabel.text = universalItem.notes
                DispatchQueue.main.async {
                    //Get project status
                    let projectsRef = Database.database().reference().child("users").child(userUID).child("projects")
                    if universalItem.projectItemKey == "0" {
                        self.universalCardViewStatusLabel.text = ""
                        self.universalCardViewCollectionView.reloadData()
                    } else {
                        projectsRef.observe(.value) { (snapshot) in
                            for item in snapshot.children {
                                let firebaseProject = ProjectItem(snapshot: item as! DataSnapshot)
                                if firebaseProject.key == universalItem.projectItemKey {
                                    self.universalCardViewStatusLabel.text = firebaseProject.projectStatusName
                                    self.universalCardViewCollectionView.reloadData()
                                }
                            }
                        }
                    }
                }
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
                universalCardViewAccountLabel.text = universalItem.accountOneName
                universalCardViewBalAfterLabel.text = universalItem.balOneAfterString
                updateAccountImage(universalItem: universalItem)
            }
        }
    }
    
    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy\nh:mma"
        //formatter.dateStyle = .medium
        //formatter.timeStyle = .short
        
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
    
    /*
    func businessCase() {
        dataSource.items = [
            LabelFlowItem(text: universalItem.whoName, color: UIColor.BizzyColor.Blue.Who, action: nil),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            LabelFlowItem(text: universalItem.what, color: UIColor.BizzyColor.Green.What, action: nil),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            LabelFlowItem(text: universalItem.whomName, color: UIColor.BizzyColor.Purple.Whom, action: nil),
            LabelFlowItem(text: "for", color: .gray, action: nil),
            LabelFlowItem(text: universalItem.taxReasonId, color: UIColor.BizzyColor.Magenta.TaxReason, action: nil)
        ]
        switch universalArray[6] {
        case 2:
            dataSource.items.append(LabelFlowItem(text: workersCompPlaceholder, color: UIColor.BizzyColor.Orange.WC, action: { self.popUpAnimateIn(popUpView: self.genericPickerView); self.pickerCode = 1 }))
        case 5:
            dataSource.items.append(LabelFlowItem(text: vehiclePlaceholder, color: UIColor.BizzyColor.Orange.Vehicle, action: { self.popUpAnimateIn(popUpView: self.selectVehicleView) }))
        case 6:
            dataSource.items.append(LabelFlowItem(text: advertisingMeansPlaceholder, color: UIColor.BizzyColor.Orange.AdMeans, action: { self.pickerCode = 2; self.popUpAnimateIn(popUpView: self.genericPickerView) }))
        default:
            break
        }
        projectLabel.isHidden = false
        odometerTextField.isHidden = true
        percentBusinessView.isHidden = true
        bottomStackView.layoutIfNeeded()
        accountLabel.isHidden = false
        reloadCollectionView()
        useTaxSwitchContainer.isHidden = false
    }
    
    func personalCase() {
        universalArray[0] = 1
        dataSource.items = [
            LabelFlowItem(text: whoPlaceholder, color: UIColor.BizzyColor.Blue.Who, action: { self.popUpAnimateIn(popUpView: self.selectWhoView) }),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            TextFieldFlowItem(text: "", amt: 0, placeholder: "what amount", color: UIColor.BizzyColor.Green.What, keyboardType: UIKeyboardType.numberPad, allowedCharsString: digits, formatterStyle: NumberFormatter.Style.currency, numberKind: 0),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            LabelFlowItem(text: whomPlaceholder, color: UIColor.BizzyColor.Purple.Whom, action: { self.popUpAnimateIn(popUpView: self.selectWhomView) }),
            LabelFlowItem(text: "for", color: .gray, action: nil),
            LabelFlowItem(text: whatPersonalReasonPlaceholder, color: UIColor.BizzyColor.Magenta.PersonalReason, action: { self.pickerCode = 3; self.popUpAnimateIn(popUpView: self.genericPickerView) })
        ]
        projectLabel.isHidden = true
        odometerTextField.isHidden = true
        percentBusinessView.isHidden = true
        bottomStackView.layoutIfNeeded()
        accountLabel.isHidden = false
        reloadCollectionView()
        useTaxSwitchContainer.isHidden = false
    }
    
    func mixedCase() {
        universalArray[0] = 2
        dataSource.items = [
            LabelFlowItem(text: whoPlaceholder, color: UIColor.BizzyColor.Blue.Who, action: { self.popUpAnimateIn(popUpView: self.selectWhoView) }),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            TextFieldFlowItem(text: "", amt: 0, placeholder: "what amount", color: UIColor.BizzyColor.Green.What, keyboardType: UIKeyboardType.numberPad, allowedCharsString: digits, formatterStyle: NumberFormatter.Style.currency, numberKind: 0),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            LabelFlowItem(text: whomPlaceholder, color: UIColor.BizzyColor.Purple.Whom, action: { self.popUpAnimateIn(popUpView: self.selectWhomView) }),
            LabelFlowItem(text: "for", color: .gray, action: nil),
            LabelFlowItem(text: whatPersonalReasonPlaceholder, color: UIColor.BizzyColor.Magenta.PersonalReason, action: { self.pickerCode = 3;  self.popUpAnimateIn(popUpView: self.genericPickerView) }),
            LabelFlowItem(text: "and", color: .gray, action: nil),
            LabelFlowItem(text: whatTaxReasonPlaceholder, color: UIColor.BizzyColor.Magenta.TaxReason, action: { self.pickerCode = 0; self.popUpAnimateIn(popUpView: self.genericPickerView) })
        ]
        switch universalArray[6] {
        case 2:
            dataSource.items.append(LabelFlowItem(text: workersCompPlaceholder, color: UIColor.BizzyColor.Orange.WC, action: { self.popUpAnimateIn(popUpView: self.genericPickerView); self.pickerCode = 1 }))
        case 5:
            dataSource.items.append(LabelFlowItem(text: taxVehiclePlaceholder, color: UIColor.BizzyColor.Orange.Vehicle, action: { self.popUpAnimateIn(popUpView: self.selectVehicleView) }))
        case 6:
            dataSource.items.append(LabelFlowItem(text: advertisingMeansPlaceholder, color: UIColor.BizzyColor.Orange.AdMeans, action: { self.pickerCode = 2; self.popUpAnimateIn(popUpView: self.genericPickerView) }))
        default:
            break
        }
        projectLabel.isHidden = false
        odometerTextField.isHidden = true
        percentBusinessView.isHidden = false
        bottomStackView.layoutIfNeeded()
        accountLabel.isHidden = false
        reloadCollectionView()
        useTaxSwitchContainer.isHidden = false
        let theTextFieldYes = dataSource.theTextFieldYes
        theTextFieldYes.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.allEditingEvents)
    }
    
    func fuelCase() {
        universalArray[0] = 3
        dataSource.items = [
            LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: nil),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            TextFieldFlowItem(text: "", amt: 0, placeholder: "what amount", color: UIColor.BizzyColor.Green.What, keyboardType: UIKeyboardType.numberPad, allowedCharsString: digits, formatterStyle: NumberFormatter.Style.currency, numberKind: 0),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            LabelFlowItem(text: whomPlaceholder, color: UIColor.BizzyColor.Purple.Whom, action: { self.popUpAnimateIn(popUpView: self.selectWhomView) }),
            LabelFlowItem(text: "for", color: .gray, action: nil),
            TextFieldFlowItem(text: "", amt: 0, placeholder: "how many", color: UIColor.BizzyColor.Green.What, keyboardType: UIKeyboardType.numberPad, allowedCharsString: digits, formatterStyle: NumberFormatter.Style.decimal, numberKind: 1),
            LabelFlowItem(text: "gallons of", color: .gray, action: nil),
            LabelFlowItem(text: fuelTypePlaceholder, color: UIColor.BizzyColor.Orange.WC, action: { self.pickerCode = 4; self.popUpAnimateIn(popUpView: self.genericPickerView) }),
            LabelFlowItem(text: "in your", color: .gray, action: nil),
            LabelFlowItem(text: vehiclePlaceholder, color: UIColor.BizzyColor.Magenta.TaxReason, action: { self.popUpAnimateIn(popUpView: self.selectVehicleView) })
        ]
        projectLabel.isHidden = true
        odometerTextField.isHidden = false
        percentBusinessView.isHidden = true
        bottomStackView.layoutIfNeeded()
        accountLabel.isHidden = false
        reloadCollectionView()
        useTaxSwitchContainer.isHidden = true
    }
    
    func transferCase() {
        universalArray[0] = 4
        dataSource.items = [
            LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: nil),
            LabelFlowItem(text: "moved", color: .gray, action: nil),
            TextFieldFlowItem(text: "", amt: 0, placeholder: "what amount", color: UIColor.BizzyColor.Green.What, keyboardType: UIKeyboardType.numberPad, allowedCharsString: digits, formatterStyle: NumberFormatter.Style.currency, numberKind: 0),
            LabelFlowItem(text: "from", color: .gray, action: nil),
            LabelFlowItem(text: yourPrimaryAccountPlaceholder, color: UIColor.BizzyColor.Green.Account, action: { self.primaryAccountTapped = true; self.popUpAnimateIn(popUpView: self.selectAccountView) }),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            LabelFlowItem(text: yourSecondaryAccountPlaceholder, color: UIColor.BizzyColor.Green.Account, action: { self.popUpAnimateIn(popUpView: self.selectSecondaryAccountView) })
        ]
        projectLabel.isHidden = true
        odometerTextField.isHidden = true
        percentBusinessView.isHidden = true
        bottomStackView.layoutIfNeeded()
        accountLabel.isHidden = true
        reloadCollectionView()
        useTaxSwitchContainer.isHidden = true
    }
    
    func adjustCase() {
        universalArray[0] = 5
        dataSource.items = [
            LabelFlowItem(text: yourAccountPlaceholder, color: UIColor.BizzyColor.Green.Account, action: { self.popUpAnimateIn(popUpView: self.selectAccountView) }),
            LabelFlowItem(text: "with a Bizzy Books balance of", color: .gray, action: nil),
            LabelFlowItem(text: bizzyBooksBalanceString, color: UIColor.BizzyColor.Green.Account, action: nil),
            LabelFlowItem(text: "should have a balance of", color: .gray, action: nil),
            TextFieldFlowItem(text: "", amt: 0, placeholder: "what amount", color: UIColor.BizzyColor.Green.What, keyboardType: UIKeyboardType.numbersAndPunctuation, allowedCharsString: negPossibleDigits, formatterStyle: NumberFormatter.Style.currency, numberKind: 0)
        ]
        projectLabel.isHidden = true
        odometerTextField.isHidden = true
        percentBusinessView.isHidden = true
        bottomStackView.layoutIfNeeded()
        accountLabel.isHidden = true
        reloadCollectionView()
        useTaxSwitchContainer.isHidden = true
    }
    
    func projectMediaCase() {
        universalArray[0] = 6
        dataSource.items = [
            LabelFlowItem(text: projectMediaTypePlaceholder, color: UIColor.BizzyColor.Blue.Project, action: { self.pickerCode = 7; self.popUpAnimateIn(popUpView: self.genericPickerView) })
        ]
        projectLabel.isHidden = false
        odometerTextField.isHidden = true
        percentBusinessView.isHidden = true
        bottomStackView.layoutIfNeeded()
        accountLabel.isHidden = true
        reloadCollectionView()
        useTaxSwitchContainer.isHidden = true
    }
 
 */
    
    func reloadCardCollectionView() {
        universalCardViewCollectionView.delegate = dataSource
        universalCardViewCollectionView.dataSource = dataSource
        universalCardViewCollectionView.reloadData()
    }

}
