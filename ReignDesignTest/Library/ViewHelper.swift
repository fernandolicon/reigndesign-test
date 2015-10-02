//
//  ViewHelper.swift
//  ReignDesignTest
//
//  Created by Luis Fernando Mata on 1/10/15.
//  Copyright © 2015 Luis Fernando Mata. All rights reserved.
//

import UIKit

class ViewHelper: NSObject {
    
    class func showMessageToUser(title: String, message: String, viewController: UIViewController){
        let alertView = UIAlertController (title: title, message: message, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "Ok", style: .Default, handler:nil)
        alertView.addAction(okButton)
        viewController.presentViewController(alertView, animated: true, completion:nil)
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
