//
//  ReportsViewController.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 1/1/18.
//  Copyright © 2018 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import SimplePDF

class ReportsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reportViewYearPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reportViewYearPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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

    let yearTimes = [1514786400000, 1546322400000, 1577858400000, 1609480800000, 1641016800000, 1672552800000, 1704088800000, 1735711200000, 1767247200000, 1798783200000, 1830319200000, 1861941600000, 1893477600000, 1925013600000, 1956549600000, 1988172000000, 2019708000000, 2051244000000, 2082780000000, 2114402400000, 2145938400000, 2177474400000, 2209010400000, 2240632800000]
    // Values above taken from http://www.unixtimestampconverter.com/
    var givenYearBeginning = 1514786400000 //Jan 1 2018
    var givenYearEnd = 1546322400000 //Jan 1 2019
    @IBOutlet weak var reportViewYearPicker: UIPickerView!
    var reportViewYearPickerData: [String] = [String]()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportViewYearPickerData = ["2018", "2019", "2020", "2021", "2022", "2023", "2024", "2025", "2026", "2027", "2028", "2029", "2030", "2031", "2032", "2033", "2034", "2035", "2036", "2037", "2038", "2039", "2040"]
        reportViewYearPicker.dataSource = self
        reportViewYearPicker.delegate = self
        reportViewYearPicker.selectRow(0, inComponent: 0, animated: false)
        calculateReports()
    }
    
    func clearTheFields() {
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
    }
    
    func calculateReports() {
        clearTheFields()
        for i in 0..<MIProcessor.sharedMIP.mIPUniversals.count where (MIProcessor.sharedMIP.mIPUniversals[i].timeStamp as! Int) < givenYearEnd && (MIProcessor.sharedMIP.mIPUniversals[i].timeStamp as! Int) > givenYearBeginning {
            switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
            case 0:
                switch MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId {
                case 0:
                    income += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 1:
                    supplies += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 2:
                    labor += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 3:
                    meals += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 4:
                    office += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 5:
                    vehicle += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 6:
                    adv += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 7:
                    proHelp += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 8:
                    machineRent += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 9:
                    taxAndLic += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 10:
                    insGLAndWC += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 11:
                    travel += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 12:
                    empBen += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 13:
                    depreciation += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 14:
                    depletion += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 15:
                    utilities += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 16:
                    commissions += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 17:
                    wages += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 18:
                    mortInterest += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 19:
                    otherInterest += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 20:
                    pension += MIProcessor.sharedMIP.mIPUniversals[i].what
                case 21:
                    repairs += MIProcessor.sharedMIP.mIPUniversals[i].what
                default:
                    print("No such useful item")
                }
            default:
                print("No such business item")
            }
            
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
        
        //let A4paperSize = CGSize(width: 595, height: 842)
        //let pdf = SimplePDF(pageSize: A4paperSize)
        
        //pdf.addText("Hello World! Income: " + String(income))
        // or
        // pdf.addText("Hello World!", font: myFont, textColor: myTextColor)
        
        //pdf.addImage(SOME IMAGE)
        
        //let dataArray = [["Test1", "Test2"],["Test3", "Test4"]]
        //pdf.addTable(rowCount: 2, columnCount: 2, rowHeight: 20.0, columnWidth: 30.0, tableLineWidth: 1.0, font: UIFont.systemFontOfSize(5.0), dataArray: dataArray)
        
        //let pdfData = pdf.generatePDFdata()
        
        // save as a local file
        //try? pdfData.writeToFile(path, options: .DataWritingAtomic)
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
