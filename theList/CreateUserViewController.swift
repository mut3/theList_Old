//
//  CreateUserViewController.swift
//  theList
//
//  Created by CSCrew on 11/6/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController, FBLoginViewDelegate, GetUserWithIdDelegate{
    
    @IBOutlet var userNameOutlet: UILabel!
    
    @IBOutlet var userAgeOutlet: UILabel!
    
    @IBOutlet var userGenderOutlet: UITextField!
    
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
    
    let databaseDevil = DatabaseWork.sharedInstanceOfDatabase()
    
    var goToCreatePage : Bool!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbLogin.delegate = self
        databaseDevil.getUserWithIdDelegate = self
        
        
        userDescriptionOutlet.text = ""
        println(userFBID)
        
        
        // Do any additional setup after loading the view.
        
        
    }
    
    
    @IBAction func submitUser(sender: AnyObject) {
        userDescript = userDescriptionOutlet.text
        userGuestID = "\(userFBID)_1"
        userHostID = "\(userFBID)_0"
        userDeviceID = "\(UIDevice.currentDevice())"
        databaseWork.uploadUser(userAgeInt, userDescript: userDescript, userFBID: userFBID, userFirstName: userNameOutlet.text!, userLastName: userLastNameStr, deviceID: userDeviceID, userGuestID: userGuestID, userHostID: userHostID, gender: userGenderOutlet.text)
    }
    
    @IBAction func viewTapped(sender : AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func testUserInfo(sender : AnyObject){
        println("end of button press")
        /*
        if(true){
            performSegueWithIdentifier("moveToHomeScreenSegue", sender: self)
        }
        */
    
    }
    /*  Current User Delegates */
    func retreivedUserWithID(currentUser: User) {
        println(currentUser.firstName)
    }
    func failedToRetreiveUser(error: NSError) {
        println(error)
    }
    
    func dateFromString(date : String) -> NSDate {
        var string : NSString =  NSString(string: (date)) as NSString
        var formatter = NSDateFormatter()
        formatter.dateFormat = "mm/dd/yyyy"
        var date : NSDate = formatter.dateFromString(string)!
        return date
    }
    
    /*facebook delegates*/
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        
        userNameOutlet.text = user.first_name
        userLastNameStr = user.last_name
        userAgeInt = Int((dateFromString(user.birthday).timeIntervalSinceNow)/(-31557600))
        userAgeOutlet.text = "\(userAgeInt)"
        userFBID = user.objectID
        //databaseDevil.checkToSeeIfUserExist(userFBID)
        println(userFBID)
        profilePic.profileID = userFBID
        
    }
    
    
    

}
