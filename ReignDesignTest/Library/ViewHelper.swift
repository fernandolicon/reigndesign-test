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
    
    class func calculateTimeFromCreation(entry: Entry) -> String{
        var difference = round(entry.getDateDifferenceFromToday())
        var intValue = Int(difference)
        
        //Firs calculate if time is less than 1 hour
        if difference < 1{
            return "<1m"
        }else if difference < 60{
            return "\(intValue)m"
        }else{
            //If difference is more than hour, transform the data to hours and check if it is less than 1 day
            difference = round(difference / 60)
            intValue = Int(difference)
            if difference < 1.5{
                return "1h"
            }else if difference < 2{
                return "1.5h"
            }else if difference < 24{
                return "\(intValue)h"
            }else{
                //If it's more than one day, then check if it was yesterday or other days ago
                difference = round(difference / 24)
                intValue = Int(difference)
                if difference < 2{
                    return "Yesterday"
                }else{
                    return "\(intValue) days ago"
                }
            }
        }
    }
}
