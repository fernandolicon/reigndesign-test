//
//  Entry.swift
//  ReignDesignTest
//
//  Created by Luis Fernando Mata on 30/9/15.
//  Copyright © 2015 Luis Fernando Mata. All rights reserved.
//

import UIKit
import RealmSwift

class Entry: Object {
    dynamic var title = ""
    dynamic var author = ""
    dynamic var createdAt = NSDate()
    dynamic var entryUrl = ""
    
    func saveEntryWithDictionary(entryDictionary : NSDictionary){
        //Title value can be only one of two different keys from the dictionary, so we need to check which one of them
        self.title = entryDictionary.objectForKey("story_title") as? String ?? entryDictionary.objectForKey("title") as! String
        //Check if URL is a valid object (as it can bee null)
        if (entryDictionary.objectForKey("story_url") as? String != nil || entryDictionary.objectForKey("url") as? String != nil){
                self.entryUrl = entryDictionary.objectForKey("story_url") as? String ?? entryDictionary.objectForKey("url") as! String
        }
        
        self.author = entryDictionary.objectForKey("author") as! String
        
        //We need to transform the created_at string to a NSDate
        let dateString = entryDictionary.objectForKey("created_at") as! String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"
        formatter.timeZone = NSTimeZone(name: "UTC")
        self.createdAt = formatter.dateFromString(dateString)!
        let realm = try! Realm()
        
        realm.write { () -> Void in
            realm.add(self)
        }
    }
    
    func getDateDifferenceFromToday() -> NSTimeInterval{
        //Get current time and the interval between that and createdAt
        let todayDate = NSDate()
        var timeSinceCreated = todayDate.timeIntervalSinceDate(self.createdAt)
        //Transform time interval to minutes
        timeSinceCreated = timeSinceCreated / 60000
        return timeSinceCreated;
    }
    
    class func deleteAllEntries(){
        let realm = try! Realm()
        realm.deleteAll()
    }
}
