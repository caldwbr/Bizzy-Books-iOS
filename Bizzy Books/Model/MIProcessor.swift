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
    public var sIP: [MultiversalItem] = [MultiversalItem]() // the search mip!
    public var mipORsip: Int = Int()
    public var mIPUniversals: [UniversalItem] = [UniversalItem]()
    public var mIPProjects: [ProjectItem] = [ProjectItem]()
    public var mIPEntities: [EntityItem] = [EntityItem]()
    public var mIPAccounts: [AccountItem] = [AccountItem]()
    public var mIPVehicles: [VehicleItem] = [VehicleItem]()
    public var trueYou: String = String()
    public var isUserCurrentlySubscribed: Bool = Bool()
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
        mipORsip = 0 // MIP!
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
        appendTheGoodies()
        for i in 0..<mIPUniversals.count {
            let j = mIPUniversals.count - i - 1
            mIP.append(mIPUniversals[j])
        }
        for i in 0..<mIPProjects.count {
            let j = mIPProjects.count - i - 1
            mIP.append(mIPProjects[j])
            let searchItem = SearchItem(i: mIP.count - 1, name: mIPProjects[j].name)
            masterSearchArray.append(searchItem)
        }
        for i in 0..<mIPEntities.count {
            let j = mIPEntities.count - i - 1
            mIP.append(mIPEntities[j])
            let searchItem = SearchItem(i: mIP.count - 1, name: mIPEntities[j].name)
            masterSearchArray.append(searchItem)
        }
        for i in 0..<mIPAccounts.count {
            let j = mIPAccounts.count - i - 1
            mIP.append(mIPAccounts[j])
            let searchItem = SearchItem(i: mIP.count - 1, name: mIPAccounts[j].name)
            masterSearchArray.append(searchItem)
        }
        for i in 0..<mIPVehicles.count {
            let j = mIPVehicles.count - i - 1
            mIP.append(mIPVehicles[j])
            let vehName = mIPVehicles[j].year + " " + mIPVehicles[j].make + " " + mIPVehicles[j].model
            let searchItem = SearchItem(i: mIP.count - 1, name: vehName)
            masterSearchArray.append(searchItem)
        }
    }
    
    func appendTheGoodies() {
        let goodies: [String] = ["Items", "Projects", "Entities", "Accounts", "Vehicles", "Overhead", "Business", "Personal", "Mixed", "Fuel", "Transfer", "Project Media"]
        for i in 0..<goodies.count {
            let searchItem = SearchItem(i: -i, name: goodies[i])
            masterSearchArray.append(searchItem)
        }
    }
    
    func updateTheSIP(i: Int) { // I.e. SEARCH mip hahahaha ;)
        mipORsip = 1 // SIP!
        sIP.removeAll()
        if i > 0 { //This would be Project, Entity, Account or Vehicle
            switch mIP[i].multiversalType {
            case 1: // Project
                if let thisProj = mIP[i] as? ProjectItem {
                    sIP.append(thisProj)
                    for thisUniv in mIPUniversals {
                        if thisUniv.projectItemKey == thisProj.key {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case 2: // Entity
                if let thisEnti = mIP[i] as? EntityItem {
                    sIP.append(thisEnti)
                    for thisProj in mIPProjects {
                        if thisProj.customerKey == thisEnti.key {
                            sIP.append(thisProj)
                        }
                    }
                    for thisUniv in mIPUniversals {
                        if (thisUniv.whoKey == thisEnti.key) || (thisUniv.whomKey == thisEnti.key) {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case 3: // Account
                if let thisAcco = mIP[i] as? AccountItem {
                    sIP.append(thisAcco)
                    for thisUniv in mIPUniversals {
                        if (thisUniv.accountOneKey == thisAcco.key) || (thisUniv.accountTwoKey == thisAcco.key) {
                            sIP.append(thisUniv)
                        }
                    }
                }
            default: // I.e. case 4 Vehicle
                if let thisVehi = mIP[i] as? VehicleItem {
                    sIP.append(thisVehi)
                    for thisUniv in mIPUniversals {
                        if thisUniv.vehicleKey == thisVehi.key {
                            sIP.append(thisUniv)
                        }
                    }
                }
            }
        } else { //This would be goodies
            switch i {
            case -1: // Show all project cards
                for thisProj in mIPProjects {
                    sIP.append(thisProj)
                }
            case -2: // Show all entities
                for thisEnti in mIPEntities {
                    sIP.append(thisEnti)
                }
            case -3: // Show all accounts
                for thisAcco in mIPAccounts {
                    sIP.append(thisAcco)
                }
            case -4: // Show all vehicles
                for thisVehi in mIPVehicles {
                    sIP.append(thisVehi)
                }
            case -5: // Show all overhead items
                for thisUniv in mIPUniversals {
                    if thisUniv.projectItemKey == "0" {
                        sIP.append(thisUniv)
                    }
                }
            case -6: // Show all business items (including mixed)
                for thisUniv in mIPUniversals {
                    if thisUniv.universalItemType == 0 || thisUniv.universalItemType == 2 {
                        sIP.append(thisUniv)
                    }
                }
            case -7: // Show all personal items (including mixed)
                for thisUniv in mIPUniversals {
                    if thisUniv.universalItemType == 1 || thisUniv.universalItemType == 2 {
                        sIP.append(thisUniv)
                    }
                }
            case -8: // Show all mixed items only
                for thisUniv in mIPUniversals {
                    if thisUniv.universalItemType == 2 {
                        sIP.append(thisUniv)
                    }
                }
            case -9: // Show all fuel items
                for thisUniv in mIPUniversals {
                    if thisUniv.universalItemType == 3 {
                        sIP.append(thisUniv)
                    }
                }
            case -10: // Show all transfer items
                for thisUniv in mIPUniversals {
                    if thisUniv.universalItemType == 4 {
                        sIP.append(thisUniv)
                    }
                }
            case -11: // Project media items
                for thisUniv in mIPUniversals {
                    if thisUniv.universalItemType == 6 {
                        sIP.append(thisUniv)
                    }
                }
            default: // I.e. case 0 Show all universals
                for thisUniv in mIPUniversals {
                    sIP.append(thisUniv)
                }
            }
        }
    }
    
}
