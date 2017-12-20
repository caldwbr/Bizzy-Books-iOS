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
    //var tHeMiP = MIProcessor.sharedMIP
    var mip = [MultiversalItem]()
    var mipA = [AccountItem]()
    var mipU = [UniversalItem]()
    var firebaseUniversals: [UniversalItem] = [UniversalItem]()
    var firebaseUniversalsFilteredByTimeRange: [UniversalItem] = [UniversalItem]()
    var firebaseUniversalsFilteredAlsoByAccountKey: [UniversalItem] = [UniversalItem]()
    var trueYou: String = String()
    var runningBalanceOne: Int = 0
    var runningBalanceTwo: Int = 0
    var runningBalances: [Int] = [Int]()
    var accountsRef: DatabaseReference!
    var accountOneKey: String = String()
    var accountTwoKey: String = String()
    var particularUniversalTimeStamp: Double = Double()
    
    func balAfter(accountKey: String, particularUniversalTimeStamp: Double) -> Int {
        for mA in mipA {
            if mA.key == accountKey {
                let startingBalanceOne = mA.startingBal
                self.runningBalanceOne = startingBalanceOne
                self.trueYou = MIProcessor.sharedMIP.trueYou
                firebaseUniversalsFilteredByTimeRange = mipU.filter({ (universalItem) -> Bool in
                    if let testedTimeStamp: Double = universalItem.timeStamp as? Double {
                        if testedTimeStamp <= particularUniversalTimeStamp {
                            return true
                        } else {
                            return false
                        }
                    } else {
                        return false
                    }
                })
                firebaseUniversalsFilteredAlsoByAccountKey = firebaseUniversalsFilteredByTimeRange.filter({ (universalItem) -> Bool in
                    if (universalItem.accountOneKey == accountOneKey) || (universalItem.accountTwoKey == accountOneKey) {
                        return true
                    } else {
                        return false
                    }
                })
                for filteredUniversalItem in firebaseUniversalsFilteredAlsoByAccountKey {
                    switch filteredUniversalItem.universalItemType {
                    case 0, 1, 2:
                        if filteredUniversalItem.whoKey == trueYou { // I.e., the general case
                            runningBalanceOne = runningBalanceOne - filteredUniversalItem.what
                        } else {
                            runningBalanceOne = runningBalanceOne + filteredUniversalItem.what
                        }
                    case 3:
                        runningBalanceOne = runningBalanceOne - filteredUniversalItem.what
                    case 4:
                        if filteredUniversalItem.accountOneKey == accountOneKey {
                            runningBalanceOne = runningBalanceOne - filteredUniversalItem.what
                        } else {
                            runningBalanceOne = runningBalanceOne + filteredUniversalItem.what
                        }
                    default:
                        if filteredUniversalItem.whoKey == trueYou { // I.e., the general case
                            runningBalanceOne = runningBalanceOne - filteredUniversalItem.what
                        } else {
                            runningBalanceOne = runningBalanceOne + filteredUniversalItem.what
                        }
                    }
                }
            }
        }
        return runningBalanceOne
    }

    func balAfter(thisUniversal: UniversalItem, completion: @escaping () -> ()) -> [Int] {
        mip = MIProcessor.sharedMIP.mIP
        mipA = MIProcessor.sharedMIP.mIPAccounts
        mipU = MIProcessor.sharedMIP.mIPUniversals
        self.accountOneKey = thisUniversal.accountOneKey
        self.accountTwoKey = thisUniversal.accountTwoKey
        self.particularUniversalTimeStamp = thisUniversal.timeStamp as! Double
        switch thisUniversal.universalItemType {
        case 4: // This is the transfer case - the only case to use a secondary account
            assumingAccountOne {
                self.runningBalances.append(self.runningBalanceOne)
            }
            assumingAccountTwo {
                self.runningBalances.append(self.runningBalanceTwo)
            }
            completion()
        default:
            assumingAccountOne {
                self.runningBalances.append(self.runningBalanceOne)
                self.runningBalances.append(self.runningBalanceTwo)
            }
            completion()
        }
        return runningBalances
    }
    
    func assumingAccountOne(completion: @escaping () -> ()) {
        for mA in mipA {
            if mA.key == self.accountOneKey {
                let startingBalanceOne = mA.startingBal
                self.runningBalanceOne = startingBalanceOne
                self.trueYou = MIProcessor.sharedMIP.trueYou
                firebaseUniversalsFilteredByTimeRange = mipU.filter({ (universalItem) -> Bool in
                    if let testedTimeStamp: Double = universalItem.timeStamp as? Double {
                        if testedTimeStamp <= particularUniversalTimeStamp {
                            return true
                        } else {
                            return false
                        }
                    } else {
                        return false
                    }
                })
                firebaseUniversalsFilteredAlsoByAccountKey = firebaseUniversalsFilteredByTimeRange.filter({ (universalItem) -> Bool in
                    if (universalItem.accountOneKey == accountOneKey) || (universalItem.accountTwoKey == accountOneKey) {
                        return true
                    } else {
                        return false
                    }
                })
                for filteredUniversalItem in firebaseUniversalsFilteredAlsoByAccountKey {
                    switch filteredUniversalItem.universalItemType {
                    case 0, 1, 2:
                        if filteredUniversalItem.whoKey == trueYou { // I.e., the general case
                            runningBalanceOne = runningBalanceOne - filteredUniversalItem.what
                        } else {
                            runningBalanceOne = runningBalanceOne + filteredUniversalItem.what
                        }
                    case 3:
                        runningBalanceOne = runningBalanceOne - filteredUniversalItem.what
                    case 4:
                        if filteredUniversalItem.accountOneKey == accountOneKey {
                            runningBalanceOne = runningBalanceOne - filteredUniversalItem.what
                        } else {
                            runningBalanceOne = runningBalanceOne + filteredUniversalItem.what
                        }
                    default:
                        if filteredUniversalItem.whoKey == trueYou { // I.e., the general case
                            runningBalanceOne = runningBalanceOne - filteredUniversalItem.what
                        } else {
                            runningBalanceOne = runningBalanceOne + filteredUniversalItem.what
                        }
                    }
                }
            }
        }
    }
    
    func assumingAccountTwo(completion: @escaping () -> ()) {
        for mA in mipA {
            if mA.key == self.accountTwoKey {
                let startingBalanceTwo = mA.startingBal
                self.runningBalanceTwo = startingBalanceTwo
                self.trueYou = MIProcessor.sharedMIP.trueYou
                firebaseUniversalsFilteredByTimeRange = mipU.filter({ (universalItem) -> Bool in
                    if let testedTimeStamp: Double = universalItem.timeStamp as? Double {
                        if testedTimeStamp <= particularUniversalTimeStamp {
                            return true
                        } else {
                            return false
                        }
                    } else {
                        return false
                    }
                })
                firebaseUniversalsFilteredAlsoByAccountKey = firebaseUniversalsFilteredByTimeRange.filter({ (universalItem) -> Bool in
                    if (universalItem.accountOneKey == accountOneKey) || (universalItem.accountTwoKey == accountOneKey) {
                        return true
                    } else {
                        return false
                    }
                })
                for filteredUniversalItem in firebaseUniversalsFilteredAlsoByAccountKey {
                    switch filteredUniversalItem.universalItemType {
                    case 0, 1, 2:
                        if filteredUniversalItem.whoKey == trueYou { // I.e., the general case
                            runningBalanceTwo = runningBalanceTwo - filteredUniversalItem.what
                        } else {
                            runningBalanceTwo = runningBalanceTwo + filteredUniversalItem.what
                        }
                    case 3:
                        runningBalanceTwo = runningBalanceTwo - filteredUniversalItem.what
                    case 4:
                        if filteredUniversalItem.accountTwoKey == accountTwoKey {
                            runningBalanceTwo = runningBalanceTwo - filteredUniversalItem.what
                        } else {
                            runningBalanceTwo = runningBalanceTwo + filteredUniversalItem.what
                        }
                    default:
                        if filteredUniversalItem.whoKey == trueYou { // I.e., the general case
                            runningBalanceTwo = runningBalanceTwo - filteredUniversalItem.what
                        } else {
                            runningBalanceTwo = runningBalanceTwo + filteredUniversalItem.what
                        }
                    }
                }
            }
        }
    }
}
