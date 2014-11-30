//
//  GuestListViewController.swift
//  theList
//
//  Created by CSCrew on 11/28/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit

class GuestListViewController: UITableViewController {
    
    let database : DatabaseWork = DatabaseWork.sharedInstanceOfDatabase()
    
    var pendingGuests : [String]!
    var acceptedGuests : [String]!
    var confirmedGuests : [String]!
    
    var pendingGuestNames : [String]!
    var acceptedGuestNames : [String]!
    var confirmedGuestNames : [String]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        //should make three sections of table
    }
    
}