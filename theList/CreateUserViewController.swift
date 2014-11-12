//
//  CreateUserViewController.swift
//  theList
//
//  Created by CSCrew on 11/6/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController{
    
    @IBOutlet var userNameOutlet: UILabel!
    
    @IBOutlet var userAgeOutlet: UILabel!
    
    @IBOutlet var userDescriptionOutlet: UITextView!
    
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

}
