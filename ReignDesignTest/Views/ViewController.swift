//
//  ViewController.swift
//  ReignDesignTest
//
//  Created by Luis Fernando Mata on 30/9/15.
//  Copyright © 2015 Luis Fernando Mata. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var entriesArray = try! Realm().objects(Entry)
    let requestHelper = RequestHelper()
    @IBOutlet weak var entriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        requestHelper.startNetworkNotifier()
        self.requestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: - Data methods
    
    func requestData(){
        requestHelper.getNewsByDate({ () -> Void in
            self.savedDataFromServer()
            }) { () -> Void in
                //If there was an error, notify the user and keep data
                dispatch_async(dispatch_get_main_queue()) {
                    self.showErrorToUser("Network error", message: "There's no internet connection, please try again later.")
                }
        }
    }
    
    func savedDataFromServer(){
        entriesArray = try! Realm().objects(Entry)
        entriesTableView.reloadData()
    }
    
    func showErrorToUser(withTitle: String, message: String){
        let alertView = UIAlertController (title: title, message: message, preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "Ok", style: .Default, handler:nil)
        alertView.addAction(okButton)
        self.presentViewController(alertView, animated: true, completion:nil)
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entriesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("entryCell") as UITableViewCell!
        
        let provisionalEntry = entriesArray[indexPath.row] as Entry
        cell.textLabel!.text = provisionalEntry.title
        
        return cell
    }
    
    // MARK:  Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let selectedEntry = entriesArray[indexPath.row] as Entry
        let entryUrl = selectedEntry.entryUrl
        
        //First we check if the user has a valid network connection
        if requestHelper.isNetworkAvailable{
            //After that we need to check if the selected entry has a valid url (as some of them can be null
            if entryUrl != ""{
                
            }else{
                showErrorToUser("No webpage", message: "The entry you selected doesn't have a valid webpage.")
            }
        }else{
            self.showErrorToUser("Network error", message: "There's no internet connection, please try again later.")
        }
    }
}

