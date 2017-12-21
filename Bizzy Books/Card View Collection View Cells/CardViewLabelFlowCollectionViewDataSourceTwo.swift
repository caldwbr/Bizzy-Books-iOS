//
//  CardViewLabelFlowCollectionViewDataSourceTwo.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 12/21/17.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit


class CardViewLabelFlowCollectionViewDataSourceTwo : NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var items = [FlowItem]()
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = items[indexPath.item]
        var cell : CardViewSentenceCell
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.cellIdentifier, for: indexPath) as! CardViewSentenceCell
        
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

