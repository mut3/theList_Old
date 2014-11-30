//
//  EventsListTableViewController.swift
//  theList
//
//  Created by William Akeson on 11/9/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit
import CloudKit

class EventsListTableViewController: UITableViewController,PastEventsDelegate {

    let givenEvents : DatabaseWork = DatabaseWork.sharedInstanceOfDatabase()
    
    var localPastEvents = Dictionary<String,String>()
    
    var userID : String = ""
    
    
    // review old event variables
    var eventNameToPass = ""
    var reviewOldEvent : Bool = false
    var eventRecord : CKRecord!
    
    var eventsCount : Int!
    var userPastEvents = [Event]()
    
    // database transfer over
    var currentUserPastEvents : [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        givenEvents.pastEventsDelegate = self
        
        givenEvents.getCurrentUserPastEvents()
        
        
        //givenEvents.fetchUserEventsWithDelegate("\(userID)_0")
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUserPastEvents.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("PastEventCell", forIndexPath: indexPath) as PastEventCell
        var givenEvent = currentUserPastEvents[indexPath.row]
        var eventRecordID : CKRecordID = CKRecordID(recordName :givenEvent[0])
        eventRecord = CKRecord(recordType : "Event", recordID : eventRecordID)
        var eventName = givenEvent[1]
//        println(eventName)
        cell.pastEventName.text = eventName
        var cap = eventRecord.objectForKey("EventCapacity") as Int!
        cell.pastEventCap.text = "Cap: \(cap)"
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var pastEventList : [String] = currentUserPastEvents[indexPath.row]
        println(eventRecord)
        eventNameToPass = pastEventList[1]
        reviewOldEvent = true
        //performSegueWithIdentifier("makeNewEvent", sender : self)

    }
    /* segue prepare work */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "makeNewEvent"){
            if (reviewOldEvent){
                let createEventVC : NewEventViewController = segue.destinationViewController as NewEventViewController
                println(eventNameToPass)
                createEventVC.eventName = eventNameToPass
                reviewOldEvent = false
            }
        }
    
    }
    
    /*
        database delegate
    */
    func pastEventsList(pastEvents: [[String]]) {
//        println(pastEvents)
        self.currentUserPastEvents = pastEvents
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    func errorWithPastEvents(error: NSError){
        let message = error.localizedDescription
        let alert = UIAlertView(title: "error loading past events", message: message, delegate: nil, cancelButtonTitle: "ok")
        alert.show()
    }
    
}
