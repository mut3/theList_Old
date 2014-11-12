//
//  LoginViewController.swift
//  theList
//
//  Created by CSCrew on 11/6/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit
import CloudKit
import Foundation

protocol UserFacebookInfoDelegate{
    func passFacebookInfoToCreatePage(controller : LoginViewController,name : String, age : Int)
}


class LoginViewController: UIViewController, FBLoginViewDelegate {
    
    
    @IBOutlet var fbLoginView : FBLoginView!
    
    @IBOutlet var profilePic: FBProfilePictureView!
    
    
    var userFbDelegate: UserFacebookInfoDelegate?
    
    /*
        facebook info variables
    */
    var userFirstName : String!
    var userBirthday : String!
    var userFacebookID : String!
    var userLastName : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.fbLoginView.delegate = self
        
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends", "user_birthday"]
        
            
    }
    
    @IBAction func goToCreateProfile(sender: UIButton) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mySegue2"{
            println("where are we?")
            let createUserVC : CreateUserViewController = segue.destinationViewController as CreateUserViewController
            println(userFirstName)
            createUserVC.userFirstNameStr = userFirstName
            createUserVC.userLastNameStr = userLastName
            createUserVC.userFBID = userFacebookID
            createUserVC.userAgeInt = 22
            createUserVC.userGuestID = "\(userFacebookID)_1"
            createUserVC.userHostID = "\(userFacebookID)_0"
        }
        else if segue.identifier == "homeSegue"{
            println("fuck are we?")
        }
    }
    
    
    
    
    
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        
        //this is where we segue 
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
        //println("User Name: \(user.name)")
        userFirstName = user.first_name
        userLastName = user.last_name
        userBirthday = user.birthday
        userFacebookID = user.objectID

        //profilePic.profileID=user.objectID
        
        //println(userBirthday)
        
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
        userFirstName = ""
        userLastName = ""
        userBirthday = ""
        userFacebookID = ""
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
