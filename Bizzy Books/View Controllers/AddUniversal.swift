//
//  AddUniversal.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 11/16/16.
//  Copyright © 2016 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import UIKit

class AddUniversal: UIViewController {
    
    private let dataSource = LabelTextFieldFlowCollectionViewDataSource()
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.items = [
            
            DropdownFlowItem(options: [
                DropdownFlowItem.Option(title: "Business", iconName: "business"),
                ]),
            LabelFlowItem(text: "Project ▾", color: .blue, action: { print("Project ▾ tapped!!") }),
            TextFieldFlowItem(text: "", placeholder: "Notes?", color: .black),
            
            LabelFlowItem(text: "Caldwell Contracting", color: .blue, action: { print("Caldwell Contracting tapped!!") }),
            LabelFlowItem(text: "paid", color: .gray, action: nil),
            
            TextFieldFlowItem(text: "", placeholder: "What amount?", color: .green),
            LabelFlowItem(text: "to", color: .gray, action: nil),
            
            LabelFlowItem(text: "whom ▾", color: .black, action: { print("whom tapped!!") }),
            LabelFlowItem(text: "for", color: .gray, action: nil),
            LabelFlowItem(text: "what tax reason ▾", color: .magenta, action: { print("what tax reason tapped!!") }),
            
            
            DropdownFlowItem(options: [
                DropdownFlowItem.Option(title: "Debit\nCard", iconName: "debit_card"),
                ]),
            LabelFlowItem(text: "Account ▾", color: .blue, action: { print("Account ▾ tapped!!") }),
        ]
        
        collectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        
    }
    
    @IBOutlet weak var leftTopView: UIView!
    @IBOutlet weak var rightTopView: UIView!
    @IBOutlet weak var rightTopLabel: UILabel!
}
