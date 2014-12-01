//
//  NewEventViewController.swift
//  theList
//
//  Created by Joey Anetsberger on 11/15/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import CloudKit

class NewEventViewController: UITableViewController, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UploadingEventDelegate /*UIPickerViewDataSource,UIPickerViewDelegate*/{
    
    var segueID : String!
    
    var eventName : String = ""
    var eventStreetAddress : String = ""
    var eventCity : String = ""
    var eventZip : String = ""
    var eventState : String = ""
    var currentLocation : CLLocation!
    var enteredLocation : CLLocation!
    var eventLocation : CLLocation!
    var eventLocationWritten : String = ""
    var eventTimeStart : String = ""
    var eventTimeEnd : String = ""
    var eventDate : String = ""
    var eventCapacity : Int = 0
    var eventRecord : CKRecord!
    
    var eventImages : [CKAsset] = []
    var numberOfImages : Int = 0
    
    let invalidFieldColor : UIColor = UIColor(red: CGFloat(0.90), green: CGFloat(0.824), blue: CGFloat(0.824), alpha: CGFloat(1))
    let defaultFieldColor : UIColor = UIColor(red: CGFloat(1.0), green: CGFloat(1.0), blue: CGFloat(1.0), alpha: CGFloat(1))
    
    // EVENT TAGS VARIABLES
    var eventTag : String!
    var eventTags : [String] = []
    var eventTagName : String!
    var tagPicked  = false
    
    let eventTagChoices = ["PreGame","Dance","Cocktail","Sports","AfterParty","420","BYOB","Cover"]
    var eventDescription : String!
    
    
    // user ID that is pasted through
    var userID : String = ""
    
    /*
    the adding text shift constant
    */
    let AddTagsShifter = 40
    
    let validator : InputValidator = InputValidator()
    
    var addTagsCounter = 0
    
    let databaseThing : DatabaseWork = DatabaseWork.sharedInstanceOfDatabase()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseThing.uploadEventDelegate = self
        
        
        if (segueID != nil && segueID == "recreateOldEvent" || eventCapacity > 0){
            locationTypeSwitch.on = false
            println("cap was passed")
            self.capacityTextField.text = "\(eventCapacity)"
            self.timeStartTextField.text = "\(eventTimeStart)"
            self.timeEndTextField.text = "\(eventTimeEnd)"
            let addressTokens = eventLocationWritten.componentsSeparatedByString(", ")
            self.locationAddressField.text = addressTokens[0]
            self.locationCityField.text = addressTokens[1]
            self.locationStateField.text = addressTokens[2].componentsSeparatedByString(" ")[0]
            self.locationZipField.text = addressTokens[2].componentsSeparatedByString(" ")[1]
            
            
            println(locationAddressField.text)
            //self.locationAddressField.text = "\(eventLocationWritten)"
            self.tagsTextField.text = ""
            for tag in eventTags{
                if (self.tagsTextField.text == ""){
                    self.tagsTextField.text = tag
                }else {
                self.tagsTextField.text = "\(self.tagsTextField.text), \(tag)"
                }
            }
            self.descriptionTextArea.text = eventDescription
        }
//        tagsPickerOutlet.hidden = true
//        tagsPickerOutlet.delegate = self
//        tagsPickerOutlet.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        //println((CLLocationManager.locationServicesEnabled()))
        
        self.eventNameField.text = eventName
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        getCurrentLocation(locationManager)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* Geocoding **********************************************************/
    
//    let currentLocation =  "44.479239, -73.198286"
//    let currentLocName = "192 pine st burlington vt"
    
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
//                self.clearAllAddressFields()
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
    
    
    func getCurrentLocation(manager: CLLocationManager!) {
        //Gets location to apple's server, which processes and returns location.
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
//            println(self.locationManager.location)
            
            if (error != nil) {
                let errorString = "Error" + error.localizedDescription
                println("Error: " + error.localizedDescription)
//                self.clearAllAddressFields()
                return
            }
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
//                println("LOCATION")
//                self.displayLocationInfo(pm)
                self.locationAddressField.text = pm.thoroughfare
                self.locationCityField.text = pm.locality
                self.locationZipField.text = pm.postalCode
                self.locationStateField.text = pm.administrativeArea
                self.locationAddressField.enabled = true
                self.currentLocation = pm.location
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
                self.enteredLocation = pm.location
//                println(self.eventLocation)
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
        if segue.identifier == "fromCreate" {
            println("we are preparing to go the event screen")
            let eventMadeVC : EventViewController = segue.destinationViewController as EventViewController
            eventMadeVC.eventID = eventRecord.recordID.recordName
            eventMadeVC.segueIdentity = "fromCreate"
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
        locationTypeLabel.text = locationTypeSwitch.on ? "Current Location" : "Enter location"
        if(locationTypeSwitch.on) {
            getCurrentLocation(locationManager)
            locationStateField.enabled = false
            locationZipField.enabled = false
            locationCityField.enabled = false
        }
        else {
            clearAllAddressFields()
            locationStateField.enabled = true
            locationZipField.enabled = true
            locationCityField.enabled = true
        }
    }
    
    
    @IBAction func viewTapped(sender : AnyObject) {
        view.endEditing(true)
    }
    
    
    @IBAction func addPictureButtonPressed(sender : AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            //println("Button capture")
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            //imag.mediaTypes = [kUTTypeImage];
            imag.allowsEditing = false
            self.presentViewController(imag, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage = image


        pictureImageView.image=selectedImage
        
        let imageData = UIImageJPEGRepresentation(selectedImage, 90)
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths[0] as String
        let myFilePath = documentDirectory.stringByAppendingPathComponent("eventImage \(numberOfImages)")
        imageData.writeToFile(myFilePath, atomically: true)
        let url = NSURL(fileURLWithPath: myFilePath)
        println(url)
        let asset = CKAsset(fileURL: url)
        numberOfImages += 1
        eventImages.append(asset)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func doneEnteringEventName(sender : AnyObject) {
        eventName = eventNameField.text
    }
    
    
    @IBAction func enteringStreetAddress(sender : AnyObject) {

    }
    @IBAction func doneEnteringStreetAddress(sender : AnyObject) {
        println("done entering address")
        eventStreetAddress = locationAddressField.text
        if(locationTypeSwitch.on) {
            forwardGeocode(locationAddressField.text + ", " + locationZipField.text)
        }
    }
    
    @IBAction func restoreDefaultColor(sender : UITextField) {
//        println("Inside default color restore")
        sender.backgroundColor = defaultFieldColor
        
    }
    
    
    @IBAction func enteringCity(sender : AnyObject) {
        if(countElements(locationCityField.text) > 3) {
            locationStateField.enabled = true
        }
    }
    @IBAction func doneEnteringCity(sender : AnyObject) {
        eventCity = locationCityField.text
    }
    
    
    @IBAction func enteringZip(sender : AnyObject) {
        let fieldContents = locationZipField.text

        if(countElements(fieldContents) > 5) {
            locationZipField.text = fieldContents.substringToIndex(advance(fieldContents.startIndex, 5))
        }
    }
    @IBAction func doneEnteringZip(sender : AnyObject) {
        if(validator.isZipFormat(locationZipField.text)) {
            forwardGeocode(locationAddressField.text + ", " + locationZipField.text)
        }
        eventZip = locationZipField.text
    }
    
    
    @IBAction func enteringState(sender: AnyObject) {
        let fieldContents = locationStateField.text
        if(countElements(locationStateField.text) > 2) {
            locationStateField.text = fieldContents.substringToIndex(advance(fieldContents.startIndex, 2))
        }
    }
    @IBAction func doneEnteringState(sender: AnyObject) {
        if(validator.isValidState(locationStateField.text)){
            let enteredLocation = (locationAddressField.text + ", " + locationCityField.text + ", " + locationStateField.text)
            forwardGeocode(enteredLocation)
        }
        locationStateField.text = locationStateField.text.uppercaseString
        eventState = locationStateField.text
    }
    
    @IBAction func hitDescriptionArea(sender : UITextView) {
        if(descriptionTextArea.text == "Must enter a description of at least 80 characters.") {
            descriptionTextArea.text = ""
        }
        descriptionTextArea.backgroundColor = defaultFieldColor
    
    }
    
    @IBAction func enteringDate(sender: AnyObject) {
//        let fieldContents = dateTextField.text
//        let fieldTokens = fieldContents.componentsSeparatedByString("/")
//        println(fieldTokens)
//        if(fieldTokens.count == 1) {
//            if(!validator.isDigit(fieldTokens[0])) {
//                dateTextField.text = ""
//            }
//        }
//        else if(fieldTokens.count == 2) {
//            if(!validator.isValidMonth(fieldTokens[0])) {
//                println("got here")
//                dateTextField.text = "\(fieldTokens[0])"
//            }
//            if(!validator.isDigit(fieldTokens[1])) {
//                dateTextField.text = "\(fieldTokens[0])/"
//            }
//        }
//        else if(fieldTokens.count == 3) {
//            if(!validator.isDigit(fieldTokens[2])) {
//                dateTextField.text = "\(fieldTokens[0])/\(fieldTokens[1])/"
//                println(dateTextField.text)
//            }
//        }
        return
    }
    
    @IBAction func doneEnteringDate(sender : AnyObject) {
        if(validator.isDateFormat(dateTextField.text)) {
            eventDate = dateTextField.text
        }
        else {
            //make field red.
        }
    }

    @IBAction func createEventButtonPressed(sender : AnyObject) {
        
        if(areAllValidFields() && haveConsistentLocation()) {
            
            if(locationTypeSwitch.on) {
                eventLocation = currentLocation
            }
            else {
                eventLocation = enteredLocation
            }
            
            println("create event pressed, valid fields")
            
            eventName = eventNameField.text
            eventLocationWritten = locationAddressField.text  + ", " + locationCityField.text + ", " + locationStateField.text + " " + locationZipField.text
            eventTimeStart = timeStartTextField.text
            eventTimeEnd = timeEndTextField.text
            eventDate = dateTextField.text
            eventCapacity = capacityTextField.text.toInt()!
            eventDescription = descriptionTextArea.text
            
            
            let eventStartTimeObject = dateFromString(eventDate, time: eventTimeStart)
            let eventEndTimeObject = dateFromString(eventDate, time: eventTimeEnd)
            eventTags = (tagsTextField.text).componentsSeparatedByString(", ")
            let hostID = CurrentUserData.getSharedInstanceOfUserData().getFacebookID()
            let hostName = CurrentUserData.getSharedInstanceOfUserData().getUserName()
            
            eventRecord = databaseWork.uploadEvent(eventCapacity, eventDescript: eventDescription, eventEndtime: eventEndTimeObject, eventStartTime: eventStartTimeObject, eventName: eventName, hostID: hostID, hostName: CurrentUserData.getSharedInstanceOfUserData().getUserName(), eventTags: eventTags, photoList: eventImages, eventLocation: eventLocation, writtenLocation: eventLocationWritten)
    
            
        }
//        
//        eventName = eventNameField.text
//        eventLocationWritten = locationAddressField.text  + ", " + locationCityField.text + ", " + locationStateField.text + " " + locationZipField.text
//        eventTimeStart = timeStartTextField.text
//        eventTimeEnd = timeEndTextField.text
//        eventDate = dateTextField.text
//        //eventTag = tagsTextField.text
//        eventCapacity = capacityTextField.text.toInt()
//        eventDescription = descriptionTextArea.text
//
//        
//        let eventStartTimeObject = dateFromString(eventDate, time: eventTimeStart)
//        let eventEndTimeObject = dateFromString(eventDate, time: eventTimeEnd)
//        eventTags = (tagsTextField.text).componentsSeparatedByString(", ")
//        
//        
//        eventRecord = databaseWork.uploadEvent(eventCapacity, eventDescript: eventDescription, eventEndtime: eventEndTimeObject, eventStartTime: eventStartTimeObject, eventName: eventName, hostID: "2", eventTags: eventTags, photoList: eventImages, eventLocation: eventLocation, writtenLocation: eventLocationWritten)
        
    }
    
    func haveConsistentLocation() -> Bool {
        var isConsistent = true
        println("Entered location: ")
        println(enteredLocation)
        
        if(locationTypeSwitch.on) {
            if(currentLocation == nil || enteredLocation == nil){
                isConsistent = false
            }
            else {
                println("Current Location: ")
                println(currentLocation)
                let distance = currentLocation.distanceFromLocation(enteredLocation)
                println(distance)
                if(!(distance < 100)) {
                    isConsistent = false
                
                }
            }
        }
        if(!isConsistent) {
            locationAddressField.placeholder = "Invalid address"
            locationAddressField.text = ""
            locationAddressField.backgroundColor = invalidFieldColor
        }
        return isConsistent
    }
    
        
    func doneUploading(eventID: String) {
        performSegueWithIdentifier("fromCreate", sender : self)
    }
    
    
    func areAllValidFields() -> Bool {
        var areValid = true
        
        if(countElements(eventNameField.text) < 5) {
            eventNameField.backgroundColor = invalidFieldColor
            eventNameField.placeholder = "Must be 5+ characters"
            eventNameField.text = ""
            areValid = false
        }
        if(!validator.isAddressFormat(locationAddressField.text)) {
            locationAddressField.backgroundColor = invalidFieldColor
            locationAddressField.text = ""
            areValid = false
        }
        if(countElements(locationCityField.text) < 3) {
            locationCityField.backgroundColor = invalidFieldColor
            locationCityField.placeholder = "City Required"
            locationCityField.text = ""
            areValid = false
        }
        if(!validator.isValidState(locationStateField.text)) {
            locationStateField.backgroundColor = invalidFieldColor
            locationStateField.text = ""
            areValid = false
        }
        if(!validator.isZipFormat(locationZipField.text)) {
            locationZipField.backgroundColor = invalidFieldColor
            locationZipField.text = ""
            areValid = false
        }
        if(!validator.isDateFormat(dateTextField.text)) {
            dateTextField.backgroundColor = invalidFieldColor
            dateTextField.text = ""
            areValid = false
        }
        if(!validator.isTimeFormat(timeStartTextField.text)) {
            timeStartTextField.backgroundColor = invalidFieldColor
            timeStartTextField.text = ""
            timeStartTextField.placeholder = "00:00"
            areValid = false
        }
        if(!validator.isTimeFormat(timeEndTextField.text)) {
            timeEndTextField.backgroundColor = invalidFieldColor
            timeEndTextField.text = ""
            timeEndTextField.placeholder = "00:00"
            areValid = false
        }
        if(!validator.isDigit(capacityTextField.text) || capacityTextField.text.toInt() < 0) {
            capacityTextField.backgroundColor = invalidFieldColor
            capacityTextField.text = ""
            capacityTextField.placeholder = "0-200"
            areValid = false
        }
        let tagsTokens = tagsTextField.text.componentsSeparatedByString(", ")
        if(tagsTokens.count < 1 || tagsTokens[0] == "" || countElements(tagsTokens[0]) < 3) {
            tagsTextField.backgroundColor = invalidFieldColor
            tagsTextField.text = ""
            tagsTextField.placeholder = "Add at least one tag."
            areValid = false
        }
        //if(countElements(descriptionTextArea.text) < 80) {
        //    descriptionTextArea.backgroundColor = invalidFieldColor
        //    descriptionTextArea.text = "Must enter a description of at least 80 characters."
        //}
    
        return areValid
        
    }
    
    /* ********************************* TEST BUTTON ***/
    
    
    @IBAction func hitTestEntry(sender : AnyObject) {
        
        let numberModifier = Int(NSDate.timeIntervalSinceReferenceDate() % 100000)
        eventNameField.text = "Test Event #\(numberModifier)"
        
        locationAddressField.text = "33 colchester ave."
        locationCityField.text = "Burlington"
        locationZipField.text = "05401"
        locationStateField.text = "VT"
        
        forwardGeocode(locationAddressField.text + ", " + locationZipField.text)
        
        locationTypeSwitch.on = false
        
        timeStartTextField.text = "1:00"
        timeEndTextField.text = "2:00"
        dateTextField.text = "05/05/2015"

        capacityTextField.text = "10"
        tagsTextField.text = "Test01, test02, test03"
        descriptionTextArea.text = "This is a test event."
        
        
        
    }
    
    
    /* *************************************************/

    
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
        locationAddressField.placeholder = "Address"
        locationCityField.placeholder = "City"
        locationZipField.placeholder = "Zip"
        locationStateField.placeholder = "State"
    }
    
    
}


//
//    /*
//    createTagLabel function creates a label programmatically using the a certain position on the screen
//    it allows from multiple instances of itself to be called so a counter is passed and shifter constant
//    is used to push over the text so no overlap occurs.
//    */
//    func createTagLabel(tagName : String, tagNumber : Int) -> UILabel{
//        let screenSize : CGRect = UIScreen.mainScreen().bounds
//        var label = UILabel(frame: CGRectMake(0, 0, 200, 21))
//        var shiftAmount : CGFloat = 190 - CGFloat(AddTagsShifter*addTagsCounter)
//        let screenWidth = screenSize.width - shiftAmount;
//        let screenHeight = screenSize.height - 230;
//        label.center = CGPointMake(screenWidth,screenHeight)
//        label.textAlignment = NSTextAlignment.Center
//        label.text = tagName
//        label.font = UIFont(name : label.font.fontName, size : 14)
//        return label
//
//    }
//
//


    /*
    THE SET OF FUNCTIONS DEAL WITH PICKERVIEW DELEGATES AND DATA SOURCES
    */
    //  DATA SOURCES
//    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return eventTagChoices.count
//    }
    // DELEGATES
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
//        return eventTagChoices[row]
//    }
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        addTagsCounter = addTagsCounter + 1
//        self.eventTags.append(eventTagChoices[tagsPickerOutlet.selectedRowInComponent(0)])
//        var tagLabel = createTagLabel(eventTagChoices[tagsPickerOutlet.selectedRowInComponent(0)],tagNumber: addTagsCounter)
//        self.view.addSubview(tagLabel)
//        tagsPickerOutlet.hidden = true
//    }
//    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
//        var pickerLabel = view as UILabel!
//        if view == nil {
//            pickerLabel = UILabel()
//            let hueBase = CGFloat(0.4)
//            let hueChange : CGFloat = CGFloat(1.0) / CGFloat(eventTagChoices.count)
//            let hue = hueBase + (hueChange * CGFloat(row) * CGFloat(hueBase))
//            pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 0.8, brightness: 1.0, alpha: 1.0)
//            pickerLabel.textAlignment = .Center
//        }
//        let tagOption = eventTagChoices[row]
//        println(tagOption);
//        //Commented the below two lines out to build
//        //var tagTitle = NSAttributedString(string: tagOption, attributes: [NSFontAttributeName:UIFont(name: "Arial", size: 26.0),NSForegroundColorAttributeName:UIColor.blackColor()])
//        //pickerLabel!.attributedText = tagTitle
//        
//        return pickerLabel
//    }
//    
    
    



