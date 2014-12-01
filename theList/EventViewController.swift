//
//  EventViewController.swift
//  theList
//
//  Created by William Akeson on 11/10/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit
import CloudKit

class EventViewController: UIViewController, MadeEventDelegate, GetGuestListCompleteDelegate{
    
    //Event checks current USER ID vs event loaded ID. If same, show host options, else show eventGoer options
    
    let sharedEvent : DatabaseWork = DatabaseWork.sharedInstanceOfDatabase()
    
    var event : Event!
    
    @IBOutlet var eventTagsField: UITextView!
    @IBOutlet var eventNameLabel : UILabel!
    @IBOutlet var hostNameButton : UIButton!
    @IBOutlet var hostRatingLabel : UILabel!
    @IBOutlet var capacityButton : UIButton!
    @IBOutlet var capacityLabel : UILabel!
    @IBOutlet var eventImageView : UIImageView!
    @IBOutlet var eventDescriptionText : UITextView!
    @IBOutlet var goButton : UIButton!
    @IBOutlet var noGoButton : UIButton!
    @IBOutlet var returnButton : UIButton!

    let database = DatabaseWork.sharedInstanceOfDatabase()
    var photoImage : UIImage!
    
    var eventID : String!
    
    var segueIdentity : String!
    
    var searchData : SearchData!
//    var eventsList : [String]!
    
    var pendingGuests : [User] = []
    var acceptedGuests : [User] = []
    var confirmedGuests : [User] = []

    override func viewDidLoad() { 
        super.viewDidLoad()
        
        sharedEvent.madeEventDelegate = self;
        sharedEvent.getGuestListCompleteDelegate = self
        

        if(segueIdentity == "fromCreate"){
            sharedEvent.getEventWithID(eventID)
            goButton.hidden = true
            goButton.enabled = false
            noGoButton.hidden = true
            noGoButton.enabled = false
            returnButton.setTitle("Home", forState : .Normal)

        }else if (segueIdentity == "fromSearch" || segueIdentity == "popEvent"){
//            eventsList = searchData["eventIDs"]!
            returnButton.setTitle("Search", forState : .Normal)
            capacityButton.enabled = false
            println(searchData.toString())
            if(searchData.eventIDs.count > 0) {
                eventID = searchData.eventIDs.removeAtIndex(0)

//                searchData["eventIDs"] = eventsList
                sharedEvent.getEventWithID(eventID)
                //            println(searchData)
                
            }
        }
        

        // Do any additional setup after loading the view.
    }
    


    func showLoadedEvent(){
//        print("EVENT: ")
//        println(event)
        if(event.photos.count != 0) {
            var photoAssetURL = event.photos[0].fileURL
//            println(" IMAGE FILES IN THE THINg ------------- ")
//            println(photoAssetURL)
            
            var imageData = NSData(contentsOfURL: photoAssetURL)
            photoImage = UIImage(data: imageData!)
            eventImageView.image = photoImage
        }
        setEventName(event.name)
                
        hostRatingLabel.text = "★★★☆☆"
        
        hostNameButton.setTitle("Host!", forState: .Normal)

        capacityLabel.text = "0 / \(event.capacity)"
        for tag in event.tags {
            eventTagsField.text = "\(eventTagsField.text) \(tag)\n"
//            println(tag)
        }
        eventDescriptionText.text = event.descript
        database.clearGuestLists()
        if(segueIdentity == "fromCreate" || segueIdentity == "fromHost") {
            database.loadPendingGuests(event.pendingGuests)
        }

    }
    
    func setEventName(name : String) {
        
        let nameLength = countElements(name)
        if(nameLength > 20) {
            let sizeMod : CGFloat = CGFloat(nameLength) - 18.0
            
            let fontSize : CGFloat = (16.0 - sizeMod/2.0)
            
            eventNameLabel.font = UIFont.systemFontOfSize(fontSize)
        }
        eventNameLabel.text = name
    }
    
    @IBAction func testingForImage() {
//        println(photoImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func returnButtonPressed(sender: UIButton) {
        if(segueIdentity == "fromCreate") {
            performSegueWithIdentifier("toHome", sender: self)
        }
        else if(segueIdentity == "fromSearch" || segueIdentity == "popEvent"){
            performSegueWithIdentifier("toSearch", sender: self)
        }
        
    }
    
    
    @IBAction func goToHostScreen(sender: AnyObject) {
        performSegueWithIdentifier("toHostFromEvent", sender: self)
    }

    
    @IBAction func decisionButtonPressed(sender: UIButton) {
        if(searchData.eventIDs.count > 0) {
            performSegueWithIdentifier("popEvent", sender: self)
        }
        else {
            performSegueWithIdentifier("noEvents", sender: self)
        }
        if(sender == goButton) {
            database.addUserToPending(CurrentUserData.getSharedInstanceOfUserData().getFacebookID(), eventRecord: event.record)
            searchData.goEvents.append(eventID)
            // perform go functionality            
        }
        else if(sender == noGoButton) {
            searchData.rejectedEvents.append(eventID)
            // perform no go functionality
        }
        println(searchData)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "popEvent") {
            let foundEventsVC : EventViewController = segue.destinationViewController as EventViewController
            foundEventsVC.searchData = searchData
            foundEventsVC.segueIdentity = segue.identifier
        }else if (segue.identifier == "toHostFromEvent"){
            let hostProfileVC : ProfileViewController = segue.destinationViewController as ProfileViewController
            hostProfileVC.userID = event.hostID
        }else if (segue.identifier == "goToGuestManagement"){
            let guestManagementVC : GuestListViewController = segue.destinationViewController as GuestListViewController
            guestManagementVC.pendingGuests = pendingGuests
            guestManagementVC.confirmedGuests = confirmedGuests
            guestManagementVC.acceptedGuests = acceptedGuests
        }
    }
    

    
    /* Events Delegate */
    func madeEventsUpdated(event : Event) {
        self.event = event
        self.hostNameButton.setTitle(event.hostName, forState: .Normal)
        showLoadedEvent()
//        print("FIRST EVEN TEST:")
//        println(event)
    }
    
    func errorMadeUpdate(error: NSError) {
        let message = error.localizedDescription
        let alert = UIAlertView(title: "error loading created event", message: message, delegate: nil, cancelButtonTitle: "ok")
        alert.show()
    }
    
    
    @IBAction func checkPendingUsers(sender: AnyObject) {
        println(self.event.pendingGuests)
    }
    
    @IBAction func acceptScott(sender: AnyObject) {
        sharedEvent.addUserToAccepted(CurrentUserData.getSharedInstanceOfUserData().getFacebookID(), eventRecord: self.event.record)
        println("accepted")
    }
    
    

    func errorGettingGuests(error : NSError) {
        println("Error getting guests: \(error)")
    }
    func returnPendingGuests(pendingGuests : [User]) {
        self.pendingGuests = pendingGuests
        println("pending guests returned")
        database.loadAcceptedGuests(event.acceptedGuests)
    }
    func returnAcceptedGuests(acceptedGuests : [User]) {
        self.acceptedGuests = acceptedGuests
        println("accepted guests returned")
        database.loadConfirmedGuests(event.confirmedGuests)
        
    }
    func returnConfirmedGuests(confirmedGuests : [User]) {
        self.confirmedGuests = confirmedGuests
        println("confirmed guests returned")
        println(self.confirmedGuests)
        println(self.acceptedGuests)
        println(self.pendingGuests)
    }
    /* tag table view */
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
