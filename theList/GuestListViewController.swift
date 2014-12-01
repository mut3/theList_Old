//
//  GuestListViewController.swift
//  theList
//
//  Created by CSCrew on 11/28/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit

class GuestListViewController: UITableViewController, BatchGetUserNamesDelegate {
    
    let database : DatabaseWork = DatabaseWork.sharedInstanceOfDatabase()
    
    var pendingGuests : [User]!
    var acceptedGuests : [User]!
    var confirmedGuests : [User]!
    
    var pendingGuestNames : [String]!
    var acceptedGuestNames : [String]!
    var confirmedGuestNames : [String]!
    //ic
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database.batchGetUserNamesDelegate = self
        gatherListNames()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
        //should make three sections of table
    }
    
    func batchNameResults(nameResults : [String], listType : String) {
        if(listType == "pending") {
            pendingGuestNames = nameResults
        }
        else if(listType == "accepted") {
            acceptedGuestNames = nameResults
        }
        else if(listType == "confirmed") {
            confirmedGuestNames = nameResults
        }
        println("Got to batch name results of type \(listType) with: ")
        println(nameResults)
        //do stuff with name results!
    }
    
    func errorGettingNames(error : NSError) {
        //error handling
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
//        var givenUser = database[indexPath.row] wtf :P
//        var guestName = database.givenUser[1]
        //        println(eventName)
//        cell.textLabel.text = eventName
        return cell
    }
    
    func gatherListNames() {

    }
    
    func populateLists() {

    }
    
}