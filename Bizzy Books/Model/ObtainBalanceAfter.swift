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
    //var tHeMiP = MIProcessor.sharedMIP //THIS IS THE FILE THAT TAKES 17seconds AND NEEDS PLACED IN BACKGROUND!! And try to rewrite to be faster!!
    var mip = [MultiversalItem]()
    var mipA = [AccountItem]()
    var mipU = [UniversalItem]()
    var firebaseUniversals: [UniversalItem] = [UniversalItem]()
    var firebaseUniversalsFilteredByTimeRange: [UniversalItem] = [UniversalItem]()
    var firebaseUniversalsFilteredAlsoByAccountKey: [UniversalItem] = [UniversalItem]()
    var passedUniversals: [UniversalItem] = [UniversalItem]()
    var trueYou: String = String()
    var runningBalanceOne: Int = 0
    var runningBalanceTwo: Int = 0
    var startingBalanceOne: Int = 0
    var runningBalances: [Int] = [Int]()
    var accountsRef: DatabaseReference!
    var accountOneKey: String = String()
    var accountTwoKey: String = String()
    var particularUniversalTimeStamp: Double = Double()
    var stringifyAnInt = StringifyAnInt()
    
    //THIS FUNCTION is just for when you are adjusting current bank balance, as there is no Universal to reference!
    func balAfter(accountKey: String, particularUniversalTimeStamp: Double, completion: @escaping () -> ()) {
        for i in 0..<MIProcessor.sharedMIP.mIPAccounts.count {
            if MIProcessor.sharedMIP.mIPAccounts[i].key == accountKey {
                startingBalanceOne = MIProcessor.sharedMIP.mIPAccounts[i].startingBal
                self.runningBalanceOne = startingBalanceOne
                self.trueYou = MIProcessor.sharedMIP.trueYou
                firebaseUniversalsFilteredByTimeRange = MIProcessor.sharedMIP.mIPUniversals.filter({ (universalItem) -> Bool in
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
                    if (universalItem.accountOneKey == accountKey) || (universalItem.accountTwoKey == accountKey) {
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
                        if filteredUniversalItem.accountOneKey == accountKey {
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
        completion()
    }
    
    func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
        let objDateformat: DateFormatter = DateFormatter()
        objDateformat.dateFormat = "yyyy-MM-dd"
        let strTime: String = objDateformat.string(from: dateToConvert as Date)
        let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
        let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
        let strTimeStamp: String = "\(milliseconds)"
        return strTimeStamp
    }
    
    func prepareBalsAfterForSingleUniversal(universal: UniversalItem) -> [Any] {
        self.accountOneKey = universal.accountOneKey
        self.accountTwoKey = universal.accountTwoKey
        self.passedUniversals.append(universal)
        let now = Double(Date().timeIntervalSince1970 * 1000)
        self.particularUniversalTimeStamp = now //?? Double(1548322400000)
        var passBackArray: [Any] = [Any]()
        switch universal.universalItemType {
        case 4: // This is the transfer case - the only case to use a secondary account
            assumingAccountOne {
                passBackArray.append(self.runningBalanceOne)
                passBackArray.append(self.stringifyAnInt.stringify(theInt: self.runningBalanceOne))
            }
            assumingAccountTwo {
                passBackArray.append(self.runningBalanceTwo)
                passBackArray.append(self.stringifyAnInt.stringify(theInt: self.runningBalanceTwo))
            }
        default:
            assumingAccountOne {
                passBackArray.append(self.runningBalanceOne)
                passBackArray.append(self.stringifyAnInt.stringify(theInt: self.runningBalanceOne))
                passBackArray.append(self.runningBalanceTwo)
                passBackArray.append(self.stringifyAnInt.stringify(theInt: self.runningBalanceTwo))
            }
        }
        return passBackArray
    }

    func balsAfter() {
        for i in 0..<MIProcessor.sharedMIP.mIPUniversals.count {
            self.accountOneKey = MIProcessor.sharedMIP.mIPUniversals[i].accountOneKey
            self.accountTwoKey = MIProcessor.sharedMIP.mIPUniversals[i].accountTwoKey
            self.particularUniversalTimeStamp = MIProcessor.sharedMIP.mIPUniversals[i].timeStamp as! Double
            switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
            case 4: // This is the transfer case - the only case to use a secondary account
                assumingAccountOne {
                    MIProcessor.sharedMIP.mIPUniversals[i].balOneAfter = self.runningBalanceOne
                    MIProcessor.sharedMIP.mIPUniversals[i].balOneAfterString = self.stringifyAnInt.stringify(theInt: self.runningBalanceOne)
                }
                assumingAccountTwo {
                    MIProcessor.sharedMIP.mIPUniversals[i].balTwoAfter = self.runningBalanceTwo
                    MIProcessor.sharedMIP.mIPUniversals[i].balTwoAfterString = self.stringifyAnInt.stringify(theInt: self.runningBalanceTwo)
                }
            default:
                assumingAccountOne {
                    MIProcessor.sharedMIP.mIPUniversals[i].balOneAfter = self.runningBalanceOne
                    MIProcessor.sharedMIP.mIPUniversals[i].balOneAfterString = self.stringifyAnInt.stringify(theInt: self.runningBalanceOne)
                    MIProcessor.sharedMIP.mIPUniversals[i].balTwoAfter = self.runningBalanceTwo
                    MIProcessor.sharedMIP.mIPUniversals[i].balTwoAfterString = self.stringifyAnInt.stringify(theInt: self.runningBalanceTwo)
                }
            }
        }
    }
    
    func assumingAccountOne(completion: @escaping () -> ()) {
        for i in 0..<MIProcessor.sharedMIP.mIPAccounts.count {
            if MIProcessor.sharedMIP.mIPAccounts[i].key == self.accountOneKey {
                print("hI")
                let startingBalanceOne = MIProcessor.sharedMIP.mIPAccounts[i].startingBal
                self.runningBalanceOne = startingBalanceOne
                self.trueYou = MIProcessor.sharedMIP.trueYou
                firebaseUniversalsFilteredByTimeRange = MIProcessor.sharedMIP.mIPUniversals.filter({ (universalItem) -> Bool in
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
                    if (universalItem.accountOneKey == self.accountOneKey) || (universalItem.accountTwoKey == self.accountOneKey) {
                        return true
                    } else {
                        return false
                    }
                })
                if passedUniversals.count > 0 {
                    firebaseUniversalsFilteredAlsoByAccountKey.append(passedUniversals[0])
                }
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
                completion()
            } else {
                completion()
            }
        }
    }
    
    func assumingAccountTwo(completion: @escaping () -> ()) {
        for i in 0..<MIProcessor.sharedMIP.mIPAccounts.count {
            if MIProcessor.sharedMIP.mIPAccounts[i].key == self.accountTwoKey {
                print("HeLLO")
                let startingBalanceTwo = MIProcessor.sharedMIP.mIPAccounts[i].startingBal
                self.runningBalanceTwo = startingBalanceTwo
                self.trueYou = MIProcessor.sharedMIP.trueYou
                firebaseUniversalsFilteredByTimeRange = MIProcessor.sharedMIP.mIPUniversals.filter({ (universalItem) -> Bool in
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
                    if (universalItem.accountOneKey == self.accountTwoKey) || (universalItem.accountTwoKey == self.accountTwoKey) {
                        return true
                    } else {
                        return false
                    }
                })
                if passedUniversals.count > 0 {
                    firebaseUniversalsFilteredAlsoByAccountKey.append(passedUniversals[0])
                }
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
                            runningBalanceTwo = runningBalanceTwo + filteredUniversalItem.what
                        } else {
                            runningBalanceTwo = runningBalanceTwo - filteredUniversalItem.what
                        }
                    default:
                        if filteredUniversalItem.whoKey == trueYou { // I.e., the general case
                            runningBalanceTwo = runningBalanceTwo - filteredUniversalItem.what
                        } else {
                            runningBalanceTwo = runningBalanceTwo + filteredUniversalItem.what
                        }
                    }
                }
                completion()
            } else {
                completion()
            }
        }
    }
}
