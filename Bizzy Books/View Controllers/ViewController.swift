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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.editProjectTableView.keyboardDismissMode = .interactive
        self.editProjectAddEntityTableView.keyboardDismissMode = .interactive
        
        //Prevent empty cells in tableview
        editProjectTableView.tableFooterView = UIView(frame: .zero)
        editProjectAddEntityTableView.tableFooterView = UIView(frame: .zero)
        
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
        projectStatusPickerData = ["Job Lead", "Bid", "Contract", "Paid", "Lost", "Other"]
        howDidTheyHearOfYouPickerData = ["(Unknown)", "(Referral)", "(Website)", "(YP)", "(Social Media)", "(Soliciting)", "(Google Adwords)", "(Company Shirts)", "(Sign)", "(Vehicle Wrap)", "(Billboard)", "(TV)", "(Radio)", "(Other)"]
        relationPickerData = ["Customer", "Vendor", "Sub", "Employee", "Store", "Government", "Other"]
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
        default: // I.e., editProjectAddEntityTableView
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
        default: // I.e., editProjectAddEntityTableView
            let contact = self.filteredIPhoneEntities[indexPath.row]
            self.selectedIPhoneEntity = contact
            self.editProjectAddEntityTableView.isHidden = true
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

