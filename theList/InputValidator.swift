//
//  InputValidator.swift
//  theList
//
//  Created by Joey Anetsberger on 11/19/14.
//  Copyright (c) 2014 Abeba Lab. All rights reserved.
//

import Foundation

class InputValidator {
    
    let states : NSArray
    
    init() {
        states = ["AL","AK","AZ","AR","CA","CO","CT","DE","FL","GA","HI","ID","IL","IN","IA",
            "KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ",
            "NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT",
            "VA","WA","WV","WI","WY"]
        
    }
    
    func isDigit(str : String) -> Bool {
        var isDigit = true
        if let n = str.toInt() {
            isDigit = true
        }
        else {
            isDigit = false
        }
        return isDigit
    }
    
    func areAllDigits(values : [String]) -> Bool {
        var areDigits = true
        for item in values {
            if(!isDigit(item)) {
                areDigits = false
            }
        }
        return areDigits
    }
    
    
    func isAddressFormat(address : String) -> Bool {
        var isCorrectFormat = true
        let addressTokens = address.componentsSeparatedByString(" ")
        
        if(!isDigit(addressTokens[0]) && addressTokens[0].toInt() > 0){
            isCorrectFormat = false
        }
        
        if(addressTokens.count <= 1 || (addressTokens.count > 1 && !(countElements(addressTokens[1]) > 2))) {
            isCorrectFormat = false
        }
        
        return isCorrectFormat
    }
    
    
    func isValidState(state : String) -> Bool {
        let isState = states.containsObject(state)
        return isState
    }
    
    
    func isZipFormat(value : String) -> Bool {
        var isZip = true
        if(!isDigit(value) || countElements(value) != 5) {
            isZip = false
        }
        return isZip
    }

    
    func isValidMonth(value : String) -> Bool {
        var isMonth = false
        if(isDigit(value)) {
            if(value.toInt() <= 12 && value.toInt() > 0) {
                isMonth = true
            }
        }
        return isMonth
    }
    
    func isValidDay(day : String, month : String) -> Bool {
        var isDay : Bool = false
        let shortMonths : NSArray = ["04", "4", "06", "6", "09", "9", "11"]
        if(isDigit(day) && isDigit(month) && day.toInt() > 0) {
            if(month.toInt() == 2) {
                if(day.toInt() <= 29) {
                    isDay = true
                }
            }
            else if(shortMonths.containsObject(month)) {
                if(day.toInt() <= 30) {
                    isDay = true
                }
            }
            else {
                if(day.toInt() <= 31) {
                    isDay = true
                }
            }
        }
        return isDay
        
    }
    
    //September November April June
    
    func isDateFormat(date : String) -> Bool {
        var isDate = true
        
        let valuesTokens = date.componentsSeparatedByString("/")
        
        if(valuesTokens.count != 3 || !areAllDigits(valuesTokens) || containsNegative(valuesTokens)) {
            isDate = false
        }
        else if(!isValidMonth(valuesTokens[0]) || !isValidDay(valuesTokens[1], month: valuesTokens[0]) || valuesTokens[2].toInt() < 2014) {
            isDate = false
        }
        
        return isDate
    
    }
    
    func isTimeFormat(time : String) -> Bool {
        var isTime = true
        let valuesTokens = time.componentsSeparatedByString(":")
        
        if(valuesTokens.count != 2 || !(areAllDigits(valuesTokens)) || containsNegative(valuesTokens)) {
            isTime = false
        }
        else if(valuesTokens[0].toInt() > 12  || valuesTokens[1].toInt() > 59) {
            isTime = false
        }
        return isTime
    }
    
    func containsNegative(values : [String]) -> Bool {
        var containsNegative = false
        for item in values {
            if(isDigit(item) && item.toInt() < 0) {
                containsNegative = true
            }
            
        }
        return containsNegative
    }

}