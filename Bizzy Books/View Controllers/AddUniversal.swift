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

class AddUniversal: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Contacts Stuff
    var recommendedContacts = [CNContact]()
    var selectedContact: CNContact?
    
    var digits = "0123456789"
    var negPossibleDigits = "0123456789-"
    let theFormatter = NumberFormatter()

    var masterRef: DatabaseReference!
    var entitiesRef: DatabaseReference!
    var projectsRef: DatabaseReference!
    var vehiclesRef: DatabaseReference!
    var accountsRef: DatabaseReference!
    var currentlySubscribedRef: DatabaseReference!
    
    var firebaseEntities = [EntityItem]()
    var firebaseProjects: [ProjectItem] = []
    var firebaseVehicles: [VehicleItem] = []
    var firebaseAccounts: [AccountItem] = []
    var filteredFirebaseEntities = [EntityItem]()
    var filteredFirebaseProjects: [ProjectItem] = []
    var filteredFirebaseVehicles: [VehicleItem] = []
    var filteredFirebaseAccounts: [AccountItem] = []
    var isUserCurrentlySubscribed: Bool = false
    
    var tempKeyHolder: String = ""
    
    private var universalArray = [0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1] //Notes and pic url will be ON THEIR OWN! Not really.
    private var chosenEntity = 0 //Customer by default
    private var chosenHowDidTheyHearOfYou = 0 //Unknown by default
    private let dataSource = LabelTextFieldFlowCollectionViewDataSource() //The collection view (ie., "sentence")
    var selectedType = 0
    var pickerCode = 0 {
        didSet {
            genericPickerView?.reloadAllComponents()
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
    var whatPeraonalReasonPlaceholderId = -1
    var projectPlaceholder = "Project ▾"
    var projectPlaceholderKeyString = ""
    var fuelTypePlaceholder = "fuel ▾"
    var fuelTypePlaceholderId = -1
    var vehiclePlaceholder = "vehicle ▾" //Fuel-up relevant vehicle
    var vehiclePlaceholderKeyString = ""
    var yourAccountPlaceholder = "Your account ▾"
    var yourAccountPlaceholderKeyString = ""
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
    var advertisingMeansPlaceholder = "Advertising means ▾ ?"
    var advertisingMeansPlaceholderId = -1
    var howDidTheyHearOfYouPlaceholder = "How did they hear of you ▾ ?"
    var howDidTheyHearOfYouPlaceholderId = -1
    var taxVehiclePlaceholder = "Which vehicle ▾ ?" //Tax reason relevant vehicle
    var taxVehiclePlaceholderKeyString = ""
    var projectMediaTypePlaceholder = "Type of picture ▾ ?"
    var projectMediaTypePlaceholderId = -1
    
    // 0 = Who, 1 = Whom, 2 = Project Customer
    var entitySenderCode = 0 {
        didSet {
            //isNegativeSwitch.isOn = false
        }
    }
    var primaryAccountTapped = false // Starts off false, can be changed to true (for filtering in transfer section)
    var timeStamp = 0
    var addEntityKeyString = ""
    var addProjectKeyString = ""
    var addVehicleKeyString = ""
    var addAccountKeyString = ""
    var addUniversalKeyString = ""
    
    var thePercent = 50
    var theAmt = 0
    var entityPickerData: [String] = [String]()
    var taxReasonPickerData: [String] = [String]()
    var wcPickerData: [String] = [String]()
    var advertisingMeansPickerData: [String] = [String]()
    var personalReasonPickerData: [String] = [String]()
    var fuelTypePickerData: [String] = [String]()
    var howDidTheyHearOfYouPickerData: [String] = [String]()
    var projectMediaTypePickerData: [String] = [String]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var leftTopView: DropdownFlowView!
    @IBOutlet weak var rightTopView: UIView!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var odometerTextField: AllowedCharsTextField!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
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
    @IBOutlet weak var overheadQuestionImage: UIImageView!
    @IBOutlet weak var projectTextField: UITextField!
    @IBAction func projectAddButtonTapped(_ sender: UIButton) {
        pickerCode = 6
        popUpAnimateIn(popUpView: addProjectView)
    }
    @IBAction func projectAcceptTapped(_ sender: UIButton) {
        if !tempKeyHolder.isEmpty && !projectTextField.text!.isEmpty{
            projectPlaceholderKeyString = tempKeyHolder
            projectPlaceholder = projectTextField.text!
            self.projectLabel.text = self.projectPlaceholder
            popUpAnimateOut(popUpView: selectProjectView)
            tempKeyHolder = ""
        }
    }
    @IBAction func projectDismissTapped(_ sender: UIButton) {
        popUpAnimateOut(popUpView: selectProjectView)
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
        pickerCode = 5
        entitySenderCode = 0
        popUpAnimateIn(popUpView: addEntityView)
    }
    @IBAction func whoDismissTapped(_ sender: UIButton) {
        popUpAnimateOut(popUpView: selectWhoView)
    }
    @IBAction func whoAcceptTapped(_ sender: UIButton) {
        if !tempKeyHolder.isEmpty && !selectWhoTextField.text!.isEmpty{
            whoPlaceholderKeyString = tempKeyHolder
            whoPlaceholder = selectWhoTextField.text!
            popUpAnimateOut(popUpView: selectWhoView)
            tempKeyHolder = ""
        }
    }
    
    //Whom Popup Items
    @IBOutlet var selectWhomView: UIView!
    @IBOutlet weak var selectWhomTableView: UITableView!
    @IBOutlet weak var selectWhomTextField: UITextField!
    @IBAction func whomAddButtonTapped(_ sender: UIButton) {
        pickerCode = 5
        entitySenderCode = 1
        popUpAnimateIn(popUpView: addEntityView)
    }
    @IBAction func whomDismissTapped(_ sender: UIButton) {
        popUpAnimateOut(popUpView: selectWhomView)
    }
    @IBAction func whomAcceptTapped(_ sender: UIButton) {
        if !tempKeyHolder.isEmpty && !selectWhomTextField.text!.isEmpty{
            whomPlaceholderKeyString = tempKeyHolder
            whomPlaceholder = selectWhomTextField.text!
            popUpAnimateOut(popUpView: selectWhomView)
            tempKeyHolder = ""
        }
    }
    
    //Vehicle Popup Items
    @IBOutlet var selectVehicleView: UIView!
    @IBOutlet weak var selectVehicleTableView: UITableView!
    @IBOutlet weak var selectVehicleTextField: UITextField!
    @IBAction func vehicleAddButtonTapped(_ sender: UIButton) {
        pickerCode = 4
        popUpAnimateIn(popUpView: addVehicleView)
    }
    @IBAction func vehicleDismissTapped(_ sender: UIButton) {
        popUpAnimateOut(popUpView: selectVehicleView)
    }
    @IBAction func vehicleAcceptTapped(_ sender: UIButton) {
        if !tempKeyHolder.isEmpty && !selectVehicleTextField.text!.isEmpty{
            vehiclePlaceholderKeyString = tempKeyHolder
            vehiclePlaceholder = selectVehicleTextField.text!
            popUpAnimateOut(popUpView: selectVehicleView)
            tempKeyHolder = ""
        }
    }
    
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
            let thisAccountItem = AccountItem(name: addAccountNameTextField.text!, phoneNumber: addAccountPhoneNumberTextField.text!, email: addAccountEmailTextField.text!, street: addAccountStreetTextField.text!, city: addAccountCityTextField.text!, state: addAccountStateTextField.text!, startingBal: addAccountStartingBalanceTextField.amt)
            accountsRef.child(addAccountKeyString).setValue(thisAccountItem.toAnyObject())
            popUpAnimateOut(popUpView: addAccountView)
            if self.accountSenderCode == 0 {
                yourAccountPlaceholderKeyString = addAccountKeyString
                yourAccountPlaceholder = thisAccountItem.name
            } else if self.accountSenderCode == 1 {
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
                if self.accountSenderCode == 1 {
                    self.selectSecondaryAccountView.removeFromSuperview()
                    self.accountSenderCode = 0
                } else {
                    self.selectAccountView.removeFromSuperview()
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
        popUpAnimateIn(popUpView: addAccountView)
    }
    @IBAction func accountDismissTapped(_ sender: UIButton) {
        if primaryAccountTapped == true {
            primaryAccountTapped = false
        }
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
            popUpAnimateOut(popUpView: selectAccountView)
            tempKeyHolder = ""
            if primaryAccountTapped == true {
                primaryAccountTapped = false
            }
        }
    }
    
    //Secondary Account Popup Items (always to)
    @IBOutlet var selectSecondaryAccountView: UIView!
    @IBOutlet weak var selectSecondaryAccountTableView: UITableView!
    @IBOutlet weak var selectSecondaryAccountTextField: UITextField!
    @IBAction func secondaryAccountAddButtonTapped(_ sender: UIButton) {
        filteredFirebaseAccounts.removeAll()
        selectSecondaryAccountTableView.reloadData()
        accountSenderCode = 1
        popUpAnimateIn(popUpView: addAccountView)
    }
    @IBAction func secondaryAccountDismissTapped(_ sender: UIButton) {
        filteredFirebaseAccounts.removeAll()
        selectSecondaryAccountTableView.reloadData()
        popUpAnimateOut(popUpView: selectSecondaryAccountView)
    }
    @IBAction func secondaryAccountAcceptTapped(_ sender: UIButton) {
        if !tempKeyHolder.isEmpty && !selectSecondaryAccountTextField.text!.isEmpty{
            yourSecondaryAccountPlaceholderKeyString = tempKeyHolder
            yourSecondaryAccountPlaceholder = selectSecondaryAccountTextField.text!
            self.reloadSentence(selectedType: selectedType)
            popUpAnimateOut(popUpView: selectSecondaryAccountView)
            tempKeyHolder = ""
            filteredFirebaseAccounts.removeAll()
            selectSecondaryAccountTableView.reloadData()
        }
    }
    
    @IBOutlet weak var contactSuggestionsTableView: UITableView!
    
    //Use Tax View Items (not a popup, but part of bottom bar)
    @IBOutlet var useTaxSwitchContainer: UIView!
    @IBOutlet var useTaxSwitch: UISwitch!
    
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
    @IBAction func selectWhoTextFieldChanged(_ sender: UITextField) {
        tempKeyHolder = ""
        self.selectWhoTableView.isHidden = false
        if let searchText = sender.text {
            if !searchText.isEmpty {
                self.filteredFirebaseEntities.removeAll()
                let thisFilteredFirebaseEntities = firebaseEntities.filter({$0.name.localizedCaseInsensitiveContains(searchText)})
                for entity in thisFilteredFirebaseEntities {
                    self.filteredFirebaseEntities.append(entity)
                }
                print(self.filteredFirebaseEntities.count)
                self.selectWhoTableView.reloadData()
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
    @IBAction func selectWhomTextFieldChanged(_ sender: UITextField) {
        tempKeyHolder = ""
        self.selectWhomTableView.isHidden = false
        if let searchText = sender.text {
            if !searchText.isEmpty {
                filteredFirebaseEntities = firebaseEntities.filter({ (entityItem) -> Bool in
                    if entityItem.name.localizedCaseInsensitiveContains(searchText) {
                        return true
                    } else {
                        return false
                    }
                })
                selectWhomTableView.reloadData()
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
    @IBAction func selectProjectTextFieldChanged(_ sender: UITextField) {
        tempKeyHolder = ""
        self.selectProjectTableView.isHidden = false
        if let searchText = sender.text {
            if !searchText.isEmpty {
                filteredFirebaseProjects = firebaseProjects.filter({ (projectItem) -> Bool in
                    if projectItem.name.localizedCaseInsensitiveContains(searchText) {
                        return true
                    } else {
                        return false
                    }
                })
                selectProjectTableView.reloadData()
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
    @IBAction func selectVehicleTextFieldChanged(_ sender: UITextField) {
        tempKeyHolder = ""
        self.selectVehicleTableView.isHidden = false
        if let searchText = sender.text {
            if !searchText.isEmpty {
                filteredFirebaseVehicles = firebaseVehicles.filter({ (vehicleItem) -> Bool in
                    if vehicleItem.year.localizedCaseInsensitiveContains(searchText) || vehicleItem.make.localizedCaseInsensitiveContains(searchText) || vehicleItem.model.localizedCaseInsensitiveContains(searchText) {
                        return true
                    } else {
                        return false
                    }
                })
                selectVehicleTableView.reloadData()
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
    @IBAction func selectAccountTextFieldChanged(_ sender: UITextField) {
        tempKeyHolder = ""
        self.selectAccountTableView.isHidden = false
        if let searchText = sender.text {
            if !searchText.isEmpty {
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
    @IBAction func selectSecondaryAccountTextFieldChanged(_ sender: UITextField) {
        tempKeyHolder = ""
        self.selectSecondaryAccountTableView.isHidden = false
        if let searchText = sender.text {
            if !searchText.isEmpty {
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
    
    @IBAction func addProjectSelectCustomerTextFieldChanged(_ sender: UITextField) {
        tempKeyHolder = ""
        self.addProjectSelectCustomerTableView.isHidden = false
        if let searchText = sender.text {
            if !searchText.isEmpty {
                filteredFirebaseEntities = firebaseEntities.filter({ (entityItem) -> Bool in
                    if entityItem.name.localizedCaseInsensitiveContains(searchText) {
                        return true
                    } else {
                        return false
                    }
                })
                addProjectSelectCustomerTableView.reloadData()
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
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        /*
        guard SubscriptionService.shared.currentSessionId != nil,
            SubscriptionService.shared.hasReceiptData else {
                showRestoreAlert()
                return
        }*/
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
        
        //Set up pickers' data
        taxReasonPickerData = ["income", "supplies", "labor", "meals", "office", "vehicle", "advertising", "pro help", "machine rental", "property rental", "tax+license", "insurance (wc+gl)", "travel", "employee benefit", "depreciation", "depletion", "utilities", "commissions", "wages", "mortgate interest", "other interest", "pension", "repairs"]
        wcPickerData = ["(sub has wc)", "(incurred wc)", "(wc n/a)"]
        advertisingMeansPickerData = ["(unknown)", "(referral)", "(website)", "(yp)", "(social media)", "(soliciting)", "(google adwords)", "(company shirts)", "(sign)", "(vehicle wrap)", "(billboard)", "(tv)", "(radio)", "(other)"]
        howDidTheyHearOfYouPickerData = advertisingMeansPickerData
        personalReasonPickerData = ["food", "fun", "pet", "utilities", "phone", "office", "giving", "insurance", "house", "yard", "medical", "travel", "clothes", "other"]
        fuelTypePickerData = ["87 gas", "89 gas", "91 gas", "diesel"]
        entityPickerData = ["customer", "vendor", "sub", "employee", "store", "other"]
        projectMediaTypePickerData = ["before", "during", "after", "drawing", "calculations", "material list", "estimate", "contract", "labor warranty", "material warranty", "safety", "other"]
        
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

        let amountText = "$0.00 "
        let iconBusiness = "business"
        let iconPersonal = "personal"
        setTextAndIconOnLabel(text: amountText, icon: iconBusiness, label: amountBusinessLabel)
        setTextAndIconOnLabel(text: amountText, icon: iconPersonal, label: amountPersonalLabel)
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
        masterRef = Database.database().reference().child("users").child(userUID)
        entitiesRef = Database.database().reference().child("users").child(userUID).child("entities")
        projectsRef = Database.database().reference().child("users").child(userUID).child("projects")
        vehiclesRef = Database.database().reference().child("users").child(userUID).child("vehicles")
        accountsRef = Database.database().reference().child("users").child(userUID).child("accounts")
        currentlySubscribedRef = Database.database().reference().child("users").child(userUID).child("currentlySubscribed")
        entitiesRef.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let firebaseEntity = EntityItem(snapshot: item as! DataSnapshot)
                print(firebaseEntity)
                self.firebaseEntities.append(firebaseEntity)
            }
            print(self.firebaseEntities)
            print(self.filteredFirebaseEntities)
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
            //let subscribed = 
        }
        //masterRef.setValue(["username": "Brad Caldwell"]) //This erases all siblings!!!!!! Including any childrenbyautoid!!!
        //masterRef.childByAutoId().setValue([3, 4, -88, 45, true])
    }
    
    @objc func useTaxSwitchToggled(useTaxSwitch: UISwitch) {
        print("Use tax switch toggled")
    }
    
    @objc func handleProjectLabelTap(projectLabelGestureRecognizer: UITapGestureRecognizer){
        popUpAnimateIn(popUpView: selectProjectView)
    }
    
    @objc func handleAccountLabelTap(accountLabelGestureRecognizer: UITapGestureRecognizer) {
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
    
    func popUpAnimateIn(popUpScrollView: UIScrollView) {
        self.view.addSubview(popUpScrollView)
        popUpScrollView.center = self.view.center
        popUpScrollView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpScrollView.alpha = 0
        
        UIScrollView.animate(withDuration: 0.4) {
            self.visualEffectView.isHidden = false
            popUpScrollView.alpha = 1
            popUpScrollView.transform = CGAffineTransform.identity
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
    
    func popUpAnimateOut(popUpScrollView: UIScrollView) {
        UIScrollView.animate(withDuration: 0.4, animations: {
            popUpScrollView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            popUpScrollView.alpha = 0
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            popUpScrollView.removeFromSuperview()
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
            dataSource.items.append(LabelFlowItem(text: taxVehiclePlaceholder, color: UIColor.BizzyColor.Orange.Vehicle, action: { self.popUpAnimateIn(popUpView: self.selectVehicleView) }))
        case 6:
            dataSource.items.append(LabelFlowItem(text: advertisingMeansPlaceholder, color: UIColor.BizzyColor.Orange.AdMeans, action: { self.pickerCode = 2; self.popUpAnimateIn(popUpView: self.genericPickerView) }))
        default:
            break
        }
        //dataSource.theTextFieldYes.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
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
            LabelFlowItem(text: whoPlaceholder, color: UIColor.BizzyColor.Blue.Who, action: { self.popUpAnimateIn(popUpView: self.selectWhoView) }),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            TextFieldFlowItem(text: "", amt: 0, placeholder: "what amount", color: UIColor.BizzyColor.Green.What, keyboardType: UIKeyboardType.numberPad, allowedCharsString: digits, formatterStyle: NumberFormatter.Style.currency, numberKind: 0),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            LabelFlowItem(text: whomPlaceholder, color: UIColor.BizzyColor.Purple.Whom, action: { self.popUpAnimateIn(popUpView: self.selectWhomView) }),
            LabelFlowItem(text: "for", color: .gray, action: nil),
            LabelFlowItem(text: whatTaxReasonPlaceholder, color: UIColor.BizzyColor.Magenta.TaxReason, action: { self.popUpAnimateIn(popUpView: self.genericPickerView); self.pickerCode = 0 }),
            LabelFlowItem(text: "and", color: .gray, action: nil),
            LabelFlowItem(text: whatPersonalReasonPlaceholder, color: UIColor.BizzyColor.Magenta.PersonalReason, action: { self.pickerCode = 3; self.popUpAnimateIn(popUpView: self.genericPickerView) })
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
        percentBusinessViewHeight.constant = 120
        bottomStackViewHeight.constant = 140
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
            TextFieldFlowItem(text: "", amt: 0, placeholder: "what amount", color: UIColor.BizzyColor.Green.What, keyboardType: UIKeyboardType.numberPad, allowedCharsString: digits, formatterStyle: NumberFormatter.Style.currency, numberKind: 0),
            LabelFlowItem(text: "from", color: .gray, action: nil),
            LabelFlowItem(text: yourPrimaryAccountPlaceholder, color: UIColor.BizzyColor.Green.Account, action: { self.primaryAccountTapped = true; self.popUpAnimateIn(popUpView: self.selectAccountView) }),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            LabelFlowItem(text: yourSecondaryAccountPlaceholder, color: UIColor.BizzyColor.Green.Account, action: { self.popUpAnimateIn(popUpView: self.selectSecondaryAccountView) })
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
            LabelFlowItem(text: yourAccountPlaceholder, color: UIColor.BizzyColor.Green.Account, action: { self.popUpAnimateIn(popUpView: self.selectAccountView) }),
            LabelFlowItem(text: "with a Bizzy Books balance of", color: .gray, action: nil),
            LabelFlowItem(text: bizzyBooksBalanceString, color: UIColor.BizzyColor.Green.Account, action: nil),
            LabelFlowItem(text: "should have a balance of", color: .gray, action: nil),
            TextFieldFlowItem(text: "", amt: 0, placeholder: "what amount", color: UIColor.BizzyColor.Green.What, keyboardType: UIKeyboardType.numbersAndPunctuation, allowedCharsString: negPossibleDigits, formatterStyle: NumberFormatter.Style.currency, numberKind: 0)
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
    
    func projectMediaCase() {
        universalArray[0] = 6
        dataSource.items = [
            LabelFlowItem(text: projectMediaTypePlaceholder, color: UIColor.BizzyColor.Blue.Project, action: { self.pickerCode = 7; self.popUpAnimateIn(popUpView: self.genericPickerView) })
        ]
        projectLabel.isHidden = false
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
        default:
            return taxReasonPickerData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerCode {
        case 0: //What tax reason
            universalArray[6] = row
            self.whatTaxReasonPlaceholder = taxReasonPickerData[row]
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
            self.workersCompPlaceholder = wcPickerData[row]
            popUpAnimateOut(popUpView: pickerView)
        case 2: //What kind of advertising did you purchase
            universalArray[9] = row
            self.advertisingMeansPlaceholder = advertisingMeansPickerData[row]
            popUpAnimateOut(popUpView: pickerView)
        case 3: //What personal reason
            universalArray[10] = row
            self.whatPersonalReasonPlaceholder = personalReasonPickerData[row]
            popUpAnimateOut(popUpView: pickerView)
        case 4: //Fuel type
            universalArray[15] = row
            self.fuelTypePlaceholder = fuelTypePickerData[row]
        case 5: //Type of entity i.e. customer, sub, employee, store, etc.
            chosenEntity = row
        case 6: //How did they hear of you
            chosenHowDidTheyHearOfYou = row
        case 7: //Project media type
            self.projectMediaTypePlaceholder = projectMediaTypePickerData[row]
            self.projectMediaTypePlaceholderId = row
            popUpAnimateOut(popUpView: pickerView)
        default: //What tax reason
            universalArray[6] = row
            self.whatTaxReasonPlaceholder = taxReasonPickerData[row]
            popUpAnimateOut(popUpView: pickerView)
        }
        if !(pickerCode == 4) && !(pickerCode == 5) && !(pickerCode == 6) {
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
            self.selectVehicleTextField.text = vehicle.year + "" + vehicle.make + "" + vehicle.model
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


