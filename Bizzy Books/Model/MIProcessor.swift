//
//  MIProcessor.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/19/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import Firebase

class MIProcessor: NSObject {
    
    static let sharedMIP = MIProcessor()
    
    public var mIP: [MultiversalItem] = [MultiversalItem]()
    public var mIPUniversals: [UniversalItem] = [UniversalItem]()
    public var mIPProjects: [ProjectItem] = [ProjectItem]()
    public var mIPEntities: [EntityItem] = [EntityItem]()
    public var mIPAccounts: [AccountItem] = [AccountItem]()
    public var mIPVehicles: [VehicleItem] = [VehicleItem]()
    public var trueYou: String = String()
    var universalsRef: DatabaseReference!
    var entitiesRef: DatabaseReference!
    var projectsRef: DatabaseReference!
    var vehiclesRef: DatabaseReference!
    var accountsRef: DatabaseReference!
    var obtainBalanceAfter = ObtainBalanceAfter()
    var balOneAfter: Int = 0
    var balTwoAfter: Int = 0
    
    func loadTheMip() {
        self.universalsRef = Database.database().reference().child("users").child(userUID).child("universals")
        self.projectsRef = Database.database().reference().child("users").child(userUID).child("projects")
        self.entitiesRef = Database.database().reference().child("users").child(userUID).child("entities")
        self.accountsRef = Database.database().reference().child("users").child(userUID).child("accounts")
        self.vehiclesRef = Database.database().reference().child("users").child(userUID).child("vehicles")
        mIP.removeAll()
        mIPUniversals.removeAll()
        mIPProjects.removeAll()
        mIPEntities.removeAll()
        mIPAccounts.removeAll()
        mIPVehicles.removeAll()
        self.universalsRef.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let firebaseUniversal = UniversalItem(snapshot: item as! DataSnapshot)
                self.mIPUniversals.append(firebaseUniversal)
                let firebaseUniversalM = firebaseUniversal as MultiversalItem
                self.mIP.append(firebaseUniversalM)
            }
        }
        self.projectsRef.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let firebaseProject = ProjectItem(snapshot: item as! DataSnapshot)
                self.mIPProjects.append(firebaseProject)
                let firebaseProjectM = firebaseProject as MultiversalItem
                self.mIP.append(firebaseProjectM)
            }
        }
        self.entitiesRef.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let firebaseEntity = EntityItem(snapshot: item as! DataSnapshot)
                self.mIPEntities.append(firebaseEntity)
                let firebaseEntityM = firebaseEntity as MultiversalItem
                self.mIP.append(firebaseEntityM)
            }
        }
        self.accountsRef.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let firebaseAccount = AccountItem(snapshot: item as! DataSnapshot)
                self.mIPAccounts.append(firebaseAccount)
                let firebaseAccountM = firebaseAccount as MultiversalItem
                self.mIP.append(firebaseAccountM)
            }
        }
        self.vehiclesRef.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let firebaseVehicle = VehicleItem(snapshot: item as! DataSnapshot)
                self.mIPVehicles.append(firebaseVehicle)
                let firebaseVehicleM = firebaseVehicle as MultiversalItem
                self.mIP.append(firebaseVehicleM)
            }
        }
        let youRef = Database.database().reference().child("users").child(userUID).child("youEntity")
        youRef.observe(.value) { (snapshot) in
            if let youKey = snapshot.value as? String {
                self.trueYou = youKey
            }
        }
    }
    
    func loadTheBalAfters() {
        for i in 0..<mIPUniversals.count {
            let balsAfter: [Int?] = obtainBalanceAfter.balAfter(thisUniversal: mIPUniversals[i])
            if balsAfter[0] != nil {
                balOneAfter = balsAfter[0]!
            }
            if balsAfter[1] != nil {
                balTwoAfter = balsAfter[1]!
            }
            mIPUniversals[i].balOneAfter = balOneAfter
            mIPUniversals[i].balTwoAfter = balTwoAfter
        }
    }
    
}
