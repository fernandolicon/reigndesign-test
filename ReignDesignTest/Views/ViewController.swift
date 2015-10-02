//
//  ViewController.swift
//  ReignDesignTest
//
//  Created by Luis Fernando Mata on 30/9/15.
//  Copyright © 2015 Luis Fernando Mata. All rights reserved.
//

import UIKit
import PullToRefreshSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var entriesArray = Entry.getAllEntries()
    var userSelectedEntry = Entry()
    let requestHelper = RequestHelper()
    @IBOutlet weak var entriesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        entriesTableView.rowHeight = UITableViewAutomaticDimension
        
        self.addPullToRefreshToTable()
        
        //Start checking if user has an available internet connection
        requestHelper.startNetworkNotifier()
        
        self.requestData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        //progressView.hide()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Data methods
    
    func requestData(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        //Make server request
        requestHelper.getNewsByDate({ () -> Void in
            self.savedDataFromServer()
            }) { () -> Void in
                self.receivedErrorFromServer()
        }
    }
    
    func savedDataFromServer(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        //If the connection was successful then get all data from database and reload table
        entriesArray = Entry.getAllEntries()
        entriesTableView.reloadData()
    }
    
    func receivedErrorFromServer(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        //If there was an error, notify the user and keep local data
        ViewHelper.showMessageToUser("Network error", message: "There's no internet connection, please try again later.", viewController: self)
    }
    
    func addPullToRefreshToTable(){
        entriesTableView.addPullToRefresh({ [weak self] in
            // refresh code
            self?.requestData()
            })
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
        //We will make this so cell adjusts to title length
        cell.textLabel?.lineBreakMode = .ByWordWrapping
        cell.textLabel?.numberOfLines = 0
        
        let provisionalEntry = entriesArray[indexPath.row] as Entry
        cell.textLabel!.text = provisionalEntry.title
        //Get detail string, author and time since it was posted
        let detailString = "\(provisionalEntry.author) - \(ViewHelper.calculateTimeFromCreation(provisionalEntry))"
        cell.detailTextLabel!.text = detailString
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
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
                userSelectedEntry = entriesArray[indexPath.row] as Entry
                self.performSegueWithIdentifier("showEntry", sender: self)
            }else{
                ViewHelper.showMessageToUser("No webpage", message: "The entry you selected doesn't have a valid webpage.", viewController: self)
            }
        }else{
            ViewHelper.showMessageToUser("Network error", message: "There's no internet connection, please try again later.", viewController: self)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true;
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //Delete object from list and database
        if editingStyle == .Delete{
            let deletedEntry = entriesArray[indexPath.row]
            Entry.deleteEntry(deletedEntry)
            entriesArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEntry"{
            let nextVC = segue.destinationViewController as! EntryWebViewController
            nextVC.entryUrlString = userSelectedEntry.entryUrl
        }
    }
}