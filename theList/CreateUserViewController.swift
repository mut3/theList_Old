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
    
    var userNameStr : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameOutlet.text = userNameStr
        
        // Do any additional setup after loading the view.
    }

}
