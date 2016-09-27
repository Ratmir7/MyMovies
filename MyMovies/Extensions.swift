//
//  Helpers.swift
//  MyMovies
//
//  Created by Ratmir Naumov on 19.09.16.
//  Copyright © 2016 Ratmir Naumov. All rights reserved.
//

import UIKit

extension UIViewController {
    func checkForNetworkError(error: NSError?) -> Bool {
        if let error = error {
            print(error)
            let alertController = UIAlertController(title: "Network Error", message: "Check network connection. Can't connect to MovieDatabase.", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            presentViewController(alertController, animated: true, completion: nil)
            return true
        }
        return false
    }
}

extension UILabel {
    class func headerLabel() -> UILabel{
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(14)
        label.numberOfLines = 0
        label.textAlignment = .Left
        label.textColor = UIColor.grayColor()
        label.backgroundColor = UIColor(red: 211/255.0, green: 211/255.0, blue: 211/255.0, alpha: 0.3)
        return label
    }
}

extension UIImage {
    func scaleToSize(aSize :CGSize) -> UIImage {
        if (CGSizeEqualToSize(self.size, aSize)) {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(aSize, false, 0.0)
        self.drawInRect(CGRectMake(0.0, 0.0, aSize.width, aSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func scaleToScreenSize() -> UIImage {
        let currentHeight = size.height
        let currentWidth = size.width
        let resizedWidth = UIScreen.mainScreen().bounds.width
        guard currentWidth != 0 else { return self }
        let resizedHeight = (resizedWidth * currentHeight) / currentWidth
        let aSize = CGSize(width: resizedWidth, height: resizedHeight)
        
        if (CGSizeEqualToSize(self.size, aSize)) {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(aSize, false, 0.0)
        self.drawInRect(CGRectMake(0.0, 0.0, aSize.width, aSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
