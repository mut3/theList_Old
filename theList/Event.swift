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
    var descript : String!
//    var endTime : NSDate!
    var startTime : NSDate!
    var location : CLLocation!
    var name : String!
    var hostID : String!
    var hostName : String!
    var photos : [CKAsset]!
    var tags : [String]!
    var capacity : Int!
    var address : String!
    var pendingGuests : [String] = []
    var acceptedGuests : [String] = []
    var confirmedGuests : [String] = []
    var rejectedGuests : [String] = []
    var database : CKDatabase!
    
    
    init(record : CKRecord, database : CKDatabase){
        self.record = record
        self.database = database
        self.descript = record.objectForKey("EventDescription") as String!
        self.startTime = record.objectForKey("EventStartTime") as NSDate!
//        self.endTime = record.objectForKey("EventEndTime") as NSDate!
        self.location = record.objectForKey("EventLocation") as CLLocation!
        self.name = record.objectForKey("EventName") as String!
        self.hostID = record.objectForKey("HostID") as String!
        self.hostName = record.objectForKey("hostName") as String!
        self.photos = record.objectForKey("Photos") as [CKAsset]!
        self.tags = record.objectForKey("tags") as [String]!
        self.capacity = record.objectForKey("EventCapacity") as Int!
        self.address  = record.objectForKey("EventAddress") as String!
        self.pendingGuests = record.objectForKey("pendingGuests") as [String]!
        self.acceptedGuests = record.objectForKey("acceptedGuests") as [String]!
        self.confirmedGuests = record.objectForKey("confirmedGuests") as [String]!
        self.rejectedGuests = record.objectForKey("rejectedGuests") as [String]!
        
//        if(pendingGuests == nil) {
//            self.pendingGuests = []
//        }
//        
//        if(acceptedGuests == nil) {
//            self.acceptedGuests = []
//        }
//        
//        if(confirmedGuests == nil) {
//            self.confirmedGuests = []
//        }
//        
//        if(rejectedGuests == nil) {
//            self.rejectedGuests = []
//        }
        println(" event named \(self.name): \(self.pendingGuests) \(self.acceptedGuests) \(self.confirmedGuests)")
    }
    
}