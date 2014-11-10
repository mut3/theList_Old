//
//  EventViewController.swift
//  theList
//
//  Created by William Akeson on 11/10/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    @IBOutlet var eventTitleOutlet: UILabel!
    var eventTitleStr : String = ""
    
    @IBOutlet var eventCapacityOutlet: UILabel!
    var eventCapStr : String = ""

    @IBOutlet var eventPictureOutlet: UIImageView!
    //var eventPicture : UIImage
    
    @IBOutlet var eventDescriptionOutlet: UITextView!
    var eventDescriptStr : String = ""
    
    
    @IBOutlet var eventTagsOutlet: UITableView!
    //var eventTagsList : [String]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventTitleOutlet.text = eventTitleStr
        eventCapacityOutlet.text = eventCapStr
        eventDescriptionOutlet.text = eventDescriptStr

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func goToHostScreen(sender: AnyObject) {
    }

    
    
    @IBAction func doNotAttendEventAction(sender: AnyObject) {
    }

    
    @IBAction func attendEventAction(sender: AnyObject) {
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
