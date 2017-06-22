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
            LabelTextFieldFlowItem(text: "Hello", placeholder: "", color: .black, editable: false),
            LabelTextFieldFlowItem(text: "World", placeholder: "", color: .black, editable: false),
            LabelTextFieldFlowItem(text: "", placeholder: "This is editable", color: .black, editable: true),
            LabelTextFieldFlowItem(text: "! aslkdf as90d8f a9s8d faisd f0a9is df09as df09 ", placeholder: "", color: .black, editable: false),
            LabelTextFieldFlowItem(text: "", placeholder: "This is editable as well", color: .black, editable: true)
        ]
        
        collectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        
    }
    
    @IBOutlet weak var leftTopView: UIView!
    @IBOutlet weak var rightTopView: UIView!
    @IBOutlet weak var rightTopLabel: UILabel!
}
