//
//  CurrentUserData.swift
//  theList
//
//  Created by William Akeson on 11/21/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import Foundation



class CurrentUserData : NSObject {
    
    var facebookID : String = ""
    var searchData : SearchData!
    var userName : String = ""
    
    class func getSharedInstanceOfUserData() -> CurrentUserData{
        return currentUserData
    }
    
    override init() {
        
    }
    
    func setSearchData(searchData : SearchData){
        self.searchData = searchData
    }
    
    func setFacebookID(idNumber : String) {
        self.facebookID = idNumber
    }
    
    func getFacebookID() -> String {
        return facebookID
        
    }
    
    func setUserName(firstName : String){
        self.userName = firstName
    }
    
    func getUserName() -> String {
        return userName
    }
    
}

let currentUserData = CurrentUserData()
