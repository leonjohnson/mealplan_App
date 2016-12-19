//
//  explanationScreens.swift
//  Story
//
//  Created by Leon Johnson on 19/12/2016.
//  Copyright © 2016 Safiyan Zulfiqar. All rights reserved.
//

import UIKit

class ExplanationScreens: UIView {
    @IBOutlet var mainObject : UIView!
    @IBOutlet var textView : UITextView!
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var subText : UILabel!
    @IBOutlet var doneButton : UIButton!
    

    override func awakeFromNib() {
        
        textView.textAlignment = .center
        mainObject.layer.cornerRadius = 10
        mainObject.layer.borderWidth = 0.5
        mainObject.layer.borderColor =  Constants.MP_DARK_GREY.cgColor
        mainObject.backgroundColor = Constants.MP_LIGHT_GREY
        
        
        doneButton.frame = CGRect(origin: doneButton.frame.origin, size: CGSize(width:mainObject.frame.width, height:64))
        doneButton.backgroundColor = Constants.MP_WHITE
        doneButton.isEnabled = false
        doneButton.setTitleColor(Constants.MP_WHITE, for: .disabled)
        
        
    }
}
