//
//  User.swift
//  theList
//
//  Created by William Akeson on 11/6/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//
import Foundation
import CloudKit

class User: NSObject{
    var record : CKRecord!
    var facebookID : String!
    var age : Int!
    var descript : String!
    var guestID : String!
    var hostID : String!
    var firstName : String!
    var lastName : String!
    var userID : String!
    var photos : [String]!
    weak var database : CKDatabase!
    var date: NSDate
    var gender : String!
    
    
    init( record : CKRecord, database: CKDatabase){
        self.record = record
        self.database = database
        self.age = record.objectForKey("Age") as Int!
        self.facebookID = record.objectForKey("FacebookID") as String!
        self.descript = record.objectForKey("Description") as String!
        self.guestID = record.objectForKey("GuestID") as String!
        self.hostID = record.objectForKey("HostID") as String!
        self.firstName = record.objectForKey("FirstName") as String!
        self.gender = record.objectForKey("Gender") as String!
        self.lastName = record.objectForKey("LastName") as String!
        self.userID = record.objectForKey("PhoneNumber") as String!
        self.photos = record.objectForKey("Photos") as [String]!
        self.date = record.creationDate
    }
    
    
    
}