//
//  ProfileViewController.swift
//  theList
//
//  Created by William Akeson on 11/21/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, FBLoginViewDelegate, GetUserWithIdDelegate, MoveUserFromListsCompleteDelegate{
    
    
    @IBOutlet var ratingOutlet: UILabel!
    
    @IBOutlet var ageOutlet: UILabel!
    
    @IBOutlet var genderOutlet: UILabel!
    
    @IBOutlet var aboutMeOutlet: UITextView!
    
    @IBOutlet var rejectButton: UIButton!
    
    @IBOutlet var acceptButton: UIButton!
    
    @IBOutlet var fbLogin: FBLoginView!
    
    @IBOutlet var profilePic: FBProfilePictureView!
    
    let databaseDevil = DatabaseWork.sharedInstanceOfDatabase()
    
    var userID : String = ""
    var user : User!
    var segueIdentity : String = ""
    var guestAccepted : Bool!
    var event : Event!
    
    
    var pendingGuests : [User] = []
    var acceptedGuests : [User] = []
    var confirmedGuests : [User] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseDevil.moveUserFromListCompleteDelegate = self
        
        if (segueIdentity == "fromGuestListToGuestProfile"){
            rejectButton.hidden = false
            acceptButton.hidden = false
        }
    
        self.fbLogin.delegate = self
        databaseDevil.getUserWithIdDelegate = self
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func guestDecisionPressed(sender: UIButton) {
        if (sender == acceptButton){
            databaseDevil.addUserToAccepted(user.facebookID, eventRecord: event.record)
        }else if (sender == rejectButton){
//            databaseDevil.addUserToRejected(user.facebookID, eventRecord: event.record)
        }
//        databaseDevil.loadPendingGuests(event.pendingGuests)

    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        println("USER ID : ")
        println(userID)
        profilePic.profileID = userID
        databaseDevil.getUserWithID(userID)
        
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "guestDecisionMade") {
            println("done adding user to accepted")

            let eventVC : EventViewController = segue.destinationViewController as EventViewController
            eventVC.segueIdentity = segue.identifier
            eventVC.eventID = event.record.recordID.recordName
        }
    }

    func doneMovingUserFromList() {
        performSegueWithIdentifier("guestDecisionMade", sender: self)
    }
    func errorMovingUserFromList(){
        
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
