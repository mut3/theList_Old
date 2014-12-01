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
    
    var eventsCount : Int!
    var userPastEvents = [Event]()
    var upcomingEvents = [Event]()
    
    // database transfer over
    var currentUserPastEvents : [Event] = []
    
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
        var cellEvent = currentUserPastEvents[indexPath.row]
        cell.pastEventName.text = cellEvent.name
        var cap = cellEvent.capacity
        cell.pastEventCap.text = "Cap: \(cap)"
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var pastEvent : Event = currentUserPastEvents[indexPath.row] as Event
        userPastEvents.removeAll(keepCapacity: true)
        userPastEvents.append(pastEvent)
        reviewOldEvent = true
        performSegueWithIdentifier("recreateOldEvent", sender : self)

    }
    /* segue prepare work */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "recreateOldEvent"){
            if (reviewOldEvent){
                let createEventVC : NewEventViewController = segue.destinationViewController as NewEventViewController
                println(eventNameToPass)
                createEventVC.eventName = userPastEvents[0].name
                println(userPastEvents[0].capacity)
                createEventVC.eventLocationWritten = userPastEvents[0].address
                createEventVC.eventTags = userPastEvents[0].tags
                createEventVC.eventCapacity = userPastEvents[0].capacity
                createEventVC.eventDescription = userPastEvents[0].descript
                reviewOldEvent = false
                createEventVC.segueID = segue.identifier
            }
        }
     /*   else if(segue.identifier == "fromHost") {
            let eventVC : EventViewController = segue.destinationViewController as EventViewController
            eventVC.eventID = upcomingEvents[0].record.recordID.recordName
            eventVC.segueIdentity = "fromHost"
            
        }
    */
    }
    
    /*
        database delegate
    */
    func pastEventsList(events: [Event]) {
        let rightNow = NSDate()
        for event in events {
            if(rightNow.earlierDate(event.startTime) == rightNow) {
                self.upcomingEvents.append(event)
            }
            else {
                self.currentUserPastEvents.append(event)
            }
            
        }
        if(upcomingEvents.count > 0) {
            performSegueWithIdentifier("fromHost", sender: self)
        }
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    func errorWithPastEvents(error: NSError){
        let message = error.localizedDescription
        let alert = UIAlertView(title: "error loading past events", message: message, delegate: nil, cancelButtonTitle: "ok")
        alert.show()
    }
    
}
