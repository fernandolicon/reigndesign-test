//
//  RequestHelper.swift
//  ReignDesignTest
//
//  Created by Luis Fernando Mata on 30/9/15.
//  Copyright © 2015 Luis Fernando Mata. All rights reserved.
//

import UIKit
import Alamofire
import ReachabilitySwift

class RequestHelper: NSObject {
    
    let reachability = Reachability.reachabilityForInternetConnection()
    var isNetworkAvailable = true
    
    func getNewsByDate(success: () -> Void, failure: () -> Void){
        //First check if  network is reachable
        if isNetworkAvailable {
            Alamofire.request(.GET, GlobalConstants.ServerAddress.address)
                .responseJSON { response in
                    //Get the response
                    let responseDictionary = response.2.value as! NSDictionary
                    let entriesDictionary = responseDictionary.objectForKey("hits") as? NSArray
                    
                    //Now we need to check if the response data is what we expected, if not, send error to user
                    if entriesDictionary != nil{
                        //Delete all previous saved entries
                        Entry.deleteAllEntries()
                        //After that, get all the entries returned by the server
                        
                        //Iterate over the dictionary to create all the entries
                        for entryDictionary in entriesDictionary!{
                            let entry = Entry()
                            entry.saveEntryWithDictionary(entryDictionary as! NSDictionary)
                        }
                        success()
                    }else{
                        failure()
                    }
            }
        }else{
            failure()
        }
    }
    
    func startNetworkNotifier(){
        //This function would be periodically checking if network is available
        self.isNetworkAvailable = reachability!.isReachable()
        
        reachability!.whenReachable = { reachability in
            self.isNetworkAvailable = true
        }
        reachability!.whenUnreachable = { reachability in
            self.isNetworkAvailable = false
        }
        
        reachability!.startNotifier()
    }
}
