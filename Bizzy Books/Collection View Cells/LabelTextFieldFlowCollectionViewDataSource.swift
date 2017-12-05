//
//  LabelTextFieldFlowCollectionViewDataSource.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 6/22/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import Foundation
import UIKit


class LabelTextFieldFlowCollectionViewDataSource : NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var items = [FlowItem]()
    var theTextFieldYes = UITextField()
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = items[indexPath.item]
        var cell : UICollectionViewCell

        cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.cellIdentifier, for: indexPath)
        if item.cellIdentifier == "TextFieldCollectionViewCell" {
            print("1")
            let theCell = cell as? TextFieldCollectionViewCell
            print("2")
            theTextFieldYes = (theCell?.textField as AllowedCharsTextField!)
            //print(theTextFieldYes.amt)
            /*if let c = cell as? FlowItemConfigurable {
                theTextFieldYes.addTarget(self, action: { c.update(item: item) }, for: UIControlEvents.editingChanged)
            }*/
            
        }

        
        if let c = cell as? FlowItemConfigurable {
            c.configure(item: item)
        }
        
        return cell
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return items[indexPath.item].displaySize
    }
    
}
