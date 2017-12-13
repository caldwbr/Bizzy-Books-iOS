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
import StoreKit
import Freddy
import CoreLocation
import Photos

class AddUniversal: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    
    // Contacts Stuff
    var recommendedContacts = [CNContact]()
    var selectedContact: CNContact?
    let locationManager = CLLocationManager()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var digits = "0123456789"
    var negPossibleDigits = "0123456789-"
    let theFormatter = NumberFormatter()
    var bradsStore = IAPProcessor.shared

    var youRef: DatabaseReference!
    var universalsRef: DatabaseReference!
    var entitiesRef: DatabaseReference!
    var projectsRef: DatabaseReference!
    var vehiclesRef: DatabaseReference!
    var accountsRef: DatabaseReference!
    var currentlySubscribedRef: DatabaseReference!
    var specialAccessRef: DatabaseReference!
    var userCurrentImageIdCountRef: DatabaseReference!
    
    var isUserCurrentlySubscribed: Bool = false
    var hasUserSpecialAccess: Bool = false
    
    var thereIsAnImage = false
    var userCurrentImageIdCount: Int = 0
    var userCurrentImageIdCountString: String = ""
    var userCurrentImageIdCountStringPlusType: String = ""
    var downloadURL: URL?
    
    var firebaseUniversals: [UniversalItem] = []
    var firebaseEntities: [EntityItem] = []
    var firebaseProjects: [ProjectItem] = []
    var firebaseVehicles: [VehicleItem] = []
    var firebaseAccounts: [AccountItem] = []
    var filteredFirebaseEntities = [EntityItem]()
    var filteredFirebaseProjects: [ProjectItem] = []
    var filteredFirebaseVehicles: [VehicleItem] = []
    var filteredFirebaseAccounts: [AccountItem] = []
    
    var tempKeyHolder: String = ""
    
    private var universalArray = [0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1] //Notes and pic url will be ON THEIR OWN! Not really.
    private var chosenEntity = 0 //Customer by default
    private var chosenHowDidTheyHearOfYou = 0 //Unknown by default
    private let dataSource = LabelTextFieldFlowCollectionViewDataSource() //The collection view (ie., "sentence")
    var selectedType = 0
    var pickerCode = 0 {
        didSet {
            genericPickerView?.reloadAllComponents() //This is the line that loads data to those pesky difficult-to-understand pickers that just stay there without any popup
            genericPickerView?.selectRow(0, inComponent: 0, animated: false)
        }
    }
    var accountSenderCode = 0 // 0 for selectedType = 0, 1, 2, 3, sometimes 4, and 5; 1 for selectedType = 4 SECONDARY ACCOUNT or just 0 for primary account; selectedType = 6 is irrelevant as no account is associated with ProjectMedia
    
    var whoPlaceholder = "You"
    var whoPlaceholderKeyString = ""
    var whomPlaceholder = "whom ▾"
    var whomPlaceholderKeyString = ""
    var whatTaxReasonPlaceholder = "what tax reason ▾"
    var whatTaxReasonPlaceholderId = -1
    var whatPersonalReasonPlaceholder = "what personal reason ▾"
    var whatPersonalReasonPlaceholderId = -1
    var projectPlaceholder = "Project ▾"
    var projectPlaceholderKeyString = ""
    var fuelTypePlaceholder = "fuel ▾"
    var fuelTypePlaceholderId = -1
    var vehiclePlaceholder = "vehicle ▾" //Fuel-up relevant vehicle
    var vehiclePlaceholderKeyString = ""
    var yourAccountPlaceholder = "Your account ▾"
    var yourAccountPlaceholderKeyString = ""
    var accountTypePlaceholder = "Bank account"
    var accountTypePlaceholderId = 0
    var bizzyBooksBalanceAsString = ""
    var bizzyBooksBalanceAsInt = 0
    var bizzyBooksBalanceAsDouble = 0.0
    var bizzyBooksBalanceString = "$0.00"
    var yourPrimaryAccountPlaceholder = "account ▾"
    var yourPrimaryAccountPlaceholderKeyString = ""
    var yourSecondaryAccountPlaceholder = "secondary account ▾"
    var yourSecondaryAccountPlaceholderKeyString = ""
    var workersCompPlaceholder = "Worker's comp ▾ ?"
    var workersCompPlaceholderId = -1
    var advertisingMeansPlaceholder = "(advertising means ▾ )"
    var advertisingMeansPlaceholderId = -1
    var howDidTheyHearOfYouPlaceholder = "How did they hear of you ▾ ?"
    var howDidTheyHearOfYouPlaceholderId = -1
    var taxVehiclePlaceholder = "Which vehicle ▾ ?" //Tax reason relevant vehicle
    var taxVehiclePlaceholderKeyString = ""
    var projectMediaTypePlaceholder = "Type of picture ▾ ?"
    var projectMediaTypePlaceholderId = -1
    var atmFee = false
    var feeAmount = 0
    
    // 0 = Who, 1 = Whom, 2 = Project Customer
    var entitySenderCode = 0 {
        didSet {
            //isNegativeSwitch.isOn = false
        }
    }
    var primaryAccountTapped = false // Starts off false, can be changed to true (for filtering in transfer section)
    var addUniversalKeyString = ""
    var addEntityKeyString = ""
    var addProjectKeyString = ""
    var addVehicleKeyString = ""
    var addAccountKeyString = ""
    
    var thePercent = 50
    var theAmt = 0
    var howMany = 0
    var entityPickerData: [String] = [String]()
    var taxReasonPickerData: [String] = [String]()
    var wcPickerData: [String] = [String]()
    var advertisingMeansPickerData: [String] = [String]()
    var personalReasonPickerData: [String] = [String]()
    var fuelTypePickerData: [String] = [String]()
    var howDidTheyHearOfYouPickerData: [String] = [String]()
    var projectMediaTypePickerData: [String] = [String]()
    var addAccountAccountTypePickerData: [String] = [String]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var leftTopView: DropdownFlowView!
    @IBOutlet weak var rightTopView: UIView!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var odometerTextField: AllowedCharsTextField!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var percentBusinessLabel: UILabel!
    @IBAction func percentBusinessSlider(_ sender: UISlider) {
        let percent = sender.value.rounded().cleanValue
        thePercent = Int(percent)!
        print(thePercent)
        let percentAsString = String(percent) + "%"
        percentBusinessLabel.text = percentAsString
        updateSliderValues(percent: thePercent)
    }
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var amountBusinessLabel: UILabel!
    @IBOutlet weak var amountPersonalLabel: UILabel!
    @IBOutlet weak var percentBusinessView: UIView!
    
    //Visual Effects View
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    //Project Popup Items
    @IBOutlet var overheadMoreInfoView: UIView!
    @IBOutlet weak var overheadQuestionImageView: UIImageView!
    @IBAction func overheadMoreInfoOkPressed(_ sender: UIButton) {
        overheadMoreInfoView.removeFromSuperview()
    }
    @IBOutlet var selectProjectView: UIView!
    @IBOutlet weak var selectProjectTableView: UITableView!
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

    @IBOutlet weak var projectTextField: UITextField!
    @IBAction func projectAddButtonTapped(_ sender: UIButton) {
        selectProjectClearing()
        pickerCode = 6
        popUpAnimateIn(popUpView: addProjectView)
    }
    @IBAction func projectAcceptTapped(_ sender: UIButton) {
        if !tempKeyHolder.isEmpty && !projectTextField.text!.isEmpty{
            projectPlaceholderKeyString = tempKeyHolder
            projectPlaceholder = projectTextField.text!
            selectProjectClearing()
            self.projectLabel.text = self.projectPlaceholder
            popUpAnimateOut(popUpView: selectProjectView)
            tempKeyHolder = ""
        }
    }
    @IBAction func projectDismissTapped(_ sender: UIButton) {
        selectProjectClearing()
        popUpAnimateOut(popUpView: selectProjectView)
    }
    
    func selectProjectClearing() {
        projectTextField.text = ""
        filteredFirebaseProjects.removeAll()
        tempKeyHolder = ""
        if selectProjectTableView != nil {
            selectProjectTableView.reloadData()
            selectProjectTableView.isHidden = true
        }
    }
    
    @IBOutlet weak var howDidTheyHearOfYouPickerView: UIPickerView!
    @IBOutlet weak var addProjectSelectCustomerTableView: UITableView!
    @IBOutlet var addProjectView: UIView!
    @IBOutlet weak var addProjectNameTextField: UITextField!
    @IBOutlet weak var addProjectSearchCustomerTextField: UITextField!
    @IBAction func addProjectAddCustomerPressed(_ sender: UIButton) {
        pickerCode = 5
        entitySenderCode = 2
        popUpAnimateIn(popUpView: addEntityView)
    }
    @IBOutlet weak var addProjectTagsTextField: UITextField!
    @IBOutlet weak var addProjectNotesTextField: UITextField!
    @IBOutlet weak var addProjectStreetTextField: UITextField!
    @IBOutlet weak var addProjectCityTextField: UITextField!
    @IBOutlet weak var addProjectStateTextField: UITextField!
    @IBAction func addProjectCancelPressed(_ sender: UIButton) {
        self.addProjectView.removeFromSuperview()
    }
    @IBAction func addProjectSavePressed(_ sender: UIButton) {
        if !tempKeyHolder.isEmpty  && !addProjectNameTextField.text!.isEmpty && !addProjectSearchCustomerTextField.text!.isEmpty {
            let addProjectKeyReference = projectsRef.childByAutoId()
            addProjectKeyString = addProjectKeyReference.key
            let thisProjectItem = ProjectItem(name: addProjectNameTextField.text!, customerName: addProjectSearchCustomerTextField.text!, customerKey: tempKeyHolder, howDidTheyHearOfYou: chosenHowDidTheyHearOfYou, projectTags: addProjectTagsTextField.text!, projectAddressStreet: addProjectStreetTextField.text!, projectAddressCity: addProjectCityTextField.text!, projectAddressState: addProjectStateTextField.text!, projectNotes: addProjectNotesTextField.text!)
            projectsRef.child(addProjectKeyString).setValue(thisProjectItem.toAnyObject())
            popUpAnimateOut(popUpView: addProjectView)
            self.projectPlaceholderKeyString = addProjectKeyString
            self.projectPlaceholder = thisProjectItem.name
            self.projectLabel.text = self.projectPlaceholder
            self.selectProjectView.removeFromSuperview()
        }
    }
    
    @IBOutlet var addVehicleView: UIView!
    @IBOutlet weak var addVehicleColorTextField: UITextField!
    @IBOutlet weak var addVehicleYearTextField: UITextField!
    @IBOutlet weak var addVehicleMakeTextField: UITextField!
    @IBOutlet weak var addVehicleModelTextField: UITextField!
    @IBOutlet weak var addVehicleFuelPickerView: UIPickerView!
    @IBOutlet weak var addVehicleLicensePlateNumberTextField: UITextField!
    @IBOutlet weak var addVehicleVehicleIdentificationNumberTextField: UITextField!
    @IBOutlet weak var addVehiclePlacedInCommissionTextField: UITextField!
    @IBAction func addVehicleCancelPressed(_ sender: UIButton) {
        self.addVehicleView.removeFromSuperview()
    }
    @IBAction func addVehicleSavePressed(_ sender: UIButton) {
        if !addVehicleColorTextField.text!.isEmpty && !addVehicleYearTextField.text!.isEmpty && !addVehicleMakeTextField.text!.isEmpty && !addVehicleModelTextField.text!.isEmpty {
            let addVehicleKeyReference = vehiclesRef.childByAutoId()
            addVehicleKeyString = addVehicleKeyReference.key
            let thisVehicleItem = VehicleItem(year: addVehicleYearTextField.text!, make: addVehicleMakeTextField.text!, model: addVehicleModelTextField.text!, color: addVehicleColorTextField.text!, fuel: addVehicleFuelPickerView.selectedRow(inComponent: 0), placedInCommissionDate: addVehiclePlacedInCommissionTextField.text!, licensePlateNumber: addVehicleLicensePlateNumberTextField.text!, vehicleIdentificationNumber: addVehicleVehicleIdentificationNumberTextField.text!)
            vehiclesRef.child(addVehicleKeyString).setValue(thisVehicleItem.toAnyObject())
            popUpAnimateOut(popUpView: addVehicleView)
            vehiclePlaceholderKeyString = addVehicleKeyString
            vehiclePlaceholder = thisVehicleItem.color + " " + thisVehicleItem.year + " " + thisVehicleItem.make + " " + thisVehicleItem.model
            self.reloadSentence(selectedType: self.selectedType)
            self.selectVehicleView.removeFromSuperview()
        }
    }
    
    
    //Entity Picker View (embedded on "Add Entity" secondary popup)
    @IBOutlet weak var entityPickerView: UIPickerView!
    
    //Generic Picker View
    @IBOutlet var genericPickerView: UIPickerView!

    //Who Popup Items
    @IBOutlet var selectWhoView: UIView!
    @IBOutlet weak var selectWhoTableView: UITableView!
    @IBOutlet weak var selectWhoTextField: UITextField!
    @IBAction func whoAddButtonTapped(_ sender: UIButton) {
        selectWhoClearing()
        pickerCode = 5
        entitySenderCode = 0
        popUpAnimateIn(popUpView: addEntityView)
    }
    @IBAction func whoDismissTapped(_ sender: UIButton) {
        selectWhoClearing()
        popUpAnimateOut(popUpView: selectWhoView)
    }
    @IBAction func whoAcceptTapped(_ sender: UIButton) {
        if !tempKeyHolder.isEmpty && !selectWhoTextField.text!.isEmpty{
            whoPlaceholderKeyString = tempKeyHolder
            whoPlaceholder = selectWhoTextField.text!
            selectWhoClearing()
            popUpAnimateOut(popUpView: selectWhoView)
            tempKeyHolder = ""
            reloadSentence(selectedType: selectedType)
        }
    }
    
    func selectWhoClearing() {
        selectWhoTextField.text = ""
        filteredFirebaseEntities.removeAll()
        tempKeyHolder = ""
        if selectWhoTableView != nil {
            selectWhoTableView.reloadData()
            selectWhoTableView.isHidden = true
        }
    }
    
    //Whom Popup Items
    @IBOutlet var selectWhomView: UIView!
    @IBOutlet weak var selectWhomTableView: UITableView!
    @IBOutlet weak var selectWhomTextField: UITextField!
    @IBAction func whomAddButtonTapped(_ sender: UIButton) {
        selectWhomClearing()
        pickerCode = 5
        entitySenderCode = 1
        popUpAnimateIn(popUpView: addEntityView)
    }
    @IBAction func whomDismissTapped(_ sender: UIButton) {
        selectWhomClearing()
        popUpAnimateOut(popUpView: selectWhomView)
    }
    @IBAction func whomAcceptTapped(_ sender: UIButton) {
        if !tempKeyHolder.isEmpty && !selectWhomTextField.text!.isEmpty{
            whomPlaceholderKeyString = tempKeyHolder
            whomPlaceholder = selectWhomTextField.text!
            selectWhomClearing()
            popUpAnimateOut(popUpView: selectWhomView)
            tempKeyHolder = ""
            reloadSentence(selectedType: selectedType)
        }
    }
    
    func selectWhomClearing() {
        selectWhomTextField.text = ""
        filteredFirebaseEntities.removeAll()
        tempKeyHolder = ""
        if selectWhomTableView != nil {
            selectWhomTableView.reloadData()
            selectWhomTableView.isHidden = true
        }
    }
    
    //Vehicle Popup Items
    @IBOutlet var selectVehicleView: UIView!
    @IBOutlet weak var selectVehicleTableView: UITableView!
    @IBOutlet weak var selectVehicleTextField: UITextField!
    @IBAction func vehicleAddButtonTapped(_ sender: UIButton) {
        selectVehicleClearing()
        pickerCode = 8
        popUpAnimateIn(popUpView: addVehicleView)
    }
    @IBAction func vehicleDismissTapped(_ sender: UIButton) {
        selectVehicleClearing()
        popUpAnimateOut(popUpView: selectVehicleView)
    }
    @IBAction func vehicleAcceptTapped(_ sender: UIButton) {
        if !tempKeyHolder.isEmpty && !selectVehicleTextField.text!.isEmpty {
            vehiclePlaceholderKeyString = tempKeyHolder
            vehiclePlaceholder = selectVehicleTextField.text!
            selectVehicleClearing()
            popUpAnimateOut(popUpView: selectVehicleView)
            tempKeyHolder = ""
            reloadSentence(selectedType: selectedType)
        }
    }
    
    func selectVehicleClearing() {
        selectVehicleTextField.text = ""
        filteredFirebaseVehicles.removeAll()
        tempKeyHolder = ""
        if selectVehicleTableView != nil {
            selectVehicleTableView.reloadData()
            selectVehicleTableView.isHidden = true
        }
    }
    
    @IBOutlet weak var addAccountAccountTypePickerView: UIPickerView!
    @IBOutlet var addAccountView: UIView!
    @IBOutlet weak var addAccountNameTextField: UITextField!
    @IBOutlet weak var addAccountStartingBalanceTextField: AllowedCharsTextField!
    @IBOutlet weak var addAccountPhoneNumberTextField: UITextField!
    @IBOutlet weak var addAccountEmailTextField: UITextField!
    @IBOutlet weak var addAccountStreetTextField: UITextField!
    @IBOutlet weak var addAccountCityTextField: UITextField!
    @IBOutlet weak var addAccountStateTextField: UITextField!
    @IBAction func addAccountCancelPressed(_ sender: UIButton) {
        accountSenderCode = 0 //Not currently going into the one 1 case, so this changes it back here.
        addAccountView.removeFromSuperview()
    }
    @IBAction func addAccountSavePressed(_ sender: UIButton) {
        if !((addAccountNameTextField.text?.isEmpty)!), !((addAccountStartingBalanceTextField.text?.isEmpty)!) {
            let addAccountKeyReference = accountsRef.childByAutoId()
            addAccountKeyString = addAccountKeyReference.key
            let thisAccountItem = AccountItem(name: addAccountNameTextField.text!, accountTypeId: accountTypePlaceholderId, phoneNumber: addAccountPhoneNumberTextField.text!, email: addAccountEmailTextField.text!, street: addAccountStreetTextField.text!, city: addAccountCityTextField.text!, state: addAccountStateTextField.text!, startingBal: Int(addAccountStartingBalanceTextField.text!)!, creditDetailsAvailable: false, isLoan: false, loanType: 0, loanTypeSubcategory: 0, loanPercentOne: 0.0, loanPercentTwo: 0.0, loanPercentThree: 0.0, loanPercentFour: 0.0, loanIntFactorOne: 0, loanIntFactorTwo: 0, loanIntFactorThree: 0, loanIntFactorFour: 0, maxLimit: 0, maxCashAdvanceAllowance: 0, closeDay: 0, dueDay: 0, cycle: 0, minimumPaymentRequired: 0, lateFeeAsOneTimeInt: 0, lateFeeAsPercentageOfTotalBalance: 0.0, cycleDues: 0, duesCycle: 0, minimumPaymentToBeSmart: 0, interestRate: 0.0, interestKind: 0, key: addAccountKeyString)
            accountsRef.child(addAccountKeyString).setValue(thisAccountItem.toAnyObject())
            popUpAnimateOut(popUpView: addAccountView)
            if accountSenderCode == 0 {
                yourAccountPlaceholderKeyString = addAccountKeyString
                yourAccountPlaceholder = thisAccountItem.name
            } else if accountSenderCode == 1 {
                yourSecondaryAccountPlaceholderKeyString = addAccountKeyString
                yourSecondaryAccountPlaceholder = thisAccountItem.name
            }
            addAccountNameTextField.text = ""
            addAccountStartingBalanceTextField.text = ""
            addAccountStartingBalanceTextField.amt = 0
            addAccountStartingBalanceTextField.isNegative = false
            addAccountPhoneNumberTextField.text = ""
            addAccountEmailTextField.text = ""
            addAccountStreetTextField.text = ""
            addAccountCityTextField.text = ""
            addAccountStateTextField.text = ""
            switch self.selectedType {
            case 0, 1, 2, 3:
                self.accountLabel.text = thisAccountItem.name
                self.selectAccountView.removeFromSuperview()
            case 4:
                self.reloadSentence(selectedType: self.selectedType)
                if accountSenderCode == 1 {
                    selectSecondaryAccountView.removeFromSuperview()
                    accountSenderCode = 0
                } else {
                    selectAccountView.removeFromSuperview()
                }
            case 5:
                self.reloadSentence(selectedType: self.selectedType)
                self.selectAccountView.removeFromSuperview()
            default:
                self.accountLabel.text = thisAccountItem.name
                self.selectAccountView.removeFromSuperview()
            }
            if primaryAccountTapped == true {
                primaryAccountTapped = false
            }
        }
    }
    
    
    //Main Account Popup Items (usually from, but can be to)
    @IBOutlet var selectAccountView: UIView!
    @IBOutlet weak var selectAccountTableView: UITableView!
    @IBOutlet weak var selectAccountTextField: UITextField!
    @IBAction func accountAddButtonTapped(_ sender: UIButton) {
        selectAccountClearing()
        pickerCode = 9
        popUpAnimateIn(popUpView: addAccountView)
    }
    @IBAction func accountDismissTapped(_ sender: UIButton) {
        if primaryAccountTapped == true {
            primaryAccountTapped = false
        }
        selectAccountClearing()
        popUpAnimateOut(popUpView: selectAccountView)
    }
    @IBAction func accountAcceptTapped(_ sender: UIButton) {
        if !tempKeyHolder.isEmpty && !selectAccountTextField.text!.isEmpty{
            switch self.selectedType {
            case 0, 1, 2, 3:
                yourAccountPlaceholderKeyString = tempKeyHolder
                yourAccountPlaceholder = selectAccountTextField.text!
                self.accountLabel.text = yourAccountPlaceholder
            case 4:
                yourPrimaryAccountPlaceholderKeyString = tempKeyHolder
                yourPrimaryAccountPlaceholder = selectAccountTextField.text!
                self.reloadSentence(selectedType: self.selectedType)
            case 5:
                yourAccountPlaceholderKeyString = tempKeyHolder
                yourAccountPlaceholder = selectAccountTextField.text!
                accountsRef.child(tempKeyHolder).observeSingleEvent(of: .value, with: { (snapshot) in
                    let thisAccount = AccountItem(snapshot: snapshot)
                    self.bizzyBooksBalanceAsInt = thisAccount.startingBal
                    self.bizzyBooksBalanceAsDouble = self.findBizzyBooksBalanceAsDouble()
                    self.bizzyBooksBalanceString = self.theFormatter.string(from: NSNumber(value: self.bizzyBooksBalanceAsDouble))!
                    self.reloadSentence(selectedType: self.selectedType)
                })
            default:
                yourAccountPlaceholderKeyString = tempKeyHolder
                yourAccountPlaceholder = selectAccountTextField.text!
                self.accountLabel.text = yourAccountPlaceholder
            }
            selectAccountClearing()
            popUpAnimateOut(popUpView: selectAccountView)
            tempKeyHolder = ""
            if primaryAccountTapped == true {
                primaryAccountTapped = false
            }
        }
    }
    
    func selectAccountClearing() {
        selectAccountTextField.text = ""
        filteredFirebaseAccounts.removeAll()
        tempKeyHolder = ""
        if selectAccountTableView != nil {
            selectAccountTableView.reloadData()
            selectAccountTableView.isHidden = true
        }
    }
    
    //Secondary Account Popup Items (always to)
    @IBOutlet var selectSecondaryAccountView: UIView!
    @IBOutlet weak var selectSecondaryAccountTableView: UITableView!
    @IBOutlet weak var selectSecondaryAccountTextField: UITextField!
    @IBAction func secondaryAccountAddButtonTapped(_ sender: UIButton) {
        selectSecondaryAccountClearing()
        accountSenderCode = 1
        pickerCode = 9
        popUpAnimateIn(popUpView: addAccountView)
    }
    @IBAction func secondaryAccountDismissTapped(_ sender: UIButton) {
        selectSecondaryAccountClearing()
        popUpAnimateOut(popUpView: selectSecondaryAccountView)
    }
    @IBAction func secondaryAccountAcceptTapped(_ sender: UIButton) {
        if !tempKeyHolder.isEmpty && !selectSecondaryAccountTextField.text!.isEmpty{
            yourSecondaryAccountPlaceholderKeyString = tempKeyHolder
            yourSecondaryAccountPlaceholder = selectSecondaryAccountTextField.text!
            self.reloadSentence(selectedType: selectedType)
            selectSecondaryAccountClearing()
            popUpAnimateOut(popUpView: selectSecondaryAccountView)
        }
    }
    
    func selectSecondaryAccountClearing() {
        selectSecondaryAccountTextField.text = ""
        filteredFirebaseAccounts.removeAll()
        tempKeyHolder = ""
        if selectSecondaryAccountTableView != nil {
            selectSecondaryAccountTableView.reloadData()
            selectSecondaryAccountTableView.isHidden = true
        }
    }
    
    @IBOutlet weak var contactSuggestionsTableView: UITableView!
    
    //Use Tax View Items (not a popup, but part of bottom bar)
    @IBOutlet var useTaxSwitchContainer: UIView!
    @IBOutlet var useTaxSwitch: UISwitch!
    var thereIsUseTax: Bool = false
    
    @IBOutlet weak var addEntityNameTextField: UITextField!
    @IBOutlet weak var addEntityPhoneNumberTextField: UITextField!
    @IBOutlet weak var addEntityEmailTextField: UITextField!
    @IBOutlet weak var addEntityStreetTextField: UITextField!
    @IBOutlet weak var addEntityCityTextField: UITextField!
    @IBOutlet weak var addEntityStateTextField: UITextField!
    @IBOutlet weak var addEntitySSNTextField: UITextField!
    @IBOutlet weak var addEntityEINTextField: UITextField!
    
    
    //"Touch up inside" doesn't work with textfields, so we use "touch down"!! LOL!!
    
    //Suggested contacts for entity
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
            } else {
                recommendedContacts.removeAll()
                contactSuggestionsTableView.reloadData()
                contactSuggestionsTableView.isHidden = true
            }
        }
    }
    @IBAction func selectWhoTextFieldChanged(_ sender: UITextField) {
        tempKeyHolder = ""
        if let searchText = sender.text {
            if !searchText.isEmpty {
                selectWhoTableView.isHidden = false
                self.filteredFirebaseEntities.removeAll()
                let thisFilteredFirebaseEntities = firebaseEntities.filter({$0.name.localizedCaseInsensitiveContains(searchText)})
                for entity in thisFilteredFirebaseEntities {
                    self.filteredFirebaseEntities.append(entity)
                }
                self.selectWhoTableView.reloadData()
            } else {
                filteredFirebaseEntities.removeAll()
                selectWhoTableView.reloadData()
                selectWhoTableView.isHidden = true
            }
        }
    }
    @IBAction func selectWhomTextFieldChanged(_ sender: UITextField) {
        tempKeyHolder = ""
        if let searchText = sender.text {
            if !searchText.isEmpty {
                selectWhomTableView.isHidden = false
                filteredFirebaseEntities = firebaseEntities.filter({ (entityItem) -> Bool in
                    if entityItem.name.localizedCaseInsensitiveContains(searchText) {
                        return true
                    } else {
                        return false
                    }
                })
                selectWhomTableView.reloadData()
            } else {
                filteredFirebaseEntities.removeAll()
                selectWhomTableView.reloadData()
                selectWhomTableView.isHidden = true
            }
        }
    }
    @IBAction func selectProjectTextFieldChanged(_ sender: UITextField) {
        tempKeyHolder = ""
        if let searchText = sender.text {
            if !searchText.isEmpty {
                selectProjectTableView.isHidden = false
                filteredFirebaseProjects = firebaseProjects.filter({ (projectItem) -> Bool in
                    if projectItem.name.localizedCaseInsensitiveContains(searchText) {
                        return true
                    } else {
                        return false
                    }
                })
                selectProjectTableView.reloadData()
            } else {
                filteredFirebaseProjects.removeAll()
                selectProjectTableView.reloadData()
                selectProjectTableView.isHidden = true
            }
        }
    }

    @IBAction func selectVehicleTextFieldChanged(_ sender: UITextField) {
        tempKeyHolder = ""
        if let searchText = sender.text {
            if !searchText.isEmpty {
                selectVehicleTableView.isHidden = false
                filteredFirebaseVehicles = firebaseVehicles.filter({ (vehicleItem) -> Bool in
                    if vehicleItem.year.localizedCaseInsensitiveContains(searchText) || vehicleItem.make.localizedCaseInsensitiveContains(searchText) || vehicleItem.model.localizedCaseInsensitiveContains(searchText) {
                        return true
                    } else {
                        return false
                    }
                })
                selectVehicleTableView.reloadData()
            } else {
                filteredFirebaseVehicles.removeAll()
                selectVehicleTableView.reloadData()
                selectVehicleTableView.isHidden = true
            }
        }
    }
    @IBAction func selectAccountTextFieldChanged(_ sender: UITextField) {
        tempKeyHolder = ""
        if let searchText = sender.text {
            if !searchText.isEmpty {
                selectAccountTableView.isHidden = false
                filteredFirebaseAccounts = firebaseAccounts.filter({ (accountItem) -> Bool in
                    if accountItem.name.localizedCaseInsensitiveContains(searchText) {
                        if primaryAccountTapped == true {
                            if accountItem.key != yourSecondaryAccountPlaceholderKeyString {
                                return true
                            } else {
                                return false
                            }
                        } else {
                            return true
                        }
                    } else {
                        return false
                    }
                })
                selectAccountTableView.reloadData()
            } else {
                filteredFirebaseAccounts.removeAll()
                selectAccountTableView.reloadData()
                selectAccountTableView.isHidden = true
            }
        }
    }
    @IBAction func selectSecondaryAccountTextFieldChanged(_ sender: UITextField) {
        tempKeyHolder = ""
        if let searchText = sender.text {
            if !searchText.isEmpty {
                selectSecondaryAccountTableView.isHidden = false
                filteredFirebaseAccounts = firebaseAccounts.filter({ (accountItem) -> Bool in
                    if accountItem.name.localizedCaseInsensitiveContains(searchText) {
                        if accountItem.key != yourPrimaryAccountPlaceholderKeyString {
                            return true
                        } else {
                            return false
                        }
                    } else {
                        return false
                    }
                })
                selectSecondaryAccountTableView.reloadData()
            } else {
                filteredFirebaseAccounts.removeAll()
                selectSecondaryAccountTableView.reloadData()
                selectSecondaryAccountTableView.isHidden = true
            }
        }
    }
    @IBAction func addProjectSelectCustomerTextFieldChanged(_ sender: UITextField) {
        tempKeyHolder = ""
        if let searchText = sender.text {
            if !searchText.isEmpty {
                addProjectSelectCustomerTableView.isHidden = false
                filteredFirebaseEntities = firebaseEntities.filter({ (entityItem) -> Bool in
                    if entityItem.name.localizedCaseInsensitiveContains(searchText) {
                        return true
                    } else {
                        return false
                    }
                })
                addProjectSelectCustomerTableView.reloadData()
            } else {
                filteredFirebaseEntities.removeAll()
                addProjectSelectCustomerTableView.reloadData()
                addProjectSelectCustomerTableView.isHidden = true
            }
        }
    }
    
    @IBOutlet var addEntityView: UIView!
    
    @IBAction func cancelEntityPressed(_ sender: UIButton) {
        addEntityView.removeFromSuperview()
    }
    
    @IBAction func clearFieldsEntityPressed(_ sender: UIButton) {
        clearAddEntityFields()
    }
    
    @IBAction func saveEntityPressed(_ sender: UIButton) {
        if (addEntityNameTextField.text == "") {
            return
        }
        let addEntityKeyReference = entitiesRef.childByAutoId()
        addEntityKeyString = addEntityKeyReference.key
        let thisEntityItem = EntityItem(type: entityPickerView.selectedRow(inComponent: 0), name: addEntityNameTextField.text as String!, phoneNumber: addEntityPhoneNumberTextField.text as String!, email: addEntityEmailTextField.text as String!, street: addEntityStreetTextField.text as String!, city: addEntityCityTextField.text as String!, state: addEntityStateTextField.text as String!, ssn: addEntitySSNTextField.text as String!, ein: addEntityEINTextField.text as String!)
        entitiesRef.child(addEntityKeyString).setValue(thisEntityItem.toAnyObject())
        switch entitySenderCode {
        case 0:
            self.whoPlaceholder = addEntityNameTextField.text!
            self.whoPlaceholderKeyString = addEntityKeyString
            popUpAnimateOut(popUpView: selectWhoView)
        case 1:
            self.whomPlaceholder = addEntityNameTextField.text!
            self.whomPlaceholderKeyString = addEntityKeyString
            popUpAnimateOut(popUpView: selectWhomView)
        case 2:
            self.addProjectSearchCustomerTextField.text = addEntityNameTextField.text!
            self.tempKeyHolder = addEntityKeyString
            self.addEntityView.removeFromSuperview()
        default:
            popUpAnimateOut(popUpView: selectWhoView)
        }
        clearAddEntityFields()
        if !(entitySenderCode == 2){
            popUpAnimateOut(popUpView: addEntityView)
        }
        reloadSentence(selectedType: selectedType)
        pickerCode = 0
    }
    
    @IBOutlet var subscriptionPopUpView: UIView!
    @IBOutlet weak var subscriptionProImage: UIImageView!
    
    @IBAction func subscriptionRestorePressed(_ sender: UIButton) {
        bradsStore.searchForProduct()
        bradsStore.restorePurchases { (isTrue, theString, err) in
            if isTrue {
                print("Restoration made " + theString!)
                self.currentlySubscribedRef.setValue(true)
            } else {
                self.currentlySubscribedRef.setValue(false)
            }
        }
        self.popUpAnimateOut(popUpView: self.subscriptionPopUpView)
    }
    
    @IBAction func subscriptionNotNowPressed(_ sender: UIButton) {
        self.popUpAnimateOut(popUpView: self.subscriptionPopUpView)
    }
    
    @IBAction func subscriptionBuyPressed(_ sender: UIButton) {
        bradsStore.searchForProduct()
        bradsStore.purchase { (isTrue, theString, err) in
            if isTrue {
                print("Purchase made " + theString!)
                self.currentlySubscribedRef.setValue(true)
            } else {
                print("Something happened " + String(describing: err))
                self.currentlySubscribedRef.setValue(false)
            }
        }
        self.popUpAnimateOut(popUpView: self.subscriptionPopUpView)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var underScrollView: UIView!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        print(String(describing: self.isUserCurrentlySubscribed))
        if hasUserSpecialAccess == true {
            launchPhotos()
        } else {
            prePhotosNoSpecialPassSubscriptionCheck()
        }
    
    }
    
    func prePhotosNoSpecialPassSubscriptionCheck() {
        switch self.isUserCurrentlySubscribed {
        case true:
            launchPhotos()
        default:
            popUpAnimateIn(popUpView: subscriptionPopUpView)
        }
    }
    
    func launchPhotos() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func showRestoreAlert() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.contactSuggestionsTableView.keyboardDismissMode = .interactive
        self.selectWhoTableView.keyboardDismissMode = .interactive
        self.selectWhomTableView.keyboardDismissMode = .interactive
        self.selectProjectTableView.keyboardDismissMode = .interactive
        self.selectVehicleTableView.keyboardDismissMode = .interactive
        self.selectAccountTableView.keyboardDismissMode = .interactive
        self.selectSecondaryAccountTableView.keyboardDismissMode = .interactive
        self.addProjectSelectCustomerTableView.keyboardDismissMode = .interactive
        
        //Prevent empty cells in tableview
        selectVehicleTableView.tableFooterView = UIView(frame: .zero)
        selectProjectTableView.tableFooterView = UIView(frame: .zero)
        selectWhoTableView.tableFooterView = UIView(frame: .zero)
        selectWhomTableView.tableFooterView = UIView(frame: .zero)
        selectAccountTableView.tableFooterView = UIView(frame: .zero)
        selectSecondaryAccountTableView.tableFooterView = UIView(frame: .zero)
        
        locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
        
        theFormatter.usesGroupingSeparator = true
        theFormatter.numberStyle = .currency
        
        overheadSwitch.isOn = false
        useTaxSwitch.isOn = false
        visualEffectView.isHidden = true
        
        self.genericPickerView.delegate = self
        self.genericPickerView.dataSource = self
        self.entityPickerView.delegate = self
        self.entityPickerView.dataSource = self
        self.howDidTheyHearOfYouPickerView.delegate = self
        self.howDidTheyHearOfYouPickerView.dataSource = self
        self.addVehicleFuelPickerView.delegate = self
        self.addVehicleFuelPickerView.dataSource = self
        self.addAccountAccountTypePickerView.delegate = self
        self.addAccountAccountTypePickerView.dataSource = self
        
        //Set up pickers' data
        taxReasonPickerData = ["income", "supplies", "labor", "meals", "office", "vehicle", "advertising", "pro help", "machine rental", "property rental", "tax+license", "insurance (wc+gl)", "travel", "employee benefit", "depreciation", "depletion", "utilities", "commissions", "wages", "mortgate interest", "other interest", "pension", "repairs"]
        wcPickerData = ["(sub has wc)", "(incurred wc)", "(wc n/a)"]
        advertisingMeansPickerData = ["(unknown)", "(referral)", "(website)", "(yp)", "(social media)", "(soliciting)", "(google adwords)", "(company shirts)", "(sign)", "(vehicle wrap)", "(billboard)", "(tv)", "(radio)", "(other)"]
        howDidTheyHearOfYouPickerData = advertisingMeansPickerData
        personalReasonPickerData = ["food", "fun", "pet", "utilities", "phone", "office", "giving", "insurance", "house", "yard", "medical", "travel", "clothes", "other"]
        fuelTypePickerData = ["87 gas", "89 gas", "91 gas", "diesel"]
        entityPickerData = ["customer", "vendor", "sub", "employee", "store", "government", "other"] // You is at position 7 but not available to user
        projectMediaTypePickerData = ["Before", "During", "After", "Drawing", "Calculations", "Material list", "Estimate", "Contract", "Labor warranty", "Material warranty", "Safety", "Other"]
        addAccountAccountTypePickerData = ["Bank account", "Credit account", "Cash account", "Store refund account"]
        
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
            DropdownFlowItem.Option(title: "Project Media", iconName: "hammer", action: { self.selectedType = 6; self.reloadSentence(selectedType: self.selectedType) })
            ])
        leftTopView.configure(item: typeItem)
        
        reloadSentence(selectedType: selectedType)
        
        //collectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        collectionView.collectionViewLayout = KTCenterFlowLayout()
        
        odometerTextField.formatter.numberStyle = NumberFormatter.Style.decimal
        odometerTextField.numberKind = 2
        odometerTextField.keyboardType = .numberPad
        odometerTextField.textColor = UIColor.BizzyColor.Grey.Notes
        odometerTextField.text = ""
        odometerTextField.placeholder = "Odometer"
        odometerTextField.allowedChars = "0123456789"
        addAccountStartingBalanceTextField.formatter.numberStyle = NumberFormatter.Style.currency
        addAccountStartingBalanceTextField.numberKind = 0
        addAccountStartingBalanceTextField.keyboardType = .numbersAndPunctuation
        addAccountStartingBalanceTextField.text = ""
        addAccountStartingBalanceTextField.placeholder = "Starting (Current) Balance"
        addAccountStartingBalanceTextField.allowedChars = "-0123456789"
        
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
        
        //Making an overhead question image tap listener
        let overheadImageViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector((handleOverheadImageViewTap)))
        self.overheadQuestionImageView.addGestureRecognizer(overheadImageViewGestureRecognizer)

        let amountText = "$0.00 "
        let iconBusiness = "business"
        let iconPersonal = "personal"
        setTextAndIconOnLabel(text: amountText, icon: iconBusiness, label: amountBusinessLabel)
        setTextAndIconOnLabel(text: amountText, icon: iconPersonal, label: amountPersonalLabel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkPermissionForPhotos()
    }

    func checkPermissionForPhotos() {
        
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
            case .authorized: print("Access is granted by user")
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (newStatus) in
                    print("status is \(newStatus)")
                    if newStatus == PHAuthorizationStatus.authorized {
                        print("success") }
                    
                })
            case .restricted: print("User do not have access to photo album.")
            case .denied: print("User has denied the permission.")
        }
    }
    
    // Print out the location to the console
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            locationManager.stopUpdatingLocation()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            thereIsAnImage = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func findBizzyBooksBalanceAsDouble () -> Double {
        bizzyBooksBalanceAsDouble = Double(bizzyBooksBalanceAsInt)/100 //REALLY, deduct effect of all Universals which affected the account to find CURRENT balance. Also, will this break if there are no Universals? Need to write it to consider that also!
        return bizzyBooksBalanceAsDouble
    }
    
    func clearAddEntityFields() {
        addEntityNameTextField.text = ""
        addEntityPhoneNumberTextField.text = ""
        addEntityEmailTextField.text = ""
        addEntityStreetTextField.text = ""
        addEntityCityTextField.text = ""
        addEntityStateTextField.text = ""
        addEntitySSNTextField.text = ""
        addEntityEINTextField.text = ""
    }
    
    func updateSliderValues(percent: Int) {
        if let theTextFieldYes = dataSource.theTextFieldYes as? AllowedCharsTextField {
            theAmt = theTextFieldYes.amt
        }
        print(theAmt)
        let prepareTheBusinessAmt = (Double(theAmt)/100) * (Double(percent)/100)
        let prepareThePersonalAmt = (Double(theAmt)/100) * (1.0 - (Double(percent)/100))
        setTextAndIconOnLabel(text: (theFormatter.string(from: NSNumber(value: prepareTheBusinessAmt)))!, icon: "business", label: amountBusinessLabel)
        setTextAndIconOnLabel(text: (theFormatter.string(from: NSNumber(value: prepareThePersonalAmt)))!, icon: "personal", label: amountPersonalLabel)
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
        youRef = Database.database().reference().child("users").child(userUID).child("youEntity")
        universalsRef = Database.database().reference().child("users").child(userUID).child("universals")
        entitiesRef = Database.database().reference().child("users").child(userUID).child("entities")
        projectsRef = Database.database().reference().child("users").child(userUID).child("projects")
        vehiclesRef = Database.database().reference().child("users").child(userUID).child("vehicles")
        accountsRef = Database.database().reference().child("users").child(userUID).child("accounts")
        currentlySubscribedRef = Database.database().reference().child("users").child(userUID).child("currentlySubscribed")
        specialAccessRef = Database.database().reference().child("users").child(userUID).child("specialAccess")
        userCurrentImageIdCountRef = Database.database().reference().child("users").child(userUID).child("userCurrentImageIdCount")
        entitiesRef.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let firebaseEntity = EntityItem(snapshot: item as! DataSnapshot)
                self.firebaseEntities.append(firebaseEntity)
            }
            self.selectWhoTableView.reloadData()
            self.selectWhomTableView.reloadData()
        }
        projectsRef.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let firebaseProject = ProjectItem(snapshot: item as! DataSnapshot)
                self.firebaseProjects.append(firebaseProject)
            }
            self.selectProjectTableView.reloadData()
        }
        vehiclesRef.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let firebaseVehicle = VehicleItem(snapshot: item as! DataSnapshot)
                self.firebaseVehicles.append(firebaseVehicle)
            }
            self.selectVehicleTableView.reloadData()
        }
        accountsRef.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let firebaseAccount = AccountItem(snapshot: item as! DataSnapshot)
                self.firebaseAccounts.append(firebaseAccount)
            }
            self.selectAccountTableView.reloadData()
            self.selectSecondaryAccountTableView.reloadData()
        }
        currentlySubscribedRef.observe(.value) { (snapshot) in
            if let subscribed = snapshot.value as? Bool {
                print("S: " + String(subscribed))
                if subscribed {
                    self.isUserCurrentlySubscribed = true
                } else {
                    self.isUserCurrentlySubscribed = false
                }
            }
        }
        specialAccessRef.observe(.value) { (snapshot) in
            if let special = snapshot.value as? Bool {
                print("Special: " + String(special))
                if special {
                    self.hasUserSpecialAccess = true
                } else {
                    self.hasUserSpecialAccess = false
                }
            } else {
                self.specialAccessRef.setValue(false)
            }
        }
        userCurrentImageIdCountRef.observe(.value) { (snapshot) in
            if let count = snapshot.value as? String {
                if let countAsInt = Int(count) {
                    self.userCurrentImageIdCount = countAsInt
                }
            }
        }
        youRef.observe(.value) { (snapshot) in
            if let youKey = snapshot.value as? String {
                self.whoPlaceholder = "You"
                self.whoPlaceholderKeyString = youKey
                self.reloadSentence(selectedType: self.selectedType)
            }
        }
        //masterRef.setValue(["username": "Brad Caldwell"]) //This erases all siblings!!!!!! Including any childrenbyautoid!!!
        //masterRef.childByAutoId().setValue([3, 4, -88, 45, true])
    }
    
    @objc func useTaxSwitchToggled(useTaxSwitch: UISwitch) {
        print("Use tax switch toggled")
        if useTaxSwitch.isOn {
            thereIsUseTax = true
        } else {
            thereIsUseTax = false
        }
    }
    
    @IBAction func useTaxMoreInfoPressed(_ sender: UIButton) {
        popUpAnimateIn(popUpView: useTaxMoreInfoView)
    }
    @IBAction func useTaxMoreInfoOKPressed(_ sender: UIButton) {
        popUpAnimateOut(popUpView: useTaxMoreInfoView)
    }
    @IBOutlet var useTaxMoreInfoView: UIView!
    
    @objc func handleProjectLabelTap(projectLabelGestureRecognizer: UITapGestureRecognizer){
        popUpAnimateIn(popUpView: selectProjectView)
    }
    
    @objc func handleAccountLabelTap(accountLabelGestureRecognizer: UITapGestureRecognizer) {
        popUpAnimateIn(popUpView: selectAccountView)
    }
    
    @objc func handleOverheadImageViewTap(overheadImageViewGestureRecognizer: UITapGestureRecognizer) {
        popUpAnimateIn(popUpView: overheadMoreInfoView)
    }
    
    func popUpAnimateIn(popUpView: UIView) {
        self.view.addSubview(popUpView)
        popUpView.center.x = self.view.center.x
        popUpView.center.y = self.view.center.y - 100
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
        //view.layoutIfNeeded()
        //collectionViewHeightConstraint.constant = collectionView.contentSize.height
        view.layoutIfNeeded()

    }
    
    func reloadSentence(selectedType: Int) {
        collectionView.reloadData()
        switch selectedType {
        case 0: businessCase()
        case 1: personalCase()
        case 2: mixedCase()
        case 3: fuelCase()
        case 4: transferCase()
        case 5: adjustCase()
        case 6: projectMediaCase()
        default: businessCase()
        }
    }
    
    func businessCase() {
        universalArray[0] = 0
        dataSource.items = [
            LabelFlowItem(text: whoPlaceholder, color: UIColor.BizzyColor.Blue.Who, action: { self.popUpAnimateIn(popUpView: self.selectWhoView) }),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            TextFieldFlowItem(text: "", amt: 0, placeholder: "0", color: UIColor.BizzyColor.Green.What, keyboardType: .numberPad, allowedCharsString: digits, formatterStyle: NumberFormatter.Style.currency, numberKind: 0),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            LabelFlowItem(text: whomPlaceholder, color: UIColor.BizzyColor.Purple.Whom, action: { self.popUpAnimateIn(popUpView: self.selectWhomView) }),
            LabelFlowItem(text: "for", color: .gray, action: nil),
            LabelFlowItem(text: whatTaxReasonPlaceholder, color: UIColor.BizzyColor.Magenta.TaxReason, action: { self.pickerCode = 0; self.popUpAnimateIn(popUpView: self.genericPickerView) })
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("Text field did change!")
        updateSliderValues(percent: thePercent)
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
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        print("getting numberOfRowsInComponent \(component) with pickerCode \(pickerCode)")

        switch pickerCode {
        case 0:
            return taxReasonPickerData.count
        case 1:
            return wcPickerData.count
        case 2:
            return advertisingMeansPickerData.count
        case 3:
            return personalReasonPickerData.count
        case 4:
            return fuelTypePickerData.count
        case 5:
            return entityPickerData.count
        case 6:
            return howDidTheyHearOfYouPickerData.count //How did they hear of you project label
        case 7:
            return projectMediaTypePickerData.count
        case 8:
            return fuelTypePickerData.count
        case 9:
            return addAccountAccountTypePickerData.count
        default:
            return taxReasonPickerData.count
        }
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("displaying row \(row) with pickerCode \(pickerCode)")
        
        switch pickerCode {
        case 0:
            return taxReasonPickerData[row]
        case 1:
            return wcPickerData[row]
        case 2:
            return advertisingMeansPickerData[row]
        case 3:
            return personalReasonPickerData[row]
        case 4:
            return fuelTypePickerData[row]
        case 5:
            return entityPickerData[row]
        case 6:
            return howDidTheyHearOfYouPickerData[row] //How did they hear of you project label
        case 7:
            return projectMediaTypePickerData[row]
        case 8:
            return fuelTypePickerData[row]
        case 9:
            return addAccountAccountTypePickerData[row]
        default:
            return taxReasonPickerData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerCode {
        case 0: //What tax reason
            universalArray[6] = row
            whatTaxReasonPlaceholder = taxReasonPickerData[row]
            whatTaxReasonPlaceholderId = row
            switch selectedType {
            case 0: //Business Type
                if self.dataSource.items.indices.contains(8) { //This just gets rid of veh, adMeans, or wc item if present before reloading.
                    self.dataSource.items.remove(at: 8) }
            case 2: //Mixed Type
                if self.dataSource.items.indices.contains(10) { //This just gets rid of veh, adMeans, or wc item if present before reloading.
                    self.dataSource.items.remove(at: 10) }
            default:
                break
            }
            popUpAnimateOut(popUpView: pickerView)
        case 1: //Worker's comp
            universalArray[8] = row
            workersCompPlaceholder = wcPickerData[row]
            workersCompPlaceholderId = row
            popUpAnimateOut(popUpView: pickerView)
        case 2: //What kind of advertising did you purchase
            universalArray[9] = row
            advertisingMeansPlaceholder = advertisingMeansPickerData[row]
            advertisingMeansPlaceholderId = row
            popUpAnimateOut(popUpView: pickerView)
        case 3: //What personal reason
            universalArray[10] = row
            whatPersonalReasonPlaceholder = personalReasonPickerData[row]
            whatPersonalReasonPlaceholderId = row
            popUpAnimateOut(popUpView: pickerView)
        case 4: //Fuel type
            universalArray[15] = row
            fuelTypePlaceholder = fuelTypePickerData[row]
            fuelTypePlaceholderId = row
            popUpAnimateOut(popUpView: pickerView)
        case 5: //Type of entity i.e. customer, sub, employee, store, etc.
            chosenEntity = row
        case 6: //How did they hear of you
            chosenHowDidTheyHearOfYou = row
        case 7: //Project media type
            projectMediaTypePlaceholder = projectMediaTypePickerData[row]
            projectMediaTypePlaceholderId = row
            popUpAnimateOut(popUpView: pickerView)
        case 8: //Fuel type picker inside addVehicleView
            let _ = 0 //Absolutely no reason except it wants something here
        case 9: //Add account account type picker stuff
            accountTypePlaceholder = addAccountAccountTypePickerData[row]
            accountTypePlaceholderId = row
        default: //What tax reason
            universalArray[6] = row
            self.whatTaxReasonPlaceholder = taxReasonPickerData[row]
            popUpAnimateOut(popUpView: pickerView)
        }
        if !(pickerCode == 5) && !(pickerCode == 6) && !(pickerCode == 8) && !(pickerCode == 9) {
            reloadSentence(selectedType: selectedType)
        }
    }
    
    func fillEntityFields() {
        if let firstName = selectedContact?.givenName, let lastName = selectedContact?.familyName {
            addEntityNameTextField.text = firstName + " " + lastName
        }
        if let phoneNumber = selectedContact?.phoneNumbers[0] {
            addEntityPhoneNumberTextField.text = String(describing: phoneNumber)
        }
        if let emailAddress = selectedContact?.emailAddresses[0] {
            addEntityEmailTextField.text = String(describing: emailAddress)
        }

    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        returnIfAnyPertinentItemsForgotten()
    }
    
    func afterTheReturnTest() {
        if thereIsAnImage {
            if let uploadData = UIImagePNGRepresentation(self.imageView.image!) {
                userCurrentImageIdCount += 1
                userCurrentImageIdCountString = String(userCurrentImageIdCount)
                userCurrentImageIdCountStringPlusType = userCurrentImageIdCountString + ".png"
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let imagesRef = storageRef.child("users").child(userUID).child(userCurrentImageIdCountStringPlusType)
                userCurrentImageIdCountRef.setValue(userCurrentImageIdCountString)
                let uploadTask = imagesRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if error != nil {
                        print(String(describing: error))
                        return
                    }
                    print(String(describing: metadata))
                    self.downloadURL = metadata?.downloadURL()
                })
                uploadTask.observe(.progress) { snapshot in
                    // Upload reported progress
                    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                        / Double(snapshot.progress!.totalUnitCount)
                }
                
                uploadTask.observe(.success) { snapshot in
                    // Upload completed successfully
                    self.saveUniversal()
                }
                
                uploadTask.observe(.failure) { snapshot in
                    if let error = snapshot.error as? NSError {
                        switch (StorageErrorCode(rawValue: error.code)!) {
                        case .objectNotFound:
                            // File doesn't exist
                            break
                        case .unauthorized:
                            // User doesn't have permission to access file
                            break
                        case .cancelled:
                            // User canceled the upload
                            break
                            
                            /* ... */
                            
                        case .unknown:
                            // Unknown error occurred, inspect the server response
                            break
                        default:
                            // A separate error occurred. This is a good place to retry the upload.
                            break
                        }
                    }
                }
                
            }
        } else {
            self.saveUniversal()
        }
    }
    
    func saveUniversal() {
        let addUniversalKeyReference = universalsRef.childByAutoId()
        self.addUniversalKeyString = addUniversalKeyReference.key
        var notes = ""
        var urlString = ""
        let timeStampDictionaryForFirebase = [".sv": "timestamp"]
        if let theNotes = notesTextField.text {
            notes = theNotes
        }
        if let theUrl = downloadURL {
            urlString = theUrl.absoluteString
        }
        if let primaryTextField = dataSource.theTextFieldYes as? AllowedCharsTextField {
            theAmt = primaryTextField.amt
        }
        if selectedType == 3 {
            if let secondaryTextField = dataSource.theSecondaryTextFieldYes as? AllowedCharsTextField {
                howMany = secondaryTextField.amt
            }
        }
        switch self.selectedType {
        case 4: //Transfer
            let thisUniversalItem = UniversalItem(universalItemType: selectedType, projectItemName: projectPlaceholder, projectItemKey: projectPlaceholderKeyString, odometerReading: 0, whoName: whoPlaceholder, whoKey: whoPlaceholderKeyString, what: theAmt, whomName: whomPlaceholder, whomKey: whomPlaceholderKeyString, taxReasonId: whatTaxReasonPlaceholderId, vehicleName: vehiclePlaceholder, vehicleKey: vehiclePlaceholderKeyString, workersCompId: workersCompPlaceholderId, advertisingMeansId: advertisingMeansPlaceholderId, personalReasonId: whatPersonalReasonPlaceholderId, percentBusiness: thePercent, accountOneName: yourPrimaryAccountPlaceholder, accountOneKey: yourPrimaryAccountPlaceholderKeyString, accountTwoName: yourSecondaryAccountPlaceholder, accountTwoKey: yourSecondaryAccountPlaceholderKeyString, howMany: howMany, fuelTypeId: fuelTypePlaceholderId, useTax: thereIsUseTax, notes: notes, picUrl: urlString, projectPicTypeId: projectMediaTypePlaceholderId, timeStamp: timeStampDictionaryForFirebase, latitude: latitude, longitude: longitude, atmFee: atmFee, feeAmount: feeAmount, key: addUniversalKeyString)
            universalsRef.child(addUniversalKeyString).setValue(thisUniversalItem.toAnyObject())
        default:
            let thisUniversalItem = UniversalItem(universalItemType: selectedType, projectItemName: projectPlaceholder, projectItemKey: projectPlaceholderKeyString, odometerReading: 0, whoName: whoPlaceholder, whoKey: whoPlaceholderKeyString, what: theAmt, whomName: whomPlaceholder, whomKey: whomPlaceholderKeyString, taxReasonId: whatTaxReasonPlaceholderId, vehicleName: vehiclePlaceholder, vehicleKey: vehiclePlaceholderKeyString, workersCompId: workersCompPlaceholderId, advertisingMeansId: advertisingMeansPlaceholderId, personalReasonId: whatPersonalReasonPlaceholderId, percentBusiness: thePercent, accountOneName: yourAccountPlaceholder, accountOneKey: yourAccountPlaceholderKeyString, accountTwoName: yourSecondaryAccountPlaceholder, accountTwoKey: yourSecondaryAccountPlaceholderKeyString, howMany: howMany, fuelTypeId: fuelTypePlaceholderId, useTax: thereIsUseTax, notes: notes, picUrl: urlString, projectPicTypeId: projectMediaTypePlaceholderId, timeStamp: timeStampDictionaryForFirebase, latitude: latitude, longitude: longitude, atmFee: atmFee, feeAmount: feeAmount, key: addUniversalKeyString)
            universalsRef.child(addUniversalKeyString).setValue(thisUniversalItem.toAnyObject())
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func returnIfAnyPertinentItemsForgotten() {
        switch self.selectedType {
        case 0:
            guard projectPlaceholderKeyString != "" else { return }
            guard whoPlaceholderKeyString != "" else { return }
            guard whomPlaceholderKeyString != "" else { return }
            guard whatTaxReasonPlaceholderId != -1 else { return }
            if whatTaxReasonPlaceholderId == 2 {
                guard workersCompPlaceholderId != -1 else { return }
            } else if whatTaxReasonPlaceholderId == 5 {
                guard vehiclePlaceholderKeyString != "" else { return }
            } else if whatTaxReasonPlaceholderId == 6 {
                guard advertisingMeansPlaceholderId != -1 else { return }
            }
            guard yourAccountPlaceholderKeyString != "" else { return }
        case 1:
            guard whoPlaceholderKeyString != "" else { return }
            guard whomPlaceholderKeyString != "" else { return }
            guard whatPersonalReasonPlaceholderId != -1 else { return }
            guard yourAccountPlaceholderKeyString != "" else { return }
        case 2:
            guard projectPlaceholderKeyString != "" else { return }
            guard whoPlaceholderKeyString != "" else { return }
            guard whomPlaceholderKeyString != "" else { return }
            guard whatPersonalReasonPlaceholderId != -1 else { return }
            guard whatTaxReasonPlaceholderId != -1 else { return }
            if whatTaxReasonPlaceholderId == 2 {
                guard workersCompPlaceholderId != -1 else { return }
            } else if whatTaxReasonPlaceholderId == 5 {
                guard vehiclePlaceholderKeyString != "" else { return }
            } else if whatTaxReasonPlaceholderId == 6 {
                guard advertisingMeansPlaceholderId != -1 else { return }
            }
            guard yourAccountPlaceholderKeyString != "" else { return }
        case 3:
            guard odometerTextField.text != "" else { return }
            guard whoPlaceholderKeyString != "" else { return }
            guard whomPlaceholderKeyString != "" else { return }
            guard fuelTypePlaceholderId != -1 else { return }
            guard vehiclePlaceholderKeyString != "" else { return }
            guard yourAccountPlaceholderKeyString != "" else { return }
        case 4:
            guard yourPrimaryAccountPlaceholderKeyString != "" else { return }
            guard yourSecondaryAccountPlaceholderKeyString != "" else { return }
        case 5:
            guard yourAccountPlaceholderKeyString != "" else { return }
        case 6:
            guard projectMediaTypePlaceholderId != -1 else { return }
        default:
            guard projectPlaceholderKeyString != "" else { return }
            guard whoPlaceholderKeyString != "" else { return }
            guard whomPlaceholderKeyString != "" else { return }
            guard whatTaxReasonPlaceholderId != -1 else { return }
            if whatTaxReasonPlaceholderId == 2 {
                guard workersCompPlaceholderId != -1 else { return }
            } else if whatTaxReasonPlaceholderId == 5 {
                guard vehiclePlaceholderKeyString != "" else { return }
            } else if whatTaxReasonPlaceholderId == 6 {
                guard advertisingMeansPlaceholderId != -1 else { return }
            }
            guard yourAccountPlaceholderKeyString != "" else { return }
        }
        afterTheReturnTest()
    }
    
}



extension AddUniversal: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case self.contactSuggestionsTableView:
            return recommendedContacts.count
        case self.selectWhoTableView:
            return filteredFirebaseEntities.count
        case self.selectWhomTableView:
            return filteredFirebaseEntities.count
        case self.selectProjectTableView:
            return filteredFirebaseProjects.count
        case self.selectVehicleTableView:
            return filteredFirebaseVehicles.count
        case self.selectAccountTableView:
            return filteredFirebaseAccounts.count
        case self.selectSecondaryAccountTableView:
            return filteredFirebaseAccounts.count
        case self.addProjectSelectCustomerTableView:
            return filteredFirebaseEntities.count
        default:
            return recommendedContacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        switch tableView {
        case self.contactSuggestionsTableView:
            print("Hello...")
            cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
            let contact = recommendedContacts[indexPath.row]
            let name = contact.givenName + " " + contact.familyName
            cell!.textLabel!.text = name
        case self.selectWhoTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SelectWhoCell", for: indexPath)
            let who = filteredFirebaseEntities[indexPath.row]
            let name = who.name
            cell!.textLabel!.text = name
            print("The name is ")
            print(name)
        case self.selectWhomTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SelectWhomCell", for: indexPath)
            let whom = filteredFirebaseEntities[indexPath.row]
            let name = whom.name
            cell!.textLabel!.text = name
        case self.selectProjectTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SelectProjectCell", for: indexPath)
            let project = filteredFirebaseProjects[indexPath.row]
            let name = project.name
            cell!.textLabel!.text = name
        case self.selectVehicleTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SelectVehicleCell", for: indexPath)
            let vehicle = filteredFirebaseVehicles[indexPath.row]
            let name = vehicle.year + " " + vehicle.make + " " + vehicle.model
            cell!.textLabel!.text = name
        case self.selectAccountTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SelectAccountCell", for: indexPath)
            let account = filteredFirebaseAccounts[indexPath.row]
            let name = account.name
            cell!.textLabel!.text = name
        case self.selectSecondaryAccountTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SelectSecondaryAccountCell", for: indexPath)
            let secondaryAccount = filteredFirebaseAccounts[indexPath.row]
            let name = secondaryAccount.name
            cell!.textLabel!.text = name
        case self.addProjectSelectCustomerTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "AddProjectSelectCustomerCell", for: indexPath)
            let customer = filteredFirebaseEntities[indexPath.row]
            let name = customer.name
            cell!.textLabel!.text = name
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
            let contact = recommendedContacts[indexPath.row]
            let name = contact.givenName + " " + contact.familyName
            cell!.textLabel!.text = name
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //Added this to stop chicanery of cells still being selected if you change your mind and go back a second time.
        switch tableView {
        case self.contactSuggestionsTableView:
            let contact = self.recommendedContacts[indexPath.row]
            self.selectedContact = contact
            self.contactSuggestionsTableView.isHidden = true
            addEntityNameTextField.text = contact.givenName + " " + contact.familyName
            if (contact.isKeyAvailable(CNContactEmailAddressesKey)) {
                if let theEmail = contact.emailAddresses.first {
                    addEntityEmailTextField.text = theEmail.value as String
                }
            }
            if (contact.isKeyAvailable(CNContactPhoneNumbersKey)) {
                if let thePhoneNumber = contact.phoneNumbers.first  {
                    addEntityPhoneNumberTextField.text = thePhoneNumber.value.stringValue
                }
            }
            if (contact.isKeyAvailable(CNContactPostalAddressesKey)) {
                if let theAddress = contact.postalAddresses.first {
                    addEntityStreetTextField.text = theAddress.value.street
                    addEntityCityTextField.text = theAddress.value.city
                    addEntityStateTextField.text = theAddress.value.state
                }
            }
            self.recommendedContacts.removeAll() //Is this safe on this particular instance?? Seems to be.
        case self.selectWhoTableView:
            let who = filteredFirebaseEntities[indexPath.row]
            self.selectWhoTableView.isHidden = true
            self.selectWhoTextField.text = who.name
            self.tempKeyHolder = who.key
            self.filteredFirebaseEntities.removeAll()
        case self.selectWhomTableView:
            let whom = filteredFirebaseEntities[indexPath.row]
            self.selectWhomTableView.isHidden = true
            self.selectWhomTextField.text = whom.name
            self.tempKeyHolder = whom.key
            self.filteredFirebaseEntities.removeAll()
        case self.selectProjectTableView:
            let project = filteredFirebaseProjects[indexPath.row]
            self.selectProjectTableView.isHidden = true
            self.projectTextField.text = project.name //The one on the main screen is a label (stupid I know)
            self.tempKeyHolder = project.key
            self.filteredFirebaseProjects.removeAll()
        case self.selectVehicleTableView:
            let vehicle = filteredFirebaseVehicles[indexPath.row]
            self.selectVehicleTableView.isHidden = true
            self.selectVehicleTextField.text = vehicle.year + " " + vehicle.make + " " + vehicle.model
            self.tempKeyHolder = vehicle.key
            self.filteredFirebaseVehicles.removeAll()
        case self.selectAccountTableView:
            let account = filteredFirebaseAccounts[indexPath.row]
            self.selectAccountTableView.isHidden = true
            self.selectAccountTextField.text = account.name
            self.tempKeyHolder = account.key
            self.filteredFirebaseAccounts.removeAll() //This critical line empties the array so when secondary account is clicked, it doesn't pre-fill with all the data from last time!! And so with all the other cases.
        case self.selectSecondaryAccountTableView:
            let secondaryAccount = filteredFirebaseAccounts[indexPath.row]
            self.selectSecondaryAccountTableView.isHidden = true
            self.selectSecondaryAccountTextField.text = secondaryAccount.name
            self.tempKeyHolder = secondaryAccount.key
            self.filteredFirebaseAccounts.removeAll()
        case self.addProjectSelectCustomerTableView:
            let customer = filteredFirebaseEntities[indexPath.row]
            self.addProjectSelectCustomerTableView.isHidden = true
            self.addProjectSearchCustomerTextField.text = customer.name
            self.tempKeyHolder = customer.key
            self.filteredFirebaseEntities.removeAll()
        default:
            let contact = self.recommendedContacts[indexPath.row]
            self.selectedContact = contact
            self.contactSuggestionsTableView.isHidden = true
            addEntityNameTextField.text = contact.givenName + " " + contact.familyName
            if (contact.isKeyAvailable(CNContactEmailAddressesKey)) {
                if let theEmail = contact.emailAddresses.first {
                    addEntityEmailTextField.text = theEmail.value as String
                }
            }
            if (contact.isKeyAvailable(CNContactPhoneNumbersKey)) {
                if let thePhoneNumber = contact.phoneNumbers.first  {
                    addEntityPhoneNumberTextField.text = thePhoneNumber.value.stringValue
                }
            }
            if (contact.isKeyAvailable(CNContactPostalAddressesKey)) {
                if let theAddress = contact.postalAddresses.first {
                    addEntityStreetTextField.text = theAddress.value.street
                    addEntityCityTextField.text = theAddress.value.city
                    addEntityStateTextField.text = theAddress.value.state
                }
            }
            self.recommendedContacts.removeAll()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
}


