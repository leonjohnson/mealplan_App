//
//  Util.swift
//  DailyMeals
//
//  Created by toobler on 6/2/16.
//  Copyright © 2016 Meals. All rights reserved.
//

import Foundation

class Util
{
    /**
     
     Method for check null in string and retun actual or space string.
     - parameter bar: checkNullString.
     - returns: sringForCheck.
     
     */
    class func checkNullString(_ key:String, pdt:NSDictionary) -> String{
        let value = pdt.object(forKey: key)
        
        if (value != nil) && !(value is NSNull) {
            return    ((pdt.object(forKey: key)!) as? String)!
        }else{
            return ""
        }
    }
}
