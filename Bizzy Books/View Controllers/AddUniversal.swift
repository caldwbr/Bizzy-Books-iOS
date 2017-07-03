//
//  AddUniversal.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/16/16.
//  Copyright © 2016 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import UIKit
import KTCenterFlowLayout
import Firebase

class AddUniversal: UIViewController {

    var masterRef: DatabaseReference!
    private let dataSource = LabelTextFieldFlowCollectionViewDataSource()
    private var selectedType = 0
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var leftTopView: DropdownFlowView!
    @IBOutlet weak var rightTopView: UIView!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var odometerTextField: UITextField!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var percentBusinessLabel: UILabel!
    @IBAction func percentBusinessSlider(_ sender: UISlider) {
        let percent = sender.value.rounded().cleanValue
        let percentAsString = String(percent) + "%"
        percentBusinessLabel.text = percentAsString
    }
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var amountBusinessLabel: UILabel!
    @IBOutlet weak var amountPersonalLabel: UILabel!
    @IBOutlet weak var percentBusinessView: UIView!
    
    @IBOutlet weak var percentBusinessViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomStackViewHeight: NSLayoutConstraint!
    //Visual Effects View
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    //Project Popup Items
    @IBOutlet var selectProjectView: UIView!
    @IBOutlet weak var projectSearchView: UIView!
    @IBOutlet weak var overheadSwitch: UISwitch!
    @IBAction func overheadSwitchTapped(_ sender: UISwitch) {
    }
    @IBOutlet weak var overheadQuestionImage: UIImageView!
    @IBOutlet weak var projectTextField: UITextField!
    @IBAction func projectAddButtonTapped(_ sender: UIButton) {
    }
    @IBAction func projectAcceptTapped(_ sender: UIButton) {
    }
    @IBAction func projectDismissTapped(_ sender: UIButton) {
        selectProjectAnimateOut()
        visualEffectView.isUserInteractionEnabled = false
    }
    
    @IBOutlet var useTaxSwitchContainer: UIView!
    @IBOutlet var useTaxSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overheadSwitch.isOn = false
        useTaxSwitch.isOn = false
        visualEffectView.isHidden = true
        selectProjectView.layer.cornerRadius = 5
        
        let typeItem = DropdownFlowItem(options: [
            DropdownFlowItem.Option(title: "Business", iconName: "business", action: { self.selectedType = 0; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Personal", iconName: "personal", action: { self.selectedType = 1; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Mixed", iconName: "mixed", action: { self.selectedType = 2; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Fuel", iconName: "fuel", action: { self.selectedType = 3; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Transfer", iconName: "transfer", action: { self.selectedType = 4; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Adjust", iconName: "adjustment", action: { self.selectedType = 5; self.reloadSentence(selectedType: self.selectedType) }),
            ])
        leftTopView.configure(item: typeItem)
        
        reloadSentence(selectedType: selectedType)
        
        //collectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        collectionView.collectionViewLayout = KTCenterFlowLayout()
        
        
        var currentItems = self.toolbarItems ?? []
        let useTaxItem = UIBarButtonItem(customView: self.useTaxSwitchContainer)
        useTaxSwitch.addTarget(self, action: #selector(useTaxSwitchToggled), for: .valueChanged)
        currentItems.insert(useTaxItem, at: 2)
        self.toolbarItems = currentItems
        
        let projectLabelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector((handleProjectLabelTap)))
        self.projectLabel.addGestureRecognizer(projectLabelGestureRecognizer)
        
        let businessAmountString = "$0.00 "
        let attachmentBusinessIcon = NSTextAttachment()
        attachmentBusinessIcon.image = UIImage(named: "business")
        let businessImageOffsetY: CGFloat = -5.0
        attachmentBusinessIcon.bounds = CGRect(x: 0, y: businessImageOffsetY, width: attachmentBusinessIcon.image!.size.width, height: attachmentBusinessIcon.image!.size.height)
        let attachmentBusinessIconString = NSAttributedString(attachment: attachmentBusinessIcon)
        let businessAmountStringWithIcon = NSMutableAttributedString(string: businessAmountString)
        businessAmountStringWithIcon.append(attachmentBusinessIconString)
        amountBusinessLabel.attributedText = businessAmountStringWithIcon
        
        let personalAmountString = "$0.00 "
        let attachmentPersonalIcon = NSTextAttachment()
        attachmentPersonalIcon.image = UIImage(named: "personal")
        let personalImageOffsetY: CGFloat = -5.0
        attachmentPersonalIcon.bounds = CGRect(x: 0, y: personalImageOffsetY, width: attachmentPersonalIcon.image!.size.width, height: attachmentPersonalIcon.image!.size.height)
        let attachmentPersonalIconString = NSAttributedString(attachment: attachmentPersonalIcon)
        let personalAmountStringWithIcon = NSMutableAttributedString(string: personalAmountString)
        personalAmountStringWithIcon.append(attachmentPersonalIconString)
        amountPersonalLabel.attributedText = personalAmountStringWithIcon
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        masterRef = Database.database().reference().child("users").child(userUID)
        //masterRef.setValue(["username": "Brad Caldwell"])
    }
    
    func useTaxSwitchToggled(useTaxSwitch: UISwitch) {
        print("Use tax switch toggled")
    }
    
    func selectProjectAnimateIn() {
        self.view.addSubview(selectProjectView)
        selectProjectView.center = self.view.center
        selectProjectView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        selectProjectView.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.isHidden = false
            self.selectProjectView.alpha = 1
            self.selectProjectView.transform = CGAffineTransform.identity
        })
    }
    
    func selectProjectAnimateOut() {
        UIView.animate(withDuration: 0.4, animations: {
            self.selectProjectView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.selectProjectView.alpha = 0
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            self.selectProjectView.removeFromSuperview()
        }
    }
    
    func handleProjectLabelTap(projectLabelGestureRecognizer: UITapGestureRecognizer){
        selectProjectAnimateIn()
        visualEffectView.isUserInteractionEnabled = true
    }
    
    func reloadCollectionView() {
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.reloadData()
        
        // Resize the collection view's height according to it's contents
        view.layoutIfNeeded()
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
        view.layoutIfNeeded()
    }
    
    func reloadSentence(selectedType: Int) {
        switch selectedType {
        case 0:
            dataSource.items = [
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { print("You tapped!!") }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { print("whom tapped!!") }),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                LabelFlowItem(text: "what tax reason ▾", color: UIColor.BizzyColor.Magenta.TaxReason, action: { print("what tax reason tapped!!") }),
                LabelFlowItem(text: "?", color: .gray, action: nil),
            ]
            projectLabel.isHidden = false
            odometerTextField.isHidden = true
            percentBusinessView.isHidden = true
            percentBusinessViewHeight.constant = 0
            bottomStackViewHeight.constant = 20
            bottomStackView.layoutIfNeeded()
            accountLabel.isHidden = false
            reloadCollectionView()
        case 1:
            dataSource.items = [
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { print("You tapped!!") }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { print("whom tapped!!") }),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                LabelFlowItem(text: "what personal reason ▾", color: UIColor.BizzyColor.Magenta.PersonalReason, action: { print("what personal reason tapped!!") }),
                LabelFlowItem(text: "?", color: .gray, action: nil),
            ]
            projectLabel.isHidden = true
            odometerTextField.isHidden = true
            percentBusinessView.isHidden = true
            percentBusinessViewHeight.constant = 0
            bottomStackViewHeight.constant = 20
            bottomStackView.layoutIfNeeded()
            accountLabel.isHidden = false
            reloadCollectionView()
        case 2:
            dataSource.items = [
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { print("You tapped!!") }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { print("whom tapped!!") }),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                LabelFlowItem(text: "what tax reason ▾", color: UIColor.BizzyColor.Magenta.TaxReason, action: { print("what tax reason tapped!!") }),
                LabelFlowItem(text: "and", color: .gray, action: nil),
                LabelFlowItem(text: "what personal reason ▾", color: UIColor.BizzyColor.Magenta.PersonalReason, action: { print("what personal reason tapped!!") }),
                LabelFlowItem(text: "?", color: .gray, action: nil),
            ]
            projectLabel.isHidden = false
            odometerTextField.isHidden = true
            percentBusinessView.isHidden = false
            percentBusinessViewHeight.constant = 120
            bottomStackViewHeight.constant = 140
            bottomStackView.layoutIfNeeded()
            accountLabel.isHidden = false
            reloadCollectionView()
        case 3:
            dataSource.items = [
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { print("You tapped!!") }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { print("whom (gas station) tapped!!") }),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "how many", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "gallons of", color: .gray, action: nil),
                LabelFlowItem(text: "87 gas ▾", color: UIColor.BizzyColor.Orange.WC, action: { print("fuel tapped!!") }),
                LabelFlowItem(text: "in your", color: .gray, action: nil),
                LabelFlowItem(text: "vehicle ▾", color: UIColor.BizzyColor.Magenta.TaxReason, action: { print("vehicle tapped!!") }),
                LabelFlowItem(text: "?", color: .gray, action: nil),
            ]
            projectLabel.isHidden = true
            odometerTextField.isHidden = false
            percentBusinessView.isHidden = true
            percentBusinessViewHeight.constant = 0
            bottomStackViewHeight.constant = 20
            bottomStackView.layoutIfNeeded()
            accountLabel.isHidden = false
            reloadCollectionView()
        case 4:
            dataSource.items = [
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: nil),
                LabelFlowItem(text: "moved", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "from", color: .gray, action: nil),
                LabelFlowItem(text: "which account ▾", color: UIColor.BizzyColor.Green.Account, action: { print("from which account tapped!!") }),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "which account ▾", color: UIColor.BizzyColor.Green.Account, action: { print("to which account tapped!!") }),
                LabelFlowItem(text: "?", color: .gray, action: nil),
            ]
            projectLabel.isHidden = true
            odometerTextField.isHidden = true
            percentBusinessView.isHidden = true
            percentBusinessViewHeight.constant = 0
            bottomStackViewHeight.constant = 20
            bottomStackView.layoutIfNeeded()
            accountLabel.isHidden = true
            reloadCollectionView()
        case 5:
            dataSource.items = [
                LabelFlowItem(text: "Your account ▾", color: UIColor.BizzyColor.Green.Account, action: { print("Your account tapped!!") }),
                LabelFlowItem(text: "with a Bizzy Books balance of", color: .gray, action: nil),
                LabelFlowItem(text: "$0.00", color: UIColor.BizzyColor.Green.Account, action: nil),
                LabelFlowItem(text: "should have a balance of", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: ".", color: .gray, action: nil),
            ]
            projectLabel.isHidden = true
            odometerTextField.isHidden = true
            percentBusinessView.isHidden = true
            percentBusinessViewHeight.constant = 0
            bottomStackViewHeight.constant = 20
            bottomStackView.layoutIfNeeded()
            accountLabel.isHidden = true
            reloadCollectionView()
        default:
            dataSource.items = [
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { print("You tapped!!") }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { print("whom tapped!!") }),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                LabelFlowItem(text: "what tax reason ▾", color: UIColor.BizzyColor.Magenta.TaxReason, action: { print("what tax reason tapped!!") }),
                LabelFlowItem(text: "?", color: .gray, action: nil),
            ]
            projectLabel.isHidden = false
            odometerTextField.isHidden = true
            percentBusinessView.isHidden = true
            percentBusinessViewHeight.constant = 0
            bottomStackViewHeight.constant = 20
            bottomStackView.layoutIfNeeded()
            accountLabel.isHidden = false
            reloadCollectionView()
        }
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {

    }

    
}
