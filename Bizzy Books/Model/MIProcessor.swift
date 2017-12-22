//
//  MIProcessor.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/19/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import Firebase

final class MIProcessor {
    
    static let sharedMIP = MIProcessor()
    private init() {}
    
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
    var obtainProjectStatus = ObtainProjectStatus()
    var balOneAfter: Int = 0
    var balTwoAfter: Int = 0
    var balsAfter: [Int?] = [Int?]()
    
    func loadTheMip(completion: @escaping () -> ()) {
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
        self.universalsRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for item in snapshot.children {
                self.mIPUniversals.append(UniversalItem(snapshot: item as! DataSnapshot))
            }
            self.projectsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                for item in snapshot.children {
                    self.mIPProjects.append(ProjectItem(snapshot: item as! DataSnapshot))
                }
                self.entitiesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    for item in snapshot.children {
                        self.mIPEntities.append(EntityItem(snapshot: item as! DataSnapshot))
                    }
                    self.accountsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        for item in snapshot.children {
                            self.mIPAccounts.append(AccountItem(snapshot: item as! DataSnapshot))
                        }
                        self.vehiclesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                            for item in snapshot.children {
                                self.mIPVehicles.append(VehicleItem(snapshot: item as! DataSnapshot))
                            }
                            let youRef = Database.database().reference().child("users").child(userUID).child("youEntity")
                            youRef.observeSingleEvent(of: .value, with: { (snapshot) in
                                if let youKey = snapshot.value as? String {
                                    self.trueYou = youKey
                                    completion()
                                }
                            })
                        })
                    })
                })
            })
        })
    }
    
    func loadTheBalAfters(completion: @escaping () -> ()) {
        for i in 0..<mIPUniversals.count {
            obtainBalanceAfter.balAfter(thisUniversal: mIPUniversals[i], completion: {
                let stringer = StringifyAnInt()
                let balOneAfter = self.obtainBalanceAfter.runningBalanceOne
                self.mIPUniversals[i].balOneAfter = balOneAfter
                self.mIPUniversals[i].balOneAfterString = stringer.stringify(theInt: balOneAfter)
                let balTwoAfter = self.obtainBalanceAfter.runningBalanceTwo
                self.mIPUniversals[i].balTwoAfter = balTwoAfter
                self.mIPUniversals[i].balTwoAfterString = stringer.stringify(theInt: balTwoAfter)
                if (i + 1) == self.mIPUniversals.count {
                    completion()
                }
            })
        }
    }
    
    func loadTheStatuses(completion: @escaping () -> ()) {
        for i in 0..<mIPUniversals.count {
            if (mIPUniversals[i].universalItemType == 0) || (mIPUniversals[i].universalItemType == 2) || (mIPUniversals[i].universalItemType == 6) {
                obtainProjectStatus.obtainStatus(universalItem: mIPUniversals[i], completion: {
                    self.mIPUniversals[i].projectStatusString = self.obtainProjectStatus.projectStatusName
                    print("ARGH! " + self.mIPUniversals[i].projectStatusString)
                    self.mIPUniversals[i].projectStatusId = self.obtainProjectStatus.projectStatusId
                    if (i + 1) == self.mIPUniversals.count {
                        completion()
                    }
                })
            }
        }
    }
    
}
