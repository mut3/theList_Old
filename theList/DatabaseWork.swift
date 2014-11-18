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
    func errorUpdate(error:NSError)
    func pastEventsListUpdated(userEvents : [Event])
}

protocol MadeEventDelegate{
    func madeEventsUpdated(event : Event)
    func errorMadeUpdate(error:NSError)
}


class DatabaseWork {
    
    var delegate : EventsDelegate?
    var madeEventDelegate : MadeEventDelegate?
    
    var container : CKContainer
    var publicDB : CKDatabase
    let privateDB : CKDatabase
    
    
    class func sharedInstanceOfTheList() -> DatabaseWork{
        return databaseWork
    }
    
    var events = [Event]()
    
    var madeEvents = [Event]()
    
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
                if error != nil {
                    println("\(error)")
                }
                NSLog("We are saving stuff")
            })
    }
    
    func uploadEvent(cap : Int,eventDescript:String,eventEndtime : NSDate, eventStartTime: NSDate, eventName : String, hostID : String, eventTags : [String], photoList : [CKAsset],eventLocation : CLLocation, writtenLocation : String)-> CKRecord{
        let eventRecord = CKRecord(recordType: "Event")
        
        eventRecord.setValue(cap, forKey: "EventCapacity")
        eventRecord.setValue(eventDescript, forKey: "EventDescription")
        eventRecord.setValue(eventName, forKey: "EventName")
        eventRecord.setValue(eventEndtime, forKey: "EventEndTime")
        eventRecord.setValue(eventStartTime, forKey: "EventStartTime")
        eventRecord.setValue(hostID, forKey: "HostID")
        eventRecord.setValue(photoList, forKey: "Photos")
        eventRecord.setValue(eventTags, forKey: "tags")
        eventRecord.setValue(eventLocation, forKey: "EventLocation")
        eventRecord.setValue(writtenLocation, forKey: "EventAddress")
        println(" event ID : \(eventRecord.recordID)")
        publicDB.saveRecord(eventRecord, completionHandler: {(results,error) -> Void in
            println(eventRecord.recordID.recordName)
            if (error != nil){
                NSLog("\(error)")}
        })
        println(" event ID : \(eventRecord.recordID.recordName)")
        return eventRecord
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
    /*
    takes the host id ( uses it as a predicate) and returns the events of the given user
    */
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
                    self.delegate?.pastEventsListUpdated(self.events)
                    return
                }
            }
        }
    }
    
    /*
        takes the current user's location, the radius he is using, and returns all the events within 
        the given radius
    */
    func fetchEventsWithRadius(currentUserLocation : CLLocation, setRadius : CLLocationDistance, completion : (results: [Event]!, error:NSError!)-> ()){
        let eventRecord = CKRecord(recordType: "Event")
        let getAllEventInsideRadius = NSPredicate(format: "distanceToLocation:fromLocation:(%K,%@) < %f","EventLocation",currentUserLocation,setRadius)
        let query = CKQuery(recordType: "Event", predicate: getAllEventInsideRadius)
        publicDB.performQuery(query, inZoneWithID: nil){
            results, error in
            var correctEvents = [Event]()
            if let records = results{
                for record in records{
                    let eventInRadius = Event(record: record as CKRecord, database: self.publicDB)
                    correctEvents.append(eventInRadius)
                }
            }
            dispatch_async(dispatch_get_main_queue()){
                completion(results: correctEvents, error: error)
            }
            
        }
    
    }
    
    
    /*
    get the created event by using the recordName from the record id
    */
    func getEventWithID(eventID : CKRecord){
        println("event id which is a record is : \(eventID)")
        
        let eventRecord = CKRecord(recordType: "Event")
        let getMadeEvent = NSPredicate(format: "recordID = %@",CKRecordID(recordName : eventID.recordID.recordName))
        
        print("hello predicate ")
        println(getMadeEvent)
        let query = CKQuery(recordType: "Event", predicate: getMadeEvent)
        println(query)
        publicDB.performQuery(query, inZoneWithID: nil){
            results, error in
            println(results)
            if error != nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.madeEventDelegate?.errorMadeUpdate(error)
                    return
                }
            }else{
                self.madeEvents.removeAll(keepCapacity: true)
                println("inside the database call")
                for record in results{
                    println("inside the database call part 2")
                    let eventOfUser = Event(record: record as CKRecord, database: self.publicDB)
                    self.madeEvents.append(eventOfUser)
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.madeEventDelegate?.madeEventsUpdated(self.madeEvents[0])
                    return
                }
            }
        }
    }
    

}
let databaseWork = DatabaseWork()