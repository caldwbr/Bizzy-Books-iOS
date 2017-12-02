//
//  UniversalItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/10/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct UniversalItem {
    
    let key: String //By "key" is meant "id"
    let universalItemType: UniversalItemType //0 - Business, 1 - Personal, 2 - Mixed, 3 - Fuel, 4 - Transfer, 5 - Adjust, 6 - Documents
    let projectItem: ProjectItem?
    let odometerReading: Int?
    let who: EntityItem?
    let what: Int? //Remember $5.48 is represented as 548, and needs to be divided by 100 before showing user and multiplied before storing.
    let whom: EntityItem?
    let taxReasonItem: TaxReasonItem?
    let vehicleItem: VehicleItem?
    let workersCompItem: WorkersCompItem?
    let advertisingMeansItem: AdvertisingMeansItem?
    let personalReasonItem: PersonalReasonItem?
    let percentBusiness: Int?
    let accountOne: AccountItem?
    let accountTwo: AccountItem?
    let howMany: Int? //x1000
    let fuelTypeItem: FuelTypeItem?
    let useTax: Bool?
    let notes: String?
    let picUrl: String?
    let projectDocs: [ProjectDocItem]?
    let timeStamp: Int //Will need to be represented in seconds, NOT MILLISECONDS!!
    let latitude: Int? //Times 100,000?? Optional because desktops don't produce lat and long I don't think
    let longitude: Int? //Times 100,000?? Optional because desktops don't produce lat and long I don't think
    let mileStone: Int? //This is for if user changes status of project from lead to bid or bid to contract or contract to paid
    let ref: DatabaseReference?
    
    init(universalItemType: UniversalItemType, projectItem: ProjectItem?, odometerReading: Int?, who: EntityItem?, what: Int?, whom: EntityItem?, taxReasonItem: TaxReasonItem?, vehicleItem: VehicleItem?, workersCompItem: WorkersCompItem?, advertisingMeansItem: AdvertisingMeansItem?, personalReasonItem: PersonalReasonItem?, percentBusiness: Int?, accountOne: AccountItem?, accountTwo: AccountItem?, howMany: Int?, fuelTypeItem: FuelTypeItem?, useTax: Bool?, notes: String?, picUrl: String?, projectDocs: [ProjectDocItem]?, timeStamp: Int, latitude: Int?, longitude: Int?, mileStone: Int?, key: String = "") {
        self.key = key
        self.universalItemType = universalItemType
        self.projectItem = projectItem
        self.odometerReading = odometerReading
        self.who = who
        self.what = what
        self.whom = whom
        self.taxReasonItem = taxReasonItem
        self.vehicleItem = vehicleItem
        self.workersCompItem = workersCompItem
        self.advertisingMeansItem = advertisingMeansItem
        self.personalReasonItem = personalReasonItem
        self.percentBusiness = percentBusiness
        self.accountOne = accountOne
        self.accountTwo = accountTwo
        self.howMany = howMany
        self.fuelTypeItem = fuelTypeItem
        self.useTax = useTax
        self.notes = notes
        self.picUrl = picUrl
        self.projectDocs = projectDocs
        self.timeStamp = timeStamp
        self.latitude = latitude
        self.longitude = longitude
        self.mileStone = mileStone
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        universalItemType = snapshotValue["universalItemType"] as! UniversalItemType
        projectItem = snapshotValue["projectItem"] as? ProjectItem
        odometerReading = snapshotValue["odometerReading"] as? Int
        who = snapshotValue["who"] as? EntityItem
        what = snapshotValue["what"] as? Int
        whom = snapshotValue["whom"] as? EntityItem
        taxReasonItem = snapshotValue["taxReasonItem"] as? TaxReasonItem
        vehicleItem = snapshotValue["vehicleItem"] as? VehicleItem
        workersCompItem = snapshotValue["workersCompItem"] as? WorkersCompItem
        advertisingMeansItem = snapshotValue["advertisingMeansItem"] as? AdvertisingMeansItem
        personalReasonItem = snapshotValue["personalReasonItem"] as? PersonalReasonItem
        percentBusiness = snapshotValue["percentBusiness"] as? Int
        accountOne = snapshotValue["accountOne"] as? AccountItem
        accountTwo = snapshotValue["accountTwo"] as? AccountItem
        howMany = snapshotValue["howMany"] as? Int
        fuelTypeItem = snapshotValue["fuelTypeItem"] as? FuelTypeItem
        useTax = snapshotValue["useTax"] as? Bool
        notes = snapshotValue["notes"] as? String
        picUrl = snapshotValue["picUrl"] as? String
        projectDocs = snapshotValue["projectDocs"] as? [ProjectDocItem]
        timeStamp = snapshotValue["timeStamp"] as! Int
        latitude = snapshotValue["latitude"] as? Int
        longitude = snapshotValue["longitude"] as? Int
        mileStone = snapshotValue["mileStone"] as? Int
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "universalItemType": universalItemType,
            "projectItem": projectItem!,
            "odometerReading": odometerReading!,
            "who": who!,
            "what": what!,
            "whom": whom!,
            "taxReasonItem": taxReasonItem!,
            "vehicleItem": vehicleItem!,
            "workersCompItem": workersCompItem!,
            "advertisingMeansItem": advertisingMeansItem!,
            "personalReasonItem": personalReasonItem!,
            "percentBusiness": percentBusiness!,
            "accountOne": accountTwo!,
            "accountTwo": accountTwo!,
            "howMany": howMany!,
            "fuelTypeItem": fuelTypeItem!,
            "useTax": useTax!,
            "notes": notes!,
            "picUrl": picUrl!,
            "projectDocs": projectDocs!,
            "timeStamp": timeStamp,
            "latitude": latitude!,
            "longitude": longitude!,
            "mileStone": mileStone!
        ]
    }
    
}


