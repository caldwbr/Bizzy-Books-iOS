//
//  DropdownReusableView.swift
//  Bizzy Books
//
//  Created by Miroslav Kutak on 22/06/2017.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit

class DropdownReusableView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func configure(option: DropdownFlowItem.Option) {
        imageView.image = option.icon
        label.text = option.title
    }
    
    static func instantiateWithNib() -> DropdownReusableView {
        return UINib(nibName: "DropdownReusableView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DropdownReusableView
    }
    
}
