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
    
    func configure(_ multiversalItemViewModel: MultiversalItem) {
        if let projectItem = multiversalItemViewModel as? ProjectItem {
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
            dataSourceTwo.items = [(LabelFlowItem(text: projectItem.key, color: .gray, action: nil))]
            projectCardViewCollectionViewTwo.reloadData()
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
