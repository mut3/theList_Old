//
//  FindEventViewController.swift
//  theList
//
//  Created by Joey Anetsberger on 11/16/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class FindEventsViewController: UIViewController, FoundEventsDelegate /*FoundEventCondenseDelegate*/ {
    
    @IBOutlet var distanceLabel : UILabel!
    @IBOutlet var distanceSlider : UISlider!
    @IBOutlet var tagsTextField : UITextField!
    @IBOutlet var timeTextField : UITextField!
    @IBOutlet var eventPage : EventViewController!
    
    var currentLocation : CLLocation!
    
    var lat : CLLocationDegrees = 44.479446
    var long : CLLocationDegrees = -73.198219
    
    var sliderValue : Int = 5
    
    var eventFoundIDs : [String] = []
    var searchData : SearchData!
    var searchTags : [String] = []
    
    var userID : String = ""
    
    
    let databaseDevil : DatabaseWork = DatabaseWork.sharedInstanceOfDatabase()

    
    override func viewDidLoad() {
        
        databaseDevil.foundEventsDelegate = self
        
        self.distanceSlider.value = Float(sliderValue)
        
        self.currentLocation = CLLocation(latitude: lat, longitude: long)
//        self.searchData["eventIDs"] = eventFoundIDs
    }
    
    @IBAction func sliderMoved(sender: AnyObject) {
        
        sliderValue = Int(distanceSlider.value)
//        println(sliderValue)
        distanceLabel.text = ("\(sliderValue) mi")
    
    }
    
    
    @IBAction func searchPressed(sender : AnyObject) {
        let searchRadius : CLLocationDistance = Double(sliderValue)
        if(tagsTextField.text != "") {
            searchTags = tagsTextField.text.componentsSeparatedByString(", ")
        }
        
//        println(searchRadius)
        eventFoundIDs = []
        let searchRadiusMeters = searchRadius * 1609.34
        databaseWork.fetchEventsWithRadius(currentLocation, setRadius: searchRadiusMeters)
        
    }
    
    
    func foundEventsUpdate(events: [Event]) {
        let currentUser = CurrentUserData.getSharedInstanceOfUserData().getFacebookID()
        for event in events {
//            println("\(event.name) :: \(event.location.coordinate.latitude) :: \(event.location.coordinate.longitude)")
            var distanceFromSelf : Double = (currentLocation.distanceFromLocation(event.location)/1609.34)
//            println("\(event.record.recordID.recordName)")
            var sameHost = event.hostID == currentUser
            var tagMatch = filterByTags(event.tags as NSArray)
            if(distanceFromSelf <= Double(distanceSlider.value) && !sameHost && tagMatch) {
                eventFoundIDs.append(event.record.recordID.recordName)
            }

        }
        
        if(CurrentUserData.getSharedInstanceOfUserData().searchData == nil) {
            searchData = SearchData(eventIDs: eventFoundIDs, tags: searchTags, radius: sliderValue, fromLocation: currentLocation)
        }
        else {
            searchData = CurrentUserData.getSharedInstanceOfUserData().searchData
            for event in eventFoundIDs {
                if (!searchData.alreadySawEvent(event)) {
                    searchData.eventIDs.append(event)
                }
            }
        }
        println(searchData.toString())
/*
        let foundEventsVC : EventViewController = EventViewController()
        foundEventsVC.searchData = searchData
        foundEventsVC.segueIdentity = "foundEvent"
        navigationController?.pushViewController(foundEventsVC, animated: true)
  */
        if(searchData.eventIDs.count > 0) {
            performSegueWithIdentifier("fromSearch", sender : self)
        }
        else{
            performSegueWithIdentifier("noEvents", sender: self)
        }
    }
    
    func filterByTags(eventTags : NSArray) -> Bool {
        var tagMatch = true
//        println(searchTags)
        if(searchTags.count > 0) {
            for tag in searchTags{
                if(!eventTags.containsObject(tag)) {
                    tagMatch = false
                }
            }
        }
//        println(tagMatch)
        return tagMatch
    }
    
    /*
    the next function prepares for a segue to the event page
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "fromSearch") {
            let foundEventsVC : EventViewController = segue.destinationViewController as EventViewController
            foundEventsVC.searchData = searchData
            foundEventsVC.segueIdentity = "fromSearch"
        }
    }

    
    
    func errorFindingEvents(error: NSError){
//        println(error)
    }
}





