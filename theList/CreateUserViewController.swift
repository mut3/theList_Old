//
//  CreateUserViewController.swift
//  theList
//
//  Created by CSCrew on 11/6/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController, FBLoginViewDelegate{
    
    @IBOutlet var userNameOutlet: UILabel!
    
    @IBOutlet var userAgeOutlet: UILabel!
    
    @IBOutlet var userDescriptionOutlet: UITextView!
    
    
    
    
    @IBOutlet var fbLogin : FBLoginView!
    
    @IBOutlet var profilePic: FBProfilePictureView!
    
    var userFirstNameStr : String = ""
    
    var userLastNameStr : String = ""
    
    var userAgeInt : Int = 0
    
    var userDescript : String = ""
    
    var userFBID : String = ""
    
    var userDeviceID : String = ("\(UIDevice.currentDevice())")
    
    var userGuestID : String = ""
    
    var userHostID : String = ""
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbLogin.delegate = self
        
        userNameOutlet.text = userFirstNameStr
        userAgeOutlet.text = "\(userAgeInt)"
        userDescriptionOutlet.text = ""
        println(userFBID)
        
        
        // Do any additional setup after loading the view.
        
        
    }
    
    
    @IBAction func submitUser(sender: AnyObject) {
        userDescript = userDescriptionOutlet.text
        databaseWork.uploadUser(userAgeInt, userDescript: userDescript, userFBID: userFBID, userFirstName: userFirstNameStr, userLastName: userLastNameStr, deviceID: userDeviceID, userGuestID: userGuestID, userHostID: userHostID)
    }
    
    
    func dateFromString(date : String) -> NSDate {
        var string : NSString =  NSString(string: (date)) as NSString
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        var date : NSDate = formatter.dateFromString(string)!
        return date
    }
    
    /*facebook delegates*/
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        var calendar : NSCalendar = NSCalendar.currentCalendar()
        var ageInSecond = NSDate.timeIntervalSinceDate(dateFromString(user.birthday))
        userFBID = user.objectID
        println(user.birthday)
        println("\(ageInSecond)")
        profilePic.profileID = userFBID
    }
    
    
    

}
