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
    class func checkNullString(key:String, pdt:NSDictionary) -> String{
        let value = pdt.objectForKey(key)
        if ( value != nil && !(value?.isKindOfClass(NSNull))! )
        {
            return    ((pdt.objectForKey(key)!) as? String)!
        }
        else{
            return ""
        }
    }
    
    }
