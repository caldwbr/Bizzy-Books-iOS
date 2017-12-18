//
//  ObtainBalanceAfter.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/18/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

class ObtainBalanceAfter {
    
    func balAfter (accountKey: String, particularUniversalTimeStamp: Double) -> (Int, Bool) {
        var firebaseUniversals: [UniversalItem] = [UniversalItem]()
        var firebaseUniversalsFilteredByTimeRange: [UniversalItem] = [UniversalItem]()
        var firebaseUniversalsFilteredAlsoByAccountKey: [UniversalItem] = [UniversalItem]()
        var failed = false
        var trueYou: String = ""
        let accountsRef = Database.database().reference().child("users").child(userUID).child("accounts")
        accountsRef.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let firebaseAccount = AccountItem(snapshot: item as! DataSnapshot)
                if firebaseAccount.key == accountKey {
                    let startingBalance = firebaseAccount.startingBal
                    let universalsRef = Database.database().reference().child("users").child(userUID).child("universals")
                    let youRef = Database.database().reference().child("users").child(userUID).child("youEntity")
                    youRef.observe(.value) { (snapshot) in
                        if let youKey = snapshot.value as? String {
                            trueYou = youKey
                        }
                    }
                    universalsRef.observe(.value) { (snapshot) in
                        for item in snapshot.children {
                            let firebaseUniversal = UniversalItem(snapshot: item as! DataSnapshot)
                            firebaseUniversals.append(firebaseUniversal)
                        }
                    }
                    firebaseUniversalsFilteredByTimeRange = firebaseUniversals.filter({ (universalItem) -> Bool in
                        if let testedTimeStamp: Double = universalItem.timeStamp as? Double {
                            if testedTimeStamp <= particularUniversalTimeStamp {
                                return true
                            } else {
                                return false
                            }
                        } else {
                            failed = true
                            return false
                        }
                    })
                    firebaseUniversalsFilteredAlsoByAccountKey = firebaseUniversalsFilteredByTimeRange.filter({ (universalItem) -> Bool in
                        if (universalItem.accountOneKey == accountKey) || (universalItem.accountTwoKey == accountKey) {
                            return true
                        } else {
                            return false
                        }
                    })
                    for filteredUniversalItem in firebaseUniversalsFilteredAlsoByAccountKey {
                        switch filteredUniversalItem.universalItemType {
                        case 0:
                            
                        }
                    }
                }
            }
        }
    }
    
}
