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

class ViewController: UIViewController, FUIAuthDelegate, UIGestureRecognizerDelegate, UICollectionViewDataSource {
    
    var kFacebookAppID = "1583985615235483"
    var backgroundImage : UIImageView! //right here
    var entitiesRef: DatabaseReference!
    var youEntityRef: DatabaseReference!
    var addEntityKeyString: String = ""
    @IBOutlet weak var cardViewCollectionView: UICollectionView!
    //var multiversalItems = [MultiversalItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardViewCollectionView.register(UINib.init(nibName: "UniversalCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UniversalCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "UniversalTransferCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UniversalTransferCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "UniversalProjectMediaCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UniversalProjectMediaCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "ProjectCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProjectCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "EntityCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EntityCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "AccountCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AccountCardViewCollectionViewCell")
        cardViewCollectionView.register(UINib.init(nibName: "VehicleCardViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VehicleCardViewCollectionViewCell")
        cardViewCollectionView.dataSource = self
        cardViewCollectionView.delegate = self
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
        let i = indexPath.row
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
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        
        //Without this line, it fires into the ADDuniversal multiple times !!
        if gesture.state != .began {
            return
        }
        
        let p = gesture.location(in: self.cardViewCollectionView)
        
        if let indexPath = self.cardViewCollectionView.indexPathForItem(at: p) {
            // get the cell at indexPath (the one you long pressed)
            //let cell = self.cardViewCollectionView.cellForItem(at: indexPath)
            if MIProcessor.sharedMIP.mIP[indexPath.row].multiversalType == 0 {
                TheAmtSingleton.shared.theMIPNumber = indexPath.row
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


//Brian Voong inspiration... see if we can get vertical sizing of collectionview cells ie cardviews
extension ViewController :UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let i = indexPath.item
        var baseHeight: CGFloat = 200
        var sentenceOneHeight: CGFloat = 0
        var sentenceTwoHeight: CGFloat = 0
        var imageHeight: CGFloat = 1
        switch MIProcessor.sharedMIP.mIP[i].multiversalType {
        case 1: // Project
            print("blah")
        case 2: // Entity
            print("blah")
        case 3: // Account
            print("blah")
        case 4: // Vehicle
            print("blah")
        default: // Universal - Ie case 0 the most frequent
            if let universalItem = MIProcessor.sharedMIP.mIP[i] as? UniversalItem {
                switch universalItem.universalItemType {
                case 4:
                    print("blah")
                case 6:
                    print("blah")
                default:
                    baseHeight = 140
                    sentenceOneHeight = 60
                    imageHeight = CGFloat(universalItem.picHeightInt)
                }
            }
        }
        let totalHeight = baseHeight + sentenceOneHeight + sentenceTwoHeight + imageHeight
        return CGSize(width: 350, height: totalHeight)
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

