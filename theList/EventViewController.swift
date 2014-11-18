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
    
    let sharedEvent : DatabaseWork = DatabaseWork.sharedInstanceOfTheList()
    
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
        }else if (segueIdentity == "fromSearch"){
            let eventsList = searchData["eventIDs"]!
            let recordName = eventsList[0]
            sharedEvent.getEventWithID(recordName)
                
            println(searchData)
        }
        

        // Do any additional setup after loading the view.
    }

    func showLoadedEvent(){
        print("EVENT: ")
        println(event)
        if(event.photos.count != 0) {
            var photoAssetURL = event.photos[0].fileURL
            println(" IMAGE FILES IN THE THINg ------------- ")
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
            println(tag)
        }
        eventDescriptionText.text = event.descript
    }
    
 
    @IBAction func testingForImage() {
        println(photoImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func goToHostScreen(sender: AnyObject) {
    }

    
    
    @IBAction func noGoPressed(sender: AnyObject) {
        
    }

    
    @IBAction func goPressed(sender: AnyObject) {
        performSegueWithIdentifier("popEvent", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "popEvent") {
            let foundEventsVC : EventViewController = segue.destinationViewController as EventViewController
            foundEventsVC.searchData = searchData
            foundEventsVC.segueIdentity = segue.identifier
        }
    }
    

    
    /* Events Delegate */
    func madeEventsUpdated(event : Event) {
        self.event = event
        showLoadedEvent()
        print("FIRST EVEN TEST:")
        println(event)
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
