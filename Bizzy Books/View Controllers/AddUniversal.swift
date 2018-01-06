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

    var specialAccessRef: DatabaseReference!
    var currentlySubscribedRef: DatabaseReference!
    var currentSubscriptionRef: DatabaseReference!
    var userCurrentImageIdCountRef: DatabaseReference!
    
    var hasUserSpecialAccess: Bool = false
    
    var thereIsAnImage = false
    var userCurrentImageIdCount: Int = 0
    var userCurrentImageIdCountString: String = ""
    var userCurrentImageIdCountStringPlusType: String = ""
    var downloadURL: URL?
    var currentlyUploading = false
    
    var firebaseUniversals: [UniversalItem] = []
    var thisUniversals: [UniversalItem] = []
    var filteredFirebaseEntities: [EntityItem] = []
    var filteredFirebaseProjects: [ProjectItem] = []
    var filteredFirebaseVehicles: [VehicleItem] = []
    var filteredFirebaseAccounts: [AccountItem] = []
    
    var tempKeyHolder: String = ""
    var tempTypeHolderId: Int = 0

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
    
    var trueYouKeyString = ""
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
    var theStartingBalance = 0
    var yourPrimaryAccountPlaceholder = "account ▾"
    var yourPrimaryAccountPlaceholderKeyString = ""
    var primaryAccountTypePlaceholder = "Bank account"
    var primaryAccountTypePlaceholderId = 0
    var yourSecondaryAccountPlaceholder = "secondary account ▾"
    var yourSecondaryAccountPlaceholderKeyString = ""
    var secondaryAccountTypePlaceholder = "Bank account"
    var secondaryAccountTypePlaceholderId = 0
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
    var projectStatusPlaceholder = "Project status ▾ ?"
    var projectStatusPlaceholderId = -1
    var atmFee = false
    var feeAmount = 0
    var addAccountNamePlaceholder = ""
    var addAccountStartingBalancePlaceholder = 0
    var theBalanceAfter = 0
    var addAccountPhoneNumberPlaceholder = ""
    var addAccountEmailPlaceholder = ""
    var addAccountStreetPlaceholder = ""
    var addAccountCityPlaceholder = ""
    var addAccountStatePlaceholder = ""
    let stringifyAnInt = StringifyAnInt()
    var imageViewHeight: CGFloat = 1
    var aspectRatio: CGFloat = 0
    var picNumber: Int = 0
    
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
    var projectStatusPickerData: [String] = [String]()
    var addAccountAccountTypePickerData: [String] = [String]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var leftTopView: DropdownFlowView!
    @IBOutlet weak var rightTopView: UIView!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var odometerTextField: AllowedCharsTextField!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var percentBusinessLabel: UILabel!
    @IBOutlet weak var percentBusinessTheSlider: UISlider!
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
        if overheadSwitch.isOn {
            projectPlaceholderKeyString = "0" // Zero for overhead! lol
            projectPlaceholder = "Overhead"
            if selectedType == 6 {
                reloadSentence(selectedType: selectedType)
                //if dataSource.items.count > 1 { dataSource.items.remove(at: 1) }
            }
            selectProjectClearing()
            self.projectLabel.text = self.projectPlaceholder
            popUpAnimateOut(popUpView: selectProjectView)
            tempKeyHolder = ""
        } else {
            if !tempKeyHolder.isEmpty && !projectTextField.text!.isEmpty {
                projectPlaceholderKeyString = tempKeyHolder
                projectPlaceholder = projectTextField.text!
                projectsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    for item in snapshot.children {
                        let firebaseProject = ProjectItem(snapshot: item as! DataSnapshot)
                        if firebaseProject.key == self.projectPlaceholderKeyString {
                            self.projectStatusPlaceholder = firebaseProject.projectStatusName
                            self.projectStatusPlaceholderId = firebaseProject.projectStatusId
                            if self.selectedType == 6 {
                                self.reloadSentence(selectedType: self.selectedType)
                            }
                            self.selectProjectClearing()
                            self.projectLabel.text = self.projectPlaceholder
                            self.popUpAnimateOut(popUpView: self.selectProjectView)
                            self.tempKeyHolder = ""
                        }
                    }
                })
            } else {
                return
            }
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
    
    @IBOutlet weak var projectStatusPickerView: UIPickerView!
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
        addProjectClearFields()
        self.addProjectView.removeFromSuperview()
    }
    @IBAction func addProjectSavePressed(_ sender: UIButton) {
        if !tempKeyHolder.isEmpty  && !addProjectNameTextField.text!.isEmpty && !addProjectSearchCustomerTextField.text!.isEmpty {
            let addProjectKeyReference = projectsRef.childByAutoId()
            addProjectKeyString = addProjectKeyReference.key
            if projectStatusPlaceholderId == -1 {
                projectStatusPlaceholderId = 0
                projectStatusPlaceholder = "Job lead"
            }
            let timeStampDictionaryForFirebase = [".sv": "timestamp"]
            let thisProjectItem = ProjectItem(name: addProjectNameTextField.text!, customerName: addProjectSearchCustomerTextField.text!, customerKey: tempKeyHolder, howDidTheyHearOfYouString: howDidTheyHearOfYouPlaceholder, howDidTheyHearOfYouId: chosenHowDidTheyHearOfYou, projectTags: addProjectTagsTextField.text!, projectAddressStreet: addProjectStreetTextField.text!, projectAddressCity: addProjectCityTextField.text!, projectAddressState: addProjectStateTextField.text!, projectNotes: addProjectNotesTextField.text!, projectStatusName: projectStatusPlaceholder, projectStatusId: projectStatusPlaceholderId, timeStamp: timeStampDictionaryForFirebase)
            projectsRef.child(addProjectKeyString).setValue(thisProjectItem.toAnyObject())
            popUpAnimateOut(popUpView: addProjectView)
            self.projectPlaceholderKeyString = addProjectKeyString
            self.projectPlaceholder = thisProjectItem.name
            self.projectLabel.text = self.projectPlaceholder
            addProjectClearFields()
            self.selectProjectView.removeFromSuperview()
        }
    }
    func addProjectClearFields() {
        addProjectNameTextField.text = ""
        addProjectSearchCustomerTextField.text = ""
        projectStatusPickerView.reloadAllComponents()
        projectStatusPickerView.selectRow(0, inComponent: 0, animated: false)
        howDidTheyHearOfYouPickerView.reloadAllComponents()
        howDidTheyHearOfYouPickerView.selectRow(0, inComponent: 0, animated: false)
        addProjectTagsTextField.text = ""
        addProjectNotesTextField.text = ""
        addProjectStreetTextField.text = ""
        addProjectCityTextField.text = ""
        addProjectStateTextField.text = ""
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
            let timeStampDictionaryForFirebase = [".sv": "timestamp"]
            let thisVehicleItem = VehicleItem(year: addVehicleYearTextField.text!, make: addVehicleMakeTextField.text!, model: addVehicleModelTextField.text!, color: addVehicleColorTextField.text!, fuelId: addVehicleFuelPickerView.selectedRow(inComponent: 0), fuelString: fuelTypePickerData[addVehicleFuelPickerView.selectedRow(inComponent: 0)], placedInCommissionDate: addVehiclePlacedInCommissionTextField.text!, licensePlateNumber: addVehicleLicensePlateNumberTextField.text!, vehicleIdentificationNumber: addVehicleVehicleIdentificationNumberTextField.text!, timeStamp: timeStampDictionaryForFirebase)
            vehiclesRef.child(addVehicleKeyString).setValue(thisVehicleItem.toAnyObject())
            popUpAnimateOut(popUpView: addVehicleView)
            vehiclePlaceholderKeyString = addVehicleKeyString
            vehiclePlaceholder = thisVehicleItem.year + " " + thisVehicleItem.make + " " + thisVehicleItem.model
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
    
    @IBOutlet weak var addAccountTableView: UITableView!
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
            let timeStampDictionaryForFirebase = [".sv": "timestamp"]
            if let _ = addAccountNameTextField.text {
                addAccountNamePlaceholder = addAccountNameTextField.text!
            }
            if let _ = addAccountPhoneNumberTextField.text {
                addAccountPhoneNumberPlaceholder = addAccountPhoneNumberTextField.text!
            }
            if let _ = addAccountEmailTextField.text {
                addAccountEmailPlaceholder = addAccountEmailTextField.text!
            }
            if let _ = addAccountStreetTextField.text {
                addAccountStreetPlaceholder = addAccountStreetTextField.text!
            }
            if let _ = addAccountCityTextField.text {
                addAccountCityPlaceholder = addAccountCityTextField.text!
            }
            if let _ = addAccountStateTextField.text {
                addAccountStatePlaceholder = addAccountStateTextField.text!
            }
            let thisAccountItem = AccountItem(name: addAccountNamePlaceholder, accountTypeId: accountTypePlaceholderId, phoneNumber: addAccountPhoneNumberPlaceholder, email: addAccountEmailPlaceholder, street: addAccountStreetPlaceholder, city: addAccountCityPlaceholder, state: addAccountStatePlaceholder, startingBal: TheAmtSingleton.shared.theStartingBal, creditDetailsAvailable: false, isLoan: false, loanType: 0, loanTypeSubcategory: 0, loanPercentOne: 0.0, loanPercentTwo: 0.0, loanPercentThree: 0.0, loanPercentFour: 0.0, loanIntFactorOne: 0, loanIntFactorTwo: 0, loanIntFactorThree: 0, loanIntFactorFour: 0, maxLimit: 0, maxCashAdvanceAllowance: 0, closeDay: 0, dueDay: 0, cycle: 0, minimumPaymentRequired: 0, lateFeeAsOneTimeInt: 0, lateFeeAsPercentageOfTotalBalance: 0.0, cycleDues: 0, duesCycle: 0, minimumPaymentToBeSmart: 0, interestRate: 0.0, interestKind: 0, timeStamp: timeStampDictionaryForFirebase, key: addAccountKeyString)
            accountsRef.child(addAccountKeyString).setValue(thisAccountItem.toAnyObject())
            popUpAnimateOut(popUpView: addAccountView)
            if accountSenderCode == 0 {
                switch self.selectedType {
                case 4:
                    yourPrimaryAccountPlaceholderKeyString = addAccountKeyString
                    yourPrimaryAccountPlaceholder = thisAccountItem.name
                    primaryAccountTypePlaceholderId = thisAccountItem.accountTypeId
                default:
                    yourAccountPlaceholderKeyString = addAccountKeyString
                    yourAccountPlaceholder = thisAccountItem.name
                    accountTypePlaceholderId = thisAccountItem.accountTypeId
                }
            } else if accountSenderCode == 1 {
                yourSecondaryAccountPlaceholderKeyString = addAccountKeyString
                yourSecondaryAccountPlaceholder = thisAccountItem.name
                secondaryAccountTypePlaceholderId = thisAccountItem.accountTypeId
            }
            addAccountClearFields()
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
    
    func addAccountClearFields() {
        addAccountNameTextField.text = ""
        addAccountStartingBalanceTextField.text = ""
        addAccountStartingBalanceTextField.isNegative = false
        addAccountPhoneNumberTextField.text = ""
        addAccountEmailTextField.text = ""
        addAccountStreetTextField.text = ""
        addAccountCityTextField.text = ""
        addAccountStateTextField.text = ""
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
                accountTypePlaceholderId = tempTypeHolderId
                self.accountLabel.text = yourAccountPlaceholder
                selectAccountClearing()
            case 4:
                yourPrimaryAccountPlaceholderKeyString = tempKeyHolder
                yourPrimaryAccountPlaceholder = selectAccountTextField.text!
                accountTypePlaceholderId = tempTypeHolderId
                self.reloadSentence(selectedType: self.selectedType)
                selectAccountClearing()
            case 5:
                yourAccountPlaceholderKeyString = tempKeyHolder
                yourAccountPlaceholder = selectAccountTextField.text!
                accountsRef.observe(.value) { (snapshot) in
                    for item in snapshot.children {
                        let theAccount = AccountItem(snapshot: item as! DataSnapshot)
                        if theAccount.key == self.tempKeyHolder {
                            let obtainBalanceAfter = ObtainBalanceAfter()
                            let currentTime: Double = Date().timeIntervalSince1970
                            let currentTimeMillis: Double = currentTime * 1000
                            obtainBalanceAfter.balAfter(accountKey: self.tempKeyHolder, particularUniversalTimeStamp: currentTimeMillis, completion: {
                                self.theBalanceAfter = obtainBalanceAfter.runningBalanceOne
                                self.theStartingBalance = obtainBalanceAfter.startingBalanceOne
                                self.bizzyBooksBalanceAsDouble = Double(self.theBalanceAfter)/100
                                self.bizzyBooksBalanceString = self.theFormatter.string(from: NSNumber(value: self.bizzyBooksBalanceAsDouble))!
                                self.reloadSentence(selectedType: self.selectedType)
                                self.selectAccountClearing()
                            })
                        }
                    }
                }
            default:
                yourAccountPlaceholderKeyString = tempKeyHolder
                yourAccountPlaceholder = selectAccountTextField.text!
                self.accountLabel.text = yourAccountPlaceholder
            }
            popUpAnimateOut(popUpView: selectAccountView)
            tempTypeHolderId = 0
            if primaryAccountTapped == true {
                primaryAccountTapped = false
            }
        }
    }
    
    func selectAccountClearing() {
        selectAccountTextField.text = ""
        filteredFirebaseAccounts.removeAll()
        tempKeyHolder = ""
        tempTypeHolderId = 0
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
            secondaryAccountTypePlaceholderId = tempTypeHolderId
            self.reloadSentence(selectedType: selectedType)
            selectSecondaryAccountClearing()
            popUpAnimateOut(popUpView: selectSecondaryAccountView)
        }
    }
    
    func selectSecondaryAccountClearing() {
        selectSecondaryAccountTextField.text = ""
        filteredFirebaseAccounts.removeAll()
        tempKeyHolder = ""
        tempTypeHolderId = 0
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
    
    @IBAction func contactNameFieldTouchedDown(_ sender: UITextField) {
        if (sender.text) != nil {
            if !(sender.text?.isEmpty)! {
                if self.contactSuggestionsTableView.isHidden == false {
                    self.contactSuggestionsTableView.isHidden = true
                } else {
                    self.contactSuggestionsTableView.isHidden = false
                }
            }
        }
    }
    
    @IBAction func selectWhoTextFieldTouchedDown(_ sender: UITextField) {
        if (sender.text) != nil {
            if !(sender.text?.isEmpty)! {
                if self.selectWhoTableView.isHidden == false {
                    self.selectWhoTableView.isHidden = true
                } else {
                    self.selectWhoTableView.isHidden = false
                }
            }
        }
    }

    @IBAction func selectWhomTextFieldTouchedDown(_ sender: UITextField) {
        if (sender.text) != nil {
            if !(sender.text?.isEmpty)! {
                if self.selectWhomTableView.isHidden == false {
                    self.selectWhomTableView.isHidden = true
                } else {
                    self.selectWhomTableView.isHidden = false
                }
            }
        }
    }

    @IBAction func selectProjectTextFieldTouchedDown(_ sender: UITextField) {
        if (sender.text) != nil {
            if !(sender.text?.isEmpty)! {
                if self.selectProjectTableView.isHidden == false {
                    self.selectProjectTableView.isHidden = true
                } else {
                    self.selectProjectTableView.isHidden = false
                }
            }
        }
    }

    @IBAction func selectVehicleTextFieldTouchedDown(_ sender: UITextField) {
        if (sender.text) != nil {
            if !(sender.text?.isEmpty)! {
                if self.selectVehicleTableView.isHidden == false {
                    self.selectVehicleTableView.isHidden = true
                } else {
                    self.selectVehicleTableView.isHidden = false
                }
            }
        }
    }

    @IBAction func selectAccountTextFieldTouchedDown(_ sender: UITextField) {
        if (sender.text) != nil {
            if !(sender.text?.isEmpty)! {
                if self.selectAccountTableView.isHidden == false {
                    self.selectAccountTableView.isHidden = true
                } else {
                    self.selectAccountTableView.isHidden = false
                }
            }
        }
    }

    @IBAction func selectSecondaryAccountTextFieldTouchedDown(_ sender: UITextField) {
        if (sender.text) != nil {
            if !(sender.text?.isEmpty)! {
                if self.selectSecondaryAccountTableView.isHidden == false {
                    self.selectSecondaryAccountTableView.isHidden = true
                } else {
                    self.selectSecondaryAccountTableView.isHidden = false
                }
            }
        }
    }
    
    @IBAction func addProjectSelectCustomerTextFieldTouchedDown(_ sender: UITextField) {
        if (sender.text) != nil {
            if !(sender.text?.isEmpty)! {
                if self.addProjectSelectCustomerTableView.isHidden == false {
                    self.addProjectSelectCustomerTableView.isHidden = true
                } else {
                    self.addProjectSelectCustomerTableView.isHidden = false
                }
            }
        }
    }
    
    @IBAction func addAccountNameTextFieldTouchedDown(_ sender: UITextField) {
        if (sender.text) != nil {
            if !(sender.text?.isEmpty)! {
                if self.addAccountTableView.isHidden == false {
                    self.addAccountTableView.isHidden = true
                } else {
                    self.addAccountTableView.isHidden = false
                }
            }
        }
    }
    
    @IBAction func addAccountNameTextFieldChanged(_ sender: UITextField) {
        if let searchText = sender.text {
            addAccountClearFields() // PURE FREAKING GOLD!!!!! clears all fields out if user starts deleting already accepted entity - dont have to do some insane code checking for backspace pressed or anything!!!
            addAccountNameTextField.text = searchText
            if !searchText.isEmpty {
                ContactsLogicManager.shared.fetchContactsMatching(name: searchText, completion: { (contacts) in
                    if let theContacts = contacts {
                        self.recommendedContacts = theContacts
                        if self.recommendedContacts.count > 0 {
                            self.addAccountTableView.isHidden = false
                        } else {
                            self.addAccountTableView.isHidden = true // PURE GOLD - hides tableview if no match to current typing so that it's not in the way when you are just trying to add your own. THIS SHOULD NOT GO IN MOST TABLEVIEW ENTRY FIELDS AS MOST OF MY TABLEVIEWS require A MATCH.
                        }
                        self.addAccountTableView.reloadData()
                    }
                    else {
                        // Contact fetch failed
                        // Denied permission
                    }
                })
            } else {
                recommendedContacts.removeAll()
                addAccountTableView.reloadData()
                addAccountTableView.isHidden = true
            }
        }
    }
    
    //Suggested contacts for entity
    @IBAction func contactNameTextFieldChanged(_ sender: UITextField) {
        if let searchText = sender.text {
            clearAddEntityFields() // PURE FREAKING GOLD!!!!! clears all fields out if user starts deleting already accepted entity - dont have to do some insane code checking for backspace pressed or anything!!!
            addEntityNameTextField.text = searchText
            if !searchText.isEmpty {
                ContactsLogicManager.shared.fetchContactsMatching(name: searchText, completion: { (contacts) in
                    if let theContacts = contacts {
                        self.recommendedContacts = theContacts
                        if self.recommendedContacts.count > 0 {
                            self.contactSuggestionsTableView.isHidden = false
                        } else {
                            self.contactSuggestionsTableView.isHidden = true // PURE GOLD - hides tableview if no match to current typing so that it's not in the way when you are just trying to add your own. THIS SHOULD NOT GO IN MOST TABLEVIEW ENTRY FIELDS AS MOST OF MY TABLEVIEWS require A MATCH.
                        }
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
                let thisFilteredFirebaseEntities = MIProcessor.sharedMIP.mIPEntities.filter({$0.name.localizedCaseInsensitiveContains(searchText)})
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
                filteredFirebaseEntities = MIProcessor.sharedMIP.mIPEntities.filter({ (entityItem) -> Bool in
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
                filteredFirebaseProjects = MIProcessor.sharedMIP.mIPProjects.filter({ (projectItem) -> Bool in
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
                filteredFirebaseVehicles = MIProcessor.sharedMIP.mIPVehicles.filter({ (vehicleItem) -> Bool in
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
        tempTypeHolderId = 0
        if let searchText = sender.text {
            if !searchText.isEmpty {
                selectAccountTableView.isHidden = false
                filteredFirebaseAccounts = MIProcessor.sharedMIP.mIPAccounts.filter({ (accountItem) -> Bool in
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
        tempTypeHolderId = 0
        if let searchText = sender.text {
            if !searchText.isEmpty {
                selectSecondaryAccountTableView.isHidden = false
                filteredFirebaseAccounts = MIProcessor.sharedMIP.mIPAccounts.filter({ (accountItem) -> Bool in
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
                filteredFirebaseEntities = MIProcessor.sharedMIP.mIPEntities.filter({ (entityItem) -> Bool in
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
        let timeStampDictionaryForFirebase = [".sv": "timestamp"]
        let thisEntityItem = EntityItem(type: entityPickerView.selectedRow(inComponent: 0), name: addEntityNameTextField.text as String!, phoneNumber: addEntityPhoneNumberTextField.text as String!, email: addEntityEmailTextField.text as String!, street: addEntityStreetTextField.text as String!, city: addEntityCityTextField.text as String!, state: addEntityStateTextField.text as String!, ssn: addEntitySSNTextField.text as String!, ein: addEntityEINTextField.text as String!, timeStamp: timeStampDictionaryForFirebase)
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
            self.pickerCode = 6 // We are resetting this to 6 so that with tag = 0 it goes back to howDidTheyHearOfYou picker (or projectStatus if tag = 1)
            self.addEntityView.removeFromSuperview()
        default:
            popUpAnimateOut(popUpView: selectWhoView)
        }
        clearAddEntityFields()
        if !(entitySenderCode == 2){
            popUpAnimateOut(popUpView: addEntityView)
        }
        reloadSentence(selectedType: selectedType)
        //I deleted self.pickerCode = 0 here in case it was messing with the AddProject screen crashing.
    }
    
    @IBOutlet var subscriptionPopUpView: UIView!
    @IBOutlet weak var subscriptionProImage: UIImageView!
    
    @IBAction func subscriptionRestorePressed(_ sender: UIButton) {
        print("la")
    }
    
    @IBAction func subscriptionNotNowPressed(_ sender: UIButton) {
        self.popUpAnimateOut(popUpView: self.subscriptionPopUpView)
    }
    
    @IBAction func subscriptionBuyPressed(_ sender: UIButton) {
        print("la la")
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var underScrollView: UIView!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        if hasUserSpecialAccess == true {
            launchPhotos()
        } else {
            prePhotosNoSpecialPassSubscriptionCheck()
        }
    }
    
    func prePhotosNoSpecialPassSubscriptionCheck() {
        switch MIProcessor.sharedMIP.isUserCurrentlySubscribed {
        case true:
            launchPhotos()
        default:
            currentSubscriptionRef.observeSingleEvent(of: .value, with: { (snapshot) in
                print("W O A H 5")
                if snapshot.exists() {
                    if let timeInterval = snapshot.value as? TimeInterval {
                        print("W O A H 6")
                        let date = Date(timeIntervalSince1970: timeInterval)
                        if Date().compare(date) == .orderedAscending {
                            // Subscription is valid
                            print("W O A H 7")
                            MIProcessor.sharedMIP.isUserCurrentlySubscribed = true
                            self.currentlySubscribedRef.setValue(true)
                            self.launchPhotos()
                        } else {
                            print("W O A H 8")
                            MIProcessor.sharedMIP.isUserCurrentlySubscribed = false
                            self.currentlySubscribedRef.setValue(false)
                            self.performSegue(withIdentifier: "proSubscription", sender: self)
                        }
                    }
                    
                    // We need to refresh the subscription state from AppStore
                    self.bradsStore.restorePurchases { (isTrue, theString, err) in
                        if err != nil {
                            print(" H e y l o 5" + String(describing: err))
                        }
                        if isTrue {
                            // Subscription is valid
                            MIProcessor.sharedMIP.isUserCurrentlySubscribed = true
                            self.currentlySubscribedRef.setValue(true)
                            print(" H E Y L O 6 ")
                            self.launchPhotos()
                        } else {
                            // Subscription is invalid
                            MIProcessor.sharedMIP.isUserCurrentlySubscribed = false
                            self.currentlySubscribedRef.setValue(false)
                            print(" H E Y L O 7 ")
                            self.performSegue(withIdentifier: "proSubscription", sender: self)
                        }
                    }
                } else {
                    self.performSegue(withIdentifier: "proSubscription", sender: self)
                }
                
            })
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
    
    //PURE GOLD - THIS hides the tableview when user doesn't want to see it ie they tap outside of its bounds
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contactSuggestionsTableView.isHidden = true
        selectWhoTableView.isHidden = true
        selectWhomTableView.isHidden = true
        selectProjectTableView.isHidden = true
        selectVehicleTableView.isHidden = true
        selectAccountTableView.isHidden = true
        selectSecondaryAccountView.isHidden = true
        addProjectSelectCustomerTableView.isHidden = true
        addAccountTableView.isHidden = true
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
        
        TheAmtSingleton.shared.theAmt = 0
        TheAmtSingleton.shared.howMany = 0
        TheAmtSingleton.shared.theOdo = 0
        TheAmtSingleton.shared.theStartingBal = 0
        
        let typeItem = DropdownFlowItem(options: [
            DropdownFlowItem.Option(title: "Business", iconName: "business", action: { self.selectedType = 0; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Personal", iconName: "personal", action: { self.selectedType = 1; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Mixed", iconName: "mixed", action: { self.selectedType = 2; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Fuel", iconName: "fuel", action: { self.selectedType = 3; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Transfer", iconName: "transfer", action: { self.selectedType = 4; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Adjust", iconName: "adjustment", action: { self.selectedType = 5; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Project Media", iconName: "media", action: { self.selectedType = 6; self.reloadSentence(selectedType: self.selectedType) })
            ])
        leftTopView.configure(item: typeItem)
        
        if TheAmtSingleton.shared.theMIPNumber != -1 {
            leftTopView.isUserInteractionEnabled = false
        }
        
        reloadSentence(selectedType: selectedType)
        
        
        //Prevent empty cells in tableview
        selectVehicleTableView.tableFooterView = UIView(frame: .zero)
        selectProjectTableView.tableFooterView = UIView(frame: .zero)
        selectWhoTableView.tableFooterView = UIView(frame: .zero)
        selectWhomTableView.tableFooterView = UIView(frame: .zero)
        selectAccountTableView.tableFooterView = UIView(frame: .zero)
        selectSecondaryAccountTableView.tableFooterView = UIView(frame: .zero)
        addProjectSelectCustomerTableView.tableFooterView = UIView(frame: .zero)
        
        theFormatter.usesGroupingSeparator = true
        theFormatter.numberStyle = .currency
        
        overheadSwitch.isOn = false
        useTaxSwitch.isOn = false
        visualEffectView.isHidden = true
        
        self.genericPickerView.delegate = self
        self.genericPickerView.dataSource = self
        self.entityPickerView.delegate = self
        self.entityPickerView.dataSource = self
        self.projectStatusPickerView.delegate = self
        self.projectStatusPickerView.dataSource = self
        self.howDidTheyHearOfYouPickerView.delegate = self
        self.howDidTheyHearOfYouPickerView.dataSource = self
        self.addVehicleFuelPickerView.delegate = self
        self.addVehicleFuelPickerView.dataSource = self
        self.addAccountAccountTypePickerView.delegate = self
        self.addAccountAccountTypePickerView.dataSource = self
        
        //Set up pickers' data
        taxReasonPickerData = ["Income", "Supplies", "Labor", "Meals", "Office", "Vehicle", "Advertising", "Pro Help", "Machine Rental", "Property Rental", "Tax+License", "Insurance (WC+GL)", "Travel", "Employee Benefit", "Depreciation", "Depletion", "Utilities", "Commissions", "Wages", "Mortgate Interest", "Other Interest", "Pension", "Repairs"]
        wcPickerData = ["(Sub Has WC)", "(Incurred WC)", "(WC N/A)"]
        advertisingMeansPickerData = ["(Unknown)", "(Referral)", "(Website)", "(YP)", "(Social Media)", "(Soliciting)", "(Google Adwords)", "(Company Shirts)", "(Sign)", "(Vehicle Wrap)", "(Billboard)", "(TV)", "(Radio)", "(Other)"]
        howDidTheyHearOfYouPickerData = advertisingMeansPickerData
        personalReasonPickerData = ["Food", "Fun", "Pet", "Utilities", "Phone", "Office", "Giving", "Insurance", "House", "Yard", "Medical", "Travel", "Clothes", "Other"]
        fuelTypePickerData = ["87 Gas", "89 Gas", "91 Gas", "Diesel"]
        entityPickerData = ["Customer", "Vendor", "Sub", "Employee", "Store", "Government", "Other"] // You is at position 7 but not available to user
        projectMediaTypePickerData = ["Before", "During", "After", "Drawing", "Calculations", "Material List", "Estimate", "Contract", "Labor Warranty", "Material Warranty", "Safety", "Other"]
        projectStatusPickerData = ["Job Lead", "Bid", "Contract", "Paid", "Lost", "Other"]
        addAccountAccountTypePickerData = ["Bank Account", "Credit Account", "Cash Account", "Store Refund Account"]
        
        //Clip corners of all popups for better aesthetics
        selectProjectView.layer.cornerRadius = 5
        selectWhoView.layer.cornerRadius = 5
        selectWhomView.layer.cornerRadius = 5
        selectVehicleView.layer.cornerRadius = 5
        selectAccountView.layer.cornerRadius = 5
        selectSecondaryAccountView.layer.cornerRadius = 5
        
        //collectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        collectionView.collectionViewLayout = KTCenterFlowLayout()
        
        odometerTextField.formatter.numberStyle = NumberFormatter.Style.decimal
        odometerTextField.numberKind = 2
        odometerTextField.keyboardType = .numberPad
        odometerTextField.textColor = UIColor.BizzyColor.Grey.Notes
        odometerTextField.text = ""
        odometerTextField.placeholder = "Odometer"
        odometerTextField.allowedChars = "0123456789"
        odometerTextField.identifier = 2
        addAccountStartingBalanceTextField.formatter.numberStyle = NumberFormatter.Style.currency
        addAccountStartingBalanceTextField.numberKind = 0
        addAccountStartingBalanceTextField.keyboardType = .numbersAndPunctuation
        addAccountStartingBalanceTextField.text = ""
        addAccountStartingBalanceTextField.placeholder = "Starting (current) balance"
        addAccountStartingBalanceTextField.allowedChars = "-0123456789"
        addAccountStartingBalanceTextField.identifier = 3
        
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
        
        switch TheAmtSingleton.shared.theMIPNumber {
        case -1: //This is the real default, ie the one that will usually happen
            locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
        default: //Default is the editing case where user will pass a number through for Universal to be edited
            let thisUniversal = MIProcessor.sharedMIP.mIP[TheAmtSingleton.shared.theMIPNumber] as! UniversalItem
            thisUniversals.append(thisUniversal)
            leftTopView.setTheProgrammaticallySelectedRow(i: thisUniversal.universalItemType)
            loadAddUniversalForEditing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkPermissionForPhotos()
    }
    
    func loadAddUniversalForEditing() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteTapped))
        saveButton.title = "Update"
        addUniversalKeyString = thisUniversals[0].key
        selectedType = thisUniversals[0].universalItemType
        switch selectedType {
        case 1:
            notesTextField.text = thisUniversals[0].notes
            whoPlaceholder = thisUniversals[0].whoName
            whoPlaceholderKeyString = thisUniversals[0].whoKey
            TheAmtSingleton.shared.theAmt = thisUniversals[0].what
            whomPlaceholder = thisUniversals[0].whomName
            whomPlaceholderKeyString = thisUniversals[0].whomKey
            whatPersonalReasonPlaceholder = thisUniversals[0].personalReasonName
            whatPersonalReasonPlaceholderId = thisUniversals[0].personalReasonId
            yourAccountPlaceholder = thisUniversals[0].accountOneName
            yourAccountPlaceholderKeyString = thisUniversals[0].accountOneKey
            accountTypePlaceholderId = thisUniversals[0].accountOneType
            accountLabel.text = yourAccountPlaceholder
            if thisUniversals[0].picUrl != "" {
                downloadURL = URL(string: thisUniversals[0].picUrl)!
                if downloadURL != nil {
                    picNumber = thisUniversals[0].picNumber
                    downloadImage(url: downloadURL!)
                }
            }
            if thisUniversals[0].useTax {
                useTaxSwitch.isOn = true
            }
        case 2:
            projectPlaceholder = thisUniversals[0].projectItemName
            projectPlaceholderKeyString = thisUniversals[0].projectItemKey
            projectLabel.text = projectPlaceholder
            notesTextField.text = thisUniversals[0].notes
            whoPlaceholder = thisUniversals[0].whoName
            whoPlaceholderKeyString = thisUniversals[0].whoKey
            TheAmtSingleton.shared.theAmt = thisUniversals[0].what
            whomPlaceholder = thisUniversals[0].whomName
            whomPlaceholderKeyString = thisUniversals[0].whomKey
            whatPersonalReasonPlaceholder = thisUniversals[0].personalReasonName
            whatPersonalReasonPlaceholderId = thisUniversals[0].personalReasonId
            whatTaxReasonPlaceholder = thisUniversals[0].taxReasonName
            whatTaxReasonPlaceholderId = thisUniversals[0].taxReasonId
            switch whatTaxReasonPlaceholderId {
            case 2: //Labor
                workersCompPlaceholder = thisUniversals[0].workersCompName
                workersCompPlaceholderId = thisUniversals[0].workersCompId
            case 5:
                vehiclePlaceholder = thisUniversals[0].vehicleName
                vehiclePlaceholderKeyString = thisUniversals[0].vehicleKey
            case 6:
                advertisingMeansPlaceholder = thisUniversals[0].advertisingMeansName
                advertisingMeansPlaceholderId = thisUniversals[0].advertisingMeansId
            default:
                break
            }
            percentBusinessLabel.text = String(thisUniversals[0].percentBusiness) + "%"
            updateSliderValues(percent: thisUniversals[0].percentBusiness)
            self.thePercent = thisUniversals[0].percentBusiness
            percentBusinessTheSlider.value = Float(thisUniversals[0].percentBusiness)
            yourAccountPlaceholder = thisUniversals[0].accountOneName
            yourAccountPlaceholderKeyString = thisUniversals[0].accountOneKey
            accountTypePlaceholderId = thisUniversals[0].accountOneType
            accountLabel.text = yourAccountPlaceholder
            if thisUniversals[0].picUrl != "" {
                downloadURL = URL(string: thisUniversals[0].picUrl)!
                if downloadURL != nil {
                    picNumber = thisUniversals[0].picNumber
                    downloadImage(url: downloadURL!)
                }
            }
            if thisUniversals[0].useTax {
                useTaxSwitch.isOn = true
            }
        case 3:
            TheAmtSingleton.shared.theOdo = thisUniversals[0].odometerReading
            odometerTextField.setOdo()
            notesTextField.text = thisUniversals[0].notes
            TheAmtSingleton.shared.theAmt = thisUniversals[0].what
            whomPlaceholder = thisUniversals[0].whomName
            whomPlaceholderKeyString = thisUniversals[0].whomKey
            TheAmtSingleton.shared.howMany = thisUniversals[0].howMany
            fuelTypePlaceholder = thisUniversals[0].fuelTypeName
            fuelTypePlaceholderId = thisUniversals[0].fuelTypeId
            vehiclePlaceholder = thisUniversals[0].vehicleName
            vehiclePlaceholderKeyString = thisUniversals[0].vehicleKey
            yourAccountPlaceholder = thisUniversals[0].accountOneName
            yourAccountPlaceholderKeyString = thisUniversals[0].accountOneKey
            accountTypePlaceholderId = thisUniversals[0].accountOneType
            accountLabel.text = yourAccountPlaceholder
            if thisUniversals[0].picUrl != "" {
                downloadURL = URL(string: thisUniversals[0].picUrl)!
                if downloadURL != nil {
                    picNumber = thisUniversals[0].picNumber
                    downloadImage(url: downloadURL!)
                }
            }
        case 4: //Transfer - the only case using "primaryAccount..."
            notesTextField.text = thisUniversals[0].notes
            TheAmtSingleton.shared.theAmt = thisUniversals[0].what
            yourPrimaryAccountPlaceholder = thisUniversals[0].accountOneName
            yourPrimaryAccountPlaceholderKeyString = thisUniversals[0].accountOneKey
            primaryAccountTypePlaceholderId = thisUniversals[0].accountOneType
            yourSecondaryAccountPlaceholder = thisUniversals[0].accountTwoName
            yourSecondaryAccountPlaceholderKeyString = thisUniversals[0].accountTwoKey
            secondaryAccountTypePlaceholderId = thisUniversals[0].accountTwoType
            if thisUniversals[0].picUrl != "" {
                downloadURL = URL(string: thisUniversals[0].picUrl)!
                if downloadURL != nil {
                    picNumber = thisUniversals[0].picNumber
                    downloadImage(url: downloadURL!)
                }
            }
        case 6:
            projectPlaceholder = thisUniversals[0].projectItemName
            projectPlaceholderKeyString = thisUniversals[0].projectItemKey
            projectLabel.text = projectPlaceholder
            projectMediaTypePlaceholder = thisUniversals[0].projectPicTypeName
            projectMediaTypePlaceholderId = thisUniversals[0].projectPicTypeId
            projectStatusPlaceholder = thisUniversals[0].projectStatusString
            projectStatusPlaceholderId = thisUniversals[0].projectStatusId
            if thisUniversals[0].picUrl != "" {
                downloadURL = URL(string: thisUniversals[0].picUrl)!
                if downloadURL != nil {
                    picNumber = thisUniversals[0].picNumber
                    downloadImage(url: downloadURL!)
                }
            }
        default: //I.e., case 0
            projectPlaceholder = thisUniversals[0].projectItemName
            projectPlaceholderKeyString = thisUniversals[0].projectItemKey
            projectLabel.text = projectPlaceholder
            notesTextField.text = thisUniversals[0].notes
            whoPlaceholder = thisUniversals[0].whoName
            whoPlaceholderKeyString = thisUniversals[0].whoKey
            TheAmtSingleton.shared.theAmt = thisUniversals[0].what
            whomPlaceholder = thisUniversals[0].whomName
            whomPlaceholderKeyString = thisUniversals[0].whomKey
            whatTaxReasonPlaceholder = thisUniversals[0].taxReasonName
            whatTaxReasonPlaceholderId = thisUniversals[0].taxReasonId
            switch whatTaxReasonPlaceholderId {
            case 2: //Labor
                workersCompPlaceholder = thisUniversals[0].workersCompName
                workersCompPlaceholderId = thisUniversals[0].workersCompId
            case 5:
                vehiclePlaceholder = thisUniversals[0].vehicleName
                vehiclePlaceholderKeyString = thisUniversals[0].vehicleKey
            case 6:
                advertisingMeansPlaceholder = thisUniversals[0].advertisingMeansName
                advertisingMeansPlaceholderId = thisUniversals[0].advertisingMeansId
            default:
                break
            }
            yourAccountPlaceholder = thisUniversals[0].accountOneName
            yourAccountPlaceholderKeyString = thisUniversals[0].accountOneKey
            accountTypePlaceholderId = thisUniversals[0].accountOneType
            accountLabel.text = yourAccountPlaceholder
            if thisUniversals[0].picUrl != "" {
                downloadURL = URL(string: thisUniversals[0].picUrl)!
                if downloadURL != nil {
                    picNumber = thisUniversals[0].picNumber
                    downloadImage(url: downloadURL!)
                }
            }
            if thisUniversals[0].useTax {
                useTaxSwitch.isOn = true
            }
        }
        reloadSentence(selectedType: selectedType)
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                if let image = UIImage(data: data) {
                    let aspectRatio = image.size.height / image.size.width
                    let screenSize = UIScreen.main.bounds
                    let screenWidth = screenSize.width
                    let imageViewWidth = screenWidth
                    var widthConstraintConstant: CGFloat = 0
                    let screenWidthTwo = UIScreen.main.bounds.size.width
                    if screenWidthTwo > 374.0 {
                        widthConstraintConstant = 350.0
                    } else {
                        widthConstraintConstant = screenWidthTwo - (2 * 12)
                    }
                    let savedImageViewWidth = widthConstraintConstant
                    self.imageViewHeight = imageViewWidth * aspectRatio
                    self.imageViewHeightConstraint.constant = self.imageViewHeight
                    self.imageView.image = image
                }
            }
        }
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
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            aspectRatio = image.size.height / image.size.width
            
            var widthConstraintConstant: CGFloat = 0
            let screenWidthTwo = UIScreen.main.bounds.size.width
            if screenWidthTwo > 374.0 {
                widthConstraintConstant = 350.0
            } else {
                widthConstraintConstant = screenWidthTwo - (2 * 12)
            }
            let savedImageViewWidth = widthConstraintConstant
            
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let imageViewWidth = screenWidth
            
            imageViewHeight = imageViewWidth * aspectRatio
            //imageViewHeightInt = Int(savedImageViewWidth * aspectRatio) // This saves CORRECT height of image based on cardview width TAKING VARIOUS SCREEN SIZES INTO ACCOUNT just like is done in UniversalCardViewCollectionViewCell.swift
            imageViewHeightConstraint.constant = imageViewHeight
            imageView.image = image
            thereIsAnImage = true
            DispatchQueue.global(qos: .background).async {
                self.attemptImageUploadToFirebase(image: image)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func attemptImageUploadToFirebase(image: UIImage) {
        if let uploadData = UIImageJPEGRepresentation(image, 0.1) {
            self.currentlyUploading = true
            userCurrentImageIdCount += 1
            picNumber = userCurrentImageIdCount
            userCurrentImageIdCountString = String(userCurrentImageIdCount)
            userCurrentImageIdCountStringPlusType = userCurrentImageIdCountString + ".jpg"
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
                self.currentlyUploading = false
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
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Canceled")
        picker.dismiss(animated: true, completion: nil)
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
        let prepareTheBusinessAmt = (Double(TheAmtSingleton.shared.theAmt)/100) * (Double(percent)/100)
        let prepareThePersonalAmt = (Double(TheAmtSingleton.shared.theAmt)/100) * (1.0 - (Double(percent)/100))
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
        specialAccessRef = Database.database().reference().child("users").child(userUID).child("specialAccess")
        currentlySubscribedRef = Database.database().reference().child("users").child(userUID).child("currentlySubscribed")
        currentSubscriptionRef = Database.database().reference().child("users").child(userUID).child("subscriptionExpirationDate")
        userCurrentImageIdCountRef = Database.database().reference().child("users").child(userUID).child("userCurrentImageIdCount")
        specialAccessRef.observeSingleEvent(of: .value, with: { (snapshot) in
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
        })
        
        currentSubscriptionRef.observeSingleEvent(of: .value, with: { (snapshot) in
            print("W O A H ")
            if let timeInterval = snapshot.value as? TimeInterval {
                print("W O A H 2")
                let date = Date(timeIntervalSince1970: timeInterval)
                if Date().compare(date) == .orderedAscending {
                    // Subscription is valid
                    print("W O A H 3")
                    MIProcessor.sharedMIP.isUserCurrentlySubscribed = true
                    self.currentlySubscribedRef.setValue(true)
                    return
                } else {
                    print("W O A H 4")
                    MIProcessor.sharedMIP.isUserCurrentlySubscribed = false
                    self.currentlySubscribedRef.setValue(false)
                }
            }
            
            // We need to refresh the subscription state from AppStore
            self.bradsStore.restorePurchases { (isTrue, theString, err) in
                if err != nil {
                    print(" H e y l o " + String(describing: err))
                }
                if isTrue {
                    // Subscription is valid
                    MIProcessor.sharedMIP.isUserCurrentlySubscribed = true
                    self.currentlySubscribedRef.setValue(true)
                    print(" H E Y L O 2 ")
                } else {
                    // Subscription is invalid
                    MIProcessor.sharedMIP.isUserCurrentlySubscribed = false
                    self.currentlySubscribedRef.setValue(false)
                    print(" H E Y L O 3 ")
                }
            }
        })
        
        
        userCurrentImageIdCountRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let count = snapshot.value as? String {
                if let countAsInt = Int(count) {
                    self.userCurrentImageIdCount = countAsInt
                }
            }
        })
        youRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let youKey = snapshot.value as? String {
                self.trueYouKeyString = youKey
                if TheAmtSingleton.shared.theMIPNumber == -1 {
                    self.whoPlaceholder = "You"
                    self.whoPlaceholderKeyString = youKey
                    self.reloadSentence(selectedType: self.selectedType)
                }
            }
        })
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
    
    @IBOutlet var deleteView: UIView!
    @objc func deleteTapped() {
        popUpAnimateIn(popUpView: deleteView)
    }
    
    @IBAction func deleteViewCancelPressed(_ sender: Any) {
        popUpAnimateOut(popUpView: deleteView)
    }
    
    @IBAction func deleteViewDeletePressed(_ sender: UIButton) {
        if TheAmtSingleton.shared.theMIPNumber != -1 {
            if let uni = MIProcessor.sharedMIP.mIP[TheAmtSingleton.shared.theMIPNumber] as? UniversalItem {
                if uni.picUrl != "" {
                    let imageNode = String(uni.picNumber) + ".jpg"
                    let nodeRef = Storage.storage().reference().child("users").child(userUID).child(imageNode)
                    nodeRef.delete(completion: { (error) in
                        if let error = error {
                            print(String(describing: error))
                        } else {
                            print("Successfully deleted the image")
                        }
                    })
                }
            }
        }
        universalsRef.child(addUniversalKeyString).removeValue()
        popUpAnimateOut(popUpView: deleteView)
        TheAmtSingleton.shared.theAmt = 0
        TheAmtSingleton.shared.howMany = 0
        TheAmtSingleton.shared.theOdo = 0
        self.navigationController?.popViewController(animated: true)
    }
    
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
        popUpView.center.y = self.view.center.y - 50
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
        dataSource.items = [
            LabelFlowItem(text: whoPlaceholder, color: UIColor.BizzyColor.Blue.Who, action: { self.popUpAnimateIn(popUpView: self.selectWhoView) }),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            TextFieldFlowItem(text: stringifyAnInt.stringify(theInt: TheAmtSingleton.shared.theAmt), placeholder: "0", color: UIColor.BizzyColor.Green.What, keyboardType: .numberPad, allowedCharsString: digits, formatterStyle: NumberFormatter.Style.currency, numberKind: 0, identifier: 0),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            LabelFlowItem(text: whomPlaceholder, color: UIColor.BizzyColor.Purple.Whom, action: { self.popUpAnimateIn(popUpView: self.selectWhomView) }),
            LabelFlowItem(text: "for", color: .gray, action: nil),
            LabelFlowItem(text: whatTaxReasonPlaceholder, color: UIColor.BizzyColor.Magenta.TaxReason, action: { self.pickerCode = 0; self.popUpAnimateIn(popUpView: self.genericPickerView) })
        ]
        switch whatTaxReasonPlaceholderId {
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
        dataSource.items = [
            LabelFlowItem(text: whoPlaceholder, color: UIColor.BizzyColor.Blue.Who, action: { self.popUpAnimateIn(popUpView: self.selectWhoView) }),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            TextFieldFlowItem(text: stringifyAnInt.stringify(theInt: TheAmtSingleton.shared.theAmt), placeholder: "what amount", color: UIColor.BizzyColor.Green.What, keyboardType: UIKeyboardType.numberPad, allowedCharsString: digits, formatterStyle: NumberFormatter.Style.currency, numberKind: 0, identifier: 0),
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
        dataSource.items = [
            LabelFlowItem(text: whoPlaceholder, color: UIColor.BizzyColor.Blue.Who, action: { self.popUpAnimateIn(popUpView: self.selectWhoView) }),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            TextFieldFlowItem(text: stringifyAnInt.stringify(theInt: TheAmtSingleton.shared.theAmt), placeholder: "what amount", color: UIColor.BizzyColor.Green.What, keyboardType: UIKeyboardType.numberPad, allowedCharsString: digits, formatterStyle: NumberFormatter.Style.currency, numberKind: 0, identifier: 0),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            LabelFlowItem(text: whomPlaceholder, color: UIColor.BizzyColor.Purple.Whom, action: { self.popUpAnimateIn(popUpView: self.selectWhomView) }),
            LabelFlowItem(text: "for", color: .gray, action: nil),
            LabelFlowItem(text: whatPersonalReasonPlaceholder, color: UIColor.BizzyColor.Magenta.PersonalReason, action: { self.pickerCode = 3;  self.popUpAnimateIn(popUpView: self.genericPickerView) }),
            LabelFlowItem(text: "and", color: .gray, action: nil),
            LabelFlowItem(text: whatTaxReasonPlaceholder, color: UIColor.BizzyColor.Magenta.TaxReason, action: { self.pickerCode = 0; self.popUpAnimateIn(popUpView: self.genericPickerView) })
        ]
        switch whatTaxReasonPlaceholderId {
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
        dataSource.items = [
            LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: nil),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            TextFieldFlowItem(text: stringifyAnInt.stringify(theInt: TheAmtSingleton.shared.theAmt), placeholder: "what amount", color: UIColor.BizzyColor.Green.What, keyboardType: UIKeyboardType.numberPad, allowedCharsString: digits, formatterStyle: NumberFormatter.Style.currency, numberKind: 0, identifier: 0),
            LabelFlowItem(text: "to", color: .gray, action: nil), 
            LabelFlowItem(text: whomPlaceholder, color: UIColor.BizzyColor.Purple.Whom, action: { self.popUpAnimateIn(popUpView: self.selectWhomView) }),
            LabelFlowItem(text: "for", color: .gray, action: nil),
            TextFieldFlowItem(text: stringifyAnInt.stringify(theInt: TheAmtSingleton.shared.howMany, theNumberStyle: .decimal, theGroupingSeparator: true), placeholder: "how many", color: UIColor.BizzyColor.Green.What, keyboardType: UIKeyboardType.numberPad, allowedCharsString: digits, formatterStyle: NumberFormatter.Style.decimal, numberKind: 1, identifier: 1),
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
        dataSource.items = [
            LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: nil),
            LabelFlowItem(text: "moved", color: .gray, action: nil),
            TextFieldFlowItem(text: stringifyAnInt.stringify(theInt: TheAmtSingleton.shared.theAmt), placeholder: "what amount", color: UIColor.BizzyColor.Green.What, keyboardType: UIKeyboardType.numberPad, allowedCharsString: digits, formatterStyle: NumberFormatter.Style.currency, numberKind: 0, identifier: 0),
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
        dataSource.items = [
            LabelFlowItem(text: yourAccountPlaceholder, color: UIColor.BizzyColor.Green.Account, action: { self.popUpAnimateIn(popUpView: self.selectAccountView) }),
            LabelFlowItem(text: "with a Bizzy Books balance of", color: .gray, action: nil),
            LabelFlowItem(text: bizzyBooksBalanceString, color: UIColor.BizzyColor.Green.Account, action: nil),
            LabelFlowItem(text: "should have a balance of", color: .gray, action: nil),
            TextFieldFlowItem(text: stringifyAnInt.stringify(theInt: TheAmtSingleton.shared.theAmt), placeholder: "what amount", color: UIColor.BizzyColor.Green.What, keyboardType: UIKeyboardType.numbersAndPunctuation, allowedCharsString: negPossibleDigits, formatterStyle: NumberFormatter.Style.currency, numberKind: 0, identifier: 0)
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
        dataSource.items = [
            LabelFlowItem(text: projectMediaTypePlaceholder, color: UIColor.BizzyColor.Blue.Project, action: { self.pickerCode = 7; self.popUpAnimateIn(popUpView: self.genericPickerView) })
        ]
        if projectPlaceholderKeyString != "0" {
            dataSource.items.append(LabelFlowItem(text: projectStatusPlaceholder, color: UIColor.BizzyColor.Yellow.ProjectStatus, action: { self.pickerCode = 10; self.popUpAnimateIn(popUpView: self.genericPickerView) }))
        }
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
        
        switch pickerView.tag {
        case 0:
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
            case 10: // Under project MEDIA
                return projectStatusPickerData.count
            default:
                return taxReasonPickerData.count
            }
        default: // I.e., tag = 1, which is only true for Add Project which has two picker views
            return projectStatusPickerData.count
        }
        
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("displaying row \(row) with pickerCode \(pickerCode)")
        
        switch pickerView.tag {
        case 0:
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
            case 10: // Under project MEDIA
                return projectStatusPickerData[row]
            default:
                return taxReasonPickerData[row]
            }
        default: // I.e., tag = 1, which is only true for Add Project which has two picker views
            return projectStatusPickerData[row]
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case 0:
            switch pickerCode {
            case 1: //Worker's comp
                workersCompPlaceholder = wcPickerData[row]
                workersCompPlaceholderId = row
                popUpAnimateOut(popUpView: pickerView)
            case 2: //What kind of advertising did you purchase
                advertisingMeansPlaceholder = advertisingMeansPickerData[row]
                advertisingMeansPlaceholderId = row
                popUpAnimateOut(popUpView: pickerView)
            case 3: //What personal reason
                whatPersonalReasonPlaceholder = personalReasonPickerData[row]
                whatPersonalReasonPlaceholderId = row
                popUpAnimateOut(popUpView: pickerView)
            case 4: //Fuel type
                fuelTypePlaceholder = fuelTypePickerData[row]
                fuelTypePlaceholderId = row
                popUpAnimateOut(popUpView: pickerView)
            case 5: //Type of entity i.e. customer, sub, employee, store, etc.
                chosenEntity = row
            case 6: //How did they hear of you
                chosenHowDidTheyHearOfYou = row
                howDidTheyHearOfYouPlaceholder = howDidTheyHearOfYouPickerData[row]
            case 7: //Project media type
                projectMediaTypePlaceholder = projectMediaTypePickerData[row]
                projectMediaTypePlaceholderId = row
                popUpAnimateOut(popUpView: pickerView)
            case 8: //Fuel type picker inside addVehicleView
                let _ = 0 //Absolutely no reason except it wants something here
            case 9: //Add account account type picker stuff
                accountTypePlaceholder = addAccountAccountTypePickerData[row]
                accountTypePlaceholderId = row
            case 10: // 10 - project status picker under project MEDIA
                projectStatusPlaceholder = projectStatusPickerData[row]
                projectStatusPlaceholderId = row
                popUpAnimateOut(popUpView: pickerView)
            default: //What tax reason IE case 0
                whatTaxReasonPlaceholderId = row
                whatTaxReasonPlaceholder = taxReasonPickerData[row]
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
            }
        default: // I.e., tag = 1, which is only true for Add Project which has two picker views. Incidentally, pickercode will be 6 here because that's what the first-created picker view in add project happened to be, which will trigger BOTH pickers
            projectStatusPlaceholder = projectStatusPickerData[row]
            projectStatusPlaceholderId = row
        }
        
        if !(pickerCode == 5) && !(pickerCode == 6) && !(pickerCode == 8) && !(pickerCode == 9) && (pickerView.tag != 1) {
            reloadSentence(selectedType: selectedType)
        }
    }
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        returnIfAnyPertinentItemsForgotten()
    }
    
    func returnIfAnyPertinentItemsForgotten() {
        switch self.selectedType {
        case 0:
            guard projectPlaceholderKeyString != "" else { return }
            guard whoPlaceholderKeyString != "" else { return }
            guard whomPlaceholderKeyString != "" else { return }
            guard whoPlaceholderKeyString != whomPlaceholderKeyString else { return } //There wasn't a purchase if same person paid themselves - it should be handled as a TRANSFER case instead.
            guard ((whoPlaceholderKeyString == trueYouKeyString) || (whomPlaceholderKeyString == trueYouKeyString)) else { return } //Checks that the user is somehow involved in the transaction, else they needn't enter it!
            guard whatTaxReasonPlaceholderId != -1 else { return }
            if whatTaxReasonPlaceholderId == 2 {
                guard workersCompPlaceholderId != -1 else { return }
            } else if whatTaxReasonPlaceholderId == 5 {
                guard vehiclePlaceholderKeyString != "" else { return }
            } else if whatTaxReasonPlaceholderId == 6 {
                guard advertisingMeansPlaceholderId != -1 else { return }
            }
            if whatTaxReasonPlaceholderId == 0 {
                guard whoPlaceholderKeyString != trueYouKeyString else { return } //User can't pay themselves for a job
                guard whomPlaceholderKeyString == trueYouKeyString else { return } //User must receive money to be paid
            }
            guard yourAccountPlaceholderKeyString != "" else { return }
        case 1:
            guard whoPlaceholderKeyString != "" else { return }
            guard whomPlaceholderKeyString != "" else { return }
            guard ((whoPlaceholderKeyString == trueYouKeyString) || (whomPlaceholderKeyString == trueYouKeyString)) else { return } //Checks that the user is somehow involved in the transaction, else they needn't enter it!
            guard whatPersonalReasonPlaceholderId != -1 else { return }
            guard yourAccountPlaceholderKeyString != "" else { return }
        case 2:
            guard projectPlaceholderKeyString != "" else { return }
            guard whoPlaceholderKeyString != "" else { return }
            guard whomPlaceholderKeyString != "" else { return }
            guard whoPlaceholderKeyString == trueYouKeyString else { return } //Make sure user is making the labor payment!
            guard whatPersonalReasonPlaceholderId != -1 else { return }
            guard whatTaxReasonPlaceholderId != -1 else { return }
            if whatTaxReasonPlaceholderId == 2 {
                guard workersCompPlaceholderId != -1 else { return }
            } else if whatTaxReasonPlaceholderId == 5 {
                guard vehiclePlaceholderKeyString != "" else { return }
            } else if whatTaxReasonPlaceholderId == 6 {
                guard advertisingMeansPlaceholderId != -1 else { return }
            }
            guard whatTaxReasonPlaceholderId != 0 else { return } //There's no chance of getting income on mixed item
            guard yourAccountPlaceholderKeyString != "" else { return }
        case 3:
            guard odometerTextField.text != "" else { return }
            guard TheAmtSingleton.shared.theOdo != 0 else { return } // Odometer would never be zero
            guard whoPlaceholderKeyString != "" else { return }
            guard TheAmtSingleton.shared.theAmt != 0 else { return } // Fix bug at John's house - user can't pay nothing for fuel
            guard TheAmtSingleton.shared.howMany != 0 else { return } // Can't be 0 gallons of fuel
            guard whomPlaceholderKeyString != "" else { return }
            guard whomPlaceholderKeyString != trueYouKeyString else { return } //Checks that user doesn't try to pay themselves for their fuel!
            guard fuelTypePlaceholderId != -1 else { return }
            guard vehiclePlaceholderKeyString != "" else { return }
            guard yourAccountPlaceholderKeyString != "" else { return }
        case 4:
            guard yourPrimaryAccountPlaceholderKeyString != "" else { return }
            guard yourSecondaryAccountPlaceholderKeyString != "" else { return }
        case 5:
            guard yourAccountPlaceholderKeyString != "" else { return }
        case 6:
            guard projectPlaceholderKeyString != "" else { return }
            if projectMediaTypePlaceholderId != -1 {
                guard projectStatusPlaceholderId != -1 else { return } // Ensure a project status unless it's overhead
            }
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
        returnIfImageIsStillUploadingToFirebase()
    }
    
    func returnIfImageIsStillUploadingToFirebase() {
        if self.currentlyUploading == true {
            return
        } else {
            saveUniversal()
        }
    }
    
    func saveUniversal() {
        var notes = ""
        var urlString = ""
        let timeStampDictionaryForFirebase = [".sv": "timestamp"]
        //var odometerAsInt = 0
        if let theNotes = notesTextField.text {
            notes = theNotes
        }
        if let theUrl = downloadURL {
            urlString = theUrl.absoluteString
        }
        if (selectedType == 3) || (selectedType == 4) {
            /*
            if odometerTextField.text != "" {
                let odometerString = odometerTextField.text!
                let cleanedOdo = odometerString.replacingOccurrences(of: ",", with: "")
                odometerAsInt = Int(cleanedOdo)!
            }*/
            whoPlaceholder = "You"
            whoPlaceholderKeyString = trueYouKeyString
        }
        if selectedType == 6 {
            if projectPlaceholderKeyString != "0" {
                for mip in MIProcessor.sharedMIP.mIPProjects {
                    if mip.key == projectPlaceholderKeyString {
                        if projectStatusPlaceholderId != mip.projectStatusId {
                            projectsRef.child(mip.key).updateChildValues(["projectStatusId": projectStatusPlaceholderId, "projectStatusName": projectStatusPlaceholder])
                        }
                    }
                }
            }
        }
        if selectedType == 4 { //WAIT TILL NOW TO DO THIS SO AS NOT TO MESS WITH VIEWS
            yourAccountPlaceholder = yourPrimaryAccountPlaceholder
            yourAccountPlaceholderKeyString = yourPrimaryAccountPlaceholderKeyString
        }
        var intifiedAspectRatio: Int = 1
        if aspectRatio != 1 { // If it is 1, we don't want to multiply - we want to keep image height so tiny as to be negligible, but without presenting something over 0 which might cause a crash.
            intifiedAspectRatio = Int(aspectRatio * 1000)
        }
        switch TheAmtSingleton.shared.theMIPNumber {
        case -1: //The AddUniversal case
            let addUniversalKeyReference = universalsRef.childByAutoId()
            self.addUniversalKeyString = addUniversalKeyReference.key
            switch self.selectedType {
            case 5: //Adjust
                let difference = theBalanceAfter - TheAmtSingleton.shared.theAmt
                let correctedStartingBalance = theStartingBalance - difference
                let thisAccountRef = Database.database().reference().child("users").child(userUID).child("accounts")
                thisAccountRef.child(yourAccountPlaceholderKeyString).updateChildValues(["startingBal": correctedStartingBalance])
            default:
                let thisUniversalItem = UniversalItem(universalItemType: selectedType, projectItemName: projectPlaceholder, projectItemKey: projectPlaceholderKeyString, odometerReading: TheAmtSingleton.shared.theOdo, whoName: whoPlaceholder, whoKey: whoPlaceholderKeyString, what: TheAmtSingleton.shared.theAmt, whomName: whomPlaceholder, whomKey: whomPlaceholderKeyString, taxReasonName: whatTaxReasonPlaceholder, taxReasonId: whatTaxReasonPlaceholderId, vehicleName: vehiclePlaceholder, vehicleKey: vehiclePlaceholderKeyString, workersCompName: workersCompPlaceholder, workersCompId: workersCompPlaceholderId, advertisingMeansName: advertisingMeansPlaceholder, advertisingMeansId: advertisingMeansPlaceholderId, personalReasonName: whatPersonalReasonPlaceholder, personalReasonId: whatPersonalReasonPlaceholderId, percentBusiness: thePercent, accountOneName: yourAccountPlaceholder, accountOneKey: yourAccountPlaceholderKeyString, accountOneType: accountTypePlaceholderId, accountTwoName: yourSecondaryAccountPlaceholder, accountTwoKey: yourSecondaryAccountPlaceholderKeyString, accountTwoType: secondaryAccountTypePlaceholderId, howMany: TheAmtSingleton.shared.howMany, fuelTypeName: fuelTypePlaceholder, fuelTypeId: fuelTypePlaceholderId, useTax: thereIsUseTax, notes: notes, picUrl: urlString, picAspectRatio: intifiedAspectRatio, picNumber: picNumber, projectPicTypeName: projectMediaTypePlaceholder, projectPicTypeId: projectMediaTypePlaceholderId, timeStamp: timeStampDictionaryForFirebase, latitude: latitude, longitude: longitude, atmFee: atmFee, feeAmount: feeAmount, key: addUniversalKeyString)
                universalsRef.child(addUniversalKeyString).setValue(thisUniversalItem.toAnyObject())
            }
        default: //The UpdateUniversal case, where MIPnumber represents item number in array
            if let theNotes = notesTextField.text {
                notes = theNotes
            }
            if selectedType == 0 || selectedType == 1 || selectedType == 2 {
                if useTaxSwitch.isOn {
                    thereIsUseTax = true
                }
            }
            universalsRef.child(addUniversalKeyString).updateChildValues(["projectItemName": projectPlaceholder, "projectItemKey": projectPlaceholderKeyString, "odometerReading": TheAmtSingleton.shared.theOdo, "howMany": TheAmtSingleton.shared.howMany, "notes": notes, "whoName": whoPlaceholder, "whoKey": whoPlaceholderKeyString, "fuelTypeName": fuelTypePlaceholder, "fuelTypeId": fuelTypePlaceholderId, "what": TheAmtSingleton.shared.theAmt, "whomName": whomPlaceholder, "whomKey": whomPlaceholderKeyString, "taxReasonName": whatTaxReasonPlaceholder, "taxReasonId": whatTaxReasonPlaceholderId, "vehicleName": vehiclePlaceholder, "vehicleKey": vehiclePlaceholderKeyString, "workersCompName": workersCompPlaceholder, "workersCompId": workersCompPlaceholderId, "advertisingMeansName": advertisingMeansPlaceholder, "advertisingMeansId": advertisingMeansPlaceholderId, "personalReasonName": whatPersonalReasonPlaceholder, "personalReasonId": whatPersonalReasonPlaceholderId, "percentBusiness": thePercent, "accountOneName": yourAccountPlaceholder, "accountOneKey": yourAccountPlaceholderKeyString, "accountOneType": accountTypePlaceholderId, "accountTwoName": yourSecondaryAccountPlaceholder, "accountTwoKey": yourSecondaryAccountPlaceholderKeyString, "accountTwoType": secondaryAccountTypePlaceholderId, "picNumber": picNumber, "picUrl": urlString, "picAspectRatio": intifiedAspectRatio, "useTax": thereIsUseTax, "projectPicTypeName": projectMediaTypePlaceholder, "projectPicTypeId": projectMediaTypePlaceholderId])
        }
        TheAmtSingleton.shared.theAmt = 0
        TheAmtSingleton.shared.howMany = 0
        TheAmtSingleton.shared.theOdo = 0
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.leftTopView.dropDownMenu.reloadAllComponents()
        self.leftTopView.dropDownMenu.closeAllComponents(animated: true)
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
        case self.addAccountTableView:
            return recommendedContacts.count
        default:
            return recommendedContacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        switch tableView {
        case contactSuggestionsTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
            let contact = recommendedContacts[indexPath.row]
            let name = contact.givenName + " " + contact.familyName
            cell!.textLabel!.text = name
        case selectWhoTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SelectWhoCell", for: indexPath)
            let who = filteredFirebaseEntities[indexPath.row]
            let name = who.name
            cell!.textLabel!.text = name
        case selectWhomTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SelectWhomCell", for: indexPath)
            let whom = filteredFirebaseEntities[indexPath.row]
            let name = whom.name
            cell!.textLabel!.text = name
        case selectProjectTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SelectProjectCell", for: indexPath)
            let project = filteredFirebaseProjects[indexPath.row]
            let name = project.name
            cell!.textLabel!.text = name
        case selectVehicleTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SelectVehicleCell", for: indexPath)
            let vehicle = filteredFirebaseVehicles[indexPath.row]
            let name = vehicle.year + " " + vehicle.make + " " + vehicle.model
            cell!.textLabel!.text = name
        case selectAccountTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SelectAccountCell", for: indexPath)
            let account = filteredFirebaseAccounts[indexPath.row]
            let name = account.name
            cell!.textLabel!.text = name
        case selectSecondaryAccountTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "SelectSecondaryAccountCell", for: indexPath)
            let secondaryAccount = filteredFirebaseAccounts[indexPath.row]
            let name = secondaryAccount.name
            cell!.textLabel!.text = name
        case addProjectSelectCustomerTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "AddProjectSelectCustomerCell", for: indexPath)
            let customer = filteredFirebaseEntities[indexPath.row]
            let name = customer.name
            cell!.textLabel!.text = name
        case addAccountTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "AccountContactCell", for: indexPath)
            let contact = recommendedContacts[indexPath.row]
            let name = contact.givenName + " " + contact.familyName
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
            self.tempTypeHolderId = account.accountTypeId
            self.filteredFirebaseAccounts.removeAll() //This critical line empties the array so when secondary account is clicked, it doesn't pre-fill with all the data from last time!! And so with all the other cases.
        case self.selectSecondaryAccountTableView:
            let secondaryAccount = filteredFirebaseAccounts[indexPath.row]
            self.selectSecondaryAccountTableView.isHidden = true
            self.selectSecondaryAccountTextField.text = secondaryAccount.name
            self.tempKeyHolder = secondaryAccount.key
            self.tempTypeHolderId = secondaryAccount.accountTypeId
            self.filteredFirebaseAccounts.removeAll()
        case self.addProjectSelectCustomerTableView:
            let customer = filteredFirebaseEntities[indexPath.row]
            self.addProjectSelectCustomerTableView.isHidden = true
            self.addProjectSearchCustomerTextField.text = customer.name
            self.tempKeyHolder = customer.key
            self.filteredFirebaseEntities.removeAll()
        case self.addAccountTableView:
            let contact = self.recommendedContacts[indexPath.row]
            self.selectedContact = contact
            self.addAccountTableView.isHidden = true
            addAccountNameTextField.text = contact.givenName + " " + contact.familyName
            if (contact.isKeyAvailable(CNContactEmailAddressesKey)) {
                if let theEmail = contact.emailAddresses.first {
                    addAccountEmailTextField.text = theEmail.value as String
                }
            }
            if (contact.isKeyAvailable(CNContactPhoneNumbersKey)) {
                if let thePhoneNumber = contact.phoneNumbers.first  {
                    addAccountPhoneNumberTextField.text = thePhoneNumber.value.stringValue
                }
            }
            if (contact.isKeyAvailable(CNContactPostalAddressesKey)) {
                if let theAddress = contact.postalAddresses.first {
                    addAccountStreetTextField.text = theAddress.value.street
                    addAccountCityTextField.text = theAddress.value.city
                    addAccountStateTextField.text = theAddress.value.state
                }
            }
            self.recommendedContacts.removeAll()
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
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
