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
    mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(_ array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}
