//
//  ProSubscriptionViewController.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 1/2/18.
//  Copyright © 2018 Caldwell Contracting LLC. All rights reserved.
//
/*
import UIKit
import FirebaseDatabase
import FirebaseDatabaseUI

class ProSubscriptionViewController: UIViewController {
    
    var bradsStore = IAPProcessor.shared
    var currentlySubscribedRef: DatabaseReference!
    var currentSubscriptionRef: DatabaseReference!
    @IBOutlet var proSubscriptionRestoreFailedView: UIView!
    @IBAction func proSubscriptionRestoreFailedOkPressed(_ sender: UIButton) {
        popUpAnimateOut(popUpView: self.proSubscriptionRestoreFailedView)
    }
    @IBOutlet var proSubscriptionBuyFailedView: UIView!
    @IBAction func proSubscriptionBuyFailedOkPressed(_ sender: UIButton) {
        popUpAnimateOut(popUpView: self.proSubscriptionBuyFailedView)
    }
    
    @IBOutlet weak var proSubscriptionContentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        currentlySubscribedRef = Database.database().reference().child("users").child(userUID).child("currentlySubscribed")
        currentSubscriptionRef = Database.database().reference().child("users").child(userUID).child("subscriptionExpirationDate")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func proSubscriptionRestorePressed(_ sender: UIBarButtonItem) {
        bradsStore.searchForProduct()
        bradsStore.restorePurchases { (isTrue, theString, err) in
            if isTrue {
                self.currentlySubscribedRef.setValue(true)
                MIProcessor.sharedMIP.isUserCurrentlySubscribed = true
                //self.navigationController?.popViewController(animated: true)
                self.closeOut()
            } else {
                self.currentlySubscribedRef.setValue(false)
                MIProcessor.sharedMIP.isUserCurrentlySubscribed = false
                self.popUpAnimateIn(popUpView: self.proSubscriptionRestoreFailedView)
            }
            if err != nil {
                print("It had an error")
                self.popUpAnimateIn(popUpView: self.proSubscriptionRestoreFailedView)
            }
        }
    }
    
    @IBAction func proSubscriptionClosePressed(_ sender: UIBarButtonItem) {
        self.closeOut()
    }
    @IBAction func proSubscriptionBuyPressed(_ sender: UIBarButtonItem) {
        print("Ana 1")
        bradsStore.searchForProduct()
        print("ana 2")
        bradsStore.purchase { (isTrue, theString, err) in
            print("ana 1 2")
            if isTrue {
                print("3 4")
                self.currentlySubscribedRef.setValue(true)
                MIProcessor.sharedMIP.isUserCurrentlySubscribed = true
                //self.navigationController?.popViewController(animated: true)
                print("ozz close")
                self.closeOut()
            } else {
                print("what??!")
                self.currentlySubscribedRef.setValue(false)
                MIProcessor.sharedMIP.isUserCurrentlySubscribed = false
                self.popUpAnimateIn(popUpView: self.proSubscriptionBuyFailedView)
            }
        }
    }
    
    func closeOut() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var proSubscriptionVisualEffectView: UIVisualEffectView!
    func popUpAnimateIn(popUpView: UIView) {
        self.view.addSubview(popUpView)
        popUpView.center.x = self.view.center.x
        popUpView.center.y = self.view.center.y - 50
        popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.proSubscriptionVisualEffectView.isHidden = false
            popUpView.alpha = 1
            popUpView.transform = CGAffineTransform.identity
        }
    }
    
    func popUpAnimateOut(popUpView: UIView) {
        UIView.animate(withDuration: 0.4, animations: {
            popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            popUpView.alpha = 0
            self.proSubscriptionVisualEffectView.isHidden = true
        }) { (success:Bool) in
            popUpView.removeFromSuperview()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
*/
