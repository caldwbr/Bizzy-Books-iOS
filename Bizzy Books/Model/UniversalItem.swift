//
//  UniversalItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/10/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct UniversalItem: MultiversalItem {
    
    var multiversalType: Int = 0
    var balOneAfter: Int = 0
    var balOneAfterString: String = "$0.00"
    var balTwoAfter: Int = 0
    var balTwoAfterString: String = "$0.00"
    var projectStatusId: Int = -1
    var projectStatusString: String = ""
    let key: String //By "key" is meant "id"
    let universalItemType: Int //0 - Business, 1 - Personal, 2 - Mixed, 3 - Fuel, 4 - Transfer, 5 - Adjust, 6 - Documents
    let projectItemName: String
    let projectItemKey: String
    let odometerReading: Int
    let whoName: String
    let whoKey: String
    let what: Int //Remember $5.48 is represented as 548, and needs to be divided by 100 before showing user and multiplied before storing.
    let whomName: String
    let whomKey: String
    let taxReasonName: String
    let taxReasonId: Int
    let vehicleName: String
    let vehicleKey: String
    let workersCompName: String
    let workersCompId: Int // 0 = Sub has wc, 1 = Incurred wc, 2 = wc n/a
    let advertisingMeansName: String
    let advertisingMeansId: Int
    let personalReasonName: String
    let personalReasonId: Int
    let percentBusiness: Int
    let accountOneName: String
    let accountOneKey: String
    let accountOneType: Int
    let accountTwoName: String
    let accountTwoKey: String
    let accountTwoType: Int
    let howMany: Int //x1000
    let fuelTypeName: String
    let fuelTypeId: Int // 0 = 87, 1 = 89, 2 = 91, 3 = Diesel
    let useTax: Bool
    let notes: String
    let picUrl: String
    let picAspectRatio: Int // Expressed as HEIGHT over WIDTH TIMES 1000 (to allow to be int with accuracy, just as with money except 1000 here) we changed it from height to aspect ratio because user could also sign in on an Android device of different width
    let picNumber: Int
    let projectPicTypeName: String
    let projectPicTypeId: Int
    let timeStamp: Any
    let latitude: Double //Times 100,000?? Optional because desktops don't produce lat and long I don't think
    let longitude: Double //Times 100,000?? Optional because desktops don't produce lat and long I don't think
    let atmFee: Bool // For future use
    let feeAmount: Int // For future use
    let ref: DatabaseReference?
    
    init(universalItemType: Int, balOneAfter: Int, balOneAfterString: String, balTwoAfter: Int, balTwoAfterString: String, projectItemName: String, projectItemKey: String, odometerReading: Int, whoName: String, whoKey: String, what: Int, whomName: String, whomKey: String, taxReasonName: String, taxReasonId: Int, vehicleName: String, vehicleKey: String, workersCompName: String, workersCompId: Int, advertisingMeansName: String, advertisingMeansId: Int, personalReasonName: String, personalReasonId: Int, percentBusiness: Int, accountOneName: String, accountOneKey: String, accountOneType: Int, accountTwoName: String, accountTwoKey: String, accountTwoType: Int, howMany: Int, fuelTypeName: String, fuelTypeId: Int, useTax: Bool, notes: String, picUrl: String, picAspectRatio: Int, picNumber: Int, projectPicTypeName: String, projectPicTypeId: Int, timeStamp: Any, latitude: Double, longitude: Double, atmFee: Bool, feeAmount: Int, key: String = "") {
        self.key = key
        self.universalItemType = universalItemType
        self.balOneAfter = balOneAfter
        self.balOneAfterString = balOneAfterString
        self.balTwoAfter = balTwoAfter
        self.balTwoAfterString = balTwoAfterString
        self.projectItemName = projectItemName
        self.projectItemKey = projectItemKey
        self.odometerReading = odometerReading
        self.whoName = whoName
        self.whoKey = whoKey
        self.what = what
        self.whomName = whomName
        self.whomKey = whomKey
        self.taxReasonName = taxReasonName
        self.taxReasonId = taxReasonId
        self.vehicleName = vehicleName
        self.vehicleKey = vehicleKey
        self.workersCompName = workersCompName
        self.workersCompId = workersCompId
        self.advertisingMeansName = advertisingMeansName
        self.advertisingMeansId = advertisingMeansId
        self.personalReasonName = personalReasonName
        self.personalReasonId = personalReasonId
        self.percentBusiness = percentBusiness
        self.accountOneName = accountOneName
        self.accountOneKey = accountOneKey
        self.accountOneType = accountOneType
        self.accountTwoName = accountTwoName
        self.accountTwoKey = accountTwoKey
        self.accountTwoType = accountTwoType
        self.howMany = howMany
        self.fuelTypeName = fuelTypeName
        self.fuelTypeId = fuelTypeId
        self.useTax = useTax
        self.notes = notes
        self.picUrl = picUrl
        self.picAspectRatio = picAspectRatio
        self.picNumber = picNumber
        self.projectPicTypeName = projectPicTypeName
        self.projectPicTypeId = projectPicTypeId
        self.timeStamp = timeStamp
        self.latitude = latitude
        self.longitude = longitude
        self.atmFee = atmFee
        self.feeAmount = feeAmount
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        universalItemType = snapshotValue["universalItemType"] as? Int ?? 0
        balOneAfter = snapshotValue["balOneAfter"] as? Int ?? 0
        balOneAfterString = snapshotValue["balOneAfterString"] as? String ?? ""
        balTwoAfter = snapshotValue["balTwoAfter"] as? Int ?? 0
        balTwoAfterString = snapshotValue["balTwoAfterString"] as? String ?? ""
        projectItemName = (snapshotValue["projectItemName"] as? String)?.decryptIt() ?? ""
        projectItemKey = snapshotValue["projectItemKey"] as? String ?? ""
        odometerReading = snapshotValue["odometerReading"] as? Int ?? 0
        whoName = (snapshotValue["whoName"] as? String)?.decryptIt() ?? ""
        whoKey = snapshotValue["whoKey"] as? String ?? ""
        what = (snapshotValue["what"] as? String)?.decryptIt().toInt() ?? 0
        whomName = (snapshotValue["whomName"] as? String)?.decryptIt() ?? ""
        whomKey = snapshotValue["whomKey"] as? String ?? ""
        taxReasonName = (snapshotValue["taxReasonName"] as? String)?.decryptIt() ?? ""
        taxReasonId = snapshotValue["taxReasonId"] as? Int ?? 0
        vehicleName = (snapshotValue["vehicleName"] as? String)?.decryptIt() ?? ""
        vehicleKey = snapshotValue["vehicleKey"] as? String ?? ""
        workersCompName = (snapshotValue["workersCompName"] as? String)?.decryptIt() ?? ""
        workersCompId = snapshotValue["workersCompId"] as? Int ?? 0
        advertisingMeansName = (snapshotValue["advertisingMeansName"] as? String)?.decryptIt() ?? ""
        advertisingMeansId = snapshotValue["advertisingMeansId"] as? Int ?? 0
        personalReasonName = (snapshotValue["personalReasonName"] as? String)?.decryptIt() ?? ""
        personalReasonId = snapshotValue["personalReasonId"] as? Int ?? 0
        percentBusiness = snapshotValue["percentBusiness"] as? Int ?? 0
        accountOneName = (snapshotValue["accountOneName"] as? String)?.decryptIt() ?? ""
        accountOneKey = snapshotValue["accountOneKey"] as? String ?? ""
        accountOneType = snapshotValue["accountOneType"] as? Int ?? 0
        accountTwoName = (snapshotValue["accountTwoName"] as? String)?.decryptIt() ?? ""
        accountTwoKey = snapshotValue["accountTwoKey"] as? String ?? ""
        accountTwoType = snapshotValue["accountTwoType"] as? Int ?? 0
        howMany = (snapshotValue["howMany"] as? String)?.decryptIt().toInt() ?? 0
        fuelTypeName = (snapshotValue["fuelTypeName"] as? String)?.decryptIt() ?? ""
        fuelTypeId = snapshotValue["fuelTypeId"] as? Int ?? 0
        useTax = snapshotValue["useTax"] as? Bool ?? false
        notes = (snapshotValue["notes"] as? String)?.decryptIt() ?? ""
        picUrl = (snapshotValue["picUrl"] as? String)?.decryptIt() ?? ""
        picAspectRatio = snapshotValue["picAspectRatio"] as? Int ?? 1
        picNumber = snapshotValue["picNumber"] as? Int ?? 0
        projectPicTypeName = ((snapshotValue["projectPicTypeName"] as? String)?.decryptIt())!
        projectPicTypeId = snapshotValue["projectPicTypeId"] as? Int ?? 0
        timeStamp = snapshotValue["timeStamp"] ?? 0
        latitude = (snapshotValue["latitude"] as? String)?.decryptIt().toDouble() ?? 0.0
        longitude = (snapshotValue["longitude"] as? String)?.decryptIt().toDouble() ?? 0.0
        atmFee = snapshotValue["atmFee"] as? Bool ?? false
        feeAmount = snapshotValue["feeAmoount"] as? Int ?? 0
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "universalItemType": universalItemType,
            "balOneAfter": balOneAfter,
            "balOneAfterString": balOneAfterString,
            "balTwoAfter": balTwoAfter,
            "balTwoAfterString": balTwoAfterString,
            "projectItemName": projectItemName,
            "projectItemKey": projectItemKey,
            "odometerReading": odometerReading,
            "whoName": whoName,
            "whoKey": whoKey,
            "what": what.toString(),
            "whomName": whomName,
            "whomKey": whomKey,
            "taxReasonName": taxReasonName,
            "taxReasonId": taxReasonId,
            "vehicleName": vehicleName,
            "vehicleKey": vehicleKey,
            "workersCompName": workersCompName,
            "workersCompId": workersCompId,
            "advertisingMeansName": advertisingMeansName,
            "advertisingMeansId": advertisingMeansId,
            "personalReasonName": personalReasonName,
            "personalReasonId": personalReasonId,
            "percentBusiness": percentBusiness,
            "accountOneName": accountOneName,
            "accountOneKey": accountOneKey,
            "accountOneType": accountOneType,
            "accountTwoName": accountTwoName,
            "accountTwoKey": accountTwoKey,
            "accountTwoType": accountTwoType,
            "howMany": howMany.toString(),
            "fuelTypeName": fuelTypeName,
            "fuelTypeId": fuelTypeId,
            "useTax": useTax,
            "notes": notes,
            "picUrl": picUrl,
            "picAspectRatio": picAspectRatio,
            "picNumber": picNumber,
            "projectPicTypeName": projectPicTypeName,
            "projectPicTypeId": projectPicTypeId,
            "timeStamp": timeStamp,
            "latitude": latitude.toString(),
            "longitude": longitude.toString(),
            "atmFee": atmFee,
            "feeAmount": feeAmount
        ]
    }
    
}


