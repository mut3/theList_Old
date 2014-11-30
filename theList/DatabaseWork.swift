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
    func pastEventsListUpdated()
}

protocol MadeEventDelegate{
    func madeEventsUpdated(event : Event)
    func errorMadeUpdate(error:NSError)
}

protocol FoundEventsDelegate{
    func foundEventsUpdate(events : [Event])
    func errorFindingEvents(error:NSError)
}

protocol FoundEventCondenseDelegate{
    func foundCondensedEvents()
    func errorFindingCondensedEvents(error:NSError)
}

protocol UploadingEventDelegate{
    func doneUploading(eventID : String)
}
protocol GetUserWithIdDelegate{
    func retreivedUserWithID(user : User)
    func failedToRetreiveUser(error : NSError)
}
protocol CheckIfUserExistDelegate{
    func failedToCheckUser(error : NSError)
    func checkIfUser(checkUser : Bool)
}
protocol PastEventsDelegate{
    func pastEventsList(pastEvents : [CKRecord])
    func errorWithPastEvents(error : NSError)

}
protocol BatchGetUserNamesDelegate {
    func batchNameResults(nameResults : [String], listType : String)
    func errorGettingNames(error : NSError)
}

class DatabaseWork {
    
    var delegate : EventsDelegate?
    var madeEventDelegate : MadeEventDelegate?
    var foundEventsDelegate : FoundEventsDelegate?
    var foundCondensedEventsDelegate : FoundEventCondenseDelegate?
    var uploadEventDelegate : UploadingEventDelegate?
    var getUserWithIdDelegate : GetUserWithIdDelegate?
    var checkIfUserExistDelegate : CheckIfUserExistDelegate?
    var pastEventsDelegate : PastEventsDelegate?
    var batchGetUserNamesDelegate : BatchGetUserNamesDelegate? // ?
    var container : CKContainer
    var publicDB : CKDatabase
    let privateDB : CKDatabase
    
    
    class func sharedInstanceOfDatabase() -> DatabaseWork{
        return databaseWork
    }
    
    var events = [Event]()
    var guestNames = [String]()
    var madeEvents = [Event]()
    
    var retreivedUser = [User]()
    
    var userExist : Bool!
    
    init(){
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
        
    }
    
    func uploadUser(age: Int, userDescript : String, userFBID : String, userFirstName: String,
        userLastName : String , deviceID : String , userGuestID : String, userHostID : String, gender : String){
        let userRecord = CKRecord(recordType: "User")
        userRecord.setValue(age, forKey: "Age")
        userRecord.setValue(userDescript, forKey: "Description")
        userRecord.setValue(deviceID, forKey: "DeviceID")
        userRecord.setValue(userFBID, forKey: "FacebookID")
        userRecord.setValue(userFirstName, forKey: "FirstName")
        userRecord.setValue(userLastName, forKey: "LastName")
        userRecord.setValue(userGuestID, forKey: "GuestID")
        userRecord.setValue(userHostID, forKey: "HostID")
        userRecord.setValue(gender, forKey: "Gender")
        //userRecord.setValue(photoList, forkey: "Photos")
            
            publicDB.saveRecord(userRecord, completionHandler: {(record, error)-> Void in
                if error != nil {
                    println("\(error)")
                }
                NSLog("We are saving stuff")
            })
    }
    
    func uploadEvent(cap : Int,eventDescript:String,eventEndtime : NSDate, eventStartTime: NSDate, eventName : String, hostID : String, hostName : String, eventTags : [String], photoList : [CKAsset],eventLocation : CLLocation, writtenLocation : String)-> CKRecord{
        let eventRecord = CKRecord(recordType: "Event")
        
        eventRecord.setValue(cap, forKey: "EventCapacity")
        eventRecord.setValue(eventDescript, forKey: "EventDescription")
        eventRecord.setValue(eventName, forKey: "EventName")
        eventRecord.setValue(eventEndtime, forKey: "EventEndTime")
        eventRecord.setValue(eventStartTime, forKey: "EventStartTime")
        eventRecord.setValue(hostID, forKey: "HostID")
        eventRecord.setValue(hostName, forKey: "hostName")
        eventRecord.setValue(photoList, forKey: "Photos")
        eventRecord.setValue(eventTags, forKey: "tags")
        eventRecord.setValue(eventLocation, forKey: "EventLocation")
        eventRecord.setValue(writtenLocation, forKey: "EventAddress")
        eventRecord.setValue([], forKey: "pendingGuests")
        eventRecord.setValue([], forKey: "confirmedGuests")
        eventRecord.setValue([], forKey: "acceptedGuests")
        eventRecord.setValue([], forKey: "rejectedGuests")
        println(" event ID : \(eventRecord.recordID)")
        publicDB.saveRecord(eventRecord, completionHandler: {(results,error) -> Void in
            println(eventRecord.recordID.recordName)
            if (error != nil){
                NSLog("\(error)")
            }
            dispatch_async(dispatch_get_main_queue()){
                self.uploadEventDelegate?.doneUploading("\(eventRecord.recordID.recordName)")
                return
            }
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
        a better way to get the list of past events of the current user. will use a predicate with the 
        format of FacebookID = the currentUserData facebook ID.
    */
    func getCurrentUserPastEvents(){
        let userID = CurrentUserData.getSharedInstanceOfUserData().getFacebookID()
        let currentUserPredicate = NSPredicate(format: "HostID = %@", userID)
        let query = CKQuery(recordType: "Event", predicate: currentUserPredicate)
        publicDB.performQuery(query, inZoneWithID : nil){
            results, error in
            var onePastEvent : [String] = []
            var pastEvents : [[String]] = []
            var pastEventRecords : [CKRecord] = []
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue()){
                    self.pastEventsDelegate?.errorWithPastEvents(error)
                    return
                }
            }else{
                for record in results{
                    if (onePastEvent.count > 0){
                        onePastEvent.removeAll(keepCapacity: true)
                    }
                    /*
                    let eventName = Event(record : record as CKRecord, database: self.publicDB).name
                    let eventID = Event(record : record as CKRecord, database: self.publicDB).record.recordID.recordName
                    onePastEvent.append(eventID)
                    onePastEvent.append(eventName)
                    pastEvents.append(onePastEvent)
                    */
                    pastEventRecords.append(record as CKRecord)
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.pastEventsDelegate?.pastEventsList(pastEventRecords)
                    return
                }
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
            var pastEvents = Dictionary<String,String>()
            if error != nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.delegate?.errorUpdate(error)
                    return
                }
            }else{
                self.events.removeAll(keepCapacity: true)
                for record in results{
                    let eventOfUser = Event(record: record as CKRecord, database: self.publicDB)
                    let eventOfUserName = Event(record: record as CKRecord, database: self.publicDB).name
                    let eventIDOfUser = Event(record: record as CKRecord, database: self.publicDB).record.recordID.recordName
                    pastEvents[eventIDOfUser] = eventOfUserName
                    self.events.append(eventOfUser)
                }
                dispatch_async(dispatch_get_main_queue()){
                    self.delegate?.pastEventsListUpdated()
                    return
                }
            }
        }
    }
    
    /*
        takes the current user's location, the radius he is using, and returns all the events within 
        the given radius
    */
    func fetchEventsWithRadius(currentUserLocation : CLLocation, setRadius : CLLocationDistance){
//        println("\(currentUserLocation)")
        let eventRecord = CKRecord(recordType: "Event")
        let getAllEventInsideRadius = NSPredicate(format: "distanceToLocation:fromLocation:(%K,%@) < %f","EventLocation",currentUserLocation,setRadius)
        let query = CKQuery(recordType: "Event", predicate: getAllEventInsideRadius)
        publicDB.performQuery(query, inZoneWithID: nil){
            results, error in
            var correctEvents = [Event]()
            var correctEventsDict = Dictionary<String,String>()
            if error != nil {
                self.foundEventsDelegate?.errorFindingEvents(error)
                return
            }
            if let records = results{
                for record in records{
                    let eventInRadius = Event(record: record as CKRecord, database: self.publicDB)
                    let eventRecordID = eventInRadius.record.recordID.recordName
                    let eventStartTime = eventInRadius.startTime
                    let eventTags = eventInRadius.tags
                    correctEventsDict["RecordID"]="\(eventRecordID)"
                    correctEventsDict["StartTime"]="\(eventStartTime)"
                    //correctEventsDict["eventTags"]="\"eventTags
                    correctEvents.append(eventInRadius)
                }
            }
            dispatch_async(dispatch_get_main_queue()){
                self.foundEventsDelegate?.foundEventsUpdate(correctEvents)
                return
            }
            
        }
    
    }
    
    func fetchEventsWithRadiusSmaller(currentUserLocation : CLLocation, setRadius : CLLocationDistance){
        //        println("\(currentUserLocation)")
        let eventRecord = CKRecord(recordType: "Event")
        let getAllEventInsideRadius = NSPredicate(format: "distanceToLocation:fromLocation:(%K,%@) < %f","EventLocation",currentUserLocation,setRadius)
        let query = CKQuery(recordType: "Event", predicate: getAllEventInsideRadius)
        publicDB.performQuery(query, inZoneWithID: nil){
            results, error in
            var correctEvents = [Event]()
            var correctEventsDict = Dictionary<String,String>()
            if error != nil {
                self.foundEventsDelegate?.errorFindingEvents(error)
                return
            }
            if let records = results{
                for record in records{
                    let eventInRadius = Event(record: record as CKRecord, database: self.publicDB)
                    let eventRecordID = Event(record: record as CKRecord, database: self.publicDB).record.recordID.recordName
                    let eventStartTime = Event(record: record as CKRecord, database: self.publicDB).startTime
                    let eventTags = Event(record: record as CKRecord, database: self.publicDB).tags
                    correctEventsDict["RecordID"]="\(eventRecordID)"
                    correctEventsDict["StartTime"]="\(eventStartTime)"
                    correctEventsDict["eventTags"]="\(eventTags)"
                    correctEvents.append(eventInRadius)
                }
            }
            dispatch_async(dispatch_get_main_queue()){
                self.foundCondensedEventsDelegate?.foundCondensedEvents()
                return
            }
            
        }
        
    }
    
    /*
    get the created event by using the recordName from the record id
    */
    func getEventWithID(eventID : String){
        let eventRecord = CKRecord(recordType: "Event")
        let getMadeEvent = NSPredicate(format: "recordID = %@",CKRecordID(recordName : eventID))
        let query = CKQuery(recordType: "Event", predicate: getMadeEvent)
        publicDB.performQuery(query, inZoneWithID: nil){
            results, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.madeEventDelegate?.errorMadeUpdate(error)
                    return
                }
            }else{
                self.madeEvents.removeAll(keepCapacity: true)
                for record in results{
                    let eventOfUser = Event(record: record as CKRecord, database: self.publicDB)
                    self.madeEvents.append(eventOfUser)
                }
                dispatch_async(dispatch_get_main_queue()){
                    if(self.madeEvents.count > 0) {
                        self.madeEventDelegate?.madeEventsUpdated(self.madeEvents[0])
                    }
                    return
                }
            }
        }
    }
    /*
    this function requires you to get the id of the user and to tell the function whether the user is a host or a guest
    */
    func getUserWithID(userID : String){
        let eventRecord = CKRecord(recordType: "Event")
        let getCurrentUser = NSPredicate(format: "FacebookID = %@",userID)
        let query = CKQuery(recordType: "User", predicate: getCurrentUser)
        publicDB.performQuery(query, inZoneWithID: nil){
            results, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.getUserWithIdDelegate?.failedToRetreiveUser(error)
                    return
                }
            }else{
                self.retreivedUser.removeAll(keepCapacity: true)
                for record in results{
                    let retreivedCurrentUser = User(record: record as CKRecord, database: self.publicDB)
                    self.retreivedUser.append(retreivedCurrentUser)
                }
                }
            dispatch_async(dispatch_get_main_queue()){
                if (self.retreivedUser.count > 0){
                    self.getUserWithIdDelegate?.retreivedUserWithID(self.retreivedUser[0])
                }
                return
            }
        }
    }
    

    func batchGetUserNamesFromIDs(userIDList : [String], listType : String){
        //where do you distinguish between the kind of list you're getting names for?
        for userID in userIDList
        {
            println("TRYING TO GET USERS")
            let eventRecord = CKRecord(recordType: "Event")
            let getCurrentUser = NSPredicate(format: "FacebookID = %@",userID)
            let query = CKQuery(recordType: "User", predicate: getCurrentUser)
            publicDB.performQuery(query, inZoneWithID: nil){
                results, error in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue()){
                        println("ERROR THING?!?!?!")
                        self.getUserWithIdDelegate?.failedToRetreiveUser(error)
                        return
                    }
                }else{
//                    self.guestNames.removeAll()
                    for record in results{
                        let retreivedCurrentUser = User(record: record as CKRecord, database: self.publicDB)
                        self.guestNames.append(retreivedCurrentUser.firstName + " " + retreivedCurrentUser.lastName)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue()){
                    println("ASYNC THING IN THE DISBATCH BLEHCGH")
                    self.batchGetUserNamesDelegate?.batchNameResults(self.guestNames, listType: listType)
                    return
                    
                }
            
            
            }

        }
    }
    
    func checkToSeeIfUserExist(userID : String){
        let eventRecord = CKRecord(recordType: "Event")
        let getCurrentUser = NSPredicate(format: "FacebookID = %@",userID)
        let query = CKQuery(recordType: "User", predicate: getCurrentUser)
        self.userExist = false
        publicDB.performQuery(query, inZoneWithID: nil){
            results, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()){
                    self.checkIfUserExistDelegate?.failedToCheckUser(error)
                    return
                }
            }else{
                if (results.count > 0){
                    self.userExist = true
                }
            }
            dispatch_async(dispatch_get_main_queue()){
                self.checkIfUserExistDelegate?.checkIfUser(self.userExist)
                return
            }
        }
    
    }
    /*
        this next function addes a user to the pending guast "list" in the database
    */
    func addUserToPending(userID : String, eventRecord : CKRecord){
        var currentPendingUsers : [String] = []
        if (eventRecord.objectForKey("pendingGuests") as [String]! != nil ){
            currentPendingUsers = eventRecord.objectForKey("pendingGuests") as [String]
        }else {println("no one on the pending list yet")}
        currentPendingUsers.insert(userID, atIndex: 0)
        eventRecord.setObject(currentPendingUsers, forKey:"pendingGuests")
        
        publicDB.saveRecord(eventRecord, completionHandler: {(record, error)-> Void in
            if error != nil {
                println("ERROR!!! \(error)")
            }
            NSLog("We are saving stuff")
        })
    }
    
    /*
        addUserToAccepted(userID : String, eventRecord : CKRecord)
            adds the user to the accepted list and removes the user from the pending list.
    */
    func addUserToAccepted(userID : String, eventRecord : CKRecord){
        var currentAcceptedUsers : [String] = []
        if (eventRecord.objectForKey("acceptedGuests") as [String]! != nil ){
            currentAcceptedUsers = eventRecord.objectForKey("acceptedGuests") as [String]
        }else {println("no one on the accepted list yet")}
        currentAcceptedUsers.insert(userID, atIndex:0)
        eventRecord.setObject(currentAcceptedUsers, forKey:"acceptedGuests")
        
        var currentPendingUsers = eventRecord.objectForKey("pendingGuests") as [String]
        let updatedPendingUsers = currentPendingUsers.filter{$0 != userID}
        eventRecord.setObject(updatedPendingUsers, forKey:"pendingGuests")
        
        publicDB.saveRecord(eventRecord, completionHandler: {(record, error)-> Void in
            if error != nil {
                println("\(error)")
            }
            NSLog("We are saving stuff")
        })
        
    }
    
    /*
        func addUserToConfirmed() will add the user to the confirmed list and remove them from the 
        accepted list and save it to the cloudkit database.
        pre: userID as a string and eventRecord as a CKRecord
        post: none
    */
    func addUserToConfirmed(userID : String, eventRecord : CKRecord){
        var currentConfirmedUsers : [String] = []
        if (eventRecord.objectForKey("") as [String]! != nil){
            currentConfirmedUsers = eventRecord.objectForKey("confirmedGuests") as [String]
        }else { println("no one on the confirmed list yet")}
        currentConfirmedUsers.insert(userID, atIndex: 0)
        eventRecord.setObject(currentConfirmedUsers, forKey: "confirmedGuests")
        
        var currentAcceptedUsers = eventRecord.objectForKey("pendingGuests") as [String]
        let updatedAcceptedUsers = currentAcceptedUsers.filter{$0 != userID}
        eventRecord.setObject(updatedAcceptedUsers, forKey: "acceptedGuests")
        
        publicDB.saveRecord(eventRecord, completionHandler: {(record,error)-> Void in
            if error != nil {
                println()
            }
            NSLog("we are changing the user from accepted to confirmed")
        })
    }
    
    ////// the Guest List creator from the database
    /*
        generate the list of "the pending guest" 
        pre: the eventRecord
        post: [string] of the pending guests
    */
    func getPendingGuests(eventRecord : CKRecord)->[String]{
        var pendingGuests = eventRecord.objectForKey("pendingGuests") as [String]
        if (pendingGuests.count < 1){
            pendingGuests = []
        }
        return pendingGuests
    }
    /*
        generate the list of accepted guests
        pre: the eventRecord
        post: [string] of the accepted guests
    */
    
    func getAcceptedGuests(eventRecord : CKRecord)->[String]{
        var acceptedGuests = eventRecord.objectForKey("acceptedGuests") as [String]
        if (acceptedGuests.count < 1){
            acceptedGuests = []
        }
        return acceptedGuests
    }
    /*
        generate the list of confirmed guests
        pre: the eventRecord
        post: [string] of the confirmed guests
    */
    func getConfirmedGuests(eventRecord : CKRecord)->[String]{
        var confirmedGuests = eventRecord.objectForKey("confirmedGuests") as [String]
        if (confirmedGuests.count < 1){
            confirmedGuests = []
        }
        return confirmedGuests
    }
}
let databaseWork = DatabaseWork()