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
import Contacts

class AddUniversal: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Contacts Stuff
    var recommendedContacts = [CNContact]()
    var selectedContact: CNContact?

    var masterRef: DatabaseReference!
    private var universalArray = [0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1] //Notes and pic url will be ON THEIR OWN!
    private let dataSource = LabelTextFieldFlowCollectionViewDataSource()
    private var selectedType = 0
    var taxReasonPickerData: [String] = [String]()
    var wcPickerData: [String] = [String]()
    var advertisingMeansPickerData: [String] = [String]()
    var personalReasonPickerData: [String] = [String]()
    var fuelTypePickerData: [String] = [String]()
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
        if overheadSwitch.isOn {
            projectSearchView.isHidden = true
            addNewProjectButton.isHidden = true
        } else {
            projectSearchView.isHidden = false
            addNewProjectButton.isHidden = false
        }
    }
    @IBOutlet weak var addNewProjectButton: UIButton!
    @IBOutlet weak var overheadQuestionImage: UIImageView!
    @IBOutlet weak var projectTextField: UITextField!
    @IBAction func projectAddButtonTapped(_ sender: UIButton) {
    }
    @IBAction func projectAcceptTapped(_ sender: UIButton) {
    }
    @IBAction func projectDismissTapped(_ sender: UIButton) {
        popUpAnimateOut(popUpView: selectProjectView)
    }
    
    //Who Popup Items
    @IBOutlet var selectWhoView: UIView!
    @IBOutlet weak var selectWhoTextField: UITextField!
    @IBAction func whoAddButtonTapped(_ sender: UIButton) {
        popUpAnimateIn(popUpView: addEntityView)
    }
    @IBAction func whoDismissTapped(_ sender: UIButton) {
        popUpAnimateOut(popUpView: selectWhoView)
    }
    @IBAction func whoAcceptTapped(_ sender: UIButton) {
    }
    
    //Whom Popup Items
    @IBOutlet var selectWhomView: UIView!
    @IBOutlet weak var selectWhomTextField: UITextField!
    @IBAction func whomAddButtonTapped(_ sender: UIButton) {
    }
    @IBAction func whomDismissTapped(_ sender: UIButton) {
        popUpAnimateOut(popUpView: selectWhomView)
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
        popUpAnimateOut(popUpView: selectVehicleView)
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
        popUpAnimateOut(popUpView: selectAccountView)
    }
    @IBAction func accountAcceptTapped(_ sender: UIButton) {
    }
    
    //Secondary Account Popup Items (always to)
    @IBOutlet var selectSecondaryAccountView: UIView!
    @IBOutlet weak var selectSecondaryAccountTextField: UITextField!
    @IBAction func secondaryAccountAddButtonTapped(_ sender: UIButton) {
    }
    @IBAction func secondaryAccountDismissTapped(_ sender: UIButton) {
        popUpAnimateOut(popUpView: selectSecondaryAccountView)
    }
    @IBAction func secondaryAccountAcceptTapped(_ sender: UIButton) {
    }
    @IBOutlet var addEntityView: UIView!
    @IBOutlet weak var contactSuggestionsTableView: UITableView!
    
    //Fuel Type Picker
    @IBOutlet var selectFuelTypePickerView: UIPickerView!
    
    //Use Tax View Items (not a popup, but part of bottom bar)
    @IBOutlet var useTaxSwitchContainer: UIView!
    @IBOutlet var useTaxSwitch: UISwitch!
    
    @IBAction func contactNameTextFieldChanged(_ sender: UITextField) {
        if let searchText = sender.text {
            if !searchText.isEmpty {
                ContactsLogicManager.shared.fetchContactsMatching(name: searchText, completion: { (contacts) in
                    if let theContacts = contacts {
                        self.recommendedContacts = theContacts
                        self.contactSuggestionsTableView.isHidden = false
                            self.contactSuggestionsTableView.reloadData()
                        
                    }
                    else {
                        // Contact fetch failed 
                        // Denied permission
                    }
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        overheadSwitch.isOn = false
        useTaxSwitch.isOn = false
        visualEffectView.isHidden = true
        
        self.taxReasonPickerView.delegate = self
        self.taxReasonPickerView.dataSource = self
        self.selectWCPickerView.delegate = self
        self.selectWCPickerView.dataSource = self
        self.selectAdvertisingMeansPickerView.delegate = self
        self.selectAdvertisingMeansPickerView.dataSource = self
        self.personalReasonPickerView.delegate = self
        self.personalReasonPickerView.dataSource = self
        self.selectFuelTypePickerView.delegate = self
        self.selectFuelTypePickerView.dataSource = self
        
        //Set up pickers' data
        taxReasonPickerData = ["Income", "Supplies", "Labor", "Meals", "Office", "Vehicle", "Advertise", "Pro Help", "Rent Machine", "Rent Property", "Tax+License", "Insurance (WC+GL)", "Travel", "Employee Benefit", "Depreciation", "Depletion", "Utilities", "Commissions", "Wages", "Mortgate Interest", "Other Interest", "Pension", "Repairs"]
        wcPickerData = ["Sub Has WC", "Incurred WC", "WC N/A"]
        advertisingMeansPickerData = ["Referral", "Website", "YP", "Social Media", "Soliciting", "Google AdWords", "Company Shirts", "Sign", "Vehicle Wrap", "Billboard", "TV", "Radio", "Other"]
        personalReasonPickerData = ["Food", "Fun", "Pet", "Utilities", "Phone", "Office", "Giving", "Insurance", "House", "Yard", "Medical", "Travel", "Other"]
        fuelTypePickerData = ["87 Gas", "89 Gas", "91 Gas", "Diesel"]
        
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

        let amountText = "$0.00 "
        let iconBusiness = "business"
        let iconPersonal = "personal"
        setTextAndIconOnLabel(text: amountText, icon: iconBusiness, label: amountBusinessLabel)
        setTextAndIconOnLabel(text: amountText, icon: iconPersonal, label: amountPersonalLabel)
        
    }
    
    func setTextAndIconOnLabel(text: String, icon: String, label: UILabel) {
        let initialString = text
        let attachmentIcon = NSTextAttachment()
        attachmentIcon.image = UIImage(named: icon)
        let imageOffsetY: CGFloat = -5.0
        attachmentIcon.bounds = CGRect(x: 0, y: imageOffsetY, width: attachmentIcon.image!.size.width, height: attachmentIcon.image!.size.height)
        let attachmentIconString = NSAttributedString(attachment: attachmentIcon)
        let combinedString = NSMutableAttributedString(string: initialString)
        combinedString.append(attachmentIconString)
        label.attributedText = combinedString
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        masterRef = Database.database().reference().child("users").child(userUID)
        //masterRef.setValue(["username": "Brad Caldwell"])
        masterRef.childByAutoId().setValue([3, 4, -88, 45, true])
    }
    
    func useTaxSwitchToggled(useTaxSwitch: UISwitch) {
        print("Use tax switch toggled")
    }
    
    func handleProjectLabelTap(projectLabelGestureRecognizer: UITapGestureRecognizer){
        popUpAnimateIn(popUpView: selectProjectView)
    }
    
    func handleAccountLabelTap(accountLabelGestureRecognizer: UITapGestureRecognizer) {
        popUpAnimateIn(popUpView: selectAccountView)
    }
    
    func popUpAnimateIn(popUpView: UIView) {
        self.view.addSubview(popUpView)
        popUpView.center = self.view.center
        popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0
        
        UIView.animate(withDuration: 0.4) { 
            self.visualEffectView.isHidden = false
            popUpView.alpha = 1
            popUpView.transform = CGAffineTransform.identity
        }
    }
    
    func popUpAnimateOut(popUpView: UIView) {
        UIView.animate(withDuration: 0.4, animations: { 
            popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            popUpView.alpha = 0
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            popUpView.removeFromSuperview()
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
        case 0: businessCase()
        case 1: personalCase()
        case 2: mixedCase()
        case 3: fuelCase()
        case 4: transferCase()
        case 5: adjustCase()
        default: businessCase()
        }
    }
    
    func businessCase() {
        universalArray[0] = 0
        dataSource.items = [
            LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { self.popUpAnimateIn(popUpView: self.selectWhoView) }),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { self.popUpAnimateIn(popUpView: self.selectWhomView) }),
            LabelFlowItem(text: "for", color: .gray, action: nil),
            LabelFlowItem(text: "what tax reason ▾", color: UIColor.BizzyColor.Magenta.TaxReason, action: { self.popUpAnimateIn(popUpView: self.taxReasonPickerView) }),
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
        useTaxSwitchContainer.isHidden = false
    }
    
    func personalCase() {
        universalArray[0] = 1
        dataSource.items = [
            LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { self.popUpAnimateIn(popUpView: self.selectWhoView) }),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { self.popUpAnimateIn(popUpView: self.selectWhomView) }),
            LabelFlowItem(text: "for", color: .gray, action: nil),
            LabelFlowItem(text: "what personal reason ▾", color: UIColor.BizzyColor.Magenta.PersonalReason, action: { self.popUpAnimateIn(popUpView: self.personalReasonPickerView) }),
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
        useTaxSwitchContainer.isHidden = false
    }
    
    func mixedCase() {
        universalArray[0] = 2
        dataSource.items = [
            LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { self.popUpAnimateIn(popUpView: self.selectWhoView) }),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { self.popUpAnimateIn(popUpView: self.selectWhomView) }),
            LabelFlowItem(text: "for", color: .gray, action: nil),
            LabelFlowItem(text: "what tax reason ▾", color: UIColor.BizzyColor.Magenta.TaxReason, action: { self.popUpAnimateIn(popUpView: self.taxReasonPickerView) }),
            LabelFlowItem(text: "and", color: .gray, action: nil),
            LabelFlowItem(text: "what personal reason ▾", color: UIColor.BizzyColor.Magenta.PersonalReason, action: { self.popUpAnimateIn(popUpView: self.personalReasonPickerView) }),
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
        useTaxSwitchContainer.isHidden = false
    }
    
    func fuelCase() {
        universalArray[0] = 3
        dataSource.items = [
            LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { self.popUpAnimateIn(popUpView: self.selectWhoView) }),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { self.popUpAnimateIn(popUpView: self.selectWhomView) /* You need to specify only gas stations here!!!!!!!!!!!!! */ }),
            LabelFlowItem(text: "for", color: .gray, action: nil),
            TextFieldFlowItem(text: "", placeholder: "how many", color: UIColor.BizzyColor.Green.What),
            LabelFlowItem(text: "gallons of", color: .gray, action: nil),
            LabelFlowItem(text: "87 gas ▾", color: UIColor.BizzyColor.Orange.WC, action: { self.popUpAnimateIn(popUpView: self.selectFuelTypePickerView) }),
            LabelFlowItem(text: "in your", color: .gray, action: nil),
            LabelFlowItem(text: "vehicle ▾", color: UIColor.BizzyColor.Magenta.TaxReason, action: { self.popUpAnimateIn(popUpView: self.selectVehicleView) }),
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
        useTaxSwitchContainer.isHidden = true
    }
    
    func transferCase() {
        universalArray[0] = 4
        dataSource.items = [
            LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: nil),
            LabelFlowItem(text: "moved", color: .gray, action: nil),
            TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
            LabelFlowItem(text: "from", color: .gray, action: nil),
            LabelFlowItem(text: "which account ▾", color: UIColor.BizzyColor.Green.Account, action: { self.popUpAnimateIn(popUpView: self.selectAccountView) }),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            LabelFlowItem(text: "which account ▾", color: UIColor.BizzyColor.Green.Account, action: { self.popUpAnimateIn(popUpView: self.selectSecondaryAccountView) }),
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
        useTaxSwitchContainer.isHidden = true
    }
    
    func adjustCase() {
        universalArray[0] = 5
        dataSource.items = [
            LabelFlowItem(text: "Your account ▾", color: UIColor.BizzyColor.Green.Account, action: { self.popUpAnimateIn(popUpView: self.selectAccountView) }),
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
        useTaxSwitchContainer.isHidden = true
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case taxReasonPickerView:
            return taxReasonPickerData.count
        case selectWCPickerView:
            return wcPickerData.count
        case selectAdvertisingMeansPickerView:
            return advertisingMeansPickerData.count
        case personalReasonPickerView:
            return personalReasonPickerData.count
        case selectFuelTypePickerView:
            return fuelTypePickerData.count
        default:
            return taxReasonPickerData.count
        }
        return taxReasonPickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case taxReasonPickerView:
            return taxReasonPickerData[row]
        case selectWCPickerView:
            return wcPickerData[row]
        case selectAdvertisingMeansPickerView:
            return advertisingMeansPickerData[row]
        case personalReasonPickerView:
            return personalReasonPickerData[row]
        case selectFuelTypePickerView:
            return fuelTypePickerData[row]
        default:
            return taxReasonPickerData[row]
        }
        return taxReasonPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case taxReasonPickerView:
            universalArray[6] = row
            popUpAnimateOut(popUpView: taxReasonPickerView)
        case selectWCPickerView:
            universalArray[8] = row
            popUpAnimateOut(popUpView: selectWCPickerView)
        case selectAdvertisingMeansPickerView:
            universalArray[9] = row
            popUpAnimateOut(popUpView: selectAdvertisingMeansPickerView)
        case personalReasonPickerView:
            universalArray[10] = row
            popUpAnimateOut(popUpView: personalReasonPickerView)
        case selectFuelTypePickerView:
            universalArray[15] = row
            print(universalArray)
            popUpAnimateOut(popUpView: selectFuelTypePickerView)
        default:
            universalArray[6] = row
            popUpAnimateOut(popUpView: taxReasonPickerView)
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {

    }
    
}



extension AddUniversal: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendedContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = recommendedContacts[indexPath.row]
        let name = contact.givenName + " " + contact.familyName
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = recommendedContacts[indexPath.row]
        self.selectedContact = contact
        self.contactSuggestionsTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}


