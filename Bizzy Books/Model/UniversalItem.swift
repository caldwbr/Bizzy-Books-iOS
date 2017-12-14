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
    let taxReasonId: Int
    let vehicleName: String
    let vehicleKey: String
    let workersCompId: Int // 0 = Sub has wc, 1 = Incurred wc, 2 = wc n/a
    let advertisingMeansId: Int
    let personalReasonId: Int
    let percentBusiness: Int
    let accountOneName: String
    let accountOneKey: String
    let accountTwoName: String
    let accountTwoKey: String
    let howMany: Int //x1000
    let fuelTypeId: Int // 0 = 87, 1 = 89, 2 = 91, 3 = Diesel
    let useTax: Bool
    let notes: String
    let picUrl: String
    let projectPicTypeId: Int
    let timeStamp: Any
    let latitude: Double //Times 100,000?? Optional because desktops don't produce lat and long I don't think
    let longitude: Double //Times 100,000?? Optional because desktops don't produce lat and long I don't think
    let atmFee: Bool // For future use
    let feeAmount: Int // For future use
    let ref: DatabaseReference?
    
    init(universalItemType: Int, projectItemName: String, projectItemKey: String, odometerReading: Int, whoName: String, whoKey: String, what: Int, whomName: String, whomKey: String, taxReasonId: Int, vehicleName: String, vehicleKey: String, workersCompId: Int, advertisingMeansId: Int, personalReasonId: Int, percentBusiness: Int, accountOneName: String, accountOneKey: String, accountTwoName: String, accountTwoKey: String, howMany: Int, fuelTypeId: Int, useTax: Bool, notes: String, picUrl: String, projectPicTypeId: Int, timeStamp: Any, latitude: Double, longitude: Double, atmFee: Bool, feeAmount: Int, key: String = "") {
        self.key = key
        self.universalItemType = universalItemType
        self.projectItemName = projectItemName
        self.projectItemKey = projectItemKey
        self.odometerReading = odometerReading
        self.whoName = whoName
        self.whoKey = whoKey
        self.what = what
        self.whomName = whomName
        self.whomKey = whomKey
        self.taxReasonId = taxReasonId
        self.vehicleName = vehicleName
        self.vehicleKey = vehicleKey
        self.workersCompId = workersCompId
        self.advertisingMeansId = advertisingMeansId
        self.personalReasonId = personalReasonId
        self.percentBusiness = percentBusiness
        self.accountOneName = accountOneName
        self.accountOneKey = accountOneKey
        self.accountTwoName = accountTwoName
        self.accountTwoKey = accountTwoKey
        self.howMany = howMany
        self.fuelTypeId = fuelTypeId
        self.useTax = useTax
        self.notes = notes
        self.picUrl = picUrl
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
        universalItemType = snapshotValue["universalItemType"] as! Int
        projectItemName = snapshotValue["projectItemName"] as! String
        projectItemKey = snapshotValue["projectItemKey"] as! String
        odometerReading = snapshotValue["odometerReading"] as! Int
        whoName = snapshotValue["whoName"] as! String
        whoKey = snapshotValue["whoKey"] as! String
        what = snapshotValue["what"] as! Int
        whomName = snapshotValue["whomName"] as! String
        whomKey = snapshotValue["whomKey"] as! String
        taxReasonId = snapshotValue["taxReasonId"] as! Int
        vehicleName = snapshotValue["vehicleName"] as! String
        vehicleKey = snapshotValue["vehicleKey"] as! String
        workersCompId = snapshotValue["workersCompId"] as! Int
        advertisingMeansId = snapshotValue["advertisingMeansId"] as! Int
        personalReasonId = snapshotValue["personalReasonId"] as! Int
        percentBusiness = snapshotValue["percentBusiness"] as! Int
        accountOneName = snapshotValue["accountOneName"] as! String
        accountOneKey = snapshotValue["accountOneKey"] as! String
        accountTwoName = snapshotValue["accountTwoName"] as! String
        accountTwoKey = snapshotValue["accountTwoKey"] as! String
        howMany = snapshotValue["howMany"] as! Int
        fuelTypeId = snapshotValue["fuelTypeId"] as! Int
        useTax = snapshotValue["useTax"] as! Bool
        notes = snapshotValue["notes"] as! String
        picUrl = snapshotValue["picUrl"] as! String
        projectPicTypeId = snapshotValue["projectPicTypeId"] as! Int
        timeStamp = snapshotValue["timeStamp"] as Any
        latitude = snapshotValue["latitude"] as! Double
        longitude = snapshotValue["longitude"] as! Double
        atmFee = snapshotValue["atmFee"] as! Bool
        feeAmount = snapshotValue["feeAmoount"] as! Int
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "universalItemType": universalItemType,
            "projectItemName": projectItemName,
            "projectItemKey": projectItemKey,
            "odometerReading": odometerReading,
            "whoName": whoName,
            "whoKey": whoKey,
            "what": what,
            "whomName": whomName,
            "whomKey": whomKey,
            "taxReasonId": taxReasonId,
            "vehicleName": vehicleName,
            "vehicleKey": vehicleKey,
            "workersCompId": workersCompId,
            "advertisingMeansId": advertisingMeansId,
            "personalReasonId": personalReasonId,
            "percentBusiness": percentBusiness,
            "accountOneName": accountOneName,
            "accountOneKey": accountOneKey,
            "accountTwoName": accountTwoName,
            "accountTwoKey": accountTwoKey,
            "howMany": howMany,
            "fuelTypeId": fuelTypeId,
            "useTax": useTax,
            "notes": notes,
            "picUrl": picUrl,
            "projectPicTypeId": projectPicTypeId,
            "timeStamp": timeStamp,
            "latitude": latitude,
            "longitude": longitude,
            "atmFee": atmFee,
            "feeAmount": feeAmount
        ]
    }
    
}


