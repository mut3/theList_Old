//
//  GuestListViewController.swift
//  theList
//
//  Created by CSCrew on 11/28/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit

class GuestListViewController: UITableViewController {
    
    var pendingGuests : [String]!
    var acceptedGuests : [String]!
    var confirmedGuests : [String]!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
        //should make three sections of table
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        var givenUser = [indexPath.row]
        var eventName = givenEvent[1]
        //        println(eventName)
        cell.textLabel.text = eventName
        return cell
    }
    
    func populateLists
    {
        //This needs to iterate through each of the three lists
        //for each GuestID it will create a cell with that guests name in it
    }
    
}