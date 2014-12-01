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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        var guestDecisionSegue = "guestDecisionMade"
        if (sender == acceptButton){
            guestAccepted = true
        }else if (sender == rejectButton){
            guestAccepted = false
        }
        performSegueWithIdentifier(guestDecisionSegue, sender : self)
    }
    
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
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
            let guestListVC : GuestListViewController = segue.destinationViewController as GuestListViewController
            if(guestAccepted == true) {
                databaseDevil.addUserToAccepted(user.facebookID, eventRecord: event.record)
//                guestListVC.acceptedGuests.append(user)
//                let guestIndex = find(guestListVC.pendingGuests, user)!
//                guestListVC.pendingGuests.removeAtIndex(guestIndex)
////                let updatedPendingGuests = guestListVC.pendingGuests.fi
                
            }
            else {
                
            }
            
        
            guestListVC.segueIdentity = segue.identifier
           }
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
