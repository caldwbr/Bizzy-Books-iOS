//
//  ProjectCardViewCollectionViewCell.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/16/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import KTCenterFlowLayout
import Firebase

class ProjectCardViewCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == projectCardViewCollectionView {
            return dataSource.items.count
        } else {
            return dataSourceTwo.items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == projectCardViewCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardViewSentenceCell", for: indexPath) as! CardViewSentenceCell
            cell.configure(labelFlowItem: dataSource.items[indexPath.row] as! LabelFlowItem)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardViewSentenceCell", for: indexPath) as! CardViewSentenceCell
            cell.configure(labelFlowItem: dataSourceTwo.items[indexPath.row] as! LabelFlowItem)
            return cell
        }
    }


    @IBOutlet weak var topCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var projectCardViewCollectionView: UICollectionView!
    @IBOutlet weak var projectCardViewCollectionViewTwo: UICollectionView!
    @IBOutlet weak var projectCardViewDateLabel: UILabel!
    @IBOutlet weak var projectCardViewJobNameLabel: UILabel!
    @IBOutlet weak var projectCardViewStatusLabel: UILabel!
    
    private var dataOne = [LabelFlowItem]()
    private var dataTwo = [LabelFlowItem]()
    private var dataSource = CardViewLabelFlowCollectionViewDataSource()
    private var dataSourceTwo = CardViewLabelFlowCollectionViewDataSourceTwo()
    let stringifyAnInt: StringifyAnInt = StringifyAnInt()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        if screenWidth > 374.0 {
            widthConstraint.constant = 350.0
        } else {
            widthConstraint.constant = screenWidth - (2 * 12)
        }
        projectCardViewCollectionView.collectionViewLayout = KTCenterFlowLayout()
        projectCardViewCollectionViewTwo.collectionViewLayout = KTCenterFlowLayout()
        
        projectCardViewCollectionView.register(UINib.init(nibName: "CardViewSentenceCell", bundle: nil), forCellWithReuseIdentifier: "CardViewSentenceCell")
        if let universalCardViewFlowLayout = projectCardViewCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            universalCardViewFlowLayout.estimatedItemSize = CGSize(width: 80, height: 30)
        }
        projectCardViewCollectionViewTwo.register(UINib.init(nibName: "CardViewSentenceCell", bundle: nil), forCellWithReuseIdentifier: "CardViewSentenceCell")
        if let universalCardViewFlowLayoutTwo = projectCardViewCollectionViewTwo.collectionViewLayout as? UICollectionViewFlowLayout {
            universalCardViewFlowLayoutTwo.estimatedItemSize = CGSize(width: 80, height: 30)
        }
        projectCardViewCollectionView.dataSource = self
        projectCardViewCollectionViewTwo.dataSource = self
    }
    
    func configure(i: Int) {
        if let projectItem = MIProcessor.sharedMIP.mIP[i] as? ProjectItem {
            if let timeStampAsDouble: Double = projectItem.timeStamp as? Double {
                let timeStampAsString = convertTimestamp(serverTimestamp: timeStampAsDouble)
                projectCardViewDateLabel.text = timeStampAsString
            }
            projectCardViewJobNameLabel.text = projectItem.name
            projectCardViewStatusLabel.text = projectItem.projectStatusName
            var forThisJob = ""
            var preparedAddress = ""
            if projectItem.projectAddressStreet == "" {
                forThisJob = "for this job"
            } else if projectItem.projectAddressCity == "" || projectItem.projectAddressState == "" {
                forThisJob = "for this job at"
                preparedAddress = projectItem.projectAddressStreet
            } else {
                forThisJob = "for this job at"
                preparedAddress = projectItem.projectAddressStreet + " (" + projectItem.projectAddressCity + ", " + projectItem.projectAddressState + ")"
            }
            /*
            dataOne.append(LabelFlowItem(text: projectItem.customerName, color: UIColor.BizzyColor.Blue.Who, action: nil))
            dataOne.append(LabelFlowItem(text: "heard of you", color: .gray, action: nil))
            dataOne.append(LabelFlowItem(text: projectItem.howDidTheyHearOfYouString, color: UIColor.BizzyColor.Green.What, action: nil))
            dataOne.append(LabelFlowItem(text: forThisJob, color: .gray, action: nil))
            dataOne.append(LabelFlowItem(text: preparedAddress, color: UIColor.BizzyColor.Magenta.PersonalReason, action: nil))
            dataOne.append(LabelFlowItem(text: "\n\n", color: .gray, action: nil))*/
            
            dataSource.items = [
                LabelFlowItem(text: projectItem.customerName, color: UIColor.BizzyColor.Blue.Who, action: nil),
                LabelFlowItem(text: "heard of you", color: .gray, action: nil),
                LabelFlowItem(text: projectItem.howDidTheyHearOfYouString, color: UIColor.BizzyColor.Green.What, action: nil),
                LabelFlowItem(text: forThisJob, color: .gray, action: nil),
                LabelFlowItem(text: preparedAddress, color: UIColor.BizzyColor.Magenta.PersonalReason, action: nil),
                LabelFlowItem(text: "\n\n", color: .gray, action: nil)
            ]
            projectCardViewCollectionView.reloadData()
            topCollectionViewHeightConstraint.constant = projectCardViewCollectionView.collectionViewLayout.collectionViewContentSize.height
            projectCardViewCollectionView.layoutIfNeeded()
            var runningGross = 0
            var runningExpensesLaborTotal = 0
            var runningExpensesLaborHasWC = 0
            var runningExpensesLaborIncursWC = 0
            var runningExpensesLaborWCNA = 0
            var runningExpensesMaterial = 0
            var runningExpensesTotal = 0
            var netProfit = 0
            var netMargin = 0
            for i in 0..<MIProcessor.sharedMIP.mIPUniversals.count {
                if MIProcessor.sharedMIP.mIPUniversals[i].projectItemKey == projectItem.key {
                    if MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId == 2 {
                        switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                        case 0:
                            switch MIProcessor.sharedMIP.mIPUniversals[i].workersCompId {
                            case 0:
                                runningExpensesLaborHasWC = runningExpensesLaborHasWC + MIProcessor.sharedMIP.mIPUniversals[i].what
                            case 1:
                                runningExpensesLaborIncursWC = runningExpensesLaborIncursWC + MIProcessor.sharedMIP.mIPUniversals[i].what
                            default: //I.e. case 2
                                runningExpensesLaborWCNA = runningExpensesLaborWCNA + MIProcessor.sharedMIP.mIPUniversals[i].what
                            }
                        default: //I.e. case 2
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
                    switch MIProcessor.sharedMIP.mIPUniversals[i].universalItemType {
                    case 0:
                        if MIProcessor.sharedMIP.trueYou == MIProcessor.sharedMIP.mIPUniversals[i].whoKey {
                            runningExpensesMaterial = runningExpensesMaterial + MIProcessor.sharedMIP.mIPUniversals[i].what
                        } else {
                            if MIProcessor.sharedMIP.mIPUniversals[i].taxReasonId == 0 {
                                runningGross = runningGross + MIProcessor.sharedMIP.mIPUniversals[i].what
                            } else {
                                runningExpensesMaterial = runningExpensesMaterial - MIProcessor.sharedMIP.mIPUniversals[i].what
                            }
                        }
                    default: //I.e. case 2.
                        if MIProcessor.sharedMIP.trueYou == MIProcessor.sharedMIP.mIPUniversals[i].whoKey {
                            runningExpensesMaterial = runningExpensesMaterial + Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what) * (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        } else {
                            runningExpensesMaterial = runningExpensesMaterial - Int(Double(MIProcessor.sharedMIP.mIPUniversals[i].what) * (Double(MIProcessor.sharedMIP.mIPUniversals[i].percentBusiness)/100))
                        }
                    }
                }
            }
            runningExpensesLaborTotal = runningExpensesLaborHasWC + runningExpensesLaborIncursWC + runningExpensesLaborWCNA
            runningExpensesTotal = runningExpensesMaterial + runningExpensesLaborTotal
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
            var labor = stringifyAnInt.stringify(theInt: runningExpensesLaborTotal)
            var laborSubHasWC = stringifyAnInt.stringify(theInt: runningExpensesLaborHasWC)
            var laborIncursWC = stringifyAnInt.stringify(theInt: runningExpensesLaborIncursWC)
            var laborWCNA = stringifyAnInt.stringify(theInt: runningExpensesLaborWCNA)
            var net = stringifyAnInt.stringify(theInt: netProfit)
            
            dataSourceTwo.items = [
                (LabelFlowItem(text: gross, color: UIColor.BizzyColor.Blue.Who, action: nil)),
                (LabelFlowItem(text: "grossed,", color: .gray, action: nil)),
                (LabelFlowItem(text: expenses, color: UIColor.BizzyColor.Green.Account, action: nil)),
                (LabelFlowItem(text: "expenses incurred, ", color: .gray, action: nil)),
                (LabelFlowItem(text: material, color: UIColor.BizzyColor.Green.What, action: nil)),
                (LabelFlowItem(text: "material and", color: .gray, action: nil)),
                (LabelFlowItem(text: labor, color: UIColor.BizzyColor.Green.What, action: nil)),
                (LabelFlowItem(text: "labor (sub had WC:", color: .gray, action: nil)),
                (LabelFlowItem(text: (laborSubHasWC + ","), color: UIColor.BizzyColor.Orange.WC, action: nil)),
                (LabelFlowItem(text: "incurred WC:", color: .gray, action: nil)),
                (LabelFlowItem(text: (laborIncursWC + ","), color: UIColor.BizzyColor.Orange.WC, action: nil)),
                (LabelFlowItem(text: "WC N/A:", color: .gray, action: nil)),
                (LabelFlowItem(text: laborWCNA, color: UIColor.BizzyColor.Orange.WC, action: nil)),
                (LabelFlowItem(text: "components), and", color: .gray, action: nil)),
                (LabelFlowItem(text: net, color: UIColor.BizzyColor.Purple.Whom, action: nil)),
                (LabelFlowItem(text: "netted, making a ", color: .gray, action: nil)),
                (LabelFlowItem(text: (margin + "%"), color: UIColor.BizzyColor.Magenta.PersonalReason, action: nil)),
                (LabelFlowItem(text: "margin", color: .gray, action: nil))
            ]
            projectCardViewCollectionViewTwo.reloadData()
            bottomCollectionViewHeightConstraint.constant = projectCardViewCollectionViewTwo.collectionViewLayout.collectionViewContentSize.height
            projectCardViewCollectionViewTwo.layoutIfNeeded()
            projectCardViewCollectionView.layoutIfNeeded()
            
        }
    }

    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy\nh:mma"
        return formatter.string(from: date as Date)
    }
    
}
