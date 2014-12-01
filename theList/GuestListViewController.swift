	//
//  GuestListViewController.swift
//  theList
//
//  Created by CSCrew on 11/28/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit

class GuestListViewController: UITableViewController {
    
    let database : DatabaseWork = DatabaseWork.sharedInstanceOfDatabase()
    
    
    var pendingGuests : [User]!
    var acceptedGuests : [User]!
    var confirmedGuests : [User]!
    var guestList : [User]!
    var hackyCounter : Int = 0
    var segueIdentity : String!
    var selectedGuest : User!
    //ic
    var event : Event!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(segueIdentity == "fromEvent") {
            guestList = pendingGuests + acceptedGuests + confirmedGuests
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        //should make three sections of table
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (pendingGuests.count + acceptedGuests.count + confirmedGuests.count);
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.tableView.dequeueReusableCellWithIdentifier("GuestListCell", forIndexPath: indexPath) as GuestListCell
        
        var givenGuest = guestList[indexPath.row]
        
        var guestName = givenGuest.firstName
        
        println(guestName)
        cell.guestName.text = guestName
        
        if(hackyCounter >= (pendingGuests.count + acceptedGuests.count)) {
            cell.guestStatus.text = "Confirmed"
        } else if(hackyCounter >= pendingGuests.count) {
            cell.guestStatus.text = "Accepted"
        } else {
            cell.guestStatus.text = "Pending"
        }
        
        return cell
    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedGuest = guestList[indexPath.row]
        performSegueWithIdentifier("fromGuestListToGuestProfile",sender : self)
    
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "fromGuestListToGuestProfile"){
            let profileVC : ProfileViewController = segue.destinationViewController as ProfileViewController
            profileVC.userID = selectedGuest.facebookID
            profileVC.segueIdentity = "fromGuestListToGuestProfile"
            profileVC.user = selectedGuest
            profileVC.event = event
        }
    
    }
    
}