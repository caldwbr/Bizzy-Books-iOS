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

var userUID = ""
var userTokens = ""

class ViewController: UIViewController, FUIAuthDelegate, UICollectionViewDataSource {
    
    var kFacebookAppID = "1583985615235483"
    var backgroundImage : UIImageView! //right here
    var entitiesRef: DatabaseReference!
    var youEntityRef: DatabaseReference!
    var addEntityKeyString: String = ""
    @IBOutlet weak var cardViewCollectionView: UICollectionView!
    var multiversalItems = [MultiversalItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardViewCollectionView.register(UINib.init(nibName: "UniversalCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UniversalCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "UniversalTransferCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UniversalTransferCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "UniversalProjectMediaCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UniversalProjectMediaCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "ProjectCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProjectCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "EntityCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EntityCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "AccountCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AccountCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "VehicleCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VehicleCardViewCollectionViewCell")
        if let cardViewFlowLayout = cardViewCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            print("We are inside")
            cardViewFlowLayout.estimatedItemSize = CGSize(width: 350, height: 200)
        }
        cardViewCollectionView.dataSource = self
        checkLoggedIn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //checkLoggedIn()
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
                self.entitiesRef = Database.database().reference().child("users").child(userUID).child("entities")
                self.youEntityRef = Database.database().reference().child("users").child(userUID).child("youEntity")
                self.initializeIfFirstAppUse()
                self.loadTheMIP()
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
                MIProcessor.sharedMIP.loadTheBalAfters {
                    self.multiversalItems.removeAll()
                    for i in 0..<MIProcessor.sharedMIP.mIPUniversals.count {
                        self.multiversalItems.append(MIProcessor.sharedMIP.mIPUniversals[i])
                    }
                    for projectItem in MIProcessor.sharedMIP.mIPProjects {
                        self.multiversalItems.append(projectItem)
                    }
                    for entityItem in MIProcessor.sharedMIP.mIPEntities {
                        self.multiversalItems.append(entityItem)
                    }
                    for accountItem in MIProcessor.sharedMIP.mIPAccounts {
                        self.multiversalItems.append(accountItem)
                    }
                    for vehicleItem in MIProcessor.sharedMIP.mIPVehicles {
                        self.multiversalItems.append(vehicleItem)
                    }
                    self.cardViewCollectionView.reloadData()//Critical line - this makes or breaks the app :/
                }
            }
        }
    }
    
    func popUpAnimateIn(popUpView: UIView) {
        self.view.addSubview(popUpView)
        popUpView.center = self.view.center
        popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            popUpView.alpha = 1
            popUpView.transform = CGAffineTransform.identity
        }
    }
    
    func popUpAnimateOut(popUpView: UIView) {
        UIView.animate(withDuration: 0.4, animations: {
            popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            popUpView.alpha = 0
        }) { (success:Bool) in
            popUpView.removeFromSuperview()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return multiversalItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let multiversalItem = multiversalItems[indexPath.row]
        print("Hey 2 " + String(describing: multiversalItems))
        switch multiversalItem.multiversalType {
        case 0:
            let universal = multiversalItem as! UniversalItem
            switch universal.universalItemType {
            case 4:
                let cell = cardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "UniversalTransferCardViewCollectionViewCell", for: indexPath) as! UniversalTransferCardViewCollectionViewCell
                cell.configure(multiversalItems[indexPath.row])
                return cell
            case 6:
                let cell = cardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "UniversalProjectMediaCardViewCollectionViewCell", for: indexPath) as! UniversalProjectMediaCardViewCollectionViewCell
                cell.configure(multiversalItems[indexPath.row])
                return cell
            default: // I.e., cases 0, 1, 2, and 3 (most all cases!)
                let cell = cardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "UniversalCardViewCollectionViewCell", for: indexPath) as! UniversalCardViewCollectionViewCell
                cell.configure(multiversalItems[indexPath.row])
                return cell
            }
        case 1:
            let cell = cardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "ProjectCardViewCollectionViewCell", for: indexPath) as! ProjectCardViewCollectionViewCell
            cell.configure(multiversalItems[indexPath.row])
            return cell
        case 2:
            let cell = cardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "EntityCardViewCollectionViewCell", for: indexPath) as! EntityCardViewCollectionViewCell
            cell.configure(multiversalItems[indexPath.row])
            return cell
        case 3:
            let cell = cardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "AccountCardViewCollectionViewCell", for: indexPath) as! AccountCardViewCollectionViewCell
            cell.configure(multiversalItems[indexPath.row])
            return cell
        case 4:
            let cell = cardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "VehicleCardViewCollectionViewCell", for: indexPath) as! VehicleCardViewCollectionViewCell
            cell.configure(multiversalItems[indexPath.row])
            return cell
        default:
            let cell = cardViewCollectionView.dequeueReusableCell(withReuseIdentifier: "UniversalCardViewCollectionViewCell", for: indexPath) as! UniversalCardViewCollectionViewCell
            cell.configure(multiversalItems[indexPath.row])
            return cell
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
            let addEntityKeyReference = entitiesRef.childByAutoId()
            addEntityKeyString = addEntityKeyReference.key
            let timeStampDictionaryForFirebase = [".sv": "timestamp"]
            let thisEntityItem = EntityItem(type: 9, name: "You", phoneNumber: "", email: "", street: "", city: "", state: "", ssn: "", ein: "", timeStamp: timeStampDictionaryForFirebase, key: addEntityKeyString)
            entitiesRef.child(addEntityKeyString).setValue(thisEntityItem.toAnyObject())
            youEntityRef.setValue(addEntityKeyString)
            popUpAnimateIn(popUpView: welcomeView)
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

