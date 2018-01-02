//
//  CustomImageView.swift
//  Bizzy Books
//
//  Created by Brad Caldwell on 1/1/18.
//  Copyright © 2018 Caldwell Contracting LLC. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()


class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    func loadImageUsingUrlString(_ urlString: String) {
        let url = URL(string: urlString)
        imageUrlString = urlString
        image = nil
        
        var widthConstraintConstant: CGFloat = 0
        let screenWidth = UIScreen.main.bounds.size.width
        if screenWidth > 374.0 {
            widthConstraintConstant = 350.0
        } else {
            widthConstraintConstant = screenWidth - (2 * 12)
        }
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!)
                return
                
            }
            
            DispatchQueue.main.async {
                
                let imageToCache = UIImage(data: data!)
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                
            }
            
            }.resume()
        
    }
}
