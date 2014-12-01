//
//  SearchData.swift
//  theList
//
//  Created by Joey Anetsberger on 11/26/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import Foundation

class SearchData : NSObject {
    var time : NSDate!
    var fromLocation : CLLocation!
    var eventIDs : [String]!
    var acceptedEventIDs : [String]!
    var rejectedEvents : [String]!
    var goEvents : [String]!
    var radius : Int!
    var tags : [String]!
    

    init(eventIDs : [String], tags : [String], radius : Int, fromLocation : CLLocation) {
        super.init()
        self.eventIDs = eventIDs
        self.fromLocation = fromLocation
        self.tags = tags
        self.radius = radius
        self.time = NSDate()
        rejectedEvents = []
        goEvents = []
        acceptedEventIDs = []
        
        CurrentUserData.getSharedInstanceOfUserData().searchData = self
    }
    
    func alreadySawEvent(eventID : String) -> Bool {
        let seenEvents = (rejectedEvents + eventIDs + goEvents) as NSArray
        var alreadySaw = false
        if(seenEvents.containsObject(eventID)) {
            alreadySaw = true
        }
        return alreadySaw
        
    }
    

    
    func toString() -> String {
        let dataString = "Event IDs: \(eventIDs)\nNumber of events found: \(eventIDs.count)\nFrom Location: \(fromLocation)\nTags: \(tags)\nRadius: \(radius)\nGo events:"
                          + "\(goEvents)\nRejected Events\(rejectedEvents)"
        
        return dataString
    }
    
}
