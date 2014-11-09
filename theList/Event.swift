//
//  Event.swift
//  theList
//
//  Created by William Akeson on 11/9/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import Foundation
import CloudKit

class Event : NSObject{
    var record : CKRecord!
    var eventDescript : String!
    var eventEndTime : NSDate!
    var eventStartTime : NSDate!
    var eventLocation : CLLocation!
    var eventName : String!
    var hostID : String!
    var photos : [String]!
    var tags : [String]!
    var eventCapacity : Int!
    var eventAddress : String!
    var database : CKDatabase!
    
    
    init(record : CKRecord, database : CKDatabase){
        self.record = record
        self.database = database
        self.eventDescript = record.objectForKey("EventDescription") as String!
        self.eventStartTime = record.objectForKey("EventStartTime") as NSDate!
        self.eventEndTime = record.objectForKey("EventEndTime") as NSDate!
        self.eventLocation = record.objectForKey("EventLocation") as CLLocation!
        self.eventName = record.objectForKey("EventName") as String!
        self.hostID = record.objectForKey("HostID") as String!
        self.photos = record.objectForKey("Photos") as [String]!
        self.tags = record.objectForKey("tags") as [String]!
        self.eventCapacity = record.objectForKey("EventCapacity") as Int!
        self.eventAddress  = record.objectForKey("EventAddress") as String!
    
    }

}