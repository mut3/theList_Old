//
//  DatabaseWork.swift
//  theList
//
//  Created by William Akeson on 11/8/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import Foundation
import CloudKit

protocol EventsDelegate{
    func pastEventsListUpdated()
    func errorUpdate(error:NSError)
}


class DatabaseWork {
    
    var delegate : EventsDelegate?
    
    var container : CKContainer
    var publicDB : CKDatabase
    let privateDB : CKDatabase
    
    
    class func sharedInstanceOfTheList() -> DatabaseWork{
        return databaseWork
    }
    
    var events = [Event]()
    
    init(){
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        
    }
    
    func uploadUser(age: Int, userDescript : String, userFBID : String, userFirstName: String,
        userLastName : String , deviceID : String , userGuestID : String, userHostID : String){
        let userRecord = CKRecord(recordType: "User")
        userRecord.setValue(age, forKey: "Age")
        userRecord.setValue(userDescript, forKey: "Description")
        userRecord.setValue(deviceID, forKey: "DeviceID")
        userRecord.setValue(userFBID, forKey: "FacebookID")
        userRecord.setValue(userFirstName, forKey: "FirstName")
        userRecord.setValue(userLastName, forKey: "LastName")
        userRecord.setValue(userGuestID, forKey: "GuestID")
        userRecord.setValue(userHostID, forKey: "HostID")
        //userRecord.setValue(photoList, forkey: "Photos")
            
            publicDB.saveRecord(userRecord, completionHandler: {(record, error)-> Void in
                NSLog("We are saving stuff")
            })
    }
    
    func uploadEvent(cap : Int,eventDescript:String,eventEndtime : NSDate, eventStartTime: NSDate, eventName : String, hostID : String, eventTags : [String], photoList : [String],eventLocation : CLLocation, writtenLocation : String){
        let eventRecord = CKRecord(recordType: "Event")
        eventRecord.setValue(cap, forKey: "EventCapacity")
        eventRecord.setValue(eventDescript, forKey: "EventDescription")
        eventRecord.setValue(eventName, forKey: "EventName")
        eventRecord.setValue(eventEndtime, forKey: "EventEndTime")
        eventRecord.setValue(eventStartTime, forKey: "EventStartTime")
        eventRecord.setValue(hostID, forKey: "HostID")
        //eventRecord.setValue(photoList, forKey: "Photos")
        eventRecord.setValue(eventTags, forKey: "tags")
        eventRecord.setValue(eventLocation, forKey: "EventLocation")
        eventRecord.setValue(writtenLocation, forKey: "EventAddress")
        
        publicDB.saveRecord(eventRecord, completionHandler: {(results,error) -> Void in
            if (error != nil){
                NSLog("\(error)")}
        })
        
    }
    
    /*
    takes the current user's hostID and retreive all of his past events created.
    pre: hostID of currentUser
    post: nothing but when the function is called a completion function needs to written.
    */
    func fetchUserEvents(hostID : String, completion: (results: [Event]!, error:NSError!)->())
    {
        let userRecord = CKRecord(recordType: "Event")
        let getCurrentUserPredicate = NSPredicate(format: "HostID = %@",hostID)
        let query = CKQuery(recordType: "Event", predicate: getCurrentUserPredicate)
        publicDB.performQuery(query, inZoneWithID: nil) {
            results, error in
            self.events.removeAll(keepCapacity: true)
            for record in results{
                let eventOfUser = Event(record: record as CKRecord, database: self.publicDB)
                self.events.append(eventOfUser)
            }
            dispatch_async(dispatch_get_main_queue()){
                completion(results: self.events, error : error)
            }
            
        }
    }
    
    func fetchUserEventsWithDelegate(hostID : String){
        let eventRecord = CKRecord(recordType: "Event")
        let getCurrentUserPredicate = NSPredicate(format: "HostID = %@",hostID)
        let query = CKQuery(recordType: "Event", predicate: getCurrentUserPredicate)
        publicDB.performQuery(query, inZoneWithID: nil) {
            results, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.delegate?.errorUpdate(error)
                    return
                }
            }else{
                self.events.removeAll(keepCapacity: true)
                for record in results{
                    let eventOfUser = Event(record: record as CKRecord, database: self.publicDB)
                    self.events.append(eventOfUser)
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.delegate?.pastEventsListUpdated()
                    return
                }
            }
        }
    }
    

}
let databaseWork = DatabaseWork()