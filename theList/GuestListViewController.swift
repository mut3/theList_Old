//
//  GuestListViewController.swift
//  theList
//
//  Created by CSCrew on 11/18/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit

class GuestListViewController: UITableViewController, GuestsDelegate {
    
    let givenGuests : DatabaseWork = DatabaseWork.sharedInstanceOfTheList()
    
    var guestCount : Int!
    var guests = [GuestList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        givenGuests.delegate = self;
        givenGuests.fetchUserEventsWithDelegate("12314")
        
        println(givenGuests.events.count)
        
        
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
        return 3 //i believe this mean three sections
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DatabaseWork.sharedInstanceOfTheList().events.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let object = DatabaseWork.sharedInstanceOfTheList().events[indexPath.row]
        // changed textLabel? to textLabel so it would build
        cell.textLabel.text = object.name
        return cell
    }
    
    
    /*
    database delegate
    */
    func guestListUpdated() {
        refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    func errorUpdate(error: NSError) {
        let message = error.localizedDescription
        let alert = UIAlertView(title: "error loading guest list", message: message, delegate: nil, cancelButtonTitle: "ok")
        alert.show()
    }
}
