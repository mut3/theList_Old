//
//  HomeViewController.swift
//  theList
//
//  Created by William Akeson on 11/21/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit
import Foundation

class HomeViewController: UIViewController, PastEventsDelegate{
    
    var currentUserPastEvents : [Event] = [Event]()
    var upcomingEvents : [Event] = [Event]()
    let database = DatabaseWork.sharedInstanceOfDatabase()
    
    override func viewDidLoad() {
        
        database.pastEventsDelegate = self

        // println(CurrentUserData.getSharedInstanceOfUserData().getFacebookID())
        
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func hostEventPressed() {
        database.getCurrentUserPastEvents()
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
            performSegueWithIdentifier("fromHomeToEvent", sender: self)
        }
        else {
            performSegueWithIdentifier("fromHomeToEventList", sender: self)
        }
    }
    
    func errorWithPastEvents(error: NSError){
        let message = error.localizedDescription
        let alert = UIAlertView(title: "error loading past events", message: message, delegate: nil, cancelButtonTitle: "ok")
        alert.show()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "fromHomeToEvent") {
            let eventVC : EventViewController = segue.destinationViewController as EventViewController
            eventVC.eventID = upcomingEvents[0].record.recordID.recordName
            eventVC.segueIdentity = "fromHomeToEvent"
        }
        else if(segue.identifier == "fromHomeToEventList") {
            let eventListVC : EventsListTableViewController = segue.destinationViewController as EventsListTableViewController
            eventListVC.currentUserPastEvents = currentUserPastEvents

        }
        else if(segue.identifier == "fromHomeToProfile") {
            let profileVC : ProfileViewController = segue.destinationViewController as ProfileViewController
            profileVC.userID = CurrentUserData.getSharedInstanceOfUserData().getFacebookID()
        }
    }

    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
