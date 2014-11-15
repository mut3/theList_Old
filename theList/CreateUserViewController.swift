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
    
    @IBOutlet var profilePic: FBProfilePictureView!
    
  
    @IBOutlet var fbLoginView : FBLoginView!


    

    
    var userFirstNameStr : String = ""
    
    var userLastNameStr : String = ""
    
    var userAgeInt : Int = 0
    
    var userDescript : String = ""
    
    var userFBID : String = ""
    
    var userDeviceID : String = ("\(UIDevice.currentDevice())")
    
    var userGuestID : String = ""
    
    var userHostID : String = ""
  
    var profileID : String = ""
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameOutlet.text = userFirstNameStr
        userAgeOutlet.text = "\(userAgeInt)"
        userDescriptionOutlet.text = ""
        println(userFBID)
        
        
        self.fbLoginView.delegate = self
        
        
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends", "user_birthday"]

        
        }
      

        
        // Do any additional setup after loading the view.
    /*
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        
        //this is where we segue
    }
    */
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
      
        profilePic.profileID = user.objectID
      
        
    }
  
    
    
    @IBAction func submitUser(sender: AnyObject) {
        userDescript = userDescriptionOutlet.text
        databaseWork.uploadUser(userAgeInt, userDescript: userDescript, userFBID: userFBID, userFirstName: userFirstNameStr, userLastName: userLastNameStr, deviceID: userDeviceID, userGuestID: userGuestID, userHostID: userHostID)
    }

}
