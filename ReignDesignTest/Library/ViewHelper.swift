//
//  ViewHelper.swift
//  ReignDesignTest
//
//  Created by Luis Fernando Mata on 1/10/15.
//  Copyright © 2015 Luis Fernando Mata. All rights reserved.
//

import UIKit
import MediumProgressView

class ViewHelper: NSObject {
    
    class func showMessageToUser(title: String, message: String, viewController: UIViewController){
        let alertView = UIAlertController (title: title, message: message, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "Ok", style: .Default, handler:nil)
        alertView.addAction(okButton)
        viewController.presentViewController(alertView, animated: true, completion:nil)
    }
    
    class func createProgressView() -> MediumProgressViewManager{
        let mediumProgressViewManager = MediumProgressViewManager.sharedInstance
        mediumProgressViewManager.position = .Top // Default is top.
        mediumProgressViewManager.color = UIColor(red: 83/255, green: 83/255, blue: 83/255, alpha: 1.0)
        // Default is UIColor(red:0.33, green:0.83, blue:0.44, alpha:1).
        mediumProgressViewManager.height   = 4.0 // Default is 4.0.
        mediumProgressViewManager.isLeftToRight = true
        mediumProgressViewManager.duration = 1.0  // Default is 1.2.
        
        return mediumProgressViewManager
    }
}
