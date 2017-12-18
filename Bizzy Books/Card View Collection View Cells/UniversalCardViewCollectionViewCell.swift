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
    @IBOutlet weak var universalCardViewBalanceAfterLabel: UILabel!
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
    
    func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String){}
    
    func configure(_ multiversalItemViewModel: MultiversalItem) {
        if let universalItem = multiversalItemViewModel as? UniversalItem {
            switch universalItem.universalItemType {
            case 0:
                imageView.image = UIImage(named: "business")
                universalCardViewItemTypeLabel.text = "Business"
                if let timeStampAsDouble: Double = universalItem.timeStamp as? Double {
                    let timeStampAsString = convertTimestamp(serverTimestamp: timeStampAsDouble)
                    universalCardViewDateLabel.text = timeStampAsString
                }
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
                universalCardViewProjectNameLabel.text = universalItem.projectItemName
                universalCardViewNotesLabel.text = universalItem.notes
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
                DispatchQueue.main.async {
                    //Get balance after
                    let obtainBalanceAfter = ObtainBalanceAfter()
                    let timeStampDouble: Double
                    if let timeStampAsDouble: Double = universalItem.timeStamp as? Double {
                        timeStampDouble = timeStampAsDouble
                        let balAfter = obtainBalanceAfter.balAfter(accountKey: universalItem.accountOneKey, particularUniversalTimeStamp: timeStampDouble)
                    }
                }
                
                universalCardViewCollectionView.reloadData()
            case 1:
                imageView.image = UIImage(named: "personal")
                universalCardViewItemTypeLabel.text = "Personal"
                universalCardViewProjectNameLabel.text = ""
                universalCardViewNotesLabel.text = universalItem.notes
            case 2:
                imageView.image = UIImage(named: "mixed")
                universalCardViewItemTypeLabel.text = "Mixed"
                universalCardViewProjectNameLabel.text = universalItem.projectItemName
                universalCardViewNotesLabel.text = universalItem.notes
            case 3:
                imageView.image = UIImage(named: "fuel")
                universalCardViewItemTypeLabel.text = "Fuel"
                universalCardViewProjectNameLabel.text = ""
                universalCardViewNotesLabel.text = universalItem.notes
            case 4:
                imageView.image = UIImage(named: "transfer")
                universalCardViewItemTypeLabel.text = "Transfer"
                universalCardViewProjectNameLabel.text = ""
                universalCardViewNotesLabel.text = universalItem.notes
            case 5:
                imageView.image = UIImage(named: "adjustment")
                universalCardViewItemTypeLabel.text = "Adjust"
                universalCardViewProjectNameLabel.text = ""
                universalCardViewNotesLabel.text = universalItem.notes
            case 6:
                imageView.image = UIImage(named: "hammer")
                universalCardViewItemTypeLabel.text = "Project Media"
                universalCardViewProjectNameLabel.text = universalItem.projectItemName
                universalCardViewNotesLabel.text = universalItem.notes
            default:
                universalCardViewItemTypeLabel.text = "Business"
                universalCardViewProjectNameLabel.text = universalItem.projectItemName
                universalCardViewNotesLabel.text = universalItem.notes
                dataSource.items = [
                    LabelFlowItem(text: universalItem.whoName, color: UIColor.BizzyColor.Blue.Who, action: nil),
                    LabelFlowItem(text: "paid", color: .gray, action: nil),
                    LabelFlowItem(text: stringifyAnInt.stringify(theInt: universalItem.what), color: UIColor.BizzyColor.Green.What, action: nil),
                    LabelFlowItem(text: "to", color: .gray, action: nil),
                    LabelFlowItem(text: universalItem.whomName, color: UIColor.BizzyColor.Purple.Whom, action: nil),
                    LabelFlowItem(text: "for", color: .gray, action: nil),
                    LabelFlowItem(text: universalItem.taxReasonName, color: UIColor.BizzyColor.Magenta.TaxReason, action: nil)
                ]
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
