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
    var rejectedEvents : [String]!
    var goEvents : [String]!
    var radius : Int!
    var tags : [String]!
    

    init(eventIDs : [String], tags : [String], radius : Int, fromLocation : CLLocation) {
        
        self.eventIDs = eventIDs
        self.fromLocation = fromLocation
        self.tags = tags
        self.radius = radius
        self.time = NSDate()
        rejectedEvents = []
        goEvents = []
    }
    
}
