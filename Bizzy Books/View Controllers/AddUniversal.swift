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
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var percentBusinessLabel: UILabel!
    @IBAction func percentBusinessSlider(_ sender: UISlider) {
        let percent = sender.value.rounded().cleanValue
        let percentAsString = String(percent) + "%"
        percentBusinessLabel.text = percentAsString
    }
    @IBOutlet weak var amountBusinessLabel: UILabel!
    @IBOutlet weak var amountPersonalLabel: UILabel!
    @IBOutlet weak var percentBusinessView: UIView!
    
    //Visual Effects View
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    //Project Popup Items
    @IBOutlet var selectProjectView: UIView!
    @IBOutlet weak var projectSearchView: UIView!
    @IBOutlet weak var overheadSwitch: UISwitch!
    @IBAction func overheadSwitchTapped(_ sender: UISwitch) {
    }
    @IBOutlet weak var overheadQuestionImage: UIImageView!
    @IBOutlet weak var projectTextField: UITextField!
    @IBAction func projectAddButtonTapped(_ sender: UIButton) {
    }
    @IBAction func projectAcceptTapped(_ sender: UIButton) {
    }
    @IBAction func projectDismissTapped(_ sender: UIButton) {
        selectProjectAnimateOut()
        visualEffectView.isUserInteractionEnabled = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overheadSwitch.isOn = false
        visualEffectView.isHidden = true
        selectProjectView.layer.cornerRadius = 5
        
        let typeItem = DropdownFlowItem(options: [
            DropdownFlowItem.Option(title: "Business", iconName: "business", action: { self.selectedType = 0; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Personal", iconName: "personal", action: { self.selectedType = 1; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Mixed", iconName: "mixed", action: { self.selectedType = 2; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Fuel", iconName: "fuel", action: { self.selectedType = 3; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Transfer", iconName: "transfer", action: { self.selectedType = 4; self.reloadSentence(selectedType: self.selectedType) }),
            DropdownFlowItem.Option(title: "Adjustment", iconName: "adjustment", action: { self.selectedType = 5; self.reloadSentence(selectedType: self.selectedType) }),
            ])
        leftTopView.configure(item: typeItem)
        
        reloadSentence(selectedType: selectedType)
        
        //collectionView.collectionViewLayout = LeftAlignedCollectionViewFlowLayout()
        collectionView.collectionViewLayout = KTCenterFlowLayout()
        
        //Code below isn't working so I commented it out.
        /*
        var projectLabelGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap")
        self.projectLabel.addGestureRecognizer(projectLabelGestureRecognizer)
        */
        
    }
    
    func selectProjectAnimateIn() {
        self.view.addSubview(selectProjectView)
        selectProjectView.center = self.view.center
        selectProjectView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        selectProjectView.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.isHidden = false
            self.selectProjectView.alpha = 1
            self.selectProjectView.transform = CGAffineTransform.identity
        })
    }
    
    func selectProjectAnimateOut() {
        UIView.animate(withDuration: 0.4, animations: {
            self.selectProjectView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.selectProjectView.alpha = 0
            self.visualEffectView.isHidden = true
        }) { (success:Bool) in
            self.selectProjectView.removeFromSuperview()
        }
    }
    
    func handleTap(projectLabelGestureRecognizer: UITapGestureRecognizer){
        selectProjectAnimateIn()
        visualEffectView.isUserInteractionEnabled = true
    }
    
    func reloadCollectionView() {
        collectionView.delegate = dataSource
        collectionView.dataSource = dataSource
        collectionView.reloadData()
        
        // Resize the collection view's height according to it's contents
        view.layoutIfNeeded()
        collectionViewHeightConstraint.constant = collectionView.contentSize.height
        view.layoutIfNeeded()
    }
    
    func reloadSentence(selectedType: Int) {
        switch selectedType {
        case 0:
            dataSource.items = [
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { print("You tapped!!") }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { print("whom tapped!!") }),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                LabelFlowItem(text: "what tax reason ▾", color: UIColor.BizzyColor.Magenta.TaxReason, action: { print("what tax reason tapped!!") }),
                LabelFlowItem(text: "?", color: .gray, action: nil),
            ]
            projectLabel.isHidden = false
            odometerTextField.isHidden = true
            percentBusinessView.isHidden = true
            accountLabel.isHidden = false
            reloadCollectionView()
        case 1:
            dataSource.items = [
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { print("You tapped!!") }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { print("whom tapped!!") }),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                LabelFlowItem(text: "what personal reason ▾", color: UIColor.BizzyColor.Magenta.PersonalReason, action: { print("what personal reason tapped!!") }),
                LabelFlowItem(text: "?", color: .gray, action: nil),
            ]
            projectLabel.isHidden = true
            odometerTextField.isHidden = true
            percentBusinessView.isHidden = true
            accountLabel.isHidden = false
            reloadCollectionView()
        case 2:
            dataSource.items = [
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { print("You tapped!!") }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { print("whom tapped!!") }),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                LabelFlowItem(text: "what tax reason ▾", color: UIColor.BizzyColor.Magenta.TaxReason, action: { print("what tax reason tapped!!") }),
                LabelFlowItem(text: "and", color: .gray, action: nil),
                LabelFlowItem(text: "what personal reason ▾", color: UIColor.BizzyColor.Magenta.PersonalReason, action: { print("what personal reason tapped!!") }),
                LabelFlowItem(text: "?", color: .gray, action: nil),
            ]
            projectLabel.isHidden = false
            odometerTextField.isHidden = true
            percentBusinessView.isHidden = false
            accountLabel.isHidden = false
            reloadCollectionView()
        case 3:
            dataSource.items = [
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { print("You tapped!!") }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { print("whom (gas station) tapped!!") }),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "how many", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "gallons of", color: .gray, action: nil),
                LabelFlowItem(text: "87 gas ▾", color: UIColor.BizzyColor.Orange.WC, action: { print("fuel tapped!!") }),
                LabelFlowItem(text: "in your", color: .gray, action: nil),
                LabelFlowItem(text: "vehicle ▾", color: UIColor.BizzyColor.Magenta.TaxReason, action: { print("vehicle tapped!!") }),
                LabelFlowItem(text: "?", color: .gray, action: nil),
            ]
            projectLabel.isHidden = true
            odometerTextField.isHidden = false
            percentBusinessView.isHidden = true
            accountLabel.isHidden = false
            reloadCollectionView()
        case 4:
            dataSource.items = [
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: nil),
                LabelFlowItem(text: "moved", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "from", color: .gray, action: nil),
                LabelFlowItem(text: "which account ▾", color: UIColor.BizzyColor.Green.Account, action: { print("from which account tapped!!") }),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "which account ▾", color: UIColor.BizzyColor.Green.Account, action: { print("to which account tapped!!") }),
                LabelFlowItem(text: "as a", color: .gray, action: nil),
                LabelFlowItem(text: "what ▾", color: UIColor.BizzyColor.Magenta.PersonalReason, action: { print("what move money tapped!!") }),
                LabelFlowItem(text: "?", color: .gray, action: nil),
            ]
            projectLabel.isHidden = true
            odometerTextField.isHidden = true
            percentBusinessView.isHidden = true
            accountLabel.isHidden = true
            reloadCollectionView()
        case 5:
            dataSource.items = [
                LabelFlowItem(text: "My account ▾", color: UIColor.BizzyColor.Green.Account, action: { print("My account tapped!!") }),
                LabelFlowItem(text: "with a Bizzy Books balance of", color: .gray, action: nil),
                LabelFlowItem(text: "$0.00", color: UIColor.BizzyColor.Green.Account, action: nil),
                LabelFlowItem(text: "should have a balance of", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: ".", color: .gray, action: nil),
            ]
            projectLabel.isHidden = true
            odometerTextField.isHidden = true
            percentBusinessView.isHidden = true
            accountLabel.isHidden = true
            reloadCollectionView()
        default:
            dataSource.items = [
                LabelFlowItem(text: "You", color: UIColor.BizzyColor.Blue.Who, action: { print("You tapped!!") }),
                LabelFlowItem(text: "paid", color: .gray, action: nil),
                TextFieldFlowItem(text: "", placeholder: "what amount", color: UIColor.BizzyColor.Green.What),
                LabelFlowItem(text: "to", color: .gray, action: nil),
                LabelFlowItem(text: "whom ▾", color: UIColor.BizzyColor.Purple.Whom, action: { print("whom tapped!!") }),
                LabelFlowItem(text: "for", color: .gray, action: nil),
                LabelFlowItem(text: "what tax reason ▾", color: UIColor.BizzyColor.Magenta.TaxReason, action: { print("what tax reason tapped!!") }),
                LabelFlowItem(text: "?", color: .gray, action: nil),
            ]
            projectLabel.isHidden = false
            odometerTextField.isHidden = true
            percentBusinessView.isHidden = true
            accountLabel.isHidden = false
            reloadCollectionView()
        }
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        selectProjectAnimateIn()
        visualEffectView.isUserInteractionEnabled = true
    }

    
}
