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
    
    var searchData : SearchData!
//    var eventsList : [String]!

    override func viewDidLoad() { 
        super.viewDidLoad()
        
        sharedEvent.madeEventDelegate = self;
        

        if(segueIdentity == "fromCreate"){
            sharedEvent.getEventWithID(eventID)

        }else if (segueIdentity == "fromSearch" || segueIdentity == "popEvent"){
//            eventsList = searchData["eventIDs"]!
            
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
        
    }

    
    @IBAction func decisionButtonPressed(sender: UIButton) {
        if(searchData.eventIDs.count > 0) {
            performSegueWithIdentifier("popEvent", sender: self)
        }
        else {
            performSegueWithIdentifier("noEvents", sender: self)
        }
        if(sender == goButton) {
            
            
            // perform go functionality            
        }
        else if(sender == noGoButton) {
            // perform no go functionality
        }
        println(searchData)
        
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
        showLoadedEvent()
//        print("FIRST EVEN TEST:")
//        println(event)
    }
    
    func errorMadeUpdate(error: NSError) {
        let message = error.localizedDescription
        let alert = UIAlertView(title: "error loading created event", message: message, delegate: nil, cancelButtonTitle: "ok")
        alert.show()
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
