//
//  AccountItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/10/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct AccountItem: MultiversalItem {
    
    var multiversalType: Int = 3
    let key: String
    let name: String
    let accountTypeId: Int //0 = Bank Account, 1 = Credit Account, 2 = Cash, 3 = Refund Store Credit
    let phoneNumber: String
    let email: String
    let street: String
    let city: String
    let state: String
    let startingBal: Int
    let creditDetailsAvailable: Bool
    let isLoan: Bool //More strictly, is it something that will definitely incur interest fee even when paid "on time"?
    let loanType: Int //For future use - for example, 6 monthly repayments equally divide original premium plus 4% of interest for first two months, and plus 1% of interest for next 4 months ALL THIS could be 0, and 1 could represent something else, etc.
    let loanTypeSubcategory: Int //For future use if needed
    let loanPercentOne: Double //Future use if needed
    let loanPercentTwo: Double //Future use if needed
    let loanPercentThree: Double //Future use if needed
    let loanPercentFour: Double //Future use if needed
    let loanIntFactorOne: Int //Future use if needed
    let loanIntFactorTwo: Int //Future use if needed
    let loanIntFactorThree: Int //Future use if needed
    let loanIntFactorFour: Int //Future use if needed
    let maxLimit: Int //Credit card max allowed borrow amount
    let maxCashAdvanceAllowance: Int
    let closeDay: Int //Day of cycle credit card closes (curtain for what is billed that month)
    let dueDay: Int //Day of cycle credit card payment is due
    let cycle: Int //Per week? per month? I.e. 0 = Month, 1 = Week, ...
    let minimumPaymentRequired: Int //Minimum payment required so as not to incur late fees
    let lateFeeAsOneTimeInt: Int
    let lateFeeAsPercentageOfTotalBalance: Double //Expressed as 12.00% for example.
    let cycleDues: Int //If there's a per-cycle due like $20/mo to be in the program
    let duesCycle: Int //0 = month, 1 = week...
    let minimumPaymentToBeSmart: Int //Minimum payment advisable so as not to incur interest fees (THIS NUMBER IS USUALLY CONVENIENTLY HIDDEN OR OBFUSCATED BY THOSE CREDIT CARD COMPANY JERKS!)
    let interestRate: Double // Expressed as % ie 29.99% apr per year
    let interestKind: Int // APR or the other kind plus are there any others?
    let timeStamp: Any
    let ref: DatabaseReference?
    
    init(name: String, accountTypeId: Int, phoneNumber: String, email: String, street: String, city: String, state: String, startingBal: Int, creditDetailsAvailable: Bool, isLoan: Bool, loanType: Int, loanTypeSubcategory: Int, loanPercentOne: Double, loanPercentTwo: Double, loanPercentThree: Double, loanPercentFour: Double, loanIntFactorOne: Int, loanIntFactorTwo: Int, loanIntFactorThree: Int, loanIntFactorFour: Int, maxLimit: Int, maxCashAdvanceAllowance: Int, closeDay: Int, dueDay: Int, cycle: Int, minimumPaymentRequired: Int, lateFeeAsOneTimeInt: Int, lateFeeAsPercentageOfTotalBalance: Double, cycleDues: Int, duesCycle: Int, minimumPaymentToBeSmart: Int, interestRate: Double, interestKind: Int, timeStamp: Any, key: String = "") {
        self.key = key
        self.name = name
        self.accountTypeId = accountTypeId
        self.phoneNumber = phoneNumber
        self.email = email
        self.street = street
        self.city = city
        self.state = state
        self.startingBal = startingBal
        self.creditDetailsAvailable = creditDetailsAvailable
        self.isLoan = isLoan
        self.loanType = loanType
        self.loanTypeSubcategory = loanTypeSubcategory
        self.loanPercentOne = loanPercentOne
        self.loanPercentTwo = loanPercentTwo
        self.loanPercentThree = loanPercentThree
        self.loanPercentFour = loanPercentFour
        self.loanIntFactorOne = loanIntFactorOne
        self.loanIntFactorTwo = loanIntFactorTwo
        self.loanIntFactorThree = loanIntFactorThree
        self.loanIntFactorFour = loanIntFactorFour
        self.maxLimit = maxLimit
        self.maxCashAdvanceAllowance = maxCashAdvanceAllowance
        self.closeDay = closeDay
        self.dueDay = dueDay
        self.cycle = cycle
        self.minimumPaymentRequired = minimumPaymentRequired
        self.lateFeeAsOneTimeInt = lateFeeAsOneTimeInt
        self.lateFeeAsPercentageOfTotalBalance = lateFeeAsPercentageOfTotalBalance
        self.cycleDues = cycleDues
        self.duesCycle = duesCycle
        self.minimumPaymentToBeSmart = minimumPaymentToBeSmart
        self.interestRate = interestRate
        self.interestKind = interestKind
        self.timeStamp = timeStamp
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = (snapshotValue["name"] as? String)?.decryptIt() ?? ""
        accountTypeId = snapshotValue["accountTypeId"] as? Int ?? 0
        phoneNumber = (snapshotValue["phoneNumber"] as? String)?.decryptIt() ?? ""
        email = (snapshotValue["email"] as? String)?.decryptIt() ?? ""
        street = (snapshotValue["street"] as? String)?.decryptIt() ?? ""
        city = (snapshotValue["city"] as? String)?.decryptIt() ?? ""
        state = (snapshotValue["state"] as? String)?.decryptIt() ?? ""
        startingBal = (snapshotValue["startingBal"] as? String)?.decryptIt().toInt() ?? 0
        creditDetailsAvailable = snapshotValue["creditDetailsAvailable"] as? Bool ?? false
        isLoan = snapshotValue["isLoan"] as? Bool ?? false
        loanType = snapshotValue["loanType"] as? Int ?? 0
        loanTypeSubcategory = snapshotValue["loanTypeSubcategory"] as? Int ?? 0
        loanPercentOne = (snapshotValue["loanPercentOne"] as? String)?.decryptIt().toDouble() ?? 0.0
        loanPercentTwo = (snapshotValue["loanPercentTwo"] as? String)?.decryptIt().toDouble() ?? 0.0
        loanPercentThree = (snapshotValue["loanPercentThree"] as? String)?.decryptIt().toDouble() ?? 0.0
        loanPercentFour = (snapshotValue["loanPercentFour"] as? String)?.decryptIt().toDouble() ?? 0.0
        loanIntFactorOne = snapshotValue["loanIntFactorOne"] as? Int ?? 0
        loanIntFactorTwo = snapshotValue["loanIntFactorTwo"] as? Int ?? 0
        loanIntFactorThree = snapshotValue["loanIntFactorThree"] as? Int ?? 0
        loanIntFactorFour = snapshotValue["loanIntFactorFour"] as? Int ?? 0
        maxLimit = (snapshotValue["maxLimit"] as? String)?.decryptIt().toInt() ?? 0
        maxCashAdvanceAllowance = (snapshotValue["maxCashAdvanceAllowance"] as? String)?.decryptIt().toInt() ?? 0
        closeDay = snapshotValue["closeDay"] as? Int ?? 0
        dueDay = snapshotValue["dueDay"] as? Int ?? 0
        cycle = snapshotValue["cycle"] as? Int ?? 0
        minimumPaymentRequired = snapshotValue["minimumPaymentRequired"] as? Int ?? 0
        lateFeeAsOneTimeInt = snapshotValue["lateFeeAsOneTimeInt"] as? Int ?? 0
        lateFeeAsPercentageOfTotalBalance = (snapshotValue["lateFeeAsPercentageOfTotalBalance"] as? String)?.decryptIt().toDouble() ?? 0.0
        cycleDues = (snapshotValue["cycleDues"] as? String)?.decryptIt().toInt() ?? 0
        duesCycle = snapshotValue["duesCycle"] as? Int ?? 0
        minimumPaymentToBeSmart = (snapshotValue["minimumPaymentToBeSmart"] as? String)?.decryptIt().toInt() ?? 0
        interestRate = (snapshotValue["interestRate"] as? String)?.decryptIt().toDouble() ?? 0.0
        interestKind = snapshotValue["interestKind"] as? Int ?? 0
        timeStamp = snapshotValue["timeStamp"] ?? 0
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "accountTypeId": accountTypeId,
            "phoneNumber": phoneNumber,
            "email": email,
            "street": street,
            "city": city,
            "state": state,
            "startingBal": startingBal.toString(),
            "creditDetailsAvailable": creditDetailsAvailable,
            "isLoan": isLoan,
            "loanType": loanType,
            "loanTypeSubcategory": loanTypeSubcategory,
            "loanPercentOne": loanPercentOne.toString(),
            "loanPercentTwo": loanPercentTwo.toString(),
            "loanPercentThree": loanPercentThree.toString(),
            "loanPercentFour": loanPercentFour.toString(),
            "loanIntFactorOne": loanIntFactorOne,
            "loanIntFactorTwo": loanIntFactorTwo,
            "loanIntFactorThree": loanIntFactorThree,
            "loanIntFactorFour": loanIntFactorFour,
            "maxLimit": maxLimit.toString(),
            "maxCashAdvanceAllowance": maxCashAdvanceAllowance.toString(),
            "closeDay": closeDay,
            "dueDay": dueDay,
            "cycle": cycle,
            "minimumPaymentRequired": minimumPaymentRequired,
            "lateFeeAsOneTimeInt": lateFeeAsOneTimeInt,
            "lateFeeAsPercentageOfTotalBalance": lateFeeAsPercentageOfTotalBalance.toString(),
            "cycleDues": cycleDues.toString(),
            "duesCycle": duesCycle,
            "minimumPaymentToBeSmart": minimumPaymentToBeSmart.toString(),
            "interestRate": interestRate.toString(),
            "interestKind": interestKind,
            "timeStamp": timeStamp
        ]
    }
    
}
