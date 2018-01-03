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
            /*
            if mIPUniversals[j].notes != "" {
                let searchItemNotes = SearchItem(i: -mIP.count - 99, name: "Notes: \(mIPUniversals[j].notes)")
                masterSearchArray.append(searchItemNotes)
            }*/
        }
        for i in 0..<mIPProjects.count {
            let j = mIPProjects.count - i - 1
            mIP.append(mIPProjects[j])
            let searchItem = SearchItem(i: mIP.count - 1, name: mIPProjects[j].name)
            masterSearchArray.append(searchItem)
            /*
            if mIPProjects[j].projectNotes != "" {
                let searchItemNotes = SearchItem(i: -mIP.count - 99, name: "Notes: \(mIPProjects[j].projectNotes)")
                masterSearchArray.append(searchItemNotes)
            }
            if mIPProjects[j].projectTags != "" {
                let searchItemTags = SearchItem(i: -mIP.count - 999999, name: "Tags: \(mIPProjects[j].projectTags)")
                masterSearchArray.append(searchItemTags)
            }*/
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
        let goodies: [String] = ["Items", "Projects", "Entities", "Accounts", "Vehicles", "Overhead", "Business", "Personal", "Mixed", "Fuel", "Transfer", "Project media", "Current job leads", "Current bids", "Jobs under contract", "Paid jobs", "Lost job opportunities", "Other project status", "Job via unknown means", "Job via referral", "Job via website", "Job via YP", "Job via social media", "Job via soliciting", "Job via AdWords", "Job via company shirts", "Job via sign", "Job via vehicle wrap", "Job via billboard", "Job via TV", "Job via radio", "Job via other method"]
        for i in 0..<goodies.count {
            let searchItem = SearchItem(i: -i, name: goodies[i])
            masterSearchArray.append(searchItem)
        }
    }
    
    func updateTheSIP(i: Int, name: String) { // I.e. SEARCH mip hahahaha ;)
        mipORsip = 1 // SIP!
        sIP.removeAll()
        if i > 0 { //This would be Project, Entity, Account or Vehicle
            if i < 1_000_000 {
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
                default: // Vehicle
                    if let thisVehi = mIP[i] as? VehicleItem {
                        sIP.append(thisVehi)
                        for thisUniv in mIPUniversals {
                            if thisUniv.vehicleKey == thisVehi.key {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            } else if i == 1_000_000 {
                let wordToRemove = "Notes containing: "
                var namey = name
                if let range = namey.range(of: wordToRemove) {
                    namey.removeSubrange(range)
                    for thisProj in mIPProjects {
                        if thisProj.projectNotes.localizedCaseInsensitiveContains(namey) {
                            sIP.append(thisProj)
                        }
                    }
                    for thisUniv in mIPUniversals {
                        if thisUniv.notes.localizedCaseInsensitiveContains(namey) {
                            sIP.append(thisUniv)
                        }
                    }
                }
            } else if i == 1_000_001 {
                let wordToRemove = "Tags containing: "
                var namey = name
                if let range = namey.range(of: wordToRemove) {
                    namey.removeSubrange(range)
                    for thisProj in mIPProjects {
                        if thisProj.projectTags.localizedCaseInsensitiveContains(namey) {
                            sIP.append(thisProj)
                        }
                    }
                }
            } // Note that nothing is done with numbers > 1_000_001 this space is AVAILABLE!! lol
        } else { //This would be goodies
            switch i {
            case 0: // Show all universals
                for thisUniv in mIPUniversals {
                    sIP.append(thisUniv)
                }
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
            case -12: // Current job leads
                for thisProj in mIPProjects {
                    if thisProj.projectStatusId == 0 {
                        sIP.append(thisProj)
                    }
                }
            case -13: // Current bids
                for thisProj in mIPProjects {
                    if thisProj.projectStatusId == 1 {
                        sIP.append(thisProj)
                    }
                }
            case -14: // Jobs under contract
                for thisProj in mIPProjects {
                    if thisProj.projectStatusId == 2 {
                        sIP.append(thisProj)
                    }
                }
            case -15: // Paid jobs
                for thisProj in mIPProjects {
                    if thisProj.projectStatusId == 3 {
                        sIP.append(thisProj)
                    }
                }
            case -16: // Lost job opportunities
                for thisProj in mIPProjects {
                    if thisProj.projectStatusId == 4 {
                        sIP.append(thisProj)
                    }
                }
            case -17: // Other project status
                for thisProj in mIPProjects {
                    if thisProj.projectStatusId == 5 {
                        sIP.append(thisProj)
                    }
                }
            case -18: // Job via unknown means
                for thisProj in mIPProjects {
                    if thisProj.howDidTheyHearOfYouId == 0 {
                        sIP.append(thisProj)
                    }
                }
            case -19: // Job via referral
                for thisProj in mIPProjects {
                    if thisProj.howDidTheyHearOfYouId == 1 {
                        sIP.append(thisProj)
                    }
                }
            case -20: // Job via website
                for thisProj in mIPProjects {
                    if thisProj.howDidTheyHearOfYouId == 2 {
                        sIP.append(thisProj)
                    }
                }
            case -21: // Job via YP
                for thisProj in mIPProjects {
                    if thisProj.howDidTheyHearOfYouId == 3 {
                        sIP.append(thisProj)
                    }
                }
            case -22: // Job via social media
                for thisProj in mIPProjects {
                    if thisProj.howDidTheyHearOfYouId == 4 {
                        sIP.append(thisProj)
                    }
                }
            case -23: // Job via soliciting
                for thisProj in mIPProjects {
                    if thisProj.howDidTheyHearOfYouId == 5 {
                        sIP.append(thisProj)
                    }
                }
            case -24: // Job via AdWords
                for thisProj in mIPProjects {
                    if thisProj.howDidTheyHearOfYouId == 6 {
                        sIP.append(thisProj)
                    }
                }
            case -25: // Job via company shirt
                for thisProj in mIPProjects {
                    if thisProj.howDidTheyHearOfYouId == 7 {
                        sIP.append(thisProj)
                    }
                }
            case -26: // Job via sign
                for thisProj in mIPProjects {
                    if thisProj.howDidTheyHearOfYouId == 8 {
                        sIP.append(thisProj)
                    }
                }
            case -27: // Job via vehicle wrap
                for thisProj in mIPProjects {
                    if thisProj.howDidTheyHearOfYouId == 9 {
                        sIP.append(thisProj)
                    }
                }
            case -28: // Job via billboard
                for thisProj in mIPProjects {
                    if thisProj.howDidTheyHearOfYouId == 10 {
                        sIP.append(thisProj)
                    }
                }
            case -29: // Job via TV
                for thisProj in mIPProjects {
                    if thisProj.howDidTheyHearOfYouId == 11 {
                        sIP.append(thisProj)
                    }
                }
            case -30: // Job via radio
                for thisProj in mIPProjects {
                    if thisProj.howDidTheyHearOfYouId == 12 {
                        sIP.append(thisProj)
                    }
                }
            case -31: // Job via other means
                for thisProj in mIPProjects {
                    if thisProj.howDidTheyHearOfYouId == 13 {
                        sIP.append(thisProj)
                    }
                }
            default: // I.e. cases -100 or lower (NOTES) **AND** cases -1_000_000 or lower (TAGS)
                print("Nada")
                /* // THIS SHOWS EVERY PROJECTS NOTES IF MATCHING, which tends to BLOAT the search field - I have a better way of simply searching notes CONTAINING or tags CONTAINING which uses POSITIVE INT 1_000_000 and 1_000_001
                if i > -1_000_000 { // I.e. univ notes or project notes
                    print(1)
                    let h = -(i + 100)
                    switch mIP[h].multiversalType {
                    case 1: // Project
                        if let thisProj = mIP[h] as? ProjectItem {
                            sIP.append(thisProj)
                        }
                    default: // Universal
                        if let thisUniv = mIP[h] as? UniversalItem {
                            sIP.append(thisUniv)
                        }
                    }
                } else { // I.e. project tags
                    print(2)
                    let h = -(i + 1_000_000)
                    if let thisProj = mIP[h] as? ProjectItem {
                        sIP.append(thisProj)
                    }
                }
 */
            }
        }
    }
    
}
