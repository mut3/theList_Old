//
//  EventsListTableViewController.swift
//  theList
//
//  Created by William Akeson on 11/9/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit

class EventsListTableViewController: UITableViewController,PastEventsDelegate {

    let givenEvents : DatabaseWork = DatabaseWork.sharedInstanceOfDatabase()
    
    var localPastEvents = Dictionary<String,String>()
    
    var userID : String = ""
    
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
        var cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        var givenEvent = currentUserPastEvents[indexPath.row]
        var eventName = givenEvent[1]
        println(eventName)
        cell.textLabel.text = eventName
        return cell
    }
    
    
    /*
        database delegate
    */
    func pastEventsList(pastEvents: [[String]]) {
        println(pastEvents)
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
