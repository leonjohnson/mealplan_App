//
//  ContactUsViewController.swift
//  DailyMeals
//
//  Created by Jithu on 3/14/16.
//  Copyright © 2016 Meals. All rights reserved.
//
//TO DO COMMENDTS (Add proper comments for all method)

import UIKit

class ContactUsViewController: UIViewController {
    
    //For SettingsTab bar
    var settingsControl : Bool?
    var fromController = NSString()
    @IBOutlet var titleDistanceConstraint: NSLayoutConstraint!
    @IBOutlet var textviewborder : UIView!
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var feedBackText : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Done button View for Serving Size Text Field keyboard
        let barButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: feedBackText, action: #selector(UIResponder.resignFirstResponder))
        //let barButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: valServing, action: "resignFirstResponder")
        barButton.tintColor = UIColor.black
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        toolbar.items = [barButton]
        feedBackText.inputAccessoryView = toolbar

        
        //Adding Border color & Width
        textviewborder?.layer.borderColor = UIColor.lightGray.cgColor
        textviewborder?.layer.borderWidth = 1
        
        //KeyBoard action for: move view up when keyboard appears
        NotificationCenter.default.addObserver(self, selector: #selector(ContactUsViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactUsViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)



        // Do any additional setup after loading the view.
    }
    
    //KeyBoard Method for: move view up when keyboard appears
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.textviewborder.frame.size.height -= keyboardSize.height
            self.titleDistanceConstraint.constant = 270

        }
        
    }
    
    //KeyBoard Method for: move view down when keyboard appears
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.textviewborder.frame.size.height += keyboardSize.height
            self.titleDistanceConstraint.constant = 2
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //To display Regestered Users name on Meal Plan's page
        nameLabel.text = DataHandler.getActiveUser().name + ",we'd love to hear from you."

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Method for Navigating back to previous ViewController.
    @IBAction func closeAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
