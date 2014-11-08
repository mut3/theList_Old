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
    
    var userNameStr : String = ""
    
    var userAgeInt : Int = 0
    
    var userDescript : String = ""
    
    var userFBID : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameOutlet.text = userNameStr
        userAgeOutlet.text = "\(userAgeInt)"
        userDescriptionOutlet.text = ""
        
        // Do any additional setup after loading the view.
    }
    
    func uploadUserInfo(){
        
    
    }

}
