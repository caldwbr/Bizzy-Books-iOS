//
//  ViewController.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 9/23/16.
//  Copyright © 2016 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseDatabaseUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FBSDKCoreKit
import FBSDKLoginKit
import Contacts

var userUID = ""
var userTokens = ""

class ViewController: UIViewController, FUIAuthDelegate, UIGestureRecognizerDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case editProjectProjectStatusPickerView:
            return projectStatusPickerData.count
        case editProjectAddEntityRelationPickerView:
            return relationPickerData.count
        case editEntityRelationPickerView:
            return relationPickerData.count
        case editVehicleFuelTypePickerView:
            return fuelTypePickerData.count
        case editAccountTypePickerView:
            return accountTypePickerData.count
        default: // I.e., howDidTheyHearOfYouPickerView
            return howDidTheyHearOfYouPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case editProjectProjectStatusPickerView:
            return projectStatusPickerData[row]
        case editProjectAddEntityRelationPickerView:
            return relationPickerData[row]
        case editEntityRelationPickerView:
            return relationPickerData[row]
        case editVehicleFuelTypePickerView:
            return fuelTypePickerData[row]
        case editAccountTypePickerView:
            return accountTypePickerData[row]
        default:
            return howDidTheyHearOfYouPickerData[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case editProjectProjectStatusPickerView:
            projectStatusId = row
        case editProjectAddEntityRelationPickerView:
            entityRelationId = row
        case editEntityRelationPickerView:
            entityRelationId = row
        case editVehicleFuelTypePickerView:
            fuelTypeId = row
        case editAccountTypePickerView:
            accountTypeId = row
        default: // I.e., howDidTheyHearOfYouPickerView
            howDidTheyHearOfYouId = row
        }
    }
    
    let timeStampDictionaryForFirebase = [".sv": "timestamp"]
    var masterRef: DatabaseReference!
    var projectsRef: DatabaseReference!
    var accountsRef: DatabaseReference!
    var vehiclesRef: DatabaseReference!
    var projectStatusPickerData: [String] = [String]()
    var howDidTheyHearOfYouPickerData: [String] = [String]()
    var relationPickerData: [String] = [String]()
    var fuelTypePickerData: [String] = [String]()
    var accountTypePickerData: [String] = [String]()
    var kFacebookAppID = "1583985615235483"
    var backgroundImage : UIImageView! //right here
    var entitiesRef: DatabaseReference!
    var youEntityRef: DatabaseReference!
    var firstTimeRef: DatabaseReference!
    var addEntityKeyString: String = ""
    var filteredBizzyEntities: [EntityItem] = [EntityItem]()
    var filteredIPhoneEntities = [CNContact]()
    var selectedIPhoneEntity: CNContact?
    @IBOutlet weak var cardViewCollectionView: UICollectionView!
    //var multiversalItems = [MultiversalItem]()
    var shouldEnterLoop = true
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        editProjectTableView.isHidden = true
        editProjectAddEntityTableView.isHidden = true
        editEntityTableView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.editProjectTableView.keyboardDismissMode = .interactive
        self.editProjectAddEntityTableView.keyboardDismissMode = .interactive
        self.editEntityTableView.keyboardDismissMode = .interactive
        
        TheAmtSingleton.shared.theStartingBal = 0
        editAccountStartingBalanceTextField.formatter.numberStyle = NumberFormatter.Style.currency
        editAccountStartingBalanceTextField.numberKind = 0
        editAccountStartingBalanceTextField.keyboardType = .numbersAndPunctuation
        editAccountStartingBalanceTextField.text = ""
        editAccountStartingBalanceTextField.placeholder = "Starting (current) balance"
        editAccountStartingBalanceTextField.allowedChars = "-0123456789"
        editAccountStartingBalanceTextField.identifier = 3
        
        //Prevent empty cells in tableview
        editProjectTableView.tableFooterView = UIView(frame: .zero)
        editProjectAddEntityTableView.tableFooterView = UIView(frame: .zero)
        editEntityTableView.tableFooterView = UIView(frame: .zero)
        
        cardViewCollectionView.register(UINib.init(nibName: "UniversalCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UniversalCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "UniversalTransferCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UniversalTransferCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "UniversalProjectMediaCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UniversalProjectMediaCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "ProjectCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProjectCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "EntityCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EntityCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "AccountCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AccountCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "VehicleCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VehicleCardViewCollectionViewCell")
        cardViewCollectionView.dataSource = self
        cardViewCollectionView.delegate = self
        editProjectProjectStatusPickerView.delegate = self
        editProjectProjectStatusPickerView.dataSource = self
        editProjectHowDidTheyHearOfYouPickerView.delegate = self
        editProjectHowDidTheyHearOfYouPickerView.dataSource = self
        editProjectAddEntityRelationPickerView.delegate = self
        editProjectAddEntityRelationPickerView.dataSource = self
        editEntityRelationPickerView.delegate = self
        editEntityRelationPickerView.dataSource = self
        editVehicleFuelTypePickerView.delegate = self
        editVehicleFuelTypePickerView.dataSource = self
        editAccountTypePickerView.delegate = self
        editAccountTypePickerView.dataSource = self
        projectStatusPickerData = ["Job Lead", "Bid", "Contract", "Paid", "Lost", "Other"]
        howDidTheyHearOfYouPickerData = ["(Unknown)", "(Referral)", "(Website)", "(YP)", "(Social Media)", "(Soliciting)", "(Google Adwords)", "(Company Shirts)", "(Sign)", "(Vehicle Wrap)", "(Billboard)", "(TV)", "(Radio)", "(Other)"]
        relationPickerData = ["Customer", "Vendor", "Sub", "Employee", "Store", "Government", "Other"]
        fuelTypePickerData = ["87 Gas", "89 Gas", "91 Gas", "Diesel"]
        accountTypePickerData = ["Bank Account", "Credit Account", "Cash Account", "Store Refund Account"]
        /*if let cardViewFlowLayout = cardViewCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            cardViewFlowLayout.estimatedItemSize = CGSize(width: 350, height: 500)
        }*/
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.cardViewCollectionView.addGestureRecognizer(lpgr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkLoggedIn()
    }

    @IBOutlet var welcomeView: UIView!
    @IBAction func welcomeViewGotItPressed(_ sender: UIButton) {
        popUpAnimateOut(popUpView: welcomeView)
    }
    @IBOutlet weak var profilePic: UIImageView!
    
    func checkLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                userUID = (user?.uid)!
                if user?.photoURL == nil {
                }else{
                    if let imageUrl = NSData(contentsOf: (user?.photoURL)!){
                        self.profilePic.image = UIImage(data: imageUrl as Data)
                    } else {
                        self.profilePic.image = UIImage(named: "bizzybooksbee")
                    }
                }
                self.masterRef = Database.database().reference().child("users").child(userUID)
                self.projectsRef = Database.database().reference().child("users").child(userUID).child("projects")
                self.entitiesRef = Database.database().reference().child("users").child(userUID).child("entities")
                self.accountsRef = Database.database().reference().child("users").child(userUID).child("accounts")
                self.vehiclesRef = Database.database().reference().child("users").child(userUID).child("vehicles")
                self.youEntityRef = Database.database().reference().child("users").child(userUID).child("youEntity")
                self.firstTimeRef = Database.database().reference().child("users").child(userUID).child("firstTime")
                self.initializeIfFirstAppUse()
                self.masterRef.observe(.childChanged , with: { (snapshot) in // GENIUS!!!!! This line loads MIP only when an item gets added/changed/deleted (and exactly WHEN an item gets added/changed/deleted) in Firebase database IN REALTIME!!!!
                    self.loadTheMIP()
                })
                if MIProcessor.sharedMIP.mIP.count == 0 {
                    if self.shouldEnterLoop {
                        self.shouldEnterLoop = false
                        self.loadTheMIP()
                    }
                }
            } else {
                // No user is signed in.
                self.login()
            }
        }
    }
    
    func login() {
        let authUI = FUIAuth.defaultAuthUI()
        let providers: [FUIAuthProvider] = [FUIGoogleAuth(), FUIFacebookAuth()]
        authUI?.providers = providers
        authUI?.delegate = self as FUIAuthDelegate
        
        let authViewController = BizzyAuthViewController(authUI: authUI!)
        let navc = UINavigationController(rootViewController: authViewController)
        self.present(navc, animated: true, completion: nil)
    }
    
    @IBAction func logoutUser(_: UIBarButtonItem) {
        try! Auth.auth().signOut()
    }
    
    @IBAction func addUniversalClicked(_: UIBarButtonItem) {
        TheAmtSingleton.shared.theMIPNumber = -1
        performSegue(withIdentifier: "createUniversal", sender: self)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if error != nil {
            //Problem signing in
            login()
        }else {
            //User is in! Here is where we code after signing in
            
        }
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionUniversalLinksOnly] as! String
        return FUIAuth.defaultAuthUI()!.handleOpen(url as URL, sourceApplication: sourceApplication )
    }
    
    func loadTheMIP() {
        //Starting with entities for testing
        DispatchQueue.main.async {
            MIProcessor.sharedMIP.loadTheMip {
                MIProcessor.sharedMIP.obtainTheBalancesAfter()
                MIProcessor.sharedMIP.loadTheStatuses()
                MIProcessor.sharedMIP.updateTheMIP()
                self.cardViewCollectionView.reloadData()//Critical line - this makes or breaks the app :/
            }
        }
    }
    @IBOutlet weak var vcvisualEffectsView: UIVisualEffectView!
    
    func popUpAnimateIn(popUpView: UIView) {
        self.view.addSubview(popUpView)
        popUpView.center = self.view.center
        popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.vcvisualEffectsView.isHidden = false
            popUpView.alpha = 1
            popUpView.transform = CGAffineTransform.identity
        }
    }
    
    func popUpAnimateOut(popUpView: UIView) {
        UIView.animate(withDuration: 0.4, animations: {
            popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            popUpView.alpha = 0
        }) { (success:Bool) in
            self.vcvisualEffectsView.isHidden = true
            popUpView.removeFromSuperview()
        }
    }
    
    /*
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 350, height: 500)
    }
 */
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MIProcessor.sharedMIP.mIP.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let i = indexPath.item
        switch MIProcessor.sharedMIP.mIP[i].multiversalType {
        case 1:
            let cell = cardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCardViewCollectionViewCell", for: indexPath) as! ProjectCardViewCollectionViewCell
            cell.configure(i: i)
            return cell
        case 2:
            let cell = cardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "EntityCardViewCollectionViewCell", for: indexPath) as! EntityCardViewCollectionViewCell
            cell.configure(i: i)
            return cell
        case 3:
            let cell = cardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "AccountCardViewCollectionViewCell", for: indexPath) as! AccountCardViewCollectionViewCell
            cell.configure(i: i)
            return cell
        case 4:
            let cell = cardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "VehicleCardViewCollectionViewCell", for: indexPath) as! VehicleCardViewCollectionViewCell
            cell.configure(i: i)
            return cell
        default:
            let universal = MIProcessor.sharedMIP.mIP[i] as! UniversalItem
            switch universal.universalItemType {
            case 4:
                let cell = cardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "UniversalTransferCardViewCollectionViewCell", for: indexPath) as! UniversalTransferCardViewCollectionViewCell
                cell.configure(i: i)
                return cell
            case 6:
                let cell = cardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "UniversalProjectMediaCardViewCollectionViewCell", for: indexPath) as! UniversalProjectMediaCardViewCollectionViewCell
                cell.configure(i: i)
                return cell
            default: // I.e., cases 0, 1, 2, and 3 (most all cases!)
                let cell = cardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "UniversalCardViewCollectionViewCell", for: indexPath) as! UniversalCardViewCollectionViewCell
                cell.configure(i: i)
                return cell
            }
        }
    }
    
    @IBAction func editEntityNameTouchedDown(_ sender: UITextField) {
        if (sender.text) != nil {
            if !(sender.text?.isEmpty)! {
                if self.editEntityTableView.isHidden == false {
                    self.editEntityTableView.isHidden = true
                } else {
                    self.editEntityTableView.isHidden = false
                }
            }
        }
    }
    
    @IBAction func editEntityNameChanged(_ sender: UITextField) {
        entityNamePlaceholder = ""
        if let searchText = sender.text {
            editEntityClearFields() // PURE FREAKING GOLD!!!!! clears all fields out if user starts deleting already accepted entity - dont have to do some insane code checking for backspace pressed or anything!!!
            editEntityNameTextField.text = searchText
            if !searchText.isEmpty {
                ContactsLogicManager.shared.fetchContactsMatching(name: searchText, completion: { (contacts) in
                    if let theContacts = contacts {
                        self.filteredIPhoneEntities = theContacts
                        if self.filteredIPhoneEntities.count > 0 {
                            self.editEntityTableView.isHidden = false
                        } else {
                            self.editEntityTableView.isHidden = true // PURE GOLD - hides tableview if no match to current typing so that it's not in the way when you are just trying to add your own. THIS SHOULD NOT GO IN MOST TABLEVIEW ENTRY FIELDS AS MOST OF MY TABLEVIEWS require A MATCH.
                        }
                        self.editEntityTableView.reloadData()
                    }
                    else {
                        // Contact fetch failed
                        // Denied permission
                    }
                })
            } else {
                filteredIPhoneEntities.removeAll()
                editEntityTableView.reloadData()
                editEntityTableView.isHidden = true
            }
        }
    }
    
    @IBAction func editProjectAddEntityNameTouchedDown(_ sender: UITextField) {
        if (sender.text) != nil {
            if !(sender.text?.isEmpty)! {
                if self.editProjectAddEntityTableView.isHidden == false {
                    self.editProjectAddEntityTableView.isHidden = true
                } else {
                    self.editProjectAddEntityTableView.isHidden = false
                }
            }
        }
    }
    
    @IBAction func editProjectAddEntityNameChanged(_ sender: UITextField) {
        entityNamePlaceholder = ""
        if let searchText = sender.text {
            editProjectAddEntityClearFields() // PURE FREAKING GOLD!!!!! clears all fields out if user starts deleting already accepted entity - dont have to do some insane code checking for backspace pressed or anything!!!
            editProjectAddEntityNameTextField.text = searchText
            if !searchText.isEmpty {
                ContactsLogicManager.shared.fetchContactsMatching(name: searchText, completion: { (contacts) in
                    if let theContacts = contacts {
                        self.filteredIPhoneEntities = theContacts
                        if self.filteredIPhoneEntities.count > 0 {
                            self.editProjectAddEntityTableView.isHidden = false
                        } else {
                            self.editProjectAddEntityTableView.isHidden = true // PURE GOLD - hides tableview if no match to current typing so that it's not in the way when you are just trying to add your own. THIS SHOULD NOT GO IN MOST TABLEVIEW ENTRY FIELDS AS MOST OF MY TABLEVIEWS require A MATCH.
                        }
                        self.editProjectAddEntityTableView.reloadData()
                    }
                    else {
                        // Contact fetch failed
                        // Denied permission
                    }
                })
            } else {
                filteredIPhoneEntities.removeAll()
                editProjectAddEntityTableView.reloadData()
                editProjectAddEntityTableView.isHidden = true
            }
        }
    }
    
    @IBAction func editProjectCustomerNameTouchedDown(_ sender: UITextField) {
        if (sender.text) != nil {
            if !(sender.text?.isEmpty)! {
                if self.editProjectTableView.isHidden == false {
                    self.editProjectTableView.isHidden = true
                } else {
                    self.editProjectTableView.isHidden = false
                }
            }
        }
    }
    
    @IBAction func editProjectCustomerNameChanged(_ sender: UITextField) {
        customerNamePlaceholder = ""
        if let searchText = sender.text {
            if !searchText.isEmpty {
                editProjectTableView.isHidden = false
                self.filteredBizzyEntities.removeAll()
                let thisFilteredBizzyEntities = MIProcessor.sharedMIP.mIPEntities.filter({$0.name.localizedCaseInsensitiveContains(searchText)})
                for entity in thisFilteredBizzyEntities {
                    self.filteredBizzyEntities.append(entity)
                }
                self.editProjectTableView.reloadData()
            } else {
                filteredBizzyEntities.removeAll()
                editProjectTableView.reloadData()
                editProjectTableView.isHidden = true
            }
        }
    }
    
    @IBOutlet var editAccountView: UIView!
    @IBOutlet weak var editAccountNameTextField: UITextField!
    @IBOutlet weak var editAccountStartingBalanceTextField: AllowedCharsTextField!
    @IBOutlet weak var editAccountPhoneNumberTextField: UITextField!
    @IBOutlet weak var editAccountEmailTextField: UITextField!
    @IBOutlet weak var editAccountStreetTextField: UITextField!
    @IBOutlet weak var editAccountCityTextField: UITextField!
    @IBOutlet weak var editAccountStateTextField: UITextField!
    @IBOutlet weak var editAccountTypePickerView: UIPickerView!
    @IBAction func editAccountCancelPressed(_ sender: UIButton) {
        popUpAnimateOut(popUpView: editAccountView)
    }
    @IBAction func editAccountUpdatePressed(_ sender: UIButton) {
        guard editAccountNameTextField.text != "" else { return }
        guard accountKeyPlaceholder != "" else { return }
        guard editAccountStartingBalanceTextField.text != "" else { return }
        if let editAccountName = editAccountNameTextField.text {
            accountNamePlaceholder = editAccountName
        }
        accountStartingBalance = TheAmtSingleton.shared.theStartingBal
        if let editAccountPhoneNumber = editAccountPhoneNumberTextField.text {
            phoneNumberPlaceholder = editAccountPhoneNumber
        }
        if let editAccountEmail = editAccountEmailTextField.text {
            emailPlaceholder = editAccountEmail
        }
        if let editAccountStreet = editAccountStreetTextField.text {
            streetPlaceholder = editAccountStreet
        }
        if let editAccountCity = editAccountCityTextField.text {
            cityPlaceholder = editAccountCity
        }
        if let editAccountState = editAccountStateTextField.text {
            statePlaceholder = editAccountState
        }
        accountsRef.child(accountKeyPlaceholder).updateChildValues(["name": accountNamePlaceholder, "startingBal": accountStartingBalance, "phoneNumber": phoneNumberPlaceholder, "email": emailPlaceholder, "street": streetPlaceholder, "city": cityPlaceholder, "state": statePlaceholder, "accountTypeId": accountTypeId])
        popUpAnimateOut(popUpView: editAccountView)
    }
    var accountKeyPlaceholder = ""
    var accountNamePlaceholder = ""
    var accountStartingBalance = 0
    var accountTypeId = 0
    
    @IBOutlet var editVehicleView: UIView!
    @IBOutlet weak var editVehicleColorTextField: UITextField!
    @IBOutlet weak var editVehicleYearTextField: UITextField!
    @IBOutlet weak var editVehicleMakeTextField: UITextField!
    @IBOutlet weak var editVehicleModelTextField: UITextField!
    @IBOutlet weak var editVehicleFuelTypePickerView: UIPickerView!
    @IBOutlet weak var editVehicleLPNTextField: UITextField!
    @IBOutlet weak var editVehicleVINTextField: UITextField!
    @IBOutlet weak var editVehiclePICTextField: UITextField!
    @IBAction func editVehicleCancelPressed(_ sender: UIButton) {
        popUpAnimateOut(popUpView: editVehicleView)
    }
    @IBAction func editVehicleUpdatePressed(_ sender: UIButton) {
        guard vehicleKeyPlaceholder != "" else { return }
        guard editVehicleColorTextField.text != "" else { return }
        guard editVehicleYearTextField.text != "" else { return }
        guard editVehicleMakeTextField.text != "" else { return }
        guard editVehicleModelTextField.text != "" else { return }
        if let editVehicleColor = editVehicleColorTextField.text {
            vehicleColorPlaceholder = editVehicleColor
        }
        if let editVehicleYear = editVehicleYearTextField.text {
            vehicleYearPlaceholder = editVehicleYear
        }
        if let editVehicleMake = editVehicleMakeTextField.text {
            vehicleMakePlaceholder = editVehicleMake
        }
        if let editVehicleModel = editVehicleModelTextField.text {
            vehicleModelPlaceholder = editVehicleModel
        }
        if let editVehicleLPN = editVehicleLPNTextField.text {
            vehicleLPNPlaceholder = editVehicleLPN
        }
        if let editVehicleVIN = editVehicleVINTextField.text {
            vehicleVINPlaceholder = editVehicleVIN
        }
        if let editVehiclePIC = editVehiclePICTextField.text {
            vehiclePICPlaceholder = editVehiclePIC
        }
        vehiclesRef.child(vehicleKeyPlaceholder).updateChildValues(["color": vehicleColorPlaceholder, "year": vehicleYearPlaceholder, "make": vehicleMakePlaceholder, "model": vehicleModelPlaceholder, "fuelId": fuelTypeId, "fuelString": fuelTypePickerData[fuelTypeId], "licensePlateNumber": vehicleLPNPlaceholder, "vehicleIdentificationNumber": vehicleVINPlaceholder, "placedInCommissionDate": vehiclePICPlaceholder])
        popUpAnimateOut(popUpView: editVehicleView)
    }
    var vehicleKeyPlaceholder = ""
    var vehicleColorPlaceholder = ""
    var vehicleYearPlaceholder = ""
    var vehicleMakePlaceholder = ""
    var vehicleModelPlaceholder = ""
    var vehicleLPNPlaceholder = ""
    var vehicleVINPlaceholder = ""
    var vehiclePICPlaceholder = ""
    var fuelTypeId = 0
    
    @IBOutlet var editEntityView: UIView!
    @IBOutlet weak var editEntityNameTextField: UITextField!
    @IBOutlet weak var editEntityTableView: UITableView!
    @IBOutlet weak var editEntityRelationPickerView: UIPickerView!
    @IBOutlet weak var editEntityPhoneNumberTextField: UITextField!
    @IBOutlet weak var editEntityEmailTextField: UITextField!
    @IBOutlet weak var editEntityStreetTextField: UITextField!
    @IBOutlet weak var editEntityCityTextField: UITextField!
    @IBOutlet weak var editEntityStateTextField: UITextField!
    @IBOutlet weak var editEntitySSNTextField: UITextField!
    @IBOutlet weak var editEntityEINTextField: UITextField!
    @IBAction func editEntityCancelPressed(_ sender: UIButton) {
        popUpAnimateOut(popUpView: editEntityView)
    }
    @IBAction func editEntityClearFieldsPressed(_ sender: UIButton) {
        editEntityClearFields()
    }
    @IBAction func editEntityUpdatePressed(_ sender: UIButton) {
        guard editEntityNameTextField.text != "" else { return }
        guard entityNamePlaceholderKeyString != "" else { return }
        if let editEntityName = editEntityNameTextField.text {
            entityNamePlaceholder = editEntityName
        }
        if let editEntityPhoneNumber = editEntityPhoneNumberTextField.text {
            phoneNumberPlaceholder = editEntityPhoneNumber
        }
        if let editEntityEmail = editEntityEmailTextField.text {
            emailPlaceholder = editEntityEmail
        }
        if let editEntityStreet = editEntityStreetTextField.text {
            streetPlaceholder = editEntityStreet
        }
        if let editEntityCity = editEntityCityTextField.text {
            cityPlaceholder = editEntityCity
        }
        if let editEntityState = editEntityStateTextField.text {
            statePlaceholder = editEntityState
        }
        if let editEntitySSN = editEntitySSNTextField.text {
            ssnPlaceholder = editEntitySSN
        }
        if let editEntityEIN = editEntityEINTextField.text {
            einPlaceholder = editEntityEIN
        }
        entitiesRef.child(entityNamePlaceholderKeyString).updateChildValues(["type": entityRelationId, "name": entityNamePlaceholder, "phoneNumber": phoneNumberPlaceholder, "email": emailPlaceholder, "street": streetPlaceholder, "city": cityPlaceholder, "state": statePlaceholder, "ssn": ssnPlaceholder, "ein": einPlaceholder])
        popUpAnimateOut(popUpView: editEntityView)
    }
    
    func editEntityClearFields() {
        editEntityNameTextField.text = ""
        editEntityPhoneNumberTextField.text = ""
        editEntityEmailTextField.text = ""
        editEntityStreetTextField.text = ""
        editEntityCityTextField.text = ""
        editEntityStateTextField.text = ""
        editEntitySSNTextField.text = ""
        editEntityEINTextField.text = ""
    }
    
    @IBOutlet var editProjectAddEntityView: UIView!
    @IBOutlet weak var editProjectAddEntityNameTextField: UITextField!
    @IBOutlet weak var editProjectAddEntityTableView: UITableView!
    @IBOutlet weak var editProjectAddEntityRelationPickerView: UIPickerView!
    @IBOutlet weak var editProjectAddEntityPhoneNumberTextField: UITextField!
    @IBOutlet weak var editProjectAddEntityEmailTextField: UITextField!
    @IBOutlet weak var editProjectAddEntityStreetTextField: UITextField!
    @IBOutlet weak var editProjectAddEntityCityTextField: UITextField!
    @IBOutlet weak var editProjectAddEntityStateTextField: UITextField!
    @IBOutlet weak var editProjectAddEntitySSNTextField: UITextField!
    @IBOutlet weak var editProjectAddEntityEINTextField: UITextField!
    @IBAction func editProjectAddEntityCancelPressed(_ sender: UIButton) {
        editProjectAddEntityClearFields()
        editProjectAddEntityView.removeFromSuperview()
    }
    @IBAction func editProjectAddEntityClearFieldsPressed(_ sender: UIButton) {
        editProjectAddEntityClearFields()
    }
    func editProjectAddEntityClearFields() {
        editProjectAddEntityNameTextField.text = ""
        editProjectAddEntityPhoneNumberTextField.text = ""
        editProjectAddEntityEmailTextField.text = ""
        editProjectAddEntityStreetTextField.text = ""
        editProjectAddEntityCityTextField.text = ""
        editProjectAddEntityStateTextField.text = ""
        editProjectAddEntitySSNTextField.text = ""
        editProjectAddEntityEINTextField.text = ""
    }
    @IBAction func editProjectAddEntitySavePressed(_ sender: UIButton) {
        guard editProjectAddEntityNameTextField.text != "" else { return }
        let thisEntityKeyRef = entitiesRef.childByAutoId()
        entityNamePlaceholderKeyString = thisEntityKeyRef.key
        if let ePAEName = editProjectAddEntityNameTextField.text {
            entityNamePlaceholder = ePAEName
        }
        if let ePAEPhoneNumber = editProjectAddEntityPhoneNumberTextField.text {
            phoneNumberPlaceholder = ePAEPhoneNumber
        }
        if let ePAEEmail = editProjectAddEntityEmailTextField.text {
            emailPlaceholder = ePAEEmail
        }
        if let ePAEStreet = editProjectAddEntityStreetTextField.text {
            streetPlaceholder = ePAEStreet
        }
        if let ePAECity = editProjectAddEntityCityTextField.text {
            cityPlaceholder = ePAECity
        }
        if let ePAEState = editProjectAddEntityStateTextField.text {
            statePlaceholder = ePAEState
        }
        if let ePAESSN = editProjectAddEntitySSNTextField.text {
            ssnPlaceholder = ePAESSN
        }
        if let ePAEEIN = editProjectAddEntityEINTextField.text {
            einPlaceholder = ePAEEIN
        }
        let thisEntity = EntityItem(type: entityRelationId, name: entityNamePlaceholder, phoneNumber: phoneNumberPlaceholder, email: emailPlaceholder, street: streetPlaceholder, city: cityPlaceholder, state: statePlaceholder, ssn: ssnPlaceholder, ein: einPlaceholder, timeStamp: timeStampDictionaryForFirebase, key: entityNamePlaceholderKeyString)
        entitiesRef.child(entityNamePlaceholderKeyString).setValue(thisEntity.toAnyObject())
        customerNamePlaceholder = entityNamePlaceholder
        customerNamePlaceholderKeyString = entityNamePlaceholderKeyString
        editProjectCustomerNameTextField.text = customerNamePlaceholder
        editProjectAddEntityView.removeFromSuperview()
    }
    var entityNamePlaceholder = ""
    var entityNamePlaceholderKeyString = ""
    var entityRelationId = 0
    var phoneNumberPlaceholder = ""
    var emailPlaceholder = ""
    var ssnPlaceholder = ""
    var einPlaceholder = ""
    
    @IBOutlet var editProjectView: UIView!
    @IBOutlet weak var editProjectNameTextField: UITextField!
    @IBOutlet weak var editProjectCustomerNameTextField: UITextField!
    @IBAction func editProjectAddCustomerPressed(_ sender: UIButton) {
        popUpAnimateIn(popUpView: editProjectAddEntityView)
    }
    @IBOutlet weak var editProjectTableView: UITableView!
    @IBOutlet weak var editProjectProjectStatusPickerView: UIPickerView!
    @IBOutlet weak var editProjectHowDidTheyHearOfYouPickerView: UIPickerView!
    @IBOutlet weak var editProjectTagsTextField: UITextField!
    @IBOutlet weak var editProjectNotesTextField: UITextField!
    @IBOutlet weak var editProjectStreetTextField: UITextField!
    @IBOutlet weak var editProjectCityTextField: UITextField!
    @IBOutlet weak var editProjectStateTextField: UITextField!
    @IBAction func editProjectCancelPressed(_ sender: UIButton) {
        popUpAnimateOut(popUpView: editProjectView)
    }
    @IBAction func editProjectUpdatePressed(_ sender: UIButton) {
        guard editProjectNameTextField.text != "" else { return }
        guard editProjectCustomerNameTextField.text != "" else { return }
        guard customerNamePlaceholderKeyString != "" else { return }
        if let editProjectName = editProjectNameTextField.text {
            projectNamePlaceholder = editProjectName
        }
        if let editProjectTags = editProjectTagsTextField.text {
            tagsPlaceholder = editProjectTags
        }
        if let editProjectNotes = editProjectNotesTextField.text {
            notesPlaceholder = editProjectNotes
        }
        if let editProjectStreet = editProjectStreetTextField.text {
            streetPlaceholder = editProjectStreet
        }
        if let editProjectCity = editProjectCityTextField.text {
            cityPlaceholder = editProjectCity
        }
        if let editProjectState = editProjectStateTextField.text {
            statePlaceholder = editProjectState
        }
        projectsRef.child(projectKeyPlaceholder).updateChildValues(["name": projectNamePlaceholder, "customerName": customerNamePlaceholder, "customerKey": customerNamePlaceholderKeyString, "howDidTheyHearOfYouString": howDidTheyHearOfYouPickerData[howDidTheyHearOfYouId], "howDidTheyHearOfYouId": howDidTheyHearOfYouId, "projectTags": tagsPlaceholder, "projectNotes": notesPlaceholder, "projectAddressStreet": streetPlaceholder, "projectAddressCity": cityPlaceholder, "projectAddressState": statePlaceholder])
        popUpAnimateOut(popUpView: editProjectView)
    }

    var projectNamePlaceholder: String = ""
    var customerNamePlaceholder: String = ""
    var customerNamePlaceholderKeyString: String = ""
    var projectStatusId: Int = 0
    var howDidTheyHearOfYouId: Int = 0
    var tagsPlaceholder: String = ""
    var notesPlaceholder: String = ""
    var streetPlaceholder: String = ""
    var cityPlaceholder: String = ""
    var statePlaceholder: String = ""
    var projectKeyPlaceholder: String = ""
    
    //LET THE EDITING OR DELETION OF ITEMS BEGIN!!!!!!!!!!!!!!!!!!
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        
        //Without this line, it fires into the ADDuniversal multiple times !!
        if gesture.state != .began {
            return
        }
        
        let p = gesture.location(in: self.cardViewCollectionView)
        
        if let indexPath = self.cardViewCollectionView.indexPathForItem(at: p) {
            TheAmtSingleton.shared.theMIPNumber = indexPath.item
            switch MIProcessor.sharedMIP.mIP[indexPath.item].multiversalType {
            case 1: // Projects
                popUpAnimateIn(popUpView: editProjectView)
                if let thisProject = MIProcessor.sharedMIP.mIP[indexPath.item] as? ProjectItem {
                    projectKeyPlaceholder = thisProject.key
                    projectNamePlaceholder = thisProject.name
                    editProjectNameTextField.text = projectNamePlaceholder
                    customerNamePlaceholder = thisProject.customerName
                    editProjectCustomerNameTextField.text = customerNamePlaceholder
                    customerNamePlaceholderKeyString = thisProject.customerKey
                    projectStatusId = thisProject.projectStatusId
                    editProjectProjectStatusPickerView.selectRow(projectStatusId, inComponent: 0, animated: true)
                    howDidTheyHearOfYouId = thisProject.howDidTheyHearOfYouId
                    editProjectHowDidTheyHearOfYouPickerView.selectRow(howDidTheyHearOfYouId, inComponent: 0, animated: true)
                    tagsPlaceholder = thisProject.projectTags
                    editProjectTagsTextField.text = tagsPlaceholder
                    notesPlaceholder = thisProject.projectNotes
                    editProjectNotesTextField.text = notesPlaceholder
                    streetPlaceholder = thisProject.projectAddressStreet
                    cityPlaceholder = thisProject.projectAddressCity
                    statePlaceholder = thisProject.projectAddressState
                }
            case 2: // Entities
                popUpAnimateIn(popUpView: editEntityView)
                if let thisEntity = MIProcessor.sharedMIP.mIP[indexPath.item] as? EntityItem {
                    entityNamePlaceholder = thisEntity.name
                    editEntityNameTextField.text = entityNamePlaceholder
                    entityNamePlaceholderKeyString = thisEntity.key
                    phoneNumberPlaceholder = thisEntity.phoneNumber
                    editEntityPhoneNumberTextField.text = phoneNumberPlaceholder
                    emailPlaceholder = thisEntity.email
                    editEntityEmailTextField.text = emailPlaceholder
                    streetPlaceholder = thisEntity.street
                    editEntityStreetTextField.text = streetPlaceholder
                    cityPlaceholder = thisEntity.city
                    editEntityCityTextField.text = cityPlaceholder
                    statePlaceholder = thisEntity.state
                    editEntityStateTextField.text = statePlaceholder
                    ssnPlaceholder = thisEntity.ssn
                    editEntitySSNTextField.text = ssnPlaceholder
                    einPlaceholder = thisEntity.ein
                    editEntityEINTextField.text = einPlaceholder
                    entityRelationId = thisEntity.type
                    editEntityRelationPickerView.selectRow(entityRelationId, inComponent: 0, animated: true)
                }
            case 3: // Accounts
                popUpAnimateIn(popUpView: editAccountView)
                if let thisAccount = MIProcessor.sharedMIP.mIP[indexPath.item] as? AccountItem {
                    accountKeyPlaceholder = thisAccount.key
                    accountNamePlaceholder = thisAccount.name
                    editAccountNameTextField.text = accountNamePlaceholder
                    accountStartingBalance = thisAccount.startingBal
                    TheAmtSingleton.shared.theStartingBal = accountStartingBalance
                    editAccountStartingBalanceTextField.setText()
                    accountTypeId = thisAccount.accountTypeId
                    editAccountTypePickerView.selectRow(accountTypeId, inComponent: 0, animated: true)
                    phoneNumberPlaceholder = thisAccount.phoneNumber
                    editAccountPhoneNumberTextField.text = phoneNumberPlaceholder
                    emailPlaceholder = thisAccount.email
                    editAccountEmailTextField.text = emailPlaceholder
                    streetPlaceholder = thisAccount.street
                    editAccountStreetTextField.text = streetPlaceholder
                    cityPlaceholder = thisAccount.city
                    editAccountCityTextField.text = cityPlaceholder
                    statePlaceholder = thisAccount.state
                    editAccountStateTextField.text = statePlaceholder
                }
            case 4: // Vehicles
                popUpAnimateIn(popUpView: editVehicleView)
                if let thisVehicle = MIProcessor.sharedMIP.mIP[indexPath.item] as? VehicleItem {
                    vehicleKeyPlaceholder = thisVehicle.key
                    vehicleColorPlaceholder = thisVehicle.color
                    editVehicleColorTextField.text = vehicleColorPlaceholder
                    vehicleYearPlaceholder = thisVehicle.year
                    editVehicleYearTextField.text = vehicleYearPlaceholder
                    vehicleMakePlaceholder = thisVehicle.make
                    editVehicleMakeTextField.text = vehicleMakePlaceholder
                    vehicleModelPlaceholder = thisVehicle.model
                    editVehicleModelTextField.text = vehicleModelPlaceholder
                    fuelTypeId = thisVehicle.fuelId
                    editVehicleFuelTypePickerView.selectRow(fuelTypeId, inComponent: 0, animated: true)
                    vehicleLPNPlaceholder = thisVehicle.licensePlateNumber
                    editVehicleLPNTextField.text = vehicleLPNPlaceholder
                    vehicleVINPlaceholder = thisVehicle.vehicleIdentificationNumber
                    editVehicleVINTextField.text = vehicleVINPlaceholder
                    vehiclePICPlaceholder = thisVehicle.placedInCommissionDate
                    editVehiclePICTextField.text = vehiclePICPlaceholder
                }
            default: // Universals
                performSegue(withIdentifier: "createUniversal", sender: self)
            }
        } else {
            print("couldn't find index path")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        cardViewCollectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func initializeIfFirstAppUse() {
        let firstLaunch = FirstLaunch(userDefaults: .standard, key: "com.bizzybooks.FirstLaunch.WasLaunchedBefore")
        
        if firstLaunch.isFirstLaunch {
            // do things // MOVE stuff from the always closure below into this one when you're ready for final deployment of app!
            firstTimeRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let isReallyFirstTime = snapshot.value as? Bool {
                    if isReallyFirstTime {
                        let addEntityKeyReference = self.entitiesRef.childByAutoId()
                        self.addEntityKeyString = addEntityKeyReference.key
                        let timeStampDictionaryForFirebase = [".sv": "timestamp"]
                        let thisEntityItem = EntityItem(type: 9, name: "You", phoneNumber: "", email: "", street: "", city: "", state: "", ssn: "", ein: "", timeStamp: timeStampDictionaryForFirebase, key: self.addEntityKeyString)
                        self.entitiesRef.child(self.addEntityKeyString).setValue(thisEntityItem.toAnyObject())
                        self.youEntityRef.setValue(self.addEntityKeyString)
                        self.firstTimeRef.setValue(false)
                        self.popUpAnimateIn(popUpView: self.welcomeView)
                    }
                }
            })
        }
        
        let alwaysFirstLaunch = FirstLaunch.alwaysFirst()
        
        if alwaysFirstLaunch.isFirstLaunch {
            // will always execute
            
        }
    }
 
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
        if let appSettings = NSURL(string: UIApplicationOpenSettingsURLString) {
            let string: String = ""
            let any: Any = ""
            UIApplication.shared.open(appSettings as URL, options: [string: any], completionHandler: { (success) in
                if success {
                    print("Good")
                }
            })
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case editProjectTableView:
            return filteredBizzyEntities.count
        default: // I.e., editProjectAddEntityTableView && editEntityTableView (both require same hookup)
            return filteredIPhoneEntities.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        switch tableView {
        case editProjectTableView:
            let filteredName = filteredBizzyEntities[indexPath.row].name
            cell = tableView.dequeueReusableCell(withIdentifier: "EditProjectCell", for: indexPath)
            cell!.textLabel!.text = filteredName
        case editEntityTableView:
            let filteredName = filteredIPhoneEntities[indexPath.row].givenName + " " + filteredIPhoneEntities[indexPath.row].familyName
            cell = tableView.dequeueReusableCell(withIdentifier: "EditEntityCell", for: indexPath)
            cell!.textLabel!.text = filteredName
        default: // I.e., editProjectAddEntityTableView
            let filteredName = filteredIPhoneEntities[indexPath.row].givenName + " " + filteredIPhoneEntities[indexPath.row].familyName
            cell = tableView.dequeueReusableCell(withIdentifier: "EditProjectAddEntityCell", for: indexPath)
            cell!.textLabel!.text = filteredName
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //Added this to stop chicanery of cells still being selected if you change your mind and go back a second time. // PURE GOLD!
        switch tableView {
        case editProjectTableView:
            customerNamePlaceholder = filteredBizzyEntities[indexPath.row].name
            customerNamePlaceholderKeyString = filteredBizzyEntities[indexPath.row].key
            editProjectCustomerNameTextField.text = customerNamePlaceholder
            filteredBizzyEntities.removeAll()
            editProjectTableView.isHidden = true // PURE GOLD!
        case editEntityTableView:
            let contact = self.filteredIPhoneEntities[indexPath.row]
            self.selectedIPhoneEntity = contact
            editEntityNameTextField.text = contact.givenName + " " + contact.familyName
            if (contact.isKeyAvailable(CNContactEmailAddressesKey)) {
                if let theEmail = contact.emailAddresses.first {
                    editEntityEmailTextField.text = theEmail.value as String
                }
            }
            if (contact.isKeyAvailable(CNContactPhoneNumbersKey)) {
                if let thePhoneNumber = contact.phoneNumbers.first {
                    editEntityPhoneNumberTextField.text = thePhoneNumber.value.stringValue
                }
            }
            if (contact.isKeyAvailable(CNContactPostalAddressesKey)) {
                if let theAddress = contact.postalAddresses.first {
                    editEntityStreetTextField.text = theAddress.value.street
                    editEntityCityTextField.text = theAddress.value.city
                    editEntityStateTextField.text = theAddress.value.state
                }
            }
            self.filteredIPhoneEntities.removeAll()
            editEntityTableView.isHidden = true
        default: // I.e., editProjectAddEntityTableView
            let contact = self.filteredIPhoneEntities[indexPath.row]
            self.selectedIPhoneEntity = contact
            editProjectAddEntityNameTextField.text = contact.givenName + " " + contact.familyName
            if (contact.isKeyAvailable(CNContactEmailAddressesKey)) {
                if let theEmail = contact.emailAddresses.first {
                    editProjectAddEntityEmailTextField.text = theEmail.value as String
                }
            }
            if (contact.isKeyAvailable(CNContactPhoneNumbersKey)) {
                if let thePhoneNumber = contact.phoneNumbers.first  {
                    editProjectAddEntityPhoneNumberTextField.text = thePhoneNumber.value.stringValue
                }
            }
            if (contact.isKeyAvailable(CNContactPostalAddressesKey)) {
                if let theAddress = contact.postalAddresses.first {
                    editProjectAddEntityStreetTextField.text = theAddress.value.street
                    editProjectAddEntityCityTextField.text = theAddress.value.city
                    editProjectAddEntityStateTextField.text = theAddress.value.state
                }
            }
            self.filteredIPhoneEntities.removeAll()
            editProjectAddEntityTableView.isHidden = true // PURE GOLD!
        }
        tableView.reloadData() // PURE GOLD!
    }
}

//Brian Voong inspiration... see if we can get vertical sizing of collectionview cells ie cardviews
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let i = indexPath.item
        var baseHeight: CGFloat = 150
        var sentenceOneHeight: CGFloat = 0
        var sentenceTwoHeight: CGFloat = 0
        var phoneHeight: CGFloat = 0
        var emailHeight: CGFloat = 0
        var geoHeight: CGFloat = 0
        var ssnHeight: CGFloat = 0
        var einHeight: CGFloat = 0
        var imageHeight: CGFloat = 1
        switch MIProcessor.sharedMIP.mIP[i].multiversalType {
        case 1: // Project
            baseHeight = 80
            sentenceOneHeight = 140
            sentenceTwoHeight = 180
        case 2: // Entity
            baseHeight = 140 //92
            if let entityItem = MIProcessor.sharedMIP.mIP[i] as? EntityItem {
                if entityItem.phoneNumber != "" {
                    phoneHeight = 30
                }
                if entityItem.email != "" {
                    emailHeight = 38
                }
                if entityItem.street != "" {
                    if entityItem.city != "" {
                        if entityItem.state != "" {
                            geoHeight = 50
                        }
                    }
                }
                if entityItem.ssn != "" {
                    ssnHeight = 29
                }
                if entityItem.ein != "" {
                    einHeight = 29
                }
            }
        case 3: // Account
            baseHeight = 140 //92
            if let accountItem = MIProcessor.sharedMIP.mIP[i] as? AccountItem {
                if accountItem.phoneNumber != "" {
                    phoneHeight = 30
                }
                if accountItem.email != "" {
                    emailHeight = 38
                }
                if accountItem.street != "" {
                    if accountItem.city != "" {
                        if accountItem.state != "" {
                            geoHeight = 50
                        }
                    }
                }
            }
        case 4: // Vehicle
            baseHeight = 140 //92
            if let vehicleItem = MIProcessor.sharedMIP.mIP[i] as? VehicleItem {
                if vehicleItem.licensePlateNumber != "" {
                    phoneHeight = 25
                }
                if vehicleItem.vehicleIdentificationNumber != "" {
                    emailHeight = 25
                }
                if vehicleItem.placedInCommissionDate != "" {
                    geoHeight = 25
                }
            }
        default: // Universal - Ie case 0 the most frequent
            if let universalItem = MIProcessor.sharedMIP.mIP[i] as? UniversalItem {
                switch universalItem.universalItemType {
                case 4: //Transfer
                    baseHeight = 218
                    if universalItem.notes != "" {
                        phoneHeight = 21
                    }
                    imageHeight = CGFloat(universalItem.picHeightInt)
                case 6: //Project Media
                    baseHeight = 113
                    if universalItem.notes != "" {
                        phoneHeight = 29
                    }
                    imageHeight = CGFloat(universalItem.picHeightInt)
                default:
                    baseHeight = 160
                    sentenceOneHeight = 60
                    imageHeight = CGFloat(universalItem.picHeightInt)
                }
            }
        }
        let totalHeight = baseHeight + sentenceOneHeight + sentenceTwoHeight + phoneHeight + emailHeight + geoHeight + ssnHeight + einHeight + imageHeight
        var theWidth: CGFloat = 0
        if view.frame.width < 370 { //Protection for tiny iPhones
            theWidth = view.frame.width - 20
        } else { //Good for most iphones and safe for iPads
            theWidth = 350
        }
        return CGSize(width: theWidth, height: totalHeight)
        /*
        if let universalItem = MIProcessor.sharedMIP.mIP[i] as? UniversalItem {
            /*
             1. get the height of the dynamic sentence
             2. get the height of image based on the card width and the aspect ratio of the image (which should be saved in the Firebase)
             3. get the height of the rest of the components (static parts)
             4. add all those componets up and you get the total height
             
             EXAMPLE:
             let approximateWidthOfBioTextView = view.frame.width - 12 - 50 - 12 - 2
             let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
             let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
             
             let estimatedFrame = NSString(string: user.bioText).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
             
             return CGSize(width: view.frame.width, height: estimatedFrame.height + 66)
             */
        }
        */
    }
    
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

final class FirstLaunch {
    
    let wasLaunchedBefore: Bool
    var isFirstLaunch: Bool {
        return !wasLaunchedBefore
    }
    
    init(getWasLaunchedBefore: () -> Bool,
         setWasLaunchedBefore: (Bool) -> ()) {
        let wasLaunchedBefore = getWasLaunchedBefore()
        self.wasLaunchedBefore = wasLaunchedBefore
        if !wasLaunchedBefore {
            setWasLaunchedBefore(true)
        }
    }
    
    convenience init(userDefaults: UserDefaults, key: String) {
        self.init(getWasLaunchedBefore: { userDefaults.bool(forKey: key) },
                  setWasLaunchedBefore: { userDefaults.set($0, forKey: key) })
    }
    
}

extension FirstLaunch {
    
    static func alwaysFirst() -> FirstLaunch {
        return FirstLaunch(getWasLaunchedBefore: { return false }, setWasLaunchedBefore: { _ in })
    }
    
}

