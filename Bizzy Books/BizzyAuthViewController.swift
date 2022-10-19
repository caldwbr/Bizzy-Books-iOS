    //
    //  BizzyAuthViewController.swift
    //  Bizzy Books
    //
    //  Created by Brad Caldwell on 10/11/16.
    //  Copyright © 2016 Caldwell Contracting LLC. All rights reserved.
    //

    import UIKit
    import FirebaseUI

    class BizzyAuthViewController: FUIAuthPickerViewController {
        
        
        override init(nibName: String?, bundle: Bundle?, authUI: FUIAuth) {
            super.init(nibName: "FUIAuthPickerViewController", bundle: bundle, authUI: authUI)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            
            let width = UIScreen.main.bounds.size.width
            let height = UIScreen.main.bounds.size.height
            
            let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            imageViewBackground.image = UIImage(named: "beesBackground")
            
            // you can change the content mode:
            imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
            
            view.insertSubview(imageViewBackground, at: 0)
     
        }

    }
