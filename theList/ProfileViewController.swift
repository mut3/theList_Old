//
//  ProfileViewController.swift
//  theList
//
//  Created by William Akeson on 11/21/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, FBLoginViewDelegate, GetUserWithIdDelegate{
    
    
    @IBOutlet var ratingOutlet: UILabel!
    
    
    @IBOutlet var ageOutlet: UILabel!
    
    
    @IBOutlet var genderOutlet: UILabel!
    
    
    @IBOutlet var aboutMeOutlet: UITextView!
    
    @IBOutlet var fbLogin: FBLoginView!
    

    
    @IBOutlet var profilePic: FBProfilePictureView!
    
    let databaseDevil = DatabaseWork.sharedInstanceOfDatabase()
    
    var userID : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fbLogin.delegate = self
        databaseDevil.getUserWithIdDelegate = self
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        
        profilePic.profileID = userID
        databaseDevil.getUserWithID(userID)
        println("USER ID : \(userID)")
        
    }
    
    func retreivedUserWithID(user: User) {
        self.title = user.firstName
        self.ageOutlet.text = "\(user.age)"
        self.aboutMeOutlet.text = user.descript
        self.genderOutlet.text = user.gender
    }
    
    func failedToRetreiveUser(error: NSError){
        println(error)
    }
    
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        loginView.hidden = false
        //        println("User Logged Out")
        performSegueWithIdentifier("userLoggedOut", sender:self)
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
