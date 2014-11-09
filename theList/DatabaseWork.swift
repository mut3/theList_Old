//
//  DatabaseWork.swift
//  theList
//
//  Created by William Akeson on 11/8/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import Foundation
import CloudKit


class DatabaseWork {
    var container : CKContainer
    var publicDB : CKDatabase
    let privateDB : CKDatabase
    
    
    class func sharedInstanceOfTheList() -> DatabaseWork{
        return databaseWork
    }
    
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
            var eventInfoNew = [Event]()
            for record in results{
                let eventOfUser = Event(record: record as CKRecord, database: self.publicDB)
                eventInfoNew.append(eventOfUser)
            }
            dispatch_async(dispatch_get_main_queue()){
                completion(results: eventInfoNew, error : error)
            }
        
        }
    }
        


}
let databaseWork = DatabaseWork()