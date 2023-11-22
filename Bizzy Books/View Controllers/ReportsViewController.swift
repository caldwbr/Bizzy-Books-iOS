//
//  ReportsViewController.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 1/1/18.
//  Copyright © 2018 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import SwiftUI
import SimplePDF
import DGCharts
import CoreGraphics
import Foundation

class ReportsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIWebViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reportViewYearPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        selectedYear = reportViewYearPickerData[row]
        return selectedYear
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedYear = reportViewYearPickerData[row]
        switch row {
        case 0: //2018
            givenYearBeginning = yearTimes[0]
            givenYearEnd = yearTimes[1]
        case 1:
            givenYearBeginning = yearTimes[1]
            givenYearEnd = yearTimes[2]
        case 2:
            givenYearBeginning = yearTimes[2]
            givenYearEnd = yearTimes[3]
        case 3: //2021
            givenYearBeginning = yearTimes[3]
            givenYearEnd = yearTimes[4]
        case 4:
            givenYearBeginning = yearTimes[4]
            givenYearEnd = yearTimes[5]
        case 5:
            givenYearBeginning = yearTimes[5]
            givenYearEnd = yearTimes[6]
        case 6: //2024
            givenYearBeginning = yearTimes[6]
            givenYearEnd = yearTimes[7]
        case 7:
            givenYearBeginning = yearTimes[7]
            givenYearEnd = yearTimes[8]
        case 8:
            givenYearBeginning = yearTimes[8]
            givenYearEnd = yearTimes[9]
        case 9: //2027
            givenYearBeginning = yearTimes[9]
            givenYearEnd = yearTimes[10]
        case 10:
            givenYearBeginning = yearTimes[10]
            givenYearEnd = yearTimes[11]
        case 11:
            givenYearBeginning = yearTimes[11]
            givenYearEnd = yearTimes[12]
        case 12: //2030
            givenYearBeginning = yearTimes[12]
            givenYearEnd = yearTimes[13]
        case 13:
            givenYearBeginning = yearTimes[13]
            givenYearEnd = yearTimes[14]
        case 14:
            givenYearBeginning = yearTimes[14]
            givenYearEnd = yearTimes[15]
        case 15: //2033
            givenYearBeginning = yearTimes[15]
            givenYearEnd = yearTimes[16]
        case 16:
            givenYearBeginning = yearTimes[16]
            givenYearEnd = yearTimes[17]
        case 17:
            givenYearBeginning = yearTimes[17]
            givenYearEnd = yearTimes[18]
        case 18: //2036
            givenYearBeginning = yearTimes[18]
            givenYearEnd = yearTimes[19]
        case 19:
            givenYearBeginning = yearTimes[19]
            givenYearEnd = yearTimes[20]
        case 20:
            givenYearBeginning = yearTimes[20]
            givenYearEnd = yearTimes[21]
        case 21: //2039
            givenYearBeginning = yearTimes[21]
            givenYearEnd = yearTimes[22]
        case 22: //2040
            givenYearBeginning = yearTimes[22]
            givenYearEnd = yearTimes[23]
        default:
            givenYearBeginning = yearTimes[0]
            givenYearEnd = yearTimes[1]
        }
        print("Given Year Beginning: " + String(givenYearBeginning))
        print("Given Year End: " + String(givenYearEnd))
        calculateReports()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        reportViewActivitySpinner.startAnimating()
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        reportViewActivitySpinner.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("To ERR is human")
        reportViewActivitySpinner.stopAnimating()
    }

    let documentInteractionController = UIDocumentInteractionController()

    let yearTimes = [1514786400000, 1546322400000, 1577858400000, 1609480800000, 1641016800000, 1672552800000, 1704088800000, 1735711200000, 1767247200000, 1798783200000, 1830319200000, 1861941600000, 1893477600000, 1925013600000, 1956549600000, 1988172000000, 2019708000000, 2051244000000, 2082780000000, 2114402400000, 2145938400000, 2177474400000, 2209010400000, 2240632800000]
    // Values above taken from http : //www . unixtimestampconverter . com/
    var givenYearBeginning = 1514786400000 //Jan 1 2018
    var givenYearEnd = 1546322400000 //Jan 1 2019
    var selectedYear = "2018"
    
    @IBOutlet weak var trialPieView: PieChartView!
    @IBOutlet weak var trialPieView2: PieChartView!
    @IBOutlet weak var reportViewWebView: UIWebView!
    @IBOutlet weak var reportViewActivitySpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var reportViewYearPicker: UIPickerView!
    
    var reportViewYearPickerData: [String] = [String]()
    var subsAndEmps: [String] = [String]()
    var subsAndEmpsNames: [String] = [String]()
    var subsAndEmpsWhich: [String] = [String]()
    var subsAndEmpsIncursWC: [Int] = [Int]()
    var subsAndEmpsHasWC: [Int] = [Int]()
    var subsAndEmpsWCNA: [Int] = [Int]()
    var subsAndEmpsProHelp: [Int] = [Int]()
    var subsAndEmpsTotals: [Int] = [Int]()
    var infoFor1099sDataArray: [[String]] = [[String]]()
    var income = 0
    var supplies = 0
    var labor = 0
    var meals = 0
    var office = 0
    var vehicle = 0
    var adv = 0
    var proHelp = 0
    var machineRent = 0
    var taxAndLic = 0
    var insGLAndWC = 0
    var travel = 0
    var empBen = 0
    var depreciation = 0
    var depletion = 0
    var utilities = 0
    var commissions = 0
    var wages = 0
    var mortInterest = 0
    var otherInterest = 0
    var pension = 0
    var repairs = 0
    var allExpenses = 0
    var net = 0
    var projectExpenses = 0
    var overheadExpenses = 0
    var grossProfit = 0
    var netProfit = 0
    var overheadMargin = 0.0
    var profitMargin = 0.0
    var profitFactor = 0.0
    var food = 0
    var fun = 0
    var pet = 0
    var utilitiesPersonal = 0
    var phone = 0
    var officePersonal = 0
    var giving = 0
    var insurancePersonal = 0
    var house = 0
    var yard = 0
    var medical = 0
    var travelPersonal = 0
    var clothes = 0
    var otherPersonal = 0
    var allPersonalSpending = 0
    var netSaving = 0
    let stringifyAnInt: StringifyAnInt = StringifyAnInt()
    var hdthoy1RunningGross = 0 //SHOULD HAVE NAMED THESE RUNNING TABS or something - it's about expenses, not gross! Oh well.
    var hdthoy2RunningGross = 0
    var hdthoy3RunningGross = 0
    var hdthoy4RunningGross = 0
    var hdthoy5RunningGross = 0
    var hdthoy6RunningGross = 0
    var hdthoy7RunningGross = 0
    var hdthoy8RunningGross = 0
    var hdthoy9RunningGross = 0
    var hdthoy10RunningGross = 0
    var hdthoy11RunningGross = 0
    var hdthoy12RunningGross = 0
    var hdthoy13RunningGross = 0
    var hdthoy14RunningGross = 0
    
    var vehicleKeysUsedInPertYear: [String] = [String]()
    var vehicleInfoArray: [[String]] = [[String]]()
    var vehicleInfoArrayOrdered: [[String]] = [[String]]()
    
    var pdfData = Data()
    var documentsFileName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentInteractionController.delegate = self
        reportViewYearPickerData = ["2018", "2019", "2020", "2021", "2022", "2023", "2024", "2025", "2026", "2027", "2028", "2029", "2030", "2031", "2032", "2033", "2034", "2035", "2036", "2037", "2038", "2039", "2040"]
        reportViewYearPicker.dataSource = self
        reportViewYearPicker.delegate = self
        reportViewYearPicker.selectRow(0, inComponent: 0, animated: false)
        reportViewWebView.delegate = self
        reportViewActivitySpinner.hidesWhenStopped = true
        selectedYear = reportViewYearPickerData[reportViewYearPicker.selectedRow(inComponent: 0)]
        calculateReports()
    }
    
    func clearTheFields() {
        subsAndEmps.removeAll()
        subsAndEmpsNames.removeAll()
        subsAndEmpsWhich.removeAll()
        subsAndEmpsHasWC.removeAll()
        subsAndEmpsIncursWC.removeAll()
        subsAndEmpsWCNA.removeAll()
        subsAndEmpsProHelp.removeAll()
        subsAndEmpsTotals.removeAll()
        infoFor1099sDataArray.removeAll()
        vehicleKeysUsedInPertYear.removeAll()
        vehicleInfoArray.removeAll()
        income = 0
        supplies = 0
        labor = 0
        meals = 0
        office = 0
        vehicle = 0
        adv = 0
        proHelp = 0
        machineRent = 0
        taxAndLic = 0
        insGLAndWC = 0
        travel = 0
        empBen = 0
        depreciation = 0
        depletion = 0
        utilities = 0
        commissions = 0
        wages = 0
        mortInterest = 0
        otherInterest = 0
        pension = 0
        repairs = 0
        allExpenses = 0
        net = 0
        projectExpenses = 0
        overheadExpenses = 0
        grossProfit = 0
        netProfit = 0
        overheadMargin = 0.0
        profitMargin = 0.0
        profitFactor = 0.0
        food = 0
        fun = 0
        pet = 0
        utilitiesPersonal = 0
        phone = 0
        officePersonal = 0
        giving = 0
        insurancePersonal = 0
        house = 0
        yard = 0
        medical = 0
        travelPersonal = 0
        clothes = 0
        otherPersonal = 0
        netSaving = 0
        allPersonalSpending = 0
        hdthoy1RunningGross = 0 //SHOULD HAVE NAMED THESE RUNNING TABS or something - it's about expenses, not gross! Oh well.
        hdthoy2RunningGross = 0
        hdthoy3RunningGross = 0
        hdthoy4RunningGross = 0
        hdthoy5RunningGross = 0
        hdthoy6RunningGross = 0
        hdthoy7RunningGross = 0
        hdthoy8RunningGross = 0
        hdthoy9RunningGross = 0
        hdthoy10RunningGross = 0
        hdthoy11RunningGross = 0
        hdthoy12RunningGross = 0
        hdthoy13RunningGross = 0
        hdthoy14RunningGross = 0
    }
    
    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy h:mma"
        return formatter.string(from: date as Date)
    }
    var vehKeyString = ""
    var vehNameString = ""
    var timeStampAsString = ""
    var odoAsString = ""
    var amtFuelPurchased = ""
    var numGallonsFuel = ""
    
    func calculateReports() {
        
        let selectedYear = self.selectedYear
        
        clearTheFields()
        for i in 0..<MIProcessor.sharedMIP.mIPUniversals.count where (MIProcessor.sharedMIP.mIPUniversals[i].timeStamp as! Int) < givenYearEnd && (MIProcessor.sharedMIP.mIPUniversals[i].timeStamp as! Int) > givenYearBeginning {
            if MIProcessor.sharedMIP.mIPUniversals[i].universalItemType == 3 { //I.e. FUEL case //HERE WE are grabbing up all the fuel info for that array/pdfTable
                if !vehicleKeysUsedInPertYear.contains(MIProcessor.sharedMIP.mIPUniversals[i].vehicleKey) {
                    vehicleKeysUsedInPertYear.append(MIProcessor.sharedMIP.mIPUniversals[i].vehicleKey)
                }
                if let timeStampAsDouble: Double = MIProcessor.sharedMIP.mIPUniversals[i].timeStamp as? Double {
                    timeStampAsString = convertTimestamp(serverTimestamp: timeStampAsDouble)
                }
                vehKeyString = MIProcessor.sharedMIP.mIPUniversals[i].vehicleKey
                vehNameString = MIProcessor.sharedMIP.mIPUniversals[i].vehicleName
                odoAsString = String(MIProcessor.sharedMIP.mIPUniversals[i].odometerReading)
                amtFuelPurchased = MIProcessor.sharedMIP.mIPUniversals[i].what.sCur()
                let theFormattUR = NumberFormatter()
                theFormattUR.usesGroupingSeparator = true
                theFormattUR.numberStyle = .decimal
                theFormattUR.locale = Locale.current
                let inTEEger = MIProcessor.sharedMIP.mIPUniversals[i].howMany
                let amOUnt = Double(inTEEger/1000) + Double(inTEEger%1000)/1000
                numGallonsFuel = theFormattUR.string(from: NSNumber(value: amOUnt))!
                vehicleInfoArray.append([vehKeyString, vehNameString, timeStampAsString, odoAsString, amtFuelPurchased, numGallonsFuel])
            }
            if (MIProcessor.sharedMIP.mIPUniversals[i].universalItemType == 0 || MIProcessor.sharedMIP.mIPUniversals[i].universalItemType == 2) && MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId == 6 {
                switch MIProcessor.sharedMIP.mIPUniversals[i].advertisingMeansId { //HERE we are grabbing up all the spending info that falls into advertising categories for later use down in the advertising array/pdfTable.
                case 0: // I.e., HDTHOY is "Unknown"
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou { //You paid something for advertising
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy1RunningGross += MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy1RunningGross += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING!!")
                        }
                    } else { //You got money back on some kind of returning of advertising or cancelling of contract or breach of service etc
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy1RunningGross -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy1RunningGross -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING out loud!!")
                        }
                    }
                case 1: // I.e., HDTHOY is "Referral"
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou { //You paid something for advertising
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy2RunningGross += MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy2RunningGross += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING!!")
                        }
                    } else { //You got money back on some kind of returning of advertising or cancelling of contract or breach of service etc
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy2RunningGross -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy2RunningGross -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING out loud!!")
                        }
                    }
                case 2: // I.e., HDTHOY is "Website"
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou { //You paid something for advertising
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy3RunningGross += MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy3RunningGross += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING!!")
                        }
                    } else { //You got money back on some kind of returning of advertising or cancelling of contract or breach of service etc
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy3RunningGross -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy3RunningGross -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING out loud!!")
                        }
                    }
                case 3: // I.e., HDTHOY is "YP"
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou { //You paid something for advertising
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy4RunningGross += MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy4RunningGross += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING!!")
                        }
                    } else { //You got money back on some kind of returning of advertising or cancelling of contract or breach of service etc
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy4RunningGross -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy4RunningGross -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING out loud!!")
                        }
                    }
                case 4: // I.e., HDTHOY is "Social Media"
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou { //You paid something for advertising
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy5RunningGross += MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy5RunningGross += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING!!")
                        }
                    } else { //You got money back on some kind of returning of advertising or cancelling of contract or breach of service etc
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy5RunningGross -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy5RunningGross -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING out loud!!")
                        }
                    }
                case 5: // I.e., HDTHOY is "Soliciting"
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou { //You paid something for advertising
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy6RunningGross += MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy6RunningGross += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING!!")
                        }
                    } else { //You got money back on some kind of returning of advertising or cancelling of contract or breach of service etc
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy6RunningGross -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy6RunningGross -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING out loud!!")
                        }
                    }
                case 6: // I.e., HDTHOY is "AdWords"
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou { //You paid something for advertising
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy7RunningGross += MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy7RunningGross += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING!!")
                        }
                    } else { //You got money back on some kind of returning of advertising or cancelling of contract or breach of service etc
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy7RunningGross -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy7RunningGross -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING out loud!!")
                        }
                    }
                case 7: // I.e., HDTHOY is "Company Shirts"
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou { //You paid something for advertising
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy8RunningGross += MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy8RunningGross += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING!!")
                        }
                    } else { //You got money back on some kind of returning of advertising or cancelling of contract or breach of service etc
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy8RunningGross -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy8RunningGross -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING out loud!!")
                        }
                    }
                case 8: // I.e., HDTHOY is "Yard Signs"
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou { //You paid something for advertising
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy9RunningGross += MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy9RunningGross += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING!!")
                        }
                    } else { //You got money back on some kind of returning of advertising or cancelling of contract or breach of service etc
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy9RunningGross -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy9RunningGross -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING out loud!!")
                        }
                    }
                case 9: // I.e., HDTHOY is "Vehicle Wrap"
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou { //You paid something for advertising
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy10RunningGross += MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy10RunningGross += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING!!")
                        }
                    } else { //You got money back on some kind of returning of advertising or cancelling of contract or breach of service etc
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy10RunningGross -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy10RunningGross -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING out loud!!")
                        }
                    }
                case 10: // I.e., HDTHOY is "Billboard"
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou { //You paid something for advertising
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy11RunningGross += MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy11RunningGross += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING!!")
                        }
                    } else { //You got money back on some kind of returning of advertising or cancelling of contract or breach of service etc
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy11RunningGross -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy11RunningGross -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING out loud!!")
                        }
                    }
                case 11: // I.e., HDTHOY is "TV"
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou { //You paid something for advertising
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy12RunningGross += MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy12RunningGross += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING!!")
                        }
                    } else { //You got money back on some kind of returning of advertising or cancelling of contract or breach of service etc
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy12RunningGross -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy12RunningGross -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING out loud!!")
                        }
                    }
                case 12: // I.e., HDTHOY is "Radio"
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou { //You paid something for advertising
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy13RunningGross += MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy13RunningGross += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING!!")
                        }
                    } else { //You got money back on some kind of returning of advertising or cancelling of contract or breach of service etc
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy13RunningGross -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy13RunningGross -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING out loud!!")
                        }
                    }
                case 13: // I.e., HDTHOY is "Other"
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou { //You paid something for advertising
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy14RunningGross += MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy14RunningGross += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING!!")
                        }
                    } else { //You got money back on some kind of returning of advertising or cancelling of contract or breach of service etc
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Business case
                            hdthoy14RunningGross -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // Mixed case
                            hdthoy14RunningGross -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NO FOR CryING out loud!!")
                        }
                    }
                default:
                    print("Yo man when ya gonna learn - DO NOT ANY THING!")
                }
            }
            switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
            case 0:
                if MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId == 2 || MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId == 7 {
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        if !subsAndEmps.contains(MIProcessor.sharedMIP.mIPUniversals[i].whomKey) {
                            var specificKey = MIProcessor.sharedMIP.mIPUniversals[i].whomKey
                            for k in 0..<MIProcessor.sharedMIP.mIPEntities.count {
                                if MIProcessor.sharedMIP.mIPEntities[k].key == specificKey {
                                    switch MIProcessor.sharedMIP.mIPEntities[k].type {
                                    case 2:
                                        subsAndEmps.append(MIProcessor.sharedMIP.mIPUniversals[i].whomKey)
                                        subsAndEmpsNames.append(MIProcessor.sharedMIP.mIPEntities[k].name)
                                        subsAndEmpsWhich.append("S")
                                    case 3:
                                        subsAndEmps.append(MIProcessor.sharedMIP.mIPUniversals[i].whomKey)
                                        subsAndEmpsNames.append(MIProcessor.sharedMIP.mIPEntities[k].name)
                                        subsAndEmpsWhich.append("E")
                                    default:
                                        print("No nada")
                                    }
                                }
                            }
                        }
                    }
                }
                switch MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId {
                case 0:
                    income += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 1:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        supplies += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        supplies -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 2:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        labor += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        labor -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 3:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        meals += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        meals -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 4:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        office += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        office -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 5:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        vehicle += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        vehicle -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 6:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        adv += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        adv -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 7:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        proHelp += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        proHelp -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 8:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        machineRent += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        machineRent -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 9:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        taxAndLic += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        taxAndLic -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 10:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        insGLAndWC += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        insGLAndWC -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 11:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        travel += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        travel -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 12:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        empBen += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        empBen -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 13:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        depreciation += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        depreciation -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 14:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        depletion += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        depletion -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 15:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        utilities += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        utilities -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 16:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        commissions += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        commissions -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 17:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        wages += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        wages -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 18:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        mortInterest += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        mortInterest -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 19:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        otherInterest += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        otherInterest -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 20:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        pension += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        pension -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                case 21:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        repairs += MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    } else {
                        repairs -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= MIProcessor.sharedMIP.mIPUniversals[i].what
                        }
                    }
                default:
                    print("No such useful item")
                }
            case 1:
                //Personal!
                switch MIProcessor.sharedMIP.mIPUniversals[i].personalReasonId {
                case 0:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        food += MIProcessor.sharedMIP.mIPUniversals[i].what
                    } else {
                        food -= MIProcessor.sharedMIP.mIPUniversals[i].what
                    }
                case 1:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        fun += MIProcessor.sharedMIP.mIPUniversals[i].what
                    } else {
                        fun -= MIProcessor.sharedMIP.mIPUniversals[i].what
                    }
                case 2:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        pet += MIProcessor.sharedMIP.mIPUniversals[i].what
                    } else {
                        pet -= MIProcessor.sharedMIP.mIPUniversals[i].what
                    }
                case 3:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        utilitiesPersonal += MIProcessor.sharedMIP.mIPUniversals[i].what
                    } else {
                        utilitiesPersonal -= MIProcessor.sharedMIP.mIPUniversals[i].what
                    }
                case 4:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        phone += MIProcessor.sharedMIP.mIPUniversals[i].what
                    } else {
                        phone -= MIProcessor.sharedMIP.mIPUniversals[i].what
                    }
                case 5:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        officePersonal += MIProcessor.sharedMIP.mIPUniversals[i].what
                    } else {
                        officePersonal -= MIProcessor.sharedMIP.mIPUniversals[i].what
                    }
                case 6:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        giving += MIProcessor.sharedMIP.mIPUniversals[i].what
                    } else {
                        giving -= MIProcessor.sharedMIP.mIPUniversals[i].what
                    }
                case 7:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        insurancePersonal += MIProcessor.sharedMIP.mIPUniversals[i].what
                    } else {
                        insurancePersonal -= MIProcessor.sharedMIP.mIPUniversals[i].what
                    }
                case 8:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        house += MIProcessor.sharedMIP.mIPUniversals[i].what
                    } else {
                        house -= MIProcessor.sharedMIP.mIPUniversals[i].what
                    }
                case 9:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        yard += MIProcessor.sharedMIP.mIPUniversals[i].what
                    } else {
                        yard -= MIProcessor.sharedMIP.mIPUniversals[i].what
                    }
                case 10:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        medical += MIProcessor.sharedMIP.mIPUniversals[i].what
                    } else {
                        medical -= MIProcessor.sharedMIP.mIPUniversals[i].what
                    }
                case 11:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        travelPersonal += MIProcessor.sharedMIP.mIPUniversals[i].what
                    } else {
                        travelPersonal -= MIProcessor.sharedMIP.mIPUniversals[i].what
                    }
                case 12:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        clothes += MIProcessor.sharedMIP.mIPUniversals[i].what
                    } else {
                        clothes -= MIProcessor.sharedMIP.mIPUniversals[i].what
                    }
                case 13:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        otherPersonal += MIProcessor.sharedMIP.mIPUniversals[i].what
                    } else {
                        otherPersonal -= MIProcessor.sharedMIP.mIPUniversals[i].what
                    }
                default:
                    print("No such useful pers item")
                }
            case 2: //Mixed
                if MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId == 2 || MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId == 7 {
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        if !subsAndEmps.contains(MIProcessor.sharedMIP.mIPUniversals[i].whomKey) {
                            var specificKey = MIProcessor.sharedMIP.mIPUniversals[i].whomKey
                            for k in 0..<MIProcessor.sharedMIP.mIPEntities.count {
                                if MIProcessor.sharedMIP.mIPEntities[k].key == specificKey {
                                    switch MIProcessor.sharedMIP.mIPEntities[k].type {
                                    case 2:
                                        subsAndEmps.append(MIProcessor.sharedMIP.mIPUniversals[i].whomKey)
                                        subsAndEmpsNames.append(MIProcessor.sharedMIP.mIPEntities[k].name)
                                        subsAndEmpsWhich.append("S")
                                    case 3:
                                        subsAndEmps.append(MIProcessor.sharedMIP.mIPUniversals[i].whomKey)
                                        subsAndEmpsNames.append(MIProcessor.sharedMIP.mIPEntities[k].name)
                                        subsAndEmpsWhich.append("E")
                                    default:
                                        print("No nada")
                                    }
                                }
                            }
                        }
                    }
                }
                switch MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId {
                case 0:
                    //income += MIProcessor.sharedMIP.mIPUniversals[i].what
                    print("do NoT any THING")
                case 1:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        supplies += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        supplies -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 2:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        labor += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        labor -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 3:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        meals += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        meals -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 4:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        office += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        office -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 5:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        vehicle += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        vehicle -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 6:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        adv += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        adv -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 7:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        proHelp += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        proHelp -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 8:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        machineRent += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        machineRent -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 9:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        taxAndLic += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        taxAndLic -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 10:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        insGLAndWC += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        insGLAndWC -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 11:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        travel += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        travel -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 12:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        empBen += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        empBen -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 13:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        depreciation += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        depreciation -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 14:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        depletion += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        depletion -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 15:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        utilities += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        utilities -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 16:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        commissions += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        commissions -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 17:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        wages += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        wages -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 18:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        mortInterest += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        mortInterest -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 19:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        otherInterest += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        otherInterest -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 20:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        pension += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        pension -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                case 21:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        repairs += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    } else {
                        repairs -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == "0" {
                            overheadExpenses -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                default:
                    print("No such useful item")
                }
                switch MIProcessor.sharedMIP.mIPUniversals[i].personalReasonId {
                case 0:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        food += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    } else {
                        food -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    }
                case 1:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        fun += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    } else {
                        fun -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    }
                case 2:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        pet += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    } else {
                        pet -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    }
                case 3:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        utilitiesPersonal += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    } else {
                        utilitiesPersonal -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    }
                case 4:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        phone += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    } else {
                        phone -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    }
                case 5:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        officePersonal += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    } else {
                        officePersonal -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    }
                case 6:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        giving += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    } else {
                        giving -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    }
                case 7:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        insurancePersonal += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    } else {
                        insurancePersonal -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    }
                case 8:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        house += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    } else {
                        house -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    }
                case 9:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        yard += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    } else {
                        yard -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    }
                case 10:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        medical += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    } else {
                        medical -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    }
                case 11:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        travelPersonal += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    } else {
                        travelPersonal -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    }
                case 12:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        clothes += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    } else {
                        clothes -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    }
                case 13:
                    if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                        otherPersonal += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    } else {
                        otherPersonal -= Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(1.0 - (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100)))
                    }
                default:
                    print("No such useful pers item")
                }
            default:
                print("No such business item")
            }
            
        }
        
        for j in 0..<subsAndEmps.count {
            subsAndEmpsHasWC.append(0)
            subsAndEmpsIncursWC.append(0)
            subsAndEmpsWCNA.append(0)
            subsAndEmpsProHelp.append(0)
            subsAndEmpsTotals.append(0)
        }
        
        for j in 0..<subsAndEmps.count {
            for i in 0..<MIProcessor.sharedMIP.mIPUniversals.count where (MIProcessor.sharedMIP.mIPUniversals[i].timeStamp as! Int) < givenYearEnd && (MIProcessor.sharedMIP.mIPUniversals[i].timeStamp as! Int) > givenYearBeginning {
                switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                case 0:
                    switch MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId {
                    case 2:
                        if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                            if MIProcessor.sharedMIP.mIPUniversals[i].whomKey == subsAndEmps[j] {
                                switch MIProcessor.sharedMIP.mIPUniversals[i].workersCompId {
                                case 0: //(Sub Has WC)
                                    subsAndEmpsHasWC[j] += MIProcessor.sharedMIP.mIPUniversals[i].what
                                    subsAndEmpsTotals[j] += MIProcessor.sharedMIP.mIPUniversals[i].what
                                case 1: //(Incurred WC)
                                    subsAndEmpsIncursWC[j] += MIProcessor.sharedMIP.mIPUniversals[i].what
                                    subsAndEmpsTotals[j] += MIProcessor.sharedMIP.mIPUniversals[i].what
                                case 2: //(WC N/A)
                                    subsAndEmpsWCNA[j] += MIProcessor.sharedMIP.mIPUniversals[i].what
                                    subsAndEmpsTotals[j] += MIProcessor.sharedMIP.mIPUniversals[i].what
                                default:
                                    print("Add not any thing")
                                }
                            }
                        }
                    case 7:
                        if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                            if MIProcessor.sharedMIP.mIPUniversals[i].whomKey == subsAndEmps[j] {
                                subsAndEmpsProHelp[j] += MIProcessor.sharedMIP.mIPUniversals[i].what
                                subsAndEmpsTotals[j] += MIProcessor.sharedMIP.mIPUniversals[i].what
                            }
                        }
                    default:
                        print("Doy noty anyy thingy")
                    }
                case 2:
                    switch MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId {
                    case 2:
                        if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                            if MIProcessor.sharedMIP.mIPUniversals[i].whomKey == subsAndEmps[j] {
                                switch MIProcessor.sharedMIP.mIPUniversals[i].workersCompId {
                                case 0: //(Sub Has WC)
                                    subsAndEmpsHasWC[j] += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                                    subsAndEmpsTotals[j] += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                                case 1: //(Incurred WC)
                                    subsAndEmpsIncursWC[j] += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                                    subsAndEmpsTotals[j] += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                                case 2: //(WC N/A)
                                    subsAndEmpsWCNA[j] += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                                    subsAndEmpsTotals[j] += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                                default:
                                    print("Add not any thing")
                                }
                            }
                        }
                    case 7:
                        if MIProcessor.sharedMIP.mIPUniversals[i].whoKey == MIProcessor.sharedMIP.trueYou {
                            if MIProcessor.sharedMIP.mIPUniversals[i].whomKey == subsAndEmps[j] {
                                subsAndEmpsProHelp[j] += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                                subsAndEmpsTotals[j] += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what)*(Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                            }
                        }
                    default:
                        print("Doy noty anyy thingy")
                    }
                default:
                    print("DOA NOTA ANYA THINGA")
                }
            }
        }
        
        infoFor1099sDataArray.append(["Worker Name", "Sub/Emp", "Incurs WC", "Has WC", "WC N/A", "Pro Help", "1099 Total"])
        
        for j in 0..<subsAndEmps.count {
            infoFor1099sDataArray.append([subsAndEmpsNames[j], subsAndEmpsWhich[j], stringifyAnInt.stringify(theInt: subsAndEmpsIncursWC[j]), stringifyAnInt.stringify(theInt: subsAndEmpsHasWC[j]), stringifyAnInt.stringify(theInt: subsAndEmpsWCNA[j]), stringifyAnInt.stringify(theInt: subsAndEmpsProHelp[j]), stringifyAnInt.stringify(theInt: subsAndEmpsTotals[j])])
        }
        
        
        print("Income: " + String(income))
        print("Supplies: " + String(supplies))
        print("Labor: " + String(labor))
        print("Meals: " + String(meals))
        print("Office: " + String(office))
        print("Vehicle: " + String(vehicle))
        print("Advertising: " + String(adv))
        print("Pro Help: " + String(proHelp))
        print("Machine Rent: " + String(machineRent))
        print("Tax and License: " + String(taxAndLic))
        print("Insurance WC and GL: " + String(insGLAndWC))
        print("Travel: " + String(travel))
        print("Employee Benefits: " + String(empBen))
        print("Depreciation: " + String(depreciation))
        print("Depletion: " + String(depletion))
        print("Utilities: " + String(utilities))
        print("Commissions: " + String(commissions))
        print("Wages: " + String(wages))
        print("Mortgage Interest: " + String(mortInterest))
        print("Other Interest: " + String(otherInterest))
        print("Pensions: " + String(pension))
        print("Repairs: " + String(repairs))
        
        allExpenses = supplies + labor + meals + office + vehicle + adv + proHelp + machineRent + taxAndLic + insGLAndWC + travel + empBen + depreciation + depletion + utilities + commissions + wages + mortInterest + otherInterest + pension + repairs
        net = income - allExpenses
        projectExpenses = allExpenses - overheadExpenses
        grossProfit = income - projectExpenses
        netProfit = net
        overheadMargin = Double(overheadExpenses) / Double(income)
        profitMargin = Double(netProfit) / Double(income)
        profitFactor = Double(income) / Double(allExpenses)
        allPersonalSpending = food + fun + pet + utilitiesPersonal + phone + officePersonal + giving + insurancePersonal + house + yard + medical + travelPersonal + clothes + otherPersonal
        netSaving = netProfit - allPersonalSpending
        
        var projectInfoArray: [[Any]] = [[Any]]()
        var projectInfoTidyArray: [[String]] = [[String]]()
        var projectSubcatInfoArray: [[Any]] = [[Any]]()
        var projectSubcatInfoTidyArray: [[String]] = [[String]]()
        var projectHDTHOYInfoArray: [[String]] = [[String]]() // "HDTHOY" stands for "How Did They Hear Of You"
        var amountsSpentOnEachTypeOfAdv: [Int] = [Int]()
        for l in 0..<MIProcessor.sharedMIP.mIPProjects.count {
            let projectItem = MIProcessor.sharedMIP.mIPProjects[l]
            var runningGross = 0
            var runningExpensesLaborAndProHelpTotal = 0
            var runningExpensesLaborTotal = 0
            var runningExpensesLaborHasWC = 0
            var runningExpensesLaborIncursWC = 0
            var runningExpensesLaborWCNA = 0
            var runningExpensesProHelp = 0
            var runningExpensesMaterial = 0
            var runningExpensesTotal = 0
            var netProfit = 0
            var netMargin = 0
            for i in 0..<MIProcessor.sharedMIP.mIPUniversals.count where (MIProcessor.sharedMIP.mIPUniversals[i].timeStamp as! Int) < givenYearEnd && (MIProcessor.sharedMIP.mIPUniversals[i].timeStamp as! Int) > givenYearBeginning { //Ensures that only transactions happening in pertinent year show. Also ensures that projects which may have been created in another year are not thrown out (That's why this time ranging code isn't included in "for l in 0..<..mIPProjects..." above
                if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == projectItem.key {
                    if MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId == 2 {
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0:
                            switch MIProcessor.sharedMIP.mIPUniversals[i].workersCompId {
                            case 0:
                                runningExpensesLaborHasWC = runningExpensesLaborHasWC + MIProcessor.sharedMIP.mIPUniversals[i].what
                            case 1:
                                runningExpensesLaborIncursWC = runningExpensesLaborIncursWC + MIProcessor.sharedMIP.mIPUniversals[i].what
                            default: //I.e. case 2 WCNA
                                runningExpensesLaborWCNA = runningExpensesLaborWCNA + MIProcessor.sharedMIP.mIPUniversals[i].what
                            }
                        default: //I.e. case 2 MIXED
                            switch MIProcessor.sharedMIP.mIPUniversals[i].workersCompId {
                            case 0:
                                runningExpensesLaborHasWC = runningExpensesLaborHasWC + Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what) * (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                            case 1:
                                runningExpensesLaborIncursWC = runningExpensesLaborIncursWC + Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what) * (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                            default: //I.e. case 2
                                runningExpensesLaborWCNA = runningExpensesLaborWCNA + Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what) * (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                            }
                        }
                    }
                    if MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId == 7 { //IE Pro Help
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0: // Ie. business item
                            runningExpensesProHelp += MIProcessor.sharedMIP.mIPUniversals[i].what
                        case 2: // I.e. mixed item
                            runningExpensesProHelp += Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what) * (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        default:
                            print("NADA!!")
                        }
                    }
                    switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                    case 0: // Business
                        if MIProcessor.sharedMIP.trueYou == MIProcessor.sharedMIP.mIPUniversals[i].whoKey {
                            if MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId == 2 || MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId == 7 {
                                print("Do not any thing YOO YOO")
                            } else {
                                runningExpensesMaterial = runningExpensesMaterial + MIProcessor.sharedMIP.mIPUniversals[i].what
                            }
                        } else {
                            if MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId == 0 {
                                runningGross = runningGross + MIProcessor.sharedMIP.mIPUniversals[i].what
                            } else {
                                runningExpensesMaterial = runningExpensesMaterial - MIProcessor.sharedMIP.mIPUniversals[i].what
                            }
                        }
                    case 2: //I.e. case 2 - MIXED
                        if MIProcessor.sharedMIP.trueYou == MIProcessor.sharedMIP.mIPUniversals[i].whoKey {
                            if MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId == 2 || MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId == 7 {
                                print("Do nothing YOO")
                            } else {
                                runningExpensesMaterial = runningExpensesMaterial + Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what) * (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                            }
                        } else {
                            runningExpensesMaterial = runningExpensesMaterial - Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what) * (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    default:
                        print("Nothing")
                    }
                }
            }
            runningExpensesLaborTotal = runningExpensesLaborHasWC + runningExpensesLaborIncursWC + runningExpensesLaborWCNA
            runningExpensesLaborAndProHelpTotal = runningExpensesLaborTotal + runningExpensesProHelp
            runningExpensesTotal = runningExpensesMaterial + runningExpensesLaborAndProHelpTotal
            netProfit = runningGross - runningExpensesTotal
            var margin = ""
            if runningGross != 0 {
                netMargin = Int((Double(netProfit) / Double(runningGross)) * 100000) //79.16% would look like 79160 and need to be formatted to three decimals.
                margin = stringifyAnInt.stringify(theInt: netMargin, theNumberStyle: .decimal, theGroupingSeparator: true)
            } else {
                margin = "NaN"
            }
            var gross = stringifyAnInt.stringify(theInt: runningGross)
            var expenses = stringifyAnInt.stringify(theInt: runningExpensesTotal)
            var material = stringifyAnInt.stringify(theInt: runningExpensesMaterial)
            var laborAndProHelp = stringifyAnInt.stringify(theInt: runningExpensesLaborAndProHelpTotal)
            var labor = stringifyAnInt.stringify(theInt: runningExpensesLaborTotal)
            var laborSubHasWC = stringifyAnInt.stringify(theInt: runningExpensesLaborHasWC)
            var laborIncursWC = stringifyAnInt.stringify(theInt: runningExpensesLaborIncursWC)
            var laborWCNA = stringifyAnInt.stringify(theInt: runningExpensesLaborWCNA)
            var proHelpTotal = stringifyAnInt.stringify(theInt: runningExpensesProHelp)
            var net = stringifyAnInt.stringify(theInt: netProfit)
            if runningGross == 0 && runningExpensesTotal == 0 {
                // (Don't append projects which saw zero revenue or expense in pertinent year)
            } else {
                projectInfoArray.append([projectItem.name, projectItem.howDidTheyHearOfYouId, projectItem.projectStatusId, projectItem.projectStatusName, runningGross, gross, runningExpensesTotal, expenses, runningExpensesMaterial, material, runningExpensesLaborAndProHelpTotal, laborAndProHelp, runningExpensesLaborTotal, labor, runningExpensesLaborHasWC, laborSubHasWC, runningExpensesLaborIncursWC, laborIncursWC, runningExpensesLaborWCNA, laborWCNA, runningExpensesProHelp, proHelpTotal, netProfit, net, projectItem.howDidTheyHearOfYouString]) //Remember that "project status id and name" now refer to project subcategory as of Jan 2019.
            }
        }
        
        projectInfoTidyArray.append(["Project Name", "Subcategory", "Adv Means", "Gross", "Expenses", "Mtrl", "Labor", "Has WC", "Incurs WC", "Pro Help", "Net"]) // 11 Columns
        for o in 0..<projectInfoArray.count {
            var element1 = projectInfoArray[o][0] as? String ?? ""
            var element2 = projectInfoArray[o][3] as? String ?? ""
            var element3 = projectInfoArray[o][24] as? String ?? ""
            var element4 = projectInfoArray[o][5] as? String ?? ""
            var element5 = projectInfoArray[o][7] as? String ?? ""
            var element6 = projectInfoArray[o][9] as? String ?? ""
            var element7 = projectInfoArray[o][13] as? String ?? ""
            var element8 = projectInfoArray[o][15] as? String ?? ""
            var element9 = projectInfoArray[o][17] as? String ?? ""
            var element10 = projectInfoArray[o][21] as? String ?? ""
            var element11 = projectInfoArray[o][23] as? String ?? ""
            projectInfoTidyArray.append([element1, element2, element3, element4, element5, element6, element7, element8, element9, element10, element11])
        }
        
        var subcat1Id = 0
        var subcat1Name = MIProcessor.sharedMIP.businessInfo.subcat1
        var subcat1Gross = 0
        var subcat1Expenses = 0
        var subcat1Mtrl = 0
        var subcat1LaborAndProHelp = 0
        var subcat1Labor = 0
        var subcat1HasWC = 0
        var subcat1IncursWC = 0
        var subcat1WCNA = 0
        var subcat1ProHelp = 0
        var subcat1Net = 0
        
        var subcat2Id = 0
        var subcat2Name = MIProcessor.sharedMIP.businessInfo.subcat2
        var subcat2Gross = 0
        var subcat2Expenses = 0
        var subcat2Mtrl = 0
        var subcat2LaborAndProHelp = 0
        var subcat2Labor = 0
        var subcat2HasWC = 0
        var subcat2IncursWC = 0
        var subcat2WCNA = 0
        var subcat2ProHelp = 0
        var subcat2Net = 0
        
        var subcat3Id = 0
        var subcat3Name = MIProcessor.sharedMIP.businessInfo.subcat3
        var subcat3Gross = 0
        var subcat3Expenses = 0
        var subcat3Mtrl = 0
        var subcat3LaborAndProHelp = 0
        var subcat3Labor = 0
        var subcat3HasWC = 0
        var subcat3IncursWC = 0
        var subcat3WCNA = 0
        var subcat3ProHelp = 0
        var subcat3Net = 0
        
        var subcat4Id = 0
        var subcat4Name = MIProcessor.sharedMIP.businessInfo.subcat4
        var subcat4Gross = 0
        var subcat4Expenses = 0
        var subcat4Mtrl = 0
        var subcat4LaborAndProHelp = 0
        var subcat4Labor = 0
        var subcat4HasWC = 0
        var subcat4IncursWC = 0
        var subcat4WCNA = 0
        var subcat4ProHelp = 0
        var subcat4Net = 0
        
        var subcat5Id = 0
        var subcat5Name = MIProcessor.sharedMIP.businessInfo.subcat5
        var subcat5Gross = 0
        var subcat5Expenses = 0
        var subcat5Mtrl = 0
        var subcat5LaborAndProHelp = 0
        var subcat5Labor = 0
        var subcat5HasWC = 0
        var subcat5IncursWC = 0
        var subcat5WCNA = 0
        var subcat5ProHelp = 0
        var subcat5Net = 0
        
        var subcat6Id = 0
        var subcat6Name = MIProcessor.sharedMIP.businessInfo.subcat6
        var subcat6Gross = 0
        var subcat6Expenses = 0
        var subcat6Mtrl = 0
        var subcat6LaborAndProHelp = 0
        var subcat6Labor = 0
        var subcat6HasWC = 0
        var subcat6IncursWC = 0
        var subcat6WCNA = 0
        var subcat6ProHelp = 0
        var subcat6Net = 0
        
        let hdthoy1name = "Unknown" //"How Did They Hear Of You" - hdthoy
        var hdthoy1gross = 0
        var hdthoy1net = 0
        
        let hdthoy2name = "Referral"
        var hdthoy2gross = 0
        var hdthoy2net = 0
        
        let hdthoy3name = "Website"
        var hdthoy3gross = 0
        var hdthoy3net = 0
        
        let hdthoy4name = "YP"
        var hdthoy4gross = 0
        var hdthoy4net = 0
        
        let hdthoy5name = "Social Media"
        var hdthoy5gross = 0
        var hdthoy5net = 0
        
        let hdthoy6name = "Soliciting"
        var hdthoy6gross = 0
        var hdthoy6net = 0
        
        let hdthoy7name = "AdWords"
        var hdthoy7gross = 0
        var hdthoy7net = 0
        
        let hdthoy8name = "Company Shirts"
        var hdthoy8gross = 0
        var hdthoy8net = 0
        
        let hdthoy9name = "Yard Signs"
        var hdthoy9gross = 0
        var hdthoy9net = 0
        
        let hdthoy10name = "Vehicle Wrap"
        var hdthoy10gross = 0
        var hdthoy10net = 0
        
        let hdthoy11name = "Billboard"
        var hdthoy11gross = 0
        var hdthoy11net = 0
        
        let hdthoy12name = "TV"
        var hdthoy12gross = 0
        var hdthoy12net = 0
        
        let hdthoy13name = "Radio"
        var hdthoy13gross = 0
        var hdthoy13net = 0
        
        let hdthoy14name = "Other"
        var hdthoy14gross = 0
        var hdthoy14net = 0
        
        for i in 0..<projectInfoArray.count {
            switch projectInfoArray[i][2] as? Int ?? 0 {
            case 0: //I.e. Subcategory 1 i.e. shingles in my case
                subcat1Gross += projectInfoArray[i][4] as? Int ?? 0
                subcat1Expenses += projectInfoArray[i][6] as? Int ?? 0
                subcat1Mtrl += projectInfoArray[i][8] as? Int ?? 0
                subcat1LaborAndProHelp += projectInfoArray[i][10] as? Int ?? 0
                subcat1Labor += projectInfoArray[i][12] as? Int ?? 0
                subcat1HasWC += projectInfoArray[i][14] as? Int ?? 0
                subcat1IncursWC += projectInfoArray[i][16] as? Int ?? 0
                subcat1WCNA += projectInfoArray[i][18] as? Int ?? 0
                subcat1ProHelp += projectInfoArray[i][20] as? Int ?? 0
                subcat1Net += projectInfoArray[i][22] as? Int ?? 0
            case 1:
                subcat2Gross += projectInfoArray[i][4] as? Int ?? 0
                subcat2Expenses += projectInfoArray[i][6] as? Int ?? 0
                subcat2Mtrl += projectInfoArray[i][8] as? Int ?? 0
                subcat2LaborAndProHelp += projectInfoArray[i][10] as? Int ?? 0
                subcat2Labor += projectInfoArray[i][12] as? Int ?? 0
                subcat2HasWC += projectInfoArray[i][14] as? Int ?? 0
                subcat2IncursWC += projectInfoArray[i][16] as? Int ?? 0
                subcat2WCNA += projectInfoArray[i][18] as? Int ?? 0
                subcat2ProHelp += projectInfoArray[i][20] as? Int ?? 0
                subcat2Net += projectInfoArray[i][22] as? Int ?? 0
            case 2:
                subcat3Gross += projectInfoArray[i][4] as? Int ?? 0
                subcat3Expenses += projectInfoArray[i][6] as? Int ?? 0
                subcat3Mtrl += projectInfoArray[i][8] as? Int ?? 0
                subcat3LaborAndProHelp += projectInfoArray[i][10] as? Int ?? 0
                subcat3Labor += projectInfoArray[i][12] as? Int ?? 0
                subcat3HasWC += projectInfoArray[i][14] as? Int ?? 0
                subcat3IncursWC += projectInfoArray[i][16] as? Int ?? 0
                subcat3WCNA += projectInfoArray[i][18] as? Int ?? 0
                subcat3ProHelp += projectInfoArray[i][20] as? Int ?? 0
                subcat3Net += projectInfoArray[i][22] as? Int ?? 0
            case 3:
                subcat4Gross += projectInfoArray[i][4] as? Int ?? 0
                subcat4Expenses += projectInfoArray[i][6] as? Int ?? 0
                subcat4Mtrl += projectInfoArray[i][8] as? Int ?? 0
                subcat4LaborAndProHelp += projectInfoArray[i][10] as? Int ?? 0
                subcat4Labor += projectInfoArray[i][12] as? Int ?? 0
                subcat4HasWC += projectInfoArray[i][14] as? Int ?? 0
                subcat4IncursWC += projectInfoArray[i][16] as? Int ?? 0
                subcat4WCNA += projectInfoArray[i][18] as? Int ?? 0
                subcat4ProHelp += projectInfoArray[i][20] as? Int ?? 0
                subcat4Net += projectInfoArray[i][22] as? Int ?? 0
            case 4:
                subcat5Gross += projectInfoArray[i][4] as? Int ?? 0
                subcat5Expenses += projectInfoArray[i][6] as? Int ?? 0
                subcat5Mtrl += projectInfoArray[i][8] as? Int ?? 0
                subcat5LaborAndProHelp += projectInfoArray[i][10] as? Int ?? 0
                subcat5Labor += projectInfoArray[i][12] as? Int ?? 0
                subcat5HasWC += projectInfoArray[i][14] as? Int ?? 0
                subcat5IncursWC += projectInfoArray[i][16] as? Int ?? 0
                subcat5WCNA += projectInfoArray[i][18] as? Int ?? 0
                subcat5ProHelp += projectInfoArray[i][20] as? Int ?? 0
                subcat5Net += projectInfoArray[i][22] as? Int ?? 0
            case 5:
                subcat6Gross += projectInfoArray[i][4] as? Int ?? 0
                subcat6Expenses += projectInfoArray[i][6] as? Int ?? 0
                subcat6Mtrl += projectInfoArray[i][8] as? Int ?? 0
                subcat6LaborAndProHelp += projectInfoArray[i][10] as? Int ?? 0
                subcat6Labor += projectInfoArray[i][12] as? Int ?? 0
                subcat6HasWC += projectInfoArray[i][14] as? Int ?? 0
                subcat6IncursWC += projectInfoArray[i][16] as? Int ?? 0
                subcat6WCNA += projectInfoArray[i][18] as? Int ?? 0
                subcat6ProHelp += projectInfoArray[i][20] as? Int ?? 0
                subcat6Net += projectInfoArray[i][22] as? Int ?? 0
            default:
                print("Not nothing")
            }
            switch projectInfoArray[i][1] as? Int ?? 0 {
            case 0: //I.e. howDidTheyHear = "Unknown"
                hdthoy1gross += projectInfoArray[i][4] as? Int ?? 0
                hdthoy1net += projectInfoArray[i][22] as? Int ?? 0
            case 1: //="Referral"
                hdthoy2gross += projectInfoArray[i][4] as? Int ?? 0
                hdthoy2net += projectInfoArray[i][22] as? Int ?? 0
            case 2: //="Website"
                hdthoy3gross += projectInfoArray[i][4] as? Int ?? 0
                hdthoy3net += projectInfoArray[i][22] as? Int ?? 0
            case 3: //="YP"
                hdthoy4gross += projectInfoArray[i][4] as? Int ?? 0
                hdthoy4net += projectInfoArray[i][22] as? Int ?? 0
            case 4: //="Social Media"
                hdthoy5gross += projectInfoArray[i][4] as? Int ?? 0
                hdthoy5net += projectInfoArray[i][22] as? Int ?? 0
            case 5: //="Soliciting"
                hdthoy6gross += projectInfoArray[i][4] as? Int ?? 0
                hdthoy6net += projectInfoArray[i][22] as? Int ?? 0
            case 6: //="AdWords"
                hdthoy7gross += projectInfoArray[i][4] as? Int ?? 0
                hdthoy7net += projectInfoArray[i][22] as? Int ?? 0
            case 7: //="Company Shirts"
                hdthoy8gross += projectInfoArray[i][4] as? Int ?? 0
                hdthoy8net += projectInfoArray[i][22] as? Int ?? 0
            case 8: //="Signs"
                hdthoy9gross += projectInfoArray[i][4] as? Int ?? 0
                hdthoy9net += projectInfoArray[i][22] as? Int ?? 0
            case 9: //="Vehicle Wrap"
                hdthoy10gross += projectInfoArray[i][4] as? Int ?? 0
                hdthoy10net += projectInfoArray[i][22] as? Int ?? 0
            case 10: //="Billboard"
                hdthoy11gross += projectInfoArray[i][4] as? Int ?? 0
                hdthoy11net += projectInfoArray[i][22] as? Int ?? 0
            case 11: //="TV"
                hdthoy12gross += projectInfoArray[i][4] as? Int ?? 0
                hdthoy12net += projectInfoArray[i][22] as? Int ?? 0
            case 12: //="Radio"
                hdthoy13gross += projectInfoArray[i][4] as? Int ?? 0
                hdthoy13net += projectInfoArray[i][22] as? Int ?? 0
            case 13: //="Other"
                hdthoy14gross += projectInfoArray[i][4] as? Int ?? 0
                hdthoy14net += projectInfoArray[i][22] as? Int ?? 0
            default:
                print("No, nothing!")
            }
        }
        
        let totallyGross = subcat1Gross + subcat2Gross + subcat3Gross + subcat4Gross + subcat5Gross + subcat6Gross
        let totallyNet = subcat1Net + subcat2Net + subcat3Net + subcat4Net + subcat5Net + subcat6Net
        
        let hdthoy1GrossPercent = Double(hdthoy1gross)/Double(totallyGross)
        let hdthoy2GrossPercent = Double(hdthoy2gross)/Double(totallyGross)
        let hdthoy3GrossPercent = Double(hdthoy3gross)/Double(totallyGross)
        let hdthoy4GrossPercent = Double(hdthoy4gross)/Double(totallyGross)
        let hdthoy5GrossPercent = Double(hdthoy5gross)/Double(totallyGross)
        let hdthoy6GrossPercent = Double(hdthoy6gross)/Double(totallyGross)
        let hdthoy7GrossPercent = Double(hdthoy7gross)/Double(totallyGross)
        let hdthoy8GrossPercent = Double(hdthoy8gross)/Double(totallyGross)
        let hdthoy9GrossPercent = Double(hdthoy9gross)/Double(totallyGross)
        let hdthoy10GrossPercent = Double(hdthoy10gross)/Double(totallyGross)
        let hdthoy11GrossPercent = Double(hdthoy11gross)/Double(totallyGross)
        let hdthoy12GrossPercent = Double(hdthoy12gross)/Double(totallyGross)
        let hdthoy13GrossPercent = Double(hdthoy13gross)/Double(totallyGross)
        let hdthoy14GrossPercent = Double(hdthoy14gross)/Double(totallyGross)
        
        let hdthoy1NetPercent = Double(hdthoy1net)/Double(totallyNet)
        let hdthoy2NetPercent = Double(hdthoy2net)/Double(totallyNet)
        let hdthoy3NetPercent = Double(hdthoy3net)/Double(totallyNet)
        let hdthoy4NetPercent = Double(hdthoy4net)/Double(totallyNet)
        let hdthoy5NetPercent = Double(hdthoy5net)/Double(totallyNet)
        let hdthoy6NetPercent = Double(hdthoy6net)/Double(totallyNet)
        let hdthoy7NetPercent = Double(hdthoy7net)/Double(totallyNet)
        let hdthoy8NetPercent = Double(hdthoy8net)/Double(totallyNet)
        let hdthoy9NetPercent = Double(hdthoy9net)/Double(totallyNet)
        let hdthoy10NetPercent = Double(hdthoy10net)/Double(totallyNet)
        let hdthoy11NetPercent = Double(hdthoy11net)/Double(totallyNet)
        let hdthoy12NetPercent = Double(hdthoy12net)/Double(totallyNet)
        let hdthoy13NetPercent = Double(hdthoy13net)/Double(totallyNet)
        let hdthoy14NetPercent = Double(hdthoy14net)/Double(totallyNet)
        
        let hdthoy1GrossROI = Double(hdthoy1gross)/Double(hdthoy1RunningGross)
        let hdthoy1GrossROIString = String(hdthoy1GrossROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy2GrossROI = Double(hdthoy2gross)/Double(hdthoy2RunningGross)
        let hdthoy2GrossROIString = String(hdthoy2GrossROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy3GrossROI = Double(hdthoy3gross)/Double(hdthoy3RunningGross)
        let hdthoy3GrossROIString = String(hdthoy3GrossROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy4GrossROI = Double(hdthoy4gross)/Double(hdthoy4RunningGross)
        let hdthoy4GrossROIString = String(hdthoy4GrossROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy5GrossROI = Double(hdthoy5gross)/Double(hdthoy5RunningGross)
        let hdthoy5GrossROIString = String(hdthoy5GrossROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy6GrossROI = Double(hdthoy6gross)/Double(hdthoy6RunningGross)
        let hdthoy6GrossROIString = String(hdthoy6GrossROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy7GrossROI = Double(hdthoy7gross)/Double(hdthoy7RunningGross)
        let hdthoy7GrossROIString = String(hdthoy7GrossROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy8GrossROI = Double(hdthoy8gross)/Double(hdthoy8RunningGross)
        let hdthoy8GrossROIString = String(hdthoy8GrossROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy9GrossROI = Double(hdthoy9gross)/Double(hdthoy9RunningGross)
        let hdthoy9GrossROIString = String(hdthoy9GrossROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy10GrossROI = Double(hdthoy10gross)/Double(hdthoy10RunningGross)
        let hdthoy10GrossROIString = String(hdthoy10GrossROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy11GrossROI = Double(hdthoy11gross)/Double(hdthoy11RunningGross)
        let hdthoy11GrossROIString = String(hdthoy11GrossROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy12GrossROI = Double(hdthoy12gross)/Double(hdthoy12RunningGross)
        let hdthoy12GrossROIString = String(hdthoy12GrossROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy13GrossROI = Double(hdthoy13gross)/Double(hdthoy13RunningGross)
        let hdthoy13GrossROIString = String(hdthoy13GrossROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy14GrossROI = Double(hdthoy14gross)/Double(hdthoy14RunningGross)
        let hdthoy14GrossROIString = String(hdthoy14GrossROI.rounded(toPlaces: 1)) + " : 1"
        
        let hdthoy1NetROI = Double(hdthoy1net)/Double(hdthoy1RunningGross)
        let hdthoy1NetROIString = String(hdthoy1NetROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy2NetROI = Double(hdthoy2net)/Double(hdthoy2RunningGross)
        let hdthoy2NetROIString = String(hdthoy2NetROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy3NetROI = Double(hdthoy3net)/Double(hdthoy3RunningGross)
        let hdthoy3NetROIString = String(hdthoy3NetROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy4NetROI = Double(hdthoy4net)/Double(hdthoy4RunningGross)
        let hdthoy4NetROIString = String(hdthoy4NetROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy5NetROI = Double(hdthoy5net)/Double(hdthoy5RunningGross)
        let hdthoy5NetROIString = String(hdthoy5NetROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy6NetROI = Double(hdthoy6net)/Double(hdthoy6RunningGross)
        let hdthoy6NetROIString = String(hdthoy6NetROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy7NetROI = Double(hdthoy7net)/Double(hdthoy7RunningGross)
        let hdthoy7NetROIString = String(hdthoy7NetROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy8NetROI = Double(hdthoy8net)/Double(hdthoy8RunningGross)
        let hdthoy8NetROIString = String(hdthoy8NetROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy9NetROI = Double(hdthoy9net)/Double(hdthoy9RunningGross)
        let hdthoy9NetROIString = String(hdthoy9NetROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy10NetROI = Double(hdthoy10net)/Double(hdthoy10RunningGross)
        let hdthoy10NetROIString = String(hdthoy10NetROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy11NetROI = Double(hdthoy11net)/Double(hdthoy11RunningGross)
        let hdthoy11NetROIString = String(hdthoy11NetROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy12NetROI = Double(hdthoy12net)/Double(hdthoy12RunningGross)
        let hdthoy12NetROIString = String(hdthoy12NetROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy13NetROI = Double(hdthoy13net)/Double(hdthoy13RunningGross)
        let hdthoy13NetROIString = String(hdthoy13NetROI.rounded(toPlaces: 1)) + " : 1"
        let hdthoy14NetROI = Double(hdthoy14net)/Double(hdthoy14RunningGross)
        let hdthoy14NetROIString = String(hdthoy14NetROI.rounded(toPlaces: 1)) + " : 1"
        
        projectSubcatInfoArray.append([subcat1Name, subcat1Gross, subcat1Expenses, subcat1Mtrl, subcat1LaborAndProHelp, subcat1Labor, subcat1IncursWC, subcat1HasWC, subcat1WCNA, subcat1ProHelp, subcat1Net])
        projectSubcatInfoArray.append([subcat2Name, subcat2Gross, subcat2Expenses, subcat2Mtrl, subcat2LaborAndProHelp, subcat2Labor, subcat2IncursWC, subcat2HasWC, subcat2WCNA, subcat2ProHelp, subcat2Net])
        projectSubcatInfoArray.append([subcat3Name, subcat3Gross, subcat3Expenses, subcat3Mtrl, subcat3LaborAndProHelp, subcat3Labor, subcat3IncursWC, subcat3HasWC, subcat3WCNA, subcat3ProHelp, subcat3Net])
        projectSubcatInfoArray.append([subcat4Name, subcat4Gross, subcat4Expenses, subcat4Mtrl, subcat4LaborAndProHelp, subcat4Labor, subcat4IncursWC, subcat4HasWC, subcat4WCNA, subcat4ProHelp, subcat4Net])
        projectSubcatInfoArray.append([subcat5Name, subcat5Gross, subcat5Expenses, subcat5Mtrl, subcat5LaborAndProHelp, subcat5Labor, subcat5IncursWC, subcat5HasWC, subcat5WCNA, subcat5ProHelp, subcat5Net])
        projectSubcatInfoArray.append([subcat6Name, subcat6Gross, subcat6Expenses, subcat6Mtrl, subcat6LaborAndProHelp, subcat6Labor, subcat6IncursWC, subcat6HasWC, subcat6WCNA, subcat6ProHelp, subcat6Net])
        
        var subcatPercentGrossArray: [String] = [String]()
        subcatPercentGrossArray.append(String(Int(Double(subcat1Gross)/Double(totallyGross)*100)) + "%")
        subcatPercentGrossArray.append(String(Int(Double(subcat2Gross)/Double(totallyGross)*100)) + "%")
        subcatPercentGrossArray.append(String(Int(Double(subcat3Gross)/Double(totallyGross)*100)) + "%")
        subcatPercentGrossArray.append(String(Int(Double(subcat4Gross)/Double(totallyGross)*100)) + "%")
        subcatPercentGrossArray.append(String(Int(Double(subcat5Gross)/Double(totallyGross)*100)) + "%")
        subcatPercentGrossArray.append(String(Int(Double(subcat6Gross)/Double(totallyGross)*100)) + "%")
        
        var subcatPercentNetArray: [String] = [String]()
        subcatPercentNetArray.append(String(Int(Double(subcat1Net)/Double(totallyNet)*100)) + "%")
        subcatPercentNetArray.append(String(Int(Double(subcat2Net)/Double(totallyNet)*100)) + "%")
        subcatPercentNetArray.append(String(Int(Double(subcat3Net)/Double(totallyNet)*100)) + "%")
        subcatPercentNetArray.append(String(Int(Double(subcat4Net)/Double(totallyNet)*100)) + "%")
        subcatPercentNetArray.append(String(Int(Double(subcat5Net)/Double(totallyNet)*100)) + "%")
        subcatPercentNetArray.append(String(Int(Double(subcat6Net)/Double(totallyNet)*100)) + "%")
        
        projectSubcatInfoTidyArray.append(["Subcategory", "Gross", "Expenses", "Material", "Labor & Pro Help", "Net", "Gross", "Net"])
        for n in 0..<projectSubcatInfoArray.count {
            projectSubcatInfoTidyArray.append([projectSubcatInfoArray[n][0] as? String ?? "Subcat 1", (projectSubcatInfoArray[n][1] as? Int ?? 0).sCur(), (projectSubcatInfoArray[n][2] as? Int ?? 0).sCur(), (projectSubcatInfoArray[n][3] as? Int ?? 0).sCur(), (projectSubcatInfoArray[n][4] as? Int ?? 0).sCur(), (projectSubcatInfoArray[n][10] as? Int ?? 0).sCur(), subcatPercentGrossArray[n], subcatPercentNetArray[n]])
        }
        
        projectHDTHOYInfoArray.append(["Advertising Means", "Grossed", "%", "Netted", "%", "Spent", "Gross ROI", "Net ROI"])
        projectHDTHOYInfoArray.append([hdthoy1name, hdthoy1gross.sCur(), hdthoy1GrossPercent.sPor(), hdthoy1net.sCur(), hdthoy1NetPercent.sPor(), hdthoy1RunningGross.sCur(), hdthoy1GrossROIString, hdthoy1NetROIString])
        projectHDTHOYInfoArray.append([hdthoy2name, hdthoy2gross.sCur(), hdthoy2GrossPercent.sPor(), hdthoy2net.sCur(), hdthoy2NetPercent.sPor(), hdthoy2RunningGross.sCur(), hdthoy2GrossROIString, hdthoy2NetROIString])
        projectHDTHOYInfoArray.append([hdthoy3name, hdthoy3gross.sCur(), hdthoy3GrossPercent.sPor(), hdthoy3net.sCur(), hdthoy3NetPercent.sPor(), hdthoy3RunningGross.sCur(), hdthoy3GrossROIString, hdthoy3NetROIString])
        projectHDTHOYInfoArray.append([hdthoy4name, hdthoy4gross.sCur(), hdthoy4GrossPercent.sPor(), hdthoy4net.sCur(), hdthoy4NetPercent.sPor(), hdthoy4RunningGross.sCur(), hdthoy4GrossROIString, hdthoy4NetROIString])
        projectHDTHOYInfoArray.append([hdthoy5name, hdthoy5gross.sCur(), hdthoy5GrossPercent.sPor(), hdthoy5net.sCur(), hdthoy5NetPercent.sPor(), hdthoy5RunningGross.sCur(), hdthoy5GrossROIString, hdthoy5NetROIString])
        projectHDTHOYInfoArray.append([hdthoy6name, hdthoy6gross.sCur(), hdthoy6GrossPercent.sPor(), hdthoy6net.sCur(), hdthoy6NetPercent.sPor(), hdthoy6RunningGross.sCur(), hdthoy6GrossROIString, hdthoy6NetROIString])
        projectHDTHOYInfoArray.append([hdthoy7name, hdthoy7gross.sCur(), hdthoy7GrossPercent.sPor(), hdthoy7net.sCur(), hdthoy7NetPercent.sPor(), hdthoy7RunningGross.sCur(), hdthoy7GrossROIString, hdthoy7NetROIString])
        projectHDTHOYInfoArray.append([hdthoy8name, hdthoy8gross.sCur(), hdthoy8GrossPercent.sPor(), hdthoy8net.sCur(), hdthoy8NetPercent.sPor(), hdthoy8RunningGross.sCur(), hdthoy8GrossROIString, hdthoy8NetROIString])
        projectHDTHOYInfoArray.append([hdthoy9name, hdthoy9gross.sCur(), hdthoy9GrossPercent.sPor(), hdthoy9net.sCur(), hdthoy9NetPercent.sPor(), hdthoy9RunningGross.sCur(), hdthoy9GrossROIString, hdthoy9NetROIString])
        projectHDTHOYInfoArray.append([hdthoy10name, hdthoy10gross.sCur(), hdthoy10GrossPercent.sPor(), hdthoy10net.sCur(), hdthoy10NetPercent.sPor(), hdthoy10RunningGross.sCur(), hdthoy10GrossROIString, hdthoy10NetROIString])
        projectHDTHOYInfoArray.append([hdthoy11name, hdthoy11gross.sCur(), hdthoy11GrossPercent.sPor(), hdthoy11net.sCur(), hdthoy11NetPercent.sPor(), hdthoy11RunningGross.sCur(), hdthoy11GrossROIString, hdthoy11NetROIString])
        projectHDTHOYInfoArray.append([hdthoy12name, hdthoy12gross.sCur(), hdthoy12GrossPercent.sPor(), hdthoy12net.sCur(), hdthoy12NetPercent.sPor(), hdthoy12RunningGross.sCur(), hdthoy12GrossROIString, hdthoy12NetROIString])
        projectHDTHOYInfoArray.append([hdthoy13name, hdthoy13gross.sCur(), hdthoy13GrossPercent.sPor(), hdthoy13net.sCur(), hdthoy13NetPercent.sPor(), hdthoy13RunningGross.sCur(), hdthoy13GrossROIString, hdthoy13NetROIString])
        projectHDTHOYInfoArray.append([hdthoy14name, hdthoy14gross.sCur(), hdthoy14GrossPercent.sPor(), hdthoy14net.sCur(), hdthoy14NetPercent.sPor(), hdthoy14RunningGross.sCur(), hdthoy14GrossROIString, hdthoy14NetROIString])
        
        let A4paperSize = CGSize(width: 595, height: 842)
        let pdf = SimplePDF(pageSize: A4paperSize, pageMargin: 20.0)
        pdf.setContentAlignment(.center)
        pdf.addImage(UIImage(named: "bizzybooksbee")!)
        let titleIncomeStatement = String(selectedYear) + " Income Statement"
        let font = UIFont.systemFont(ofSize: 36)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]
        let attributedTitleIncomeStatement = NSAttributedString(string: titleIncomeStatement, attributes: titleAttributes)
        pdf.addAttributedText(attributedTitleIncomeStatement)
        pdf.addText("Created with Bizzy Books " + DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short))
        pdf.addLineSeparator()
        pdf.addVerticalSpace(24)
        let incomeStatementDataArray = [["Revenues", stringifyAnInt.stringify(theInt: income)], ["Supplies", stringifyAnInt.stringify(theInt: supplies)], ["Labor", stringifyAnInt.stringify(theInt: labor)], ["Meals", stringifyAnInt.stringify(theInt: meals)], ["Office", stringifyAnInt.stringify(theInt: office)], ["Vehicle", stringifyAnInt.stringify(theInt: vehicle)], ["Advertising", stringifyAnInt.stringify(theInt: adv)], ["Pro Help", stringifyAnInt.stringify(theInt: proHelp)], ["Machine Rent", stringifyAnInt.stringify(theInt: machineRent)], ["Tax and License", stringifyAnInt.stringify(theInt: taxAndLic)], ["WC and GL Insurance", stringifyAnInt.stringify(theInt: insGLAndWC)], ["Travel", stringifyAnInt.stringify(theInt: travel)], ["Employee Benefits", stringifyAnInt.stringify(theInt: empBen)], ["Depreciation", stringifyAnInt.stringify(theInt: depreciation)], ["Depletion", stringifyAnInt.stringify(theInt: depletion)], ["Utilities", stringifyAnInt.stringify(theInt: utilities)], ["Commissions", stringifyAnInt.stringify(theInt: commissions)], ["Wages", stringifyAnInt.stringify(theInt: wages)], ["Mortgage Interest", stringifyAnInt.stringify(theInt: mortInterest)], ["Other Interest", stringifyAnInt.stringify(theInt: otherInterest)], ["Pensions", stringifyAnInt.stringify(theInt: pension)], ["Repairs", stringifyAnInt.stringify(theInt: repairs)], ["Net", stringifyAnInt.stringify(theInt: net)]]
        //pdf.addTable(incomeStatementDataArray.count, columnCount: 2, rowHeight: 18.0, columnWidth: 160.0, tableLineWidth: 1.0, font: UIFont.systemFont(ofSize: 12.0), dataArray: incomeStatementDataArray)
        //pdf.setContentAlignment(.left)
        
        let tableDefIncomeStatement = TableDefinition(alignments: [.left, .right],
                                       columnWidths: [350, 200],
                                       fonts: [UIFont.systemFont(ofSize: 16),
                                               UIFont.systemFont(ofSize: 16)],
                                       textColors: [UIColor.gray,
                                                    UIColor.black])
        pdf.addTable(incomeStatementDataArray.count, columnCount: 2, rowHeight: 24.0, tableLineWidth: 1.0, tableDefinition: tableDefIncomeStatement, dataArray: incomeStatementDataArray)
        
        pdf.beginNewPage()
        pdf.addImage(UIImage(named: "bizzybooksbee")!)
        let titleProfitStatement = String(selectedYear) + " Profit Statement"
        let attributedTitleProfitStatement = NSAttributedString(string: titleProfitStatement, attributes: titleAttributes)
        pdf.addAttributedText(attributedTitleProfitStatement)
        pdf.addText("Created with Bizzy Books " + DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short))
        pdf.addLineSeparator()
        pdf.addVerticalSpace(24)
        let profitStatementDataArray = [["Income", stringifyAnInt.stringify(theInt: income)], ["Total Expenses", stringifyAnInt.stringify(theInt: allExpenses)], ["(Project Expenses)", stringifyAnInt.stringify(theInt: projectExpenses)], ["(Overhead Expenses)", stringifyAnInt.stringify(theInt: overheadExpenses)], ["Gross Profit", stringifyAnInt.stringify(theInt: grossProfit)], ["Net Profit", stringifyAnInt.stringify(theInt: netProfit)], ["Overhead Margin", stringifyAnInt.stringify(theDoubPorciento: overheadMargin)], ["Profit Margin", stringifyAnInt.stringify(theDoubPorciento: profitMargin)], ["Profit Factor", stringifyAnInt.stringify(theDoubFactor: profitFactor)]]
        let tableDefProfitStatement = TableDefinition(alignments: [.left, .right], columnWidths: [350, 200], fonts: [UIFont.systemFont(ofSize: 16), UIFont.systemFont(ofSize: 16)], textColors: [UIColor.gray, UIColor.black])
        pdf.addTable(profitStatementDataArray.count, columnCount: 2, rowHeight: 24.0, tableLineWidth: 1.0, tableDefinition: tableDefProfitStatement, dataArray: profitStatementDataArray)
        
        pdf.beginNewPage()
        pdf.addImage(UIImage(named: "bizzybooksbee")!)
        let titlePersonalSpending = String(selectedYear) + " Personal Spending"
        let attributedTitlePersonalSpending = NSAttributedString(string: titlePersonalSpending, attributes: titleAttributes)
        pdf.addAttributedText(attributedTitlePersonalSpending)
        pdf.addText("Created with Bizzy Books " + DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short))
        pdf.addLineSeparator()
        pdf.addVerticalSpace(24)
        let personalSpendingDataArray = [["Earned", stringifyAnInt.stringify(theInt: netProfit)], ["All Personal Spending", stringifyAnInt.stringify(theInt: allPersonalSpending)], ["Food", stringifyAnInt.stringify(theInt: food)], ["Fun", stringifyAnInt.stringify(theInt: fun)], ["Pet", stringifyAnInt.stringify(theInt: pet)], ["Utilities", stringifyAnInt.stringify(theInt: utilitiesPersonal)], ["Phone", stringifyAnInt.stringify(theInt: phone)], ["Office", stringifyAnInt.stringify(theInt: officePersonal)], ["Giving", stringifyAnInt.stringify(theInt: giving)], ["Insurance", stringifyAnInt.stringify(theInt: insurancePersonal)], ["House", stringifyAnInt.stringify(theInt: house)], ["Yard", stringifyAnInt.stringify(theInt: yard)], ["Medical", stringifyAnInt.stringify(theInt: medical)], ["Travel", stringifyAnInt.stringify(theInt: travelPersonal)], ["Clothes", stringifyAnInt.stringify(theInt: clothes)], ["Other", stringifyAnInt.stringify(theInt: otherPersonal)], ["Net Saving", stringifyAnInt.stringify(theInt: netSaving)]]
        let tableDefPersonalSpending = TableDefinition(alignments: [.left, .right], columnWidths: [350, 200], fonts: [UIFont.systemFont(ofSize: 16), UIFont.systemFont(ofSize: 16)], textColors: [UIColor.gray, UIColor.black])
        pdf.addTable(personalSpendingDataArray.count, columnCount: 2, rowHeight: 24.0, tableLineWidth: 1.0, tableDefinition: tableDefPersonalSpending, dataArray: personalSpendingDataArray)
        
        pdf.beginNewPage()
        pdf.addImage(UIImage(named: "bizzybooksbee")!)
        let titleInfoFor1099s = String(selectedYear) + " Info for 1099s"
        let attributedTitleInfoFor1099s = NSAttributedString(string: titleInfoFor1099s, attributes: titleAttributes)
        pdf.addAttributedText(attributedTitleInfoFor1099s)
        pdf.addText("Created with Bizzy Books " + DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short))
        pdf.addLineSeparator()
        pdf.addVerticalSpace(24)
        let tableDefInfoFor1099s = TableDefinition(alignments: [.left, .left, .left, .left, .left, .left, .left], columnWidths: [130, 70, 70, 70, 70, 70, 70], fonts: [UIFont.systemFont(ofSize: 12), UIFont.systemFont(ofSize: 12), UIFont.systemFont(ofSize: 12), UIFont.systemFont(ofSize: 12), UIFont.systemFont(ofSize: 12), UIFont.systemFont(ofSize: 12), UIFont.systemFont(ofSize: 12)], textColors: [UIColor.gray, UIColor.black, UIColor.black, UIColor.black, UIColor.black, UIColor.black, UIColor.black])
        pdf.addTable(infoFor1099sDataArray.count, columnCount: 7, rowHeight: 24.0, tableLineWidth: 1.0, tableDefinition: tableDefInfoFor1099s, dataArray: infoFor1099sDataArray)
        
        pdf.beginNewPage()
        pdf.addImage(UIImage(named: "bizzybooksbee")!)
        let titleAdvertisingSummary = String(selectedYear) + " Advertising Summary"
        let attributedTitleAdvertisingSummary = NSAttributedString(string: titleAdvertisingSummary, attributes: titleAttributes)
        pdf.addAttributedText(attributedTitleAdvertisingSummary)
        pdf.addText("Created with Bizzy Books " + DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short))
        pdf.addLineSeparator()
        pdf.addVerticalSpace(24)
        let tableDefAdvertisingSummary = TableDefinition(alignments: [.left, .left, .left, .left, .left, .left, .left, .left], columnWidths: [130, 80, 40, 80, 40, 60, 60, 60], fonts: [UIFont.systemFont(ofSize: 11), UIFont.systemFont(ofSize: 11), UIFont.systemFont(ofSize: 11), UIFont.systemFont(ofSize: 11), UIFont.systemFont(ofSize: 11), UIFont.systemFont(ofSize: 11), UIFont.systemFont(ofSize: 11), UIFont.systemFont(ofSize: 11)], textColors: [UIColor.gray, UIColor.black, UIColor.black, UIColor.black, UIColor.black, UIColor.black, UIColor.black, UIColor.black])
        pdf.addTable(projectHDTHOYInfoArray.count, columnCount: 8, rowHeight: 20.0, tableLineWidth: 1.0, tableDefinition: tableDefAdvertisingSummary, dataArray: projectHDTHOYInfoArray)
        
        pdf.beginNewPage()
        pdf.addImage(UIImage(named: "bizzybooksbee")!)
        let titleSubcatInfo = String(selectedYear) + " Subcategories"
        let attributedTitleSubcatInfo = NSAttributedString(string: titleSubcatInfo, attributes: titleAttributes)
        pdf.addAttributedText(attributedTitleSubcatInfo)
        pdf.addText("Created with Bizzy Books " + DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short))
        pdf.addLineSeparator()
        pdf.addVerticalSpace(24)
        let tableDefSubcatInfo = TableDefinition(alignments: [.left, .left, .left, .left, .left, .left, .left, .left], columnWidths: [80, 70, 70, 70, 100, 70, 40, 40], fonts: [UIFont.systemFont(ofSize: 11), UIFont.systemFont(ofSize: 11), UIFont.systemFont(ofSize: 11), UIFont.systemFont(ofSize: 11), UIFont.systemFont(ofSize: 11), UIFont.systemFont(ofSize: 11), UIFont.systemFont(ofSize: 11), UIFont.systemFont(ofSize: 11)], textColors: [UIColor.gray, UIColor.black, UIColor.black, UIColor.black, UIColor.black, UIColor.black, UIColor.black, UIColor.black])
        pdf.addTable(projectSubcatInfoTidyArray.count, columnCount: 8, rowHeight: 20.0, tableLineWidth: 1.0, tableDefinition: tableDefSubcatInfo, dataArray: projectSubcatInfoTidyArray)
        
        for t in 0..<vehicleKeysUsedInPertYear.count {
            vehicleInfoArrayOrdered.removeAll()
            vehicleInfoArrayOrdered.append(["Date", "Odometer", "Spend", "Gallons"])
            var thisVehName = ""
            for u in 0..<vehicleInfoArray.count {
                if vehicleInfoArray[u][0]==vehicleKeysUsedInPertYear[t] {
                    thisVehName = vehicleInfoArray[u][1]
                    vehicleInfoArrayOrdered.append([vehicleInfoArray[u][2], vehicleInfoArray[u][3], vehicleInfoArray[u][4], vehicleInfoArray[u][5]])
                }
            }
            pdf.beginNewPage()
            pdf.addImage(UIImage(named: "bizzybooksbee")!)
            let titleVehicle = String(selectedYear) + " \(thisVehName) Info"
            let attributedTitleVehicle = NSAttributedString(string: titleVehicle, attributes: titleAttributes)
            pdf.addAttributedText(attributedTitleVehicle)
            pdf.addText("Created with Bizzy Books " + DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short))
            pdf.addLineSeparator()
            pdf.addVerticalSpace(24)
            let tableDefVehicle = TableDefinition(alignments: [.left, .left, .left, .left], columnWidths: [200, 100, 125, 125], fonts: [UIFont.systemFont(ofSize: 10), UIFont.systemFont(ofSize: 10), UIFont.systemFont(ofSize: 10), UIFont.systemFont(ofSize: 10)], textColors: [UIColor.black, UIColor.black, UIColor.black, UIColor.black])
            pdf.addTable(vehicleInfoArrayOrdered.count, columnCount: 4, rowHeight: 16.0, tableLineWidth: 1.0, tableDefinition: tableDefVehicle, dataArray: vehicleInfoArrayOrdered)
        }
        
        let subcat1GrossTidy = Double(subcat1Gross/100)
        let subcat2GrossTidy = Double(subcat2Gross/100)
        let subcat3GrossTidy = Double(subcat3Gross/100)
        let subcat4GrossTidy = Double(subcat4Gross/100)
        let subcat5GrossTidy = Double(subcat5Gross/100)
        let subcat6GrossTidy = Double(subcat6Gross/100)
        let subcat1GrossEntry = DGCharts.PieChartDataEntry(value: subcat1GrossTidy, label: subcat1Name)
        let subcat2GrossEntry = DGCharts.PieChartDataEntry(value: subcat2GrossTidy, label: subcat2Name)
        let subcat3GrossEntry = DGCharts.PieChartDataEntry(value: subcat3GrossTidy, label: subcat3Name)
        let subcat4GrossEntry = DGCharts.PieChartDataEntry(value: subcat4GrossTidy, label: subcat4Name)
        let subcat5GrossEntry = DGCharts.PieChartDataEntry(value: subcat5GrossTidy, label: subcat5Name)
        let subcat6GrossEntry = DGCharts.PieChartDataEntry(value: subcat6GrossTidy, label: subcat6Name)
        let subcatGrossNums = [subcat1GrossEntry, subcat2GrossEntry, subcat3GrossEntry, subcat4GrossEntry, subcat5GrossEntry, subcat6GrossEntry]
        //let subcatGrossPieChart = PieChartView()
        let subcatGrossDataSet = DGCharts.PieChartDataSet(entries: subcatGrossNums, label: "")
        let subcatGrossData = DGCharts.PieChartData(dataSet: subcatGrossDataSet)
        let colors = [UIColor.BizzyColor.Blue.Project, UIColor.BizzyColor.Green.Account, UIColor.BizzyColor.Purple.Whom, UIColor.BizzyColor.Magenta.TaxReason, UIColor.BizzyColor.Orange.WC, UIColor.BizzyColor.Yellow.TheFabButton]
        subcatGrossDataSet.colors = colors
        //subcatGrossPieChart.data = subcatGrossData
        //trialPieView.data = subcatGrossData
        
        pdf.beginNewPage()
        pdf.addImage(UIImage(named: "bizzybooksbee")!)
        let titleSubcatGross = String(selectedYear) + " Subcategories by Gross"
        let attributedTitleSubcatGross = NSAttributedString(string: titleSubcatGross, attributes: titleAttributes)
        pdf.addAttributedText(attributedTitleSubcatGross)
        pdf.addText("Created with Bizzy Books " + DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short))
        pdf.addLineSeparator()
        pdf.addVerticalSpace(24)
        pdf.addImage(trialPieView.asImage())
        
        let subcat1NetTidy = Double(subcat1Net/100)
        let subcat2NetTidy = Double(subcat2Net/100)
        let subcat3NetTidy = Double(subcat3Net/100)
        let subcat4NetTidy = Double(subcat4Net/100)
        let subcat5NetTidy = Double(subcat5Net/100)
        let subcat6NetTidy = Double(subcat6Net/100)
        let subcat1NetEntry = DGCharts.PieChartDataEntry(value: subcat1NetTidy, label: subcat1Name)
        let subcat2NetEntry = DGCharts.PieChartDataEntry(value: subcat2NetTidy, label: subcat2Name)
        let subcat3NetEntry = DGCharts.PieChartDataEntry(value: subcat3NetTidy, label: subcat3Name)
        let subcat4NetEntry = DGCharts.PieChartDataEntry(value: subcat4NetTidy, label: subcat4Name)
        let subcat5NetEntry = DGCharts.PieChartDataEntry(value: subcat5NetTidy, label: subcat5Name)
        let subcat6NetEntry = DGCharts.PieChartDataEntry(value: subcat6NetTidy, label: subcat6Name)
        let subcatNetNums = [subcat1NetEntry, subcat2NetEntry, subcat3NetEntry, subcat4NetEntry, subcat5NetEntry, subcat6NetEntry]
        let subcatNetDataSet = DGCharts.PieChartDataSet(entries: subcatNetNums, label: "")
        let subcatNetData = DGCharts.PieChartData(dataSet: subcatNetDataSet)
        let colors2 = [UIColor.BizzyColor.Blue.Project, UIColor.BizzyColor.Green.Account, UIColor.BizzyColor.Purple.Whom, UIColor.BizzyColor.Magenta.TaxReason, UIColor.BizzyColor.Orange.WC, UIColor.BizzyColor.Yellow.TheFabButton]
        subcatNetDataSet.colors = colors2
        //subcatGrossPieChart.data = subcatGrossData
        //trialPieView2.data = subcatNetData
        
        pdf.beginNewPage()
        pdf.addImage(UIImage(named: "bizzybooksbee")!)
        let titleSubcatNet = String(selectedYear) + " Subcategories by Net"
        let attributedTitleSubcatNet = NSAttributedString(string: titleSubcatNet, attributes: titleAttributes)
        pdf.addAttributedText(attributedTitleSubcatNet)
        pdf.addText("Created with Bizzy Books " + DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short))
        pdf.addLineSeparator()
        pdf.addVerticalSpace(24)
        pdf.addImage(trialPieView2.asImage())
        
        for m in 0..<((projectInfoTidyArray.count + 33)/34) {
            var thirtyFourAtATimeProjectInfoTidyArray: [[String]] = [[String]]()
            var insideLoopCount = 0
            if projectInfoTidyArray.count <= 34 {
                insideLoopCount = projectInfoTidyArray.count
            } else if (projectInfoTidyArray.count - (m*34)) >= 34 {
                insideLoopCount = 34
            } else {
                insideLoopCount = projectInfoTidyArray.count % 34
            }
            for p in 0..<insideLoopCount {
                let q = (m*34) + p
                thirtyFourAtATimeProjectInfoTidyArray.append([projectInfoTidyArray[q][0], projectInfoTidyArray[q][1], projectInfoTidyArray[q][2], projectInfoTidyArray[q][3], projectInfoTidyArray[q][4], projectInfoTidyArray[q][5], projectInfoTidyArray[q][6], projectInfoTidyArray[q][7], projectInfoTidyArray[q][8], projectInfoTidyArray[q][9], projectInfoTidyArray[q][10]])
            }
            pdf.beginNewPage()
            pdf.addImage(UIImage(named: "bizzybooksbee")!)
            let titleProjectInfo = String(selectedYear) + " Project Info"
            let attributedTitleProjectInfo = NSAttributedString(string: titleProjectInfo, attributes: titleAttributes)
            pdf.addAttributedText(attributedTitleProjectInfo)
            pdf.addText("Created with Bizzy Books " + DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short))
            pdf.addLineSeparator()
            pdf.addVerticalSpace(24)
            let tableDefProjectInfo = TableDefinition(alignments: [.left, .left, .left, .left, .left, .left, .left, .left, .left, .left, .left], columnWidths: [112, 55, 55, 41, 41, 41, 41, 41, 41, 41, 41], fonts: [UIFont.systemFont(ofSize: 5), UIFont.systemFont(ofSize: 7), UIFont.systemFont(ofSize: 7), UIFont.systemFont(ofSize: 7), UIFont.systemFont(ofSize: 7), UIFont.systemFont(ofSize: 7), UIFont.systemFont(ofSize: 7), UIFont.systemFont(ofSize: 7), UIFont.systemFont(ofSize: 7), UIFont.systemFont(ofSize: 7), UIFont.systemFont(ofSize: 7)], textColors: [UIColor.black, UIColor.gray, UIColor.gray, UIColor.black, UIColor.red, UIColor.BizzyColor.Green.What, UIColor.BizzyColor.Blue.Who, UIColor.BizzyColor.Orange.WC, UIColor.BizzyColor.Orange.WC, UIColor.BizzyColor.Magenta.TaxReason, UIColor.black])
            pdf.addTable(thirtyFourAtATimeProjectInfoTidyArray.count, columnCount: 11, rowHeight: 16.0, tableLineWidth: 1.0, tableDefinition: tableDefProjectInfo, dataArray: thirtyFourAtATimeProjectInfoTidyArray)
        }
        
        // Generate PDF data and save to a local file.
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            
            let fileName = "report.pdf"
            documentsFileName = documentDirectories + "/" + fileName
            
            pdfData = pdf.generatePDFdata()
            do{
                try pdfData.write(to: URL(fileURLWithPath: documentsFileName), options: .atomic)
                print("\nThe generated pdf can be found at:")
                print("\n\t\(documentsFileName)\n")
            }catch{
                print(error)
            }
            let request = URLRequest(url: URL(fileURLWithPath: documentsFileName))
            reportViewWebView.loadRequest(request)
        }
    
    }
    
    @IBAction func shareReportPressed(_ sender: Any) {
        share(url: URL(fileURLWithPath: documentsFileName))
        //let request2 = URLRequest(url: URL(fileURLWithPath: documentsFileName))
        //let vc = UIActivityViewController(activityItems: [request2!], applicationActivities: [])
        //present(vc, animated: true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ReportsViewController {
    /// This function will set all the required properties, and then provide a preview for the document
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = "com.adobe.pdf"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }
    /// This function will store your document to some temporary URL and then provide sharing, copying, printing, saving options to the user
    func storeAndShare(withURLString: String) {
        guard let url = URL(string: withURLString) else { return }
        /// START YOUR ACTIVITY INDICATOR HERE
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "fileName.png")
            do {
                try data.write(to: tmpURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.share(url: tmpURL)
            }
            }.resume()
    }
}

extension ReportsViewController: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
