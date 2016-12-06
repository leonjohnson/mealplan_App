//
//  AboutUsViewController.swift
//  DailyMeals
//
//  Created by Jithu on 3/14/16.
//  Copyright © 2016 Meals. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    //For SettingsTab bar
    var settingsControl : Bool?
    var fromController = NSString()



    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(NSURLRequest(url: NSURL(string: Constants.ABOUT_US_URL)! as URL) as URLRequest)

        // Do any additional setup after loading the view.
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
