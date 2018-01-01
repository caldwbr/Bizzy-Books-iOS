//
//  UniversalTransferCardViewCollectionViewCell.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/20/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import Firebase

class UniversalTransferCardViewCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var universalTransferImageView: UIImageView!
    @IBOutlet weak var universalTransferDateLabel: UILabel!
    @IBOutlet weak var universalTransferNotesLabel: UILabel!
    @IBOutlet weak var universalTransferAmountLabel: UILabel!
    @IBOutlet weak var universalTransferFromBankImageView: UIImageView!
    @IBOutlet weak var universalTransferFromBankLabel: UILabel!
    @IBOutlet weak var universalTransferFromBankBalAfterLabel: UILabel!
    @IBOutlet weak var universalTransferToBankImageView: UIImageView!
    @IBOutlet weak var universalTransferToBankLabel: UILabel!
    @IBOutlet weak var universalTransferToBankBalAfterLabel: UILabel!
    @IBOutlet weak var universalTransferMainImageView: UIImageView!
    
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
        universalTransferImageView.image = nil
        universalTransferFromBankImageView.image = nil
        universalTransferToBankImageView.image = nil
        universalTransferMainImageView.image = nil
        if let universalItem = MIProcessor.sharedMIP.mIP[i] as? UniversalItem {
            universalTransferNotesLabel.text = universalItem.notes
            if let timeStampAsDouble: Double = universalItem.timeStamp as? Double {
                let timeStampAsString = convertTimestamp(serverTimestamp: timeStampAsDouble)
                universalTransferDateLabel.text = timeStampAsString
            }
            let stringifyAnInt = StringifyAnInt()
            let amtTransferred = stringifyAnInt.stringify(theInt: universalItem.what) + " moved"
            universalTransferAmountLabel.text = amtTransferred
            updateAccountImages(universalItem: universalItem)
            universalTransferFromBankLabel.text = universalItem.accountOneName
            universalTransferToBankLabel.text = universalItem.accountTwoName
            universalTransferFromBankBalAfterLabel.text = universalItem.balOneAfterString
            universalTransferToBankBalAfterLabel.text = universalItem.balTwoAfterString
            if universalItem.picUrl != "" {
                let downloadURL = URL(string: universalItem.picUrl)!
                downloadImage(url: downloadURL)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    @IBOutlet weak var universalTransferMainImageViewHeightConstraint: NSLayoutConstraint!
    
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
                self.universalTransferMainImageViewHeightConstraint.constant = imageViewHeight
                self.universalTransferMainImageView.image = image
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
    
    func updateAccountImages(universalItem: UniversalItem) {
        switch universalItem.accountOneType {
        case 0:
            universalTransferFromBankImageView.image = UIImage(named: "bank")
        case 1:
            universalTransferFromBankImageView.image = UIImage(named: "credit")
        case 2:
            universalTransferFromBankImageView.image = UIImage(named: "cash")
        case 3:
            universalTransferFromBankImageView.image = UIImage(named: "storecredit")
        default:
            universalTransferFromBankImageView.image = UIImage(named: "bank")
        }
        switch universalItem.accountTwoType {
        case 0:
            universalTransferToBankImageView.image = UIImage(named: "bank")
        case 1:
            universalTransferToBankImageView.image = UIImage(named: "credit")
        case 2:
            universalTransferToBankImageView.image = UIImage(named: "cash")
        case 3:
            universalTransferToBankImageView.image = UIImage(named: "storecredit")
        default:
            universalTransferToBankImageView.image = UIImage(named: "bank")
        }
    }
    
}
