//
//  EventViewController.swift
//  theList
//
//  Created by William Akeson on 11/10/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit
import CloudKit

class EventViewController: UIViewController, MadeEventDelegate{
    
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
    
    
    var photoImage : UIImage!
    
    var eventID : String!
    
    var segueIdentity : String!
    
    var searchData = Dictionary<String, [String]>()

    override func viewDidLoad() { 
        super.viewDidLoad()
        
//        sleep(1)
        sharedEvent.madeEventDelegate = self;
        
        if(segueIdentity == "fromCreate"){
            sleep(1)
            sharedEvent.getEventWithID(eventID)
            self.goButton.hidden = true
            self.noGoButton.hidden = true
        }else if (segueIdentity == "fromSearch" || segueIdentity == "popEvent"){
            var eventsList = searchData["eventIDs"]!
//            println(searchData)
            let recordName = eventsList.removeAtIndex(0)
//            println("##############################################")
            //println(eventsList)
            searchData["eventIDs"] = eventsList
            sharedEvent.getEventWithID(recordName)
//            println(searchData)
        }
        

        // Do any additional setup after loading the view.
    }

    func showLoadedEvent(){
//        print("EVENT: ")
//        println(event)
        if(event.photos.count != 0) {
            var photoAssetURL = event.photos[0].fileURL
//            println(" IMAGE FILES IN THE THINg ------------- ")
            println(photoAssetURL)
            
            var imageData = NSData(contentsOfURL: photoAssetURL)
            photoImage = UIImage(data: imageData!)
            eventImageView.image = photoImage
        }
    
        
        eventNameLabel.text = event.name
        
        
        hostNameButton.titleLabel!.text = " "
        hostRatingLabel.text = "★★★☆☆"
        capacityLabel.text = "0 / \(event.capacity)"
        for tag in event.tags {
            eventTagsField.text = "\(eventTagsField.text) \(tag)\n"
//            println(tag)
        }
        eventDescriptionText.text = event.descript
    }
    
 
    @IBAction func testingForImage() {
//        println(photoImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func goToHostScreen(sender: AnyObject) {
    }

    
    
    @IBAction func noGoPressed(sender: AnyObject) {
        performSegueWithIdentifier("popEvent", sender: self)
    }

    
    @IBAction func goPressed(sender: AnyObject) {
        sharedEvent.addUserToPending(CurrentUserData.getSharedInstanceOfUserData().getFacebookID(), eventRecord : self.event.record)
        
        performSegueWithIdentifier("popEvent", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "popEvent") {
            let foundEventsVC : EventViewController = segue.destinationViewController as EventViewController
            foundEventsVC.searchData = searchData
            foundEventsVC.segueIdentity = segue.identifier
        }else if (segue.identifier == "goToHostProfile"){
            let hostProfileVC : ProfileViewController = segue.destinationViewController as ProfileViewController
            hostProfileVC.userID = event.hostID
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
        sharedEvent.addUserToAccepted("10204435702066817", eventRecord: self.event.record)
        println("accepted")
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
