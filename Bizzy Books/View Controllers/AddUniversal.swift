//
//  AddUniversal.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/16/16.
//  Copyright © 2016 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import UIKit
import KTCenterFlowLayout

class AddUniversal: UIViewController {
    
    private let dataSource = LabelTextFieldFlowCollectionViewDataSource()
    private var selectedType = 0
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var leftTopView: DropdownFlowView!
    @IBOutlet weak var rightTopView: UIView!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var odometerTextField: UITextField!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let typeItem = DropdownFlowItem(options: [
            DropdownFlowItem.Option(title: "Business", iconName: "business", action: { self.selectedType = 0 }),
            DropdownFlowItem.Option(title: "Personal", iconName: "personal", action: { self.selectedType = 1 }),
            DropdownFlowItem.Option(title: "Mixed", iconName: "mixed", action: { self.selectedType = 2 }),
            DropdownFlowItem.Option(title: "Fuel", iconName: "fuel", action: { self.selectedType = 3 }),
            DropdownFlowItem.Option(title: "Transfer", iconName: "transfer", action: { self.selectedType = 4 }),
            DropdownFlowItem.Option(title: "Adjustment", iconName: "adjustment", action: { self.selectedType = 5 }),
            ])
        leftTopView.configure(item: typeItem)
        
        switch selectedType {
        case 0:
            dataSource.items = [
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { print("You tapped!!") }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { print("whom tapped!!") }),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                LabelFlowItem(text: "what tax reason ▾", color: UIColor.BizzyColor.Magenta.Reason, action: { print("what tax reason tapped!!") })
            ]
        case 1:
            dataSource.items = [
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { print("You tapped!!") }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { print("whom tapped!!") }),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                LabelFlowItem(text: "what personal reason ▾", color: UIColor.BizzyColor.Magenta.Reason, action: { print("what personal reason tapped!!") })
            ]
        default:
            dataSource.items = [
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { print("You tapped!!") }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { print("whom tapped!!") }),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                LabelFlowItem(text: "what tax reason ▾", color: UIColor.BizzyColor.Magenta.Reason, action: { print("what tax reason tapped!!") })
            ]
        }
        
        //collectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        collectionView.collectionViewLayout = KTCenterFlowLayout()
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.reloadData()
        
        // Resize the collection view's height according to it's contents
        view.layoutIfNeeded()
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
        view.layoutIfNeeded()
        
    }
    
   
    
}
