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
    @IBOutlet weak var universalProjMediaNotesLabel: UILabel!
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
    
    func configure(i: Int) {
        universalProjMediaHugeImageView.image = nil
        let universalItem: UniversalItem
        if MIProcessor.sharedMIP.mipORsip == 0 {
            universalItem = MIProcessor.sharedMIP.mIP[i] as! UniversalItem
        } else {
            universalItem = MIProcessor.sharedMIP.sIP[i] as! UniversalItem
        }
        if let timeStampAsDouble: Double = universalItem.timeStamp as? Double {
            let timeStampAsString = convertTimestamp(serverTimestamp: timeStampAsDouble)
            universalProjMediaDateLabel.text = timeStampAsString
        }
        universalProjMediaNotesLabel.text = universalItem.notes
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
        if universalItem.picUrl != "" {
            let downloadURL = URL(string: universalItem.picUrl)!
            downloadImage(url: downloadURL)
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    @IBOutlet weak var universalProjMediaHugeImageViewHeightConstraint: NSLayoutConstraint!
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                let image: UIImage = UIImage(data: data)!
                let aspectRatio = image.size.height / image.size.width
                let imageViewHeight = self.widthConstraint.constant * aspectRatio
                self.universalProjMediaHugeImageViewHeightConstraint.constant = imageViewHeight
                self.universalProjMediaHugeImageView.image = image
            }
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
