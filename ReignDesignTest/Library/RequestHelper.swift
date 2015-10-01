//
//  RequestHelper.swift
//  ReignDesignTest
//
//  Created by Luis Fernando Mata on 30/9/15.
//  Copyright © 2015 Luis Fernando Mata. All rights reserved.
//

import UIKit
import Alamofire

class RequestHelper: NSObject {
    
    class func getNewsByDate(completion: () -> Void ){
        
        Alamofire.request(.GET, GlobalConstants.ServerAddress.address)
            .responseJSON { response in
                //Delete all previous saved entries
                Entry .deleteAllEntries()
                //Now get the response
                let responseDictionary = response.2.value as! NSDictionary
                //After that, get all the entries returned by the server
                let entriesDictionary = responseDictionary.objectForKey("hits") as! NSArray
                
                //Iterate over the dictionary to create all the entries
                for entryDictionary in entriesDictionary{
                    let entry = Entry()
                    entry.saveEntryWithDictionary(entryDictionary as! NSDictionary)
                }
                
                completion()
        }
    }
}
