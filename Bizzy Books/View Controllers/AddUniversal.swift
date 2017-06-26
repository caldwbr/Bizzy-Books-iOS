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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var leftTopView: DropdownFlowView!
    @IBOutlet weak var rightTopView: UIView!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var odometerTextField: UITextField!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.items = [
            /*
            DropdownFlowItem(options: [
                DropdownFlowItem.Option(title: "Business", iconName: "business"),
                ]),
            LabelFlowItem(text: "Project ▾", color: .blue, action: { print("Project ▾ tapped!!") }),
            TextFieldFlowItem(text: "", placeholder: "Notes?", color: .black),
            */
            
            LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { print("You tapped!!") }),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            
            TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            
            LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { print("whom tapped!!") }),
            LabelFlowItem(text: "for", color: .gray, action: nil),
            
            /*
            LabelFlowItem(text: "what tax reason ▾", color: .magenta, action: { print("what tax reason tapped!!") }),
            DropdownFlowItem(options: [
                DropdownFlowItem.Option(title: "Debit\nCard", iconName: "debit_card"),
                ]),
            LabelFlowItem(text: "Account ▾", color: .blue, action: { print("Account ▾ tapped!!") }),
 */
            
            LabelFlowItem(text: "what tax reason ▾", color: UIColor.BizzyColor.Magenta.Reason, action: { print("what tax reason tapped!!") })
        ]
        
        //collectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        collectionView.collectionViewLayout = KTCenterFlowLayout()
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.reloadData()
        
        // Resize the collection view's height according to it's contents
        view.layoutIfNeeded()
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
        view.layoutIfNeeded()
        
        let typeItem = DropdownFlowItem(options: [
            DropdownFlowItem.Option(title: "Business", iconName: "business", action: { print("Business tapped!!") }),
            DropdownFlowItem.Option(title: "Personal", iconName: "personal", action: { print("Personal tapped!!") }),
            DropdownFlowItem.Option(title: "Mixed", iconName: "mixed", action: { print("Mixed tapped!!") }),
            ])
        leftTopView.configure(item: typeItem)
    }
    
}
