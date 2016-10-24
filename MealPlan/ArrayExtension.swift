//
//  ArrayExtension.swift
//  DailyMeals
//
//  Created by Leon Johnson on 16/06/2016.
//  Copyright © 2016 Meals. All rights reserved.
//

import UIKit

// Swift 2 Array Extension
extension Array where Element: Equatable {
    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
    
    mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}
