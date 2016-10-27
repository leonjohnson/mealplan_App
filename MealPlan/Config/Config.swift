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
    static func getStringValue(_ key:String ,withDefault :String)->NSString{
        if let value = UserDefaults.standard.string(forKey: key) {
            return value as NSString
        }
        return withDefault as NSString
    }
    // GET A BOOL VALUE
    static func getBoolValue(_ key:String )->Bool{
        return  UserDefaults.standard.bool(forKey: key)
    }
    // SET A BOOL VALUE
    static func setBoolValue(_ key:String ,status :Bool ){
        let userDefaults = UserDefaults.standard
        userDefaults.set(status, forKey: key)
        userDefaults.synchronize()
    }
    // SET A STRING VALUE
    static func setStringValue(_ key:String ,status :String ){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(status, forKey: key)
        userDefaults.synchronize()
    }
    // GET API KEY 
    static func getApiKey()->String{
        return Constants.KEY_EMPTY;
    }
    //SHOW AN ALERT
    static func showAlert( _ title:String?,message:String){
        hideAlert()
        if(title == nil){
        }
    }
    //HIDE AN ALERT
    static func hideAlert(){
        
    }
    
    
}
