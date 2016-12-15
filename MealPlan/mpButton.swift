//
//  mpButton.swift
//  DailyMeals
//
//  Created by Leon Johnson on 09/06/2016.
//  Copyright © 2016 Meals. All rights reserved.
//

import UIKit

class mpButton: UIButton {

    var colour : UIColor?
    override func draw(_ rect: CGRect) {
        
        let defaultColour = UIColor(red: 0.529, green: 0.839, blue: 0.780, alpha: 1.000)
        let myframe = self.frame
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: myframe.origin.x, y: myframe.origin.y, width: myframe.size.width, height: myframe.size.height),cornerRadius: 40)
        if colour != nil{
            colour?.setFill()
        } else {
            defaultColour.setFill()
        }
        rectanglePath.fill()
    }
}
