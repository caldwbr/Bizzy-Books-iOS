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
    
    //Who Popup Items
    @IBOutlet var selectWhoView: UIView!
    @IBOutlet weak var selectWhoTextField: UITextField!
    @IBAction func whoAddButtonTapped(_ sender: UIButton) {
    }
    @IBAction func whoDismissTapped(_ sender: UIButton) {
        selectWhoAnimateOut()
        visualEffectView.isUserInteractionEnabled = false
    }
    @IBAction func whoAcceptTapped(_ sender: UIButton) {
    }
    
    //Whom Popup Items
    @IBOutlet var selectWhomView: UIView!
    @IBOutlet weak var selectWhomTextField: UITextField!
    @IBAction func whomAddButtonTapped(_ sender: UIButton) {
    }
    @IBAction func whomDismissTapped(_ sender: UIButton) {
        selectWhomAnimateOut()
        visualEffectView.isUserInteractionEnabled = false
    }
    @IBAction func whomAcceptTapped(_ sender: UIButton) {
    }
    
    //Tax Reason Picker
    @IBOutlet var taxReasonPickerView: UIPickerView!
    
    //Vehicle Popup Items
    @IBOutlet var selectVehicleView: UIView!
    @IBOutlet weak var selectVehicleTextField: UITextField!
    @IBAction func vehicleAddButtonTapped(_ sender: UIButton) {
    }
    @IBAction func vehicleDismissTapped(_ sender: UIButton) {
        selectVehicleAnimateOut()
        visualEffectView.isUserInteractionEnabled = false
    }
    @IBAction func vehicleAcceptTapped(_ sender: UIButton) {
    }
    
    //Worker's Comp Picker
    @IBOutlet var selectWCPickerView: UIPickerView!
    
    //Advertising Means Picker
    @IBOutlet var selectAdvertisingMeansPickerView: UIPickerView!
    
    //Personal Reason Picker
    @IBOutlet var personalReasonPickerView: UIPickerView!
    
    //Main Account Popup Items (usually from, but can be to)
    @IBOutlet var selectAccountView: UIView!
    @IBOutlet weak var selectAccountTextField: UITextField!
    @IBAction func accountAddButtonTapped(_ sender: UIButton) {
    }
    @IBAction func accountDismissTapped(_ sender: UIButton) {
        selectAccountAnimateOut()
        visualEffectView.isUserInteractionEnabled = false
    }
    @IBAction func accountAcceptTapped(_ sender: UIButton) {
    }
    
    //Secondary Account Popup Items (always to)
    @IBOutlet var selectSecondaryAccountView: UIView!
    @IBOutlet weak var selectSecondaryAccountTextField: UITextField!
    @IBAction func secondaryAccountAddButtonTapped(_ sender: UIButton) {
    }
    @IBAction func secondaryAccountDismissTapped(_ sender: UIButton) {
        selectSecondaryAccountAnimateOut()
        visualEffectView.isUserInteractionEnabled = false
    }
    @IBAction func secondaryAccountAcceptTapped(_ sender: UIButton) {
    }
    
    //Fuel Type Picker
    @IBOutlet var selectFuelTypePickerView: UIPickerView!
    
    //Use Tax View Items (not a popup, but part of bottom bar)
    @IBOutlet var useTaxSwitchContainer: UIView!
    @IBOutlet var useTaxSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overheadSwitch.isOn = false
        useTaxSwitch.isOn = false
        visualEffectView.isHidden = true
        
        //Clip corners of all popups for better aesthetics
        selectProjectView.layer.cornerRadius = 5
        selectWhoView.layer.cornerRadius = 5
        selectWhomView.layer.cornerRadius = 5
        selectVehicleView.layer.cornerRadius = 5
        selectAccountView.layer.cornerRadius = 5
        selectSecondaryAccountView.layer.cornerRadius = 5
        
        
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
        
        //Placing the use tax view inside the bottom bar
        var currentItems = self.toolbarItems ?? []
        let useTaxItem = UIBarButtonItem(customView: self.useTaxSwitchContainer)
        useTaxSwitch.addTarget(self, action: #selector(useTaxSwitchToggled), for: .valueChanged)
        currentItems.insert(useTaxItem, at: 2)
        self.toolbarItems = currentItems
        
        //Making a tap listener on Project label
        let projectLabelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector((handleProjectLabelTap)))
        self.projectLabel.addGestureRecognizer(projectLabelGestureRecognizer)
        
        //Making a tap listener on Account label
        let accountLabelGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector((handleAccountLabelTap)))
        self.accountLabel.addGestureRecognizer(accountLabelGestureRecognizer)
        
        //Combine icon with String for under slider for Mixed type
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
    
    func handleProjectLabelTap(projectLabelGestureRecognizer: UITapGestureRecognizer){
        selectProjectAnimateIn()
        visualEffectView.isUserInteractionEnabled = true
    }
    
    func whoLabelTapped() {
        selectWhoAnimateIn()
        visualEffectView.isUserInteractionEnabled = true
    }
    
    func whomLabelTapped() {
        selectWhomAnimateIn()
        visualEffectView.isUserInteractionEnabled = true
    }
    
    func vehicleLabelTapped() {
        selectVehicleAnimateIn()
        visualEffectView.isUserInteractionEnabled = true
    }
    
    func handleAccountLabelTap(accountLabelGestureRecognizer: UITapGestureRecognizer) {
        selectAccountAnimateIn()
        visualEffectView.isUserInteractionEnabled = true
    }
    
    func accountLabelTapped() {
        selectAccountAnimateIn()
        visualEffectView.isUserInteractionEnabled = true
    }
    
    func secondaryAccountLabelTapped() {
        selectSecondaryAccountAnimateIn()
        visualEffectView.isUserInteractionEnabled = true
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
    
    func selectWhoAnimateIn() {
        self.view.addSubview(selectWhoView)
        selectWhoView.center = self.view.center
        selectWhoView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        selectWhoView.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.isHidden = false
            self.selectWhoView.alpha = 1
            self.selectWhoView.transform = CGAffineTransform.identity
        })
    }
    
    func selectWhoAnimateOut() {
        UIView.animate(withDuration: 0.4, animations: {
            self.selectWhoView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.selectWhoView.alpha = 0
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            self.selectWhoView.removeFromSuperview()
        }
    }

    func selectWhomAnimateIn() {
        self.view.addSubview(selectWhomView)
        selectWhomView.center = self.view.center
        selectWhomView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        selectWhomView.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.isHidden = false
            self.selectWhomView.alpha = 1
            self.selectWhomView.transform = CGAffineTransform.identity
        })
    }
    
    func selectWhomAnimateOut() {
        UIView.animate(withDuration: 0.4, animations: {
            self.selectWhomView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.selectWhomView.alpha = 0
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            self.selectWhomView.removeFromSuperview()
        }
    }
    
    func selectVehicleAnimateIn() {
        self.view.addSubview(selectVehicleView)
        selectVehicleView.center = self.view.center
        selectVehicleView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        selectVehicleView.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.isHidden = false
            self.selectVehicleView.alpha = 1
            self.selectVehicleView.transform = CGAffineTransform.identity
        })
    }
    
    func selectVehicleAnimateOut() {
        UIView.animate(withDuration: 0.4, animations: {
            self.selectVehicleView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.selectVehicleView.alpha = 0
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            self.selectVehicleView.removeFromSuperview()
        }
    }
    
    func selectAccountAnimateIn() {
        self.view.addSubview(selectAccountView)
        selectAccountView.center = self.view.center
        selectAccountView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        selectAccountView.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.isHidden = false
            self.selectAccountView.alpha = 1
            self.selectAccountView.transform = CGAffineTransform.identity
        })
    }
    
    func selectAccountAnimateOut() {
        UIView.animate(withDuration: 0.4, animations: {
            self.selectAccountView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.selectAccountView.alpha = 0
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            self.selectAccountView.removeFromSuperview()
        }
    }
    
    func selectSecondaryAccountAnimateIn() {
        self.view.addSubview(selectSecondaryAccountView)
        selectSecondaryAccountView.center = self.view.center
        selectSecondaryAccountView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        selectSecondaryAccountView.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.isHidden = false
            self.selectSecondaryAccountView.alpha = 1
            self.selectSecondaryAccountView.transform = CGAffineTransform.identity
        })
    }
    
    func selectSecondaryAccountAnimateOut() {
        UIView.animate(withDuration: 0.4, animations: {
            self.selectSecondaryAccountView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.selectSecondaryAccountView.alpha = 0
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            self.selectSecondaryAccountView.removeFromSuperview()
        }
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
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { self.whoLabelTapped() }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { self.whomLabelTapped() }),
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
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { self.whoLabelTapped() }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { self.whomLabelTapped() }),
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
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { self.whoLabelTapped() }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { self.whomLabelTapped() }),
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
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { self.whoLabelTapped() }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { self.whomLabelTapped() /* You need to specify only gas stations here!!!!!!!!!!!!! */ }),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "how many", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "gallons of", color: .gray, action: nil),
                LabelFlowItem(text: "87 gas ▾", color: UIColor.BizzyColor.Orange.WC, action: { print("fuel tapped!!") }),
                LabelFlowItem(text: "in your", color: .gray, action: nil),
                LabelFlowItem(text: "vehicle ▾", color: UIColor.BizzyColor.Magenta.TaxReason, action: { self.vehicleLabelTapped() }),
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
                LabelFlowItem(text: "which account ▾", color: UIColor.BizzyColor.Green.Account, action: { self.accountLabelTapped() }),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "which account ▾", color: UIColor.BizzyColor.Green.Account, action: { self.secondaryAccountLabelTapped() }),
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
                LabelFlowItem(text: "Your account ▾", color: UIColor.BizzyColor.Green.Account, action: { self.accountLabelTapped() }),
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
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { self.whoLabelTapped() }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { self.whomLabelTapped() }),
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
