//
//  FindEventViewController.swift
//  theList
//
//  Created by Joey Anetsberger on 11/16/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class FindEventsViewController: UIViewController {
    
    @IBOutlet var distanceLabel : UILabel!
    @IBOutlet var distanceSlider : UISlider!
    @IBOutlet var tagsTextField : UITextField!
    
    var currentLocation : CLLocation!
    
    var lat : CLLocationDegrees = 44.479446
    var long : CLLocationDegrees = -73.198219
    

    
    override func viewDidLoad() {
        
        self.currentLocation = CLLocation(latitude: lat, longitude: long)
    }
    
    @IBAction func searchPressed() {
        let searchRadius : CLLocationDistance = Double(distanceSlider.value)
        println(searchRadius)
        databaseWork.fetchEventsWithRadius(searchRadius, currentLocation)
        
    }
    
}





