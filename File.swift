//
//  File.swift
//  theList
//
//  Created by CSCrew on 11/30/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import Foundation





if placemarks.count > 0 {
    placemark = placemarks[0] as CLPlacemark
    print(locs[0] + " CORRESPONDS TO: ")
    println(placemark.location)
    self.placemarkArray.append(placemark)
    var newArray = [String]()
    if(locs.count > 1) {
        newArray = [String](locs[1...(locs.count - 1)])
        self.forwardGeocodeList(newArray)
    }
    
}