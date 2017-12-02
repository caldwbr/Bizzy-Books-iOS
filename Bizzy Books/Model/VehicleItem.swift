//
//  VehicleItem.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/10/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

struct VehicleItem {
    
    let key: String //By "key" is meant "id"
    let year: String
    let make: String
    let model: String
    let color: String
    let fuel: Int
    let placedInCommissionDate: String
    let licensePlateNumber: String
    let vehicleIdentificationNumber: String
    let ref: DatabaseReference?
    
    init(year: String, make: String, model: String, color: String, fuel: Int, placedInCommissionDate: String, licensePlateNumber: String, vehicleIdentificationNumber: String, key: String = "") {
        self.key = key
        self.year = year
        self.make = make
        self.model = model
        self.color = color
        self.fuel = fuel
        self.placedInCommissionDate = placedInCommissionDate
        self.licensePlateNumber = licensePlateNumber
        self.vehicleIdentificationNumber = vehicleIdentificationNumber
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        year = snapshotValue["year"] as! String
        make = snapshotValue["make"] as! String
        model = snapshotValue["model"] as! String
        color = snapshotValue["color"] as! String
        fuel = snapshotValue["fuel"] as! Int
        placedInCommissionDate = snapshotValue["placedInCommissionDate"] as! String
        licensePlateNumber = snapshotValue["licensePlateNumber"] as! String
        vehicleIdentificationNumber = snapshotValue["vehicleIdentificationNumber"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "year": year,
            "make": make,
            "model": model,
            "color": color,
            "fuel": fuel,
            "placedInCommissionDate": placedInCommissionDate,
            "licensePlateNumber": licensePlateNumber,
            "vehicleIdentificationNumber": vehicleIdentificationNumber,
        ]
    }
    
}
