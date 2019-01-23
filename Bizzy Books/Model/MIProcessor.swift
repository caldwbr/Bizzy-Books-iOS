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
    
    public var firstTime: Bool = false
    public var mIP: [MultiversalItem] = [MultiversalItem]()
    public var sIP: [MultiversalItem] = [MultiversalItem]() // the search mip!
    public var mipORsip: Int = Int()
    public var mIPUniversals: [UniversalItem] = [UniversalItem]()
    public var mIPProjects: [ProjectItem] = [ProjectItem]()
    public var mIPEntities: [EntityItem] = [EntityItem]()
    public var mIPAccounts: [AccountItem] = [AccountItem]()
    public var mIPVehicles: [VehicleItem] = [VehicleItem]()
    public var mIPBusinessInfos: [BusinessInfo] = [BusinessInfo]()
    public var businessInfo: BusinessInfo = BusinessInfo(businessName: "", businessAddress1: "", businessAddress2: "", mainWork: "", subcat1: "", subcat2: "", subcat3: "", subcat4: "", subcat5: "", subcat6: "")
    public var trueYou: String = String()
    public var isUserCurrentlySubscribed: Bool = Bool()
    private var tHeKeY: Data!
    var theUser: User!
    var universalsRef: DatabaseReference!
    var entitiesRef: DatabaseReference!
    var projectsRef: DatabaseReference!
    var vehiclesRef: DatabaseReference!
    var accountsRef: DatabaseReference!
    var businessInfoRef: DatabaseReference!
    var keyRef: DatabaseReference!
    var obtainBalanceAfter = ObtainBalanceAfter()
    var obtainProjectStatus = ObtainProjectStatus()
    var balOneAfter: Int = 0
    var balTwoAfter: Int = 0
    var balsAfter: [Int?] = [Int?]()
    var masterSearchArray: [SearchItem] = [SearchItem]()
    var authorized: Bool!
    var theKeyIsHere: String!
    
    func loadTheMip(completion: @escaping () -> ()) {
        mipORsip = 0 // MIP!
        //obtainTheKey {
            
            self.universalsRef = Database.database().reference().child("users").child(userUID).child("universals")
            self.projectsRef = Database.database().reference().child("users").child(userUID).child("projects")
            self.entitiesRef = Database.database().reference().child("users").child(userUID).child("entities")
            self.accountsRef = Database.database().reference().child("users").child(userUID).child("accounts")
            self.vehiclesRef = Database.database().reference().child("users").child(userUID).child("vehicles")
            self.businessInfoRef = Database.database().reference().child("users").child(userUID).child("businessInfo")
            self.mIPUniversals.removeAll()
            self.mIPProjects.removeAll()
            self.mIPEntities.removeAll()
            self.mIPAccounts.removeAll()
            self.mIPVehicles.removeAll()
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
                                        self.businessInfoRef.observeSingleEvent(of: .value, with: { (snapshot) in
                                            for item in snapshot.children {
                                                self.mIPBusinessInfos.append(BusinessInfo(snapshot: item as! DataSnapshot))
                                                self.businessInfo.businessName = self.mIPBusinessInfos[0].businessName ?? ""
                                                self.businessInfo.businessAddress1 = self.mIPBusinessInfos[0].businessAddress1 ?? ""
                                                self.businessInfo.businessAddress2 = self.mIPBusinessInfos[0].businessAddress2 ?? ""
                                                self.businessInfo.mainWork = self.mIPBusinessInfos[0].mainWork ?? ""
                                                self.businessInfo.subcat1 = self.mIPBusinessInfos[0].subcat1 ?? ""
                                                self.businessInfo.subcat2 = self.mIPBusinessInfos[0].subcat2 ?? ""
                                                self.businessInfo.subcat3 = self.mIPBusinessInfos[0].subcat3 ?? ""
                                                self.businessInfo.subcat4 = self.mIPBusinessInfos[0].subcat4 ?? ""
                                                self.businessInfo.subcat5 = self.mIPBusinessInfos[0].subcat5 ?? ""
                                                self.businessInfo.subcat6 = self.mIPBusinessInfos[0].subcat6 ?? ""
                                                completion()
                                            }
                                        })
                                    }
                                })
                            })
                        })
                    })
                })
            })
        //}
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
        let goodies: [String] = ["Items", "Projects", "Entities", "Accounts", "Vehicles", "Overhead", "Business", "Personal", "Mixed", "Fuel", "Transfer", "Project media", businessInfo.subcat1, businessInfo.subcat2, businessInfo.subcat3, businessInfo.subcat4, businessInfo.subcat5, businessInfo.subcat6, "Jobs via unknown means", "Jobs via referral", "Jobs via website", "Jobs via YP", "Jobs via social media", "Jobs via soliciting", "Jobs via AdWords", "Jobs via company shirts", "Jobs via sign", "Jobs via vehicle wrap", "Jobs via billboard", "Jobs via TV", "Jobs via radio", "Jobs via other method", "Customers", "Vendors", "Subs", "Employees", "Stores", "Government", "Other entities", "You entity type", "Food", "Fun", "Pet", "Utilities", "Phone", "Office", "Giving", "Insurance", "House", "Yard", "Medical", "Travel", "Clothes", "Other personal category", "Income", "Supplies", "Labor", "Meals", "Office", "Vehicle", "Advertising", "Pro help", "Machine rental", "Property rental", "Tax+license", "Insurance(WC+GL)", "Business travel", "Employee benefit", "Depreciation", "Depletion", "Business utilities", "Commissions", "Business wages", "Business mortgage interest", "Other business interest", "Business pension", "Business repairs", "Unknown advertising expenses", "Referral expenses", "Website expenses", "YP expenses", "Social media expenses", "Soliciting expenses", "AdWords expenses", "Company shirt expenses", "Sign expenses", "Vehicle wrap expenses", "Billboard expenses", "TV ad expenses", "Radio ad expenses", "Other ad expenses", "Sub has WC", "Incurred WC", "WC N/A", "Bank accounts", "Credit accounts", "Cash accounts", "Store refund accounts"]
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
            case -12: // Current job leads//NOPE NOW IT'S subcat1
                for thisProj in mIPProjects {
                    if thisProj.projectStatusId == 0 {
                        sIP.append(thisProj)
                    }
                }
            case -13: // Current bids//NOPE NOW IT'S subcat2
                for thisProj in mIPProjects {
                    if thisProj.projectStatusId == 1 {
                        sIP.append(thisProj)
                    }
                }
            case -14: // Jobs under contract//NOPE NOW IT'S subcat3
                for thisProj in mIPProjects {
                    if thisProj.projectStatusId == 2 {
                        sIP.append(thisProj)
                    }
                }
            case -15: // Paid jobs//NOPE NOW IT'S subcat4
                for thisProj in mIPProjects {
                    if thisProj.projectStatusId == 3 {
                        sIP.append(thisProj)
                    }
                }
            case -16: // Lost job opportunities//NOPE NOW IT'S subcat5
                for thisProj in mIPProjects {
                    if thisProj.projectStatusId == 4 {
                        sIP.append(thisProj)
                    }
                }
            case -17: // Other project status//NOPE NOW IT'S subcat6
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
            case -32: // Customers
                for thisEnti in mIPEntities {
                    if thisEnti.type == 0 {
                        sIP.append(thisEnti)
                    }
                }
            case -33: // Vendors
                for thisEnti in mIPEntities {
                    if thisEnti.type == 1 {
                        sIP.append(thisEnti)
                    }
                }
            case -34: // Subs
                for thisEnti in mIPEntities {
                    if thisEnti.type == 2 {
                        sIP.append(thisEnti)
                    }
                }
            case -35: // Employees
                for thisEnti in mIPEntities {
                    if thisEnti.type == 3 {
                        sIP.append(thisEnti)
                    }
                }
            case -36: // Stores
                for thisEnti in mIPEntities {
                    if thisEnti.type == 4 {
                        sIP.append(thisEnti)
                    }
                }
            case -37: // Government
                for thisEnti in mIPEntities {
                    if thisEnti.type == 5 {
                        sIP.append(thisEnti)
                    }
                }
            case -38: // Other Entities
                for thisEnti in mIPEntities {
                    if thisEnti.type == 6 {
                        sIP.append(thisEnti)
                    }
                }
            case -39: // You
                for thisEnti in mIPEntities {
                    if thisEnti.type == 9 {
                        sIP.append(thisEnti)
                    }
                }
            case -40: // Food
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 1) || (thisUniv.universalItemType == 2) {
                        if thisUniv.personalReasonId == 0 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -41: // Fun
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 1) || (thisUniv.universalItemType == 2) {
                        if thisUniv.personalReasonId == 1 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -42: // Pet
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 1) || (thisUniv.universalItemType == 2) {
                        if thisUniv.personalReasonId == 2 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -43: // Utilities
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 1) || (thisUniv.universalItemType == 2) {
                        if thisUniv.personalReasonId == 3 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -44: // Phone
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 1) || (thisUniv.universalItemType == 2) {
                        if thisUniv.personalReasonId == 4 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -45: // Office
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 1) || (thisUniv.universalItemType == 2) {
                        if thisUniv.personalReasonId == 5 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -46: // Giving
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 1) || (thisUniv.universalItemType == 2) {
                        if thisUniv.personalReasonId == 6 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -47: // Insurance
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 1) || (thisUniv.universalItemType == 2) {
                        if thisUniv.personalReasonId == 7 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -48: // House
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 1) || (thisUniv.universalItemType == 2) {
                        if thisUniv.personalReasonId == 8 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -49: // Yard
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 1) || (thisUniv.universalItemType == 2) {
                        if thisUniv.personalReasonId == 9 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -50: // Medical
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 1) || (thisUniv.universalItemType == 2) {
                        if thisUniv.personalReasonId == 10 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -51: // Travel
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 1) || (thisUniv.universalItemType == 2) {
                        if thisUniv.personalReasonId == 11 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -52: // Clothes
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 1) || (thisUniv.universalItemType == 2) {
                        if thisUniv.personalReasonId == 12 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -53: // Other personal category
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 1) || (thisUniv.universalItemType == 2) {
                        if thisUniv.personalReasonId == 13 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -54: // Income
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 0 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -55: // Supplies
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 1 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -56: // Labor
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 2 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -57: // Meals
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 3 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -58: // Office
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 4 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -59: // Vehicle (taxReasonforExpense)
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 5 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -60: // Advertising (taxReasonForExpense)
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 6 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -61: // Pro help
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 7 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -62: // Machine rental
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 8 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -63: // Property rental
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 9 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -64: // Tax+license
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 10 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -65: // Insurance(WC+GL)
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 11 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -66: // Travel
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 12 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -67: // Employee benefit
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 13 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -68: // Depreciation
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 14 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -69: // Depletion
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 15 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -70: // Business utilities
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 16 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -71: // Commissions
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 17 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -72: // Wages
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 18 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -73: // Mortgage business interest
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 19 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -74: // Other business interest
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 20 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -75: // Pension
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 21 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -76: // Business repairs
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 22 {
                            sIP.append(thisUniv)
                        }
                    }
                }
            case -77: // Unknown advertising expenses
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 6 { // I.e. = advertising expense
                            if thisUniv.advertisingMeansId == 0 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -78: // Referral advertising expenses
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 6 { // I.e. = advertising expense
                            if thisUniv.advertisingMeansId == 0 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -79: // Website advertising expenses
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 6 { // I.e. = advertising expense
                            if thisUniv.advertisingMeansId == 0 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -80: // YP advertising expenses
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 6 { // I.e. = advertising expense
                            if thisUniv.advertisingMeansId == 0 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -81: // Social media advertising expenses
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 6 { // I.e. = advertising expense
                            if thisUniv.advertisingMeansId == 0 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -82: // Soliciting advertising expenses
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 6 { // I.e. = advertising expense
                            if thisUniv.advertisingMeansId == 0 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -83: // AdWords advertising expenses
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 6 { // I.e. = advertising expense
                            if thisUniv.advertisingMeansId == 0 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -84: // Company shirts advertising expenses
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 6 { // I.e. = advertising expense
                            if thisUniv.advertisingMeansId == 0 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -85: // Sign advertising expenses
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 6 { // I.e. = advertising expense
                            if thisUniv.advertisingMeansId == 0 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -86: // Vehicle wrap advertising expenses
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 6 { // I.e. = advertising expense
                            if thisUniv.advertisingMeansId == 0 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -87: // Billboard advertising expenses
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 6 { // I.e. = advertising expense
                            if thisUniv.advertisingMeansId == 0 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -88: // TV advertising expenses
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 6 { // I.e. = advertising expense
                            if thisUniv.advertisingMeansId == 0 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -89: // Radio advertising expenses
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 6 { // I.e. = advertising expense
                            if thisUniv.advertisingMeansId == 0 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -90: // Other advertising expenses
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 6 { // I.e. = advertising expense
                            if thisUniv.advertisingMeansId == 0 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -91: // Sub has WC
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 2 { // I.e. = labor expense
                            if thisUniv.workersCompId == 0 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -92: // Incurred WC
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 2 { // I.e. = labor expense
                            if thisUniv.workersCompId == 1 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -93: // WC N/A
                for thisUniv in mIPUniversals {
                    if (thisUniv.universalItemType == 0) || (thisUniv.universalItemType == 2) {
                        if thisUniv.taxReasonId == 2 { // I.e. = labor expense
                            if thisUniv.workersCompId == 2 {
                                sIP.append(thisUniv)
                            }
                        }
                    }
                }
            case -94: // Bank accounts
                for thisAcco in mIPAccounts {
                    if thisAcco.accountTypeId == 0 {
                        sIP.append(thisAcco)
                    }
                }
            case -95: // Credit accounts
                for thisAcco in mIPAccounts {
                    if thisAcco.accountTypeId == 1 {
                        sIP.append(thisAcco)
                    }
                }
            case -96: // Cash accounts
                for thisAcco in mIPAccounts {
                    if thisAcco.accountTypeId == 2 {
                        sIP.append(thisAcco)
                    }
                }
            case -97: // Store refund accounts
                for thisAcco in mIPAccounts {
                    if thisAcco.accountTypeId == 3 {
                        sIP.append(thisAcco)
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
    /*
    func askForTheKey() -> Data {
        return self.tHeKeY
    }
    
    func obtainTheKey(completion: @escaping () -> ()) {
        print("HAYLOA")
        if tHeKeY != nil {
            completion()
        } else {
            self.keyRef = Database.database().reference().child("users").child(userUID).child("encryptedKey")
            self.keyRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let ke = snapshot.value as? String {
                    self.theKeyIsHere = ke
                    if let _ = self.theKeyIsHere, self.theKeyIsHere != "" {
                        if self.authorized == nil {
                            Auth.auth().addStateDidChangeListener { auth, user in
                                if user != nil {
                                    // User is signed in.
                                    self.theUser = user
                                    self.authorized = true
                                    
                                    self.theUser.getIDTokenForcingRefresh(true) { idToken, error in
                                        if let error = error, idToken != "" {
                                            // Handle error
                                            print("The error IS HERE")
                                            return
                                        }
                                        
                                        //DECRYPTION
                                        var url2 = URLComponents(string: "https://bizzy-books.appspot.com/decrypt")!
                                        url2.queryItems = [
                                            URLQueryItem(name: "value", value: self.theKeyIsHere)
                                        ]
                                        var request2 = URLRequest(url: url2.url!)
                                        request2.addValue("Bearer \(idToken!)", forHTTPHeaderField: "Authorization")
                                        request2.httpMethod = "GET"
                                        let task2 = URLSession.shared.dataTask(with: request2) { data, response, error in
                                            guard let data = data, error == nil else {
                                                print("error=\(error)")
                                                return
                                            }
                                            if let httpStatus2 = response as? HTTPURLResponse, httpStatus2.statusCode != 200 {
                                                print("statusCode should be 200, but is \(httpStatus2.statusCode)")
                                                print("response = \(response)")
                                            }
                                            
                                            let responseString2 = String(data: data, encoding: .utf8)
                                            print("responseString2 = \(responseString2)")
                                            do {
                                                let json = try JSONSerialization.jsonObject(with: data, options: [])
                                                if let object = json as? [String: Any] {
                                                    // json is a dictionary
                                                    self.theKeyIsHere = String(describing: object["key"]!) + "82gw2yN7bK"
                                                    self.tHeKeY = self.theKeyIsHere.data(using: .utf8)
                                                    print("recoveredKeyYo = " + self.theKeyIsHere)
                                                    DispatchQueue.main.async {
                                                        completion()
                                                    }
                                                } else {
                                                    print("JSON is invalid")
                                                    DispatchQueue.main.async {
                                                        completion()
                                                    }
                                                }
                                            } catch {
                                                print("TO ERR IS HUMAN")
                                                DispatchQueue.main.async {
                                                    completion()
                                                }
                                            }
                                        }
                                        task2.resume()
                                        
                                    }
                                    
                                } else {
                                    self.authorized = false
                                }
                            }
                        }
                        
                        
                    } else {
                        print("The error is THERE")
                    }
                }
            })
        }
    }
*/
    
}
