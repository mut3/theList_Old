//
//  createUser.swift
//  theList
//
//  Created by William Akeson on 11/6/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import Foundation
import CloudKit

class DatabaseModel{
    var container : CKContainer
    var publicDB : CKDatabase
    let privateDB : CKDatabase
    
    init(){
        container = CKContainer.defaultContainer()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase

    }
    
    func uploadUser(){
        let userRecord = CKRecord(recordType: "User")
        
    
    }

}