//
//  EventsListTableViewController.swift
//  theList
//
//  Created by William Akeson on 11/9/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit

class EventsListTableViewController: UITableViewController, EventsDelegate {

    let givenEvents : DatabaseWork = DatabaseWork.sharedInstanceOfTheList()
    
    var localPastEvents = Dictionary<String,String>()
    
    var eventsCount : Int!
    var userPastEvents = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        givenEvents.delegate = self;
        givenEvents.fetchUserEventsWithDelegate("12314")
        
        println(givenEvents.events.count)
        

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
        return DatabaseWork.sharedInstanceOfTheList().events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let object = DatabaseWork.sharedInstanceOfTheList().events[indexPath.row].name
        //changed textLabel? to textLabel so it would build
        cell.textLabel.text = object
        return cell
    }
    
    /*
        database delegate
    */
    func pastEventsListUpdated() {
        //localPastEvents = pastEvents
        //println(localPastEvents)
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    func errorUpdate(error: NSError) {
        let message = error.localizedDescription
        let alert = UIAlertView(title: "error loading past events", message: message, delegate: nil, cancelButtonTitle: "ok")
        alert.show()
    }
}
