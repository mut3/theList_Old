//
//  CreateNewEventViewController.swift
//  theList
//
//  Created by Joey Anetsberger on 11/8/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit
import CoreLocation

class CreateEventViewController: UIViewController, CLLocationManagerDelegate {
    
    var eventName : String!
    var eventLocation : CLLocation!
    var eventLocationWritten : String!
    var eventTimeStart : String!
    var eventTimeEnd : String!
    var eventDate : String!
    var eventCapacity : Int!
    var eventTag : String!
    var eventDescription : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        //        let geocoder = LocationsModel()
        //geocoder.getCurrentLocation()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        println((CLLocationManager.locationServicesEnabled()))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* Geocoding **********************************************************/
    
    let currentLocation =  "44.479239, -73.198286"
    let currentLocName = "192 pine st burlington vt"
    
    var myLocation = ""
    
    var locationManager = CLLocationManager()
    var geocoder = CLGeocoder()
    
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: " + error.localizedDescription)
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        //Gets location to apple's server, which processes and returns location.
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            if (error != nil) {
                
                let errorString = "Error" + error.localizedDescription
                println("Error: " + error.localizedDescription)
                self.clearAllAddressFields()
                return
            }
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                //                self.displayLocationInfo(pm)
            }
            else {
                println("Error with data")
                
            }
            
        })
        
    }
    
    
    func getCurrentLocation(/*manager: CLLocationManager!*/ location : String) {
        //Gets location to apple's server, which processes and returns location.
        /*CLGeocoder().reverseGeocodeLocation(manager.location
        */      geocoder.geocodeAddressString(self.currentLocName, completionHandler: { (placemarks, error) -> Void in
            println(self.locationManager.location)
            
            if (error != nil) {
                let errorString = "Error" + error.localizedDescription
                println("Error: " + error.localizedDescription)
                self.clearAllAddressFields()
                return
            }
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                println("LOCATION")
                self.displayLocationInfo(pm)
                self.locationAddressField.text = pm.thoroughfare
                self.locationCityField.text = pm.locality
                self.locationZipField.text = pm.postalCode
                self.locationStateField.text = pm.administrativeArea
                self.locationAddressField.enabled = true
                self.eventLocation = pm.location
            }
            else {
                println("Error with data")
            }
        })
    }
    
    
    
    
    func displayLocationInfo(placemark: CLPlacemark) {
        
        self.locationManager.stopUpdatingLocation()
        println(placemark.locality)
        println(placemark.postalCode)
        println(placemark.administrativeArea)
        println(placemark.country)
        
        let address = placemark.locality + ", " + placemark.postalCode
        self.myLocation = address
        
        println(address)
    }
    
    func forwardGeocode(loc: String) {
        var placemark: CLPlacemark!
        
        geocoder.geocodeAddressString(loc, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            
            if (error != nil) {
                let errorString = "Error" + error.localizedDescription
                println("Error: " + error.localizedDescription)
                
                return
            }
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                self.eventLocation = pm.location
                println(self.eventLocation)
                if(self.locationCityField.text == ""){
                    self.locationCityField.text = pm.locality
                    self.locationStateField.text = pm.administrativeArea
                }
                else if(self.locationZipField.text == "") {
                    self.locationZipField.text == pm.postalCode
                }
            }
            else {
                println("Error with data")
            }
        })
    }
    
    /*
        the next function prepares for a segue to the event page
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToEventSegue"{
            println("we are preparing to go the event screen")
            let eventMadeVC : EventViewController = segue.destinationViewController as EventViewController
            eventMadeVC.eventDescriptStr = descriptionTextArea.text
            eventMadeVC.eventTitleStr = eventNameField.text
            eventMadeVC.eventCapStr = capacityTextField.text
        }
    }
    
    
    
    
    
    /* UI Object code *****************************************/
    
    @IBOutlet var eventNameField : UITextField!
    
    @IBOutlet var locationTypeSwitch : UISwitch!
    @IBOutlet var locationTypeLabel : UILabel!
    
    @IBOutlet var locationAddressField : UITextField!
    @IBOutlet var locationCityField : UITextField!
    @IBOutlet var locationZipField : UITextField!
    @IBOutlet var locationStateField : UITextField!
    
    @IBOutlet var timeStartTextField : UITextField!
    @IBOutlet var timeEndTextField : UITextField!
    @IBOutlet var dateTextField : UITextField!
    
    @IBOutlet var capacityTextField : UITextField!
    @IBOutlet var tagsTextField : UITextField!
    @IBOutlet var descriptionTextArea : UITextView!
    @IBOutlet var pictureImageView : UIImageView!
    
    
    @IBAction func locationTypeSwitched(sender : AnyObject) {
        //locationTypeSwitch.setOn(!locationTypeSwitch.on, animated: true)
        locationTypeLabel.text = locationTypeSwitch.on ? "Current Location" : "Enter Address"
        locationAddressField.enabled = !locationTypeSwitch.on
        if(locationTypeSwitch.on) {
            getCurrentLocation(/*locationManager*/currentLocName)
        }
        //        locationZipField.enabled = !locationTypeSwitch.on
        //        locationCityField.enabled = !locationTypeSwitch.on
        //        locationStateField.enabled = !locationTypeSwitch.on
    }
    
    
    @IBAction func viewTapped(sender : AnyObject) {
        view.endEditing(true)
    }
    
    
    @IBAction func addPictureButtonPressed(sender : AnyObject) {
        let imagePicker : UIImagePickerController = UIImagePickerController()
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func enteringStreetAddress(sender : AnyObject) {
        if(countElements(locationAddressField.text) > 5 && !(locationTypeSwitch.on)) {
            locationZipField.enabled = true
            locationCityField.enabled = true
        }
    }
    
    
    @IBAction func doneEnteringZip(sender : AnyObject) {
        if(countElements(locationZipField.text) == 5) {
            forwardGeocode(locationAddressField.text + ", " + locationZipField.text)
        }
    }
    
    
    @IBAction func enteringCity(sender : AnyObject) {
        if(countElements(locationCityField.text) > 3) {
            locationStateField.enabled = true
        }
    }
    
    
    @IBAction func doneEnteringState(sender: AnyObject) {
        let enteredLocation = (locationAddressField.text + ", " + locationCityField.text + ", " + locationStateField.text)
        if(countElements(locationStateField.text) == 2){
            forwardGeocode(enteredLocation)
        }
    }
    
    
    @IBAction func createEventButtonPressed(sender : AnyObject) {
        
//        var eventName : String!
//        var eventLocation : CLLocation!
//        var eventLocationWritten : String!
//        var eventTimeStart : String!
//        var eventTimeEnd : String!
//        var eventDate : String!
//        var eventCapacity : Int!
//        var eventTag : String!
//        var eventDescription : String!
        
        eventName = eventNameField.text
        eventLocationWritten = locationAddressField.text  + ", " + locationCityField.text + ", " + locationStateField.text + " " + locationZipField.text
        eventTimeStart = timeStartTextField.text
        eventTimeEnd = timeEndTextField.text
        eventDate = dateTextField.text
        eventTag = tagsTextField.text
        eventCapacity = capacityTextField.text.toInt()
        eventDescription = descriptionTextArea.text
        
        println(eventLocation)
        
        var tempEventTagArray : [String] = [eventTag, ""]
        var photos : [String] = ["dd","aa"]

        let eventStartTimeObject = dateFromString(eventDate, time: eventTimeStart)
        let eventEndTimeObject = dateFromString(eventDate, time: eventTimeEnd)
        
        databaseWork.uploadEvent(eventCapacity, eventDescript: eventDescription, eventEndtime: eventEndTimeObject, eventStartTime: eventStartTimeObject, eventName: eventName, hostID: "12314", eventTags: tempEventTagArray, photoList: photos, eventLocation: eventLocation, writtenLocation: eventLocationWritten)
    }
    
    
    func dateFromString(date : String, time : String) -> NSDate {
        var string : NSString =  NSString(string: (date + " " + time)) as NSString
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm"
        var gmt = NSTimeZone(abbreviation: "GMT-5")
        formatter.timeZone = gmt
        var date : NSDate = formatter.dateFromString(string)!
        return date
    }
    
    func clearAllAddressFields() {
        locationAddressField.text = ""
        locationCityField.text = ""
        locationZipField.text = ""
        locationStateField.text = ""
        locationZipField.enabled = false
        locationStateField.enabled = false
        locationCityField.enabled = false
        locationAddressField.placeholder = "Address"
        locationCityField.placeholder = "City"
        locationZipField.placeholder = "Zip"
        locationStateField.placeholder = "State"
    }
    
    
    
    
    
    
    
}
