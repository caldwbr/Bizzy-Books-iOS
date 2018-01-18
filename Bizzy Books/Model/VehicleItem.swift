//
//  VehicleItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/10/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct VehicleItem: MultiversalItem {
    
    var multiversalType: Int = 4
    let key: String //By "key" is meant "id"
    let year: String
    let make: String
    let model: String
    let color: String
    let fuelId: Int
    let fuelString: String
    let placedInCommissionDate: String
    let licensePlateNumber: String
    let vehicleIdentificationNumber: String
    let timeStamp: Any
    let ref: DatabaseReference?
    
    init(year: String, make: String, model: String, color: String, fuelId: Int, fuelString: String, placedInCommissionDate: String, licensePlateNumber: String, vehicleIdentificationNumber: String, timeStamp: Any, key: String = "") {
        self.key = key
        self.year = year
        self.make = make
        self.model = model
        self.color = color
        self.fuelId = fuelId
        self.fuelString = fuelString
        self.placedInCommissionDate = placedInCommissionDate
        self.licensePlateNumber = licensePlateNumber
        self.vehicleIdentificationNumber = vehicleIdentificationNumber
        self.timeStamp = timeStamp
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        year = (snapshotValue["year"] as? String)?.decryptIt() ?? ""
        make = (snapshotValue["make"] as? String)?.decryptIt() ?? ""
        model = (snapshotValue["model"] as? String)?.decryptIt() ?? ""
        color = (snapshotValue["color"] as? String)?.decryptIt() ?? ""
        fuelId = snapshotValue["fuelId"] as? Int ?? 0
        fuelString = (snapshotValue["fuelString"] as? String)?.decryptIt() ?? ""
        placedInCommissionDate = (snapshotValue["placedInCommissionDate"] as? String)?.decryptIt() ?? ""
        licensePlateNumber = (snapshotValue["licensePlateNumber"] as? String)?.decryptIt() ?? ""
        vehicleIdentificationNumber = (snapshotValue["vehicleIdentificationNumber"] as? String)?.decryptIt() ?? ""
        timeStamp = snapshotValue["timeStamp"] ?? 0
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "year": year.encryptIt(),
            "make": make.encryptIt(),
            "model": model.encryptIt(),
            "color": color.encryptIt(),
            "fuelId": fuelId,
            "fuelString": fuelString.encryptIt(),
            "placedInCommissionDate": placedInCommissionDate.encryptIt(),
            "licensePlateNumber": licensePlateNumber.encryptIt(),
            "vehicleIdentificationNumber": vehicleIdentificationNumber.encryptIt(),
            "timeStamp": timeStamp
        ]
    }
    
}
