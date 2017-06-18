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

class ViewController: UIViewController, FIRAuthUIDelegate {
    
    //var db = FIRDatabaseReference.init()
        var kFacebookAppID = "1583985615235483"
    var backgroundImage : UIImageView! //right here
    var customAuthPickerViewController : FIRAuthPickerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLoggedIn()
        
    }
    
    @IBOutlet weak var profilePic: UIImageView!
    
    func checkLoggedIn() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                if user?.photoURL == nil {
                }else{
                    var imageUrl = NSData(contentsOf: (user?.photoURL)!)
                    self.profilePic.image = UIImage(data: imageUrl as! Data)
                }
            } else {
                // No user is signed in.
                self.login()
            }
        }
    }
    
    func login() {
        let authUI = FIRAuthUI.init(auth: Auth.auth())
        let options = FirebaseApp.app()?.options
        let clientId = options?.clientID
        let googleProvider = FIRGoogleAuthUI(scopes: [clientId!])
        let facebookProvider = FIRFacebookAuthUI(permissions: ["public_profile"])
        authUI?.delegate = self
        authUI?.providers = [googleProvider, facebookProvider]
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
    
    
    func authUI(_ authUI: FIRAuthUI, didSignInWith user: User?, error: Error?) {
        if error != nil {
            //Problem signing in
            login()
        }else {
            //User is in! Here is where we code after signing in
            
        }
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionUniversalLinksOnly] as! String
        return FIRAuthUI.default()!.handleOpen(url as URL, sourceApplication: sourceApplication ) 
    }
 
}

