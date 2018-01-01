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
    var masterSearchArray: [SearchItem] = [SearchItem]()
    
    func loadTheMip(completion: @escaping () -> ()) {
        self.universalsRef = Database.database().reference().child("users").child(userUID).child("universals")
        self.projectsRef = Database.database().reference().child("users").child(userUID).child("projects")
        self.entitiesRef = Database.database().reference().child("users").child(userUID).child("entities")
        self.accountsRef = Database.database().reference().child("users").child(userUID).child("accounts")
        self.vehiclesRef = Database.database().reference().child("users").child(userUID).child("vehicles")
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
    
    func loadTheStatuses() {
        for i in 0..<mIPUniversals.count {
            if (mIPUniversals[i].universalItemType == 0) || (mIPUniversals[i].universalItemType == 2) || (mIPUniversals[i].universalItemType == 6) {
                obtainProjectStatus.obtainStatus(i: i)
            }
        }
    }
    
    func obtainTheBalancesAfter() {
        let obtainBalanceAfter = ObtainBalanceAfter()
        obtainBalanceAfter.balsAfter()
    }
    
    func updateTheMIP() {
        mIP.removeAll()
        masterSearchArray.removeAll()
        //HERE IS WHERE YOU WANT TO ADD IN THE GOODIES INTO THE MASTER SEARCH ARRAY ALL THE NEGATIVE INTS
        for i in 0..<mIPUniversals.count {
            let j = mIPUniversals.count - i - 1
            mIP.append(mIPUniversals[j])
        }
        for i in 0..<mIPProjects.count {
            let j = mIPProjects.count - i - 1
            mIP.append(mIPProjects[j])
            let searchItem = SearchItem(i: mIP.count, name: mIPProjects[j].name)
            masterSearchArray.append(searchItem)
        }
        for i in 0..<mIPEntities.count {
            let j = mIPEntities.count - i - 1
            mIP.append(mIPEntities[j])
            let searchItem = SearchItem(i: mIP.count, name: mIPEntities[j].name)
            masterSearchArray.append(searchItem)
        }
        for i in 0..<mIPAccounts.count {
            let j = mIPAccounts.count - i - 1
            mIP.append(mIPAccounts[j])
            let searchItem = SearchItem(i: mIP.count, name: mIPAccounts[j].name)
            masterSearchArray.append(searchItem)
        }
        for i in 0..<mIPVehicles.count {
            let j = mIPVehicles.count - i - 1
            mIP.append(mIPVehicles[j])
            let vehName = mIPVehicles[j].year + " " + mIPVehicles[j].make + " " + mIPVehicles[j].model
            let searchItem = SearchItem(i: mIP.count, name: vehName)
            masterSearchArray.append(searchItem)
        }
    }
    
}
