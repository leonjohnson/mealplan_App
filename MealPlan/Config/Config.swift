//
//  Config.swift
//  DailyMeals
//
//  Created by Mzalih on 05/04/16.
//  Copyright © 2016 Meals. All rights reserved.
//

import UIKit

class Config: NSObject {
    static let HAS_PROFILE = "hasProfile"
    
    
    // GET A STRING VALUE
    static func getStringValue(key:String ,withDefault :String)->NSString{
        if let value = NSUserDefaults.standardUserDefaults().stringForKey(key) {
            return value
        }
        return withDefault
    }
    // GET A BOOL VALUE
    static func getBoolValue(key:String )->Bool{
        return  NSUserDefaults.standardUserDefaults().boolForKey(key)
    }
    // SET A BOOL VALUE
    static func setBoolValue(key:String ,status :Bool ){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(status, forKey: key)
        userDefaults.synchronize()
    }
    // SET A STRING VALUE
    static func setStringValue(key:String ,status :String ){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(status, forKey: key)
        userDefaults.synchronize()
    }
    // GET API KEY 
    static func getApiKey()->String{
        return Constants.KEY_EMPTY;
    }
    //SHOW AN ALERT
    static func showAlert( title:String?,message:String){
        hideAlert()
        if(title == nil){
        }
    }
    //HIDE AN ALERT
    static func hideAlert(){
        
    }
    
    
}
