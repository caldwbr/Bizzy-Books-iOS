//
//  UniversalProjectMediaCardViewCollectionViewCell.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/20/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import Firebase

class UniversalProjectMediaCardViewCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var universalProjMediaStatusLabel: UILabel!
    @IBOutlet weak var universalProjMediaDateLabel: UILabel!
    @IBOutlet weak var universalProjMediaJobNameLabel: UILabel!
    @IBOutlet weak var universalProjMediaPicTypeLabel: UILabel!
    @IBOutlet weak var universalProjMediaHugeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        let screenWidth = UIScreen.main.bounds.size.width
        if screenWidth > 374.0 {
            widthConstraint.constant = 350.0
        } else {
            widthConstraint.constant = screenWidth - (2 * 12)
        }
    }
    
    func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {}
    
    func configure(_ multiversalItemViewModel: MultiversalItem) {
        if let universalItem = multiversalItemViewModel as? UniversalItem {
            if let timeStampAsDouble: Double = universalItem.timeStamp as? Double {
                let timeStampAsString = convertTimestamp(serverTimestamp: timeStampAsDouble)
                universalProjMediaDateLabel.text = timeStampAsString
            }
            universalProjMediaJobNameLabel.text = universalItem.projectItemName
            universalProjMediaPicTypeLabel.text = universalItem.projectPicTypeName
            DispatchQueue.main.async {
                //Get project status
                let projectsRef = Database.database().reference().child("users").child(userUID).child("projects")
                if universalItem.projectItemKey == "0" {
                    self.universalProjMediaStatusLabel.text = ""
                } else {
                    projectsRef.observe(.value) { (snapshot) in
                        for item in snapshot.children {
                            let firebaseProject = ProjectItem(snapshot: item as! DataSnapshot)
                            if firebaseProject.key == universalItem.projectItemKey {
                                self.universalProjMediaStatusLabel.text = firebaseProject.projectStatusName
                            }
                        }
                    }
                }
            }
        }
    }
    
    func convertTimestamp(serverTimestamp: Double) -> String {
        let x = serverTimestamp / 1000
        let date = NSDate(timeIntervalSince1970: x)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy\nh:mma"
        //formatter.dateStyle = .medium
        //formatter.timeStyle = .short
        
        return formatter.string(from: date as Date)
    }
    
}
