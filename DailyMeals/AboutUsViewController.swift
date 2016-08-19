//
//  AboutUsViewController.swift
//  DailyMeals
//
//  Created by Jithu on 3/14/16.
//  Copyright © 2016 Meals. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    
    //For SettingsTab bar
    var settingsControl : Bool?
    var fromController = NSString()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func closeAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
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
