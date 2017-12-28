//
//  DropdownFlowView.swift
//  Bizzy Books
//
//  Created by Miroslav Kutak on 27/06/2017.
//  Copyright © 2017 Caldwell Contracting LLC. All rights reserved.
//

import UIKit
import MKDropdownMenu

class DropdownFlowView: UIView, FlowItemConfigurable, MKDropdownMenuDataSource, MKDropdownMenuDelegate {
    
    @IBOutlet weak var dropDownMenu: MKDropdownMenu!
    private var item : DropdownFlowItem?
    private var selectedRow = 0
    private var viewForComponent : DropdownReusableView?
    
    func configure(item: FlowItem) {
        selectedRow = 0
        self.item = item as? DropdownFlowItem
        dropDownMenu.reloadAllComponents()
    }
    
    // MARK: - MKDropdownMenuDataSource
    
    func numberOfComponents(in dropdownMenu: MKDropdownMenu) -> Int {
        return 1
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, numberOfRowsInComponent component: Int) -> Int {
        return item?.options.count ?? 0
    }
    
    // MARK: - MKDropdownMenuDelegate
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
        
        // Perform the selected option's action (if there is such)
        if let action = item?.options[row].action {
            action()
        }
        
        dropdownMenu.reloadAllComponents()
        dropdownMenu.closeAllComponents(animated: true)
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let option = item?.options[row] {
            let view = view as? DropdownReusableView ?? DropdownReusableView.instantiateWithNib()
            view.configure(option: option)
            return view
        }
        // No view found or could be created
        return view ?? UIView()
    }
    
    func dropdownMenu(_ dropdownMenu: MKDropdownMenu, viewForComponent component: Int) -> UIView {
        if let option = item?.options[selectedRow] {
            let view = viewForComponent ?? DropdownReusableView.instantiateWithNib()
            view.configure(option: option)
            return view
        }
        
        return UIView()
    }
    
    func setTheProgrammaticallySelectedRow(i: Int) {
        selectedRow = i
        dropDownMenu.reloadAllComponents()
    }
}

