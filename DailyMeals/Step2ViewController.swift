//
//  Step2ViewController.swift
//  DailyMeals
//
//  Created by Jithu on 3/14/16.
//  Copyright © 2016 Meals. All rights reserved.
//
//TO DO COMMENDTS (Add proper comments to all method)
import UIKit

class Step2ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //var fromController = NSString()
    
    @IBOutlet var categoryView : UIView!
    
    @IBOutlet var backButton : UIButton!
    @IBOutlet var step2NextButton : mpButton!
    @IBOutlet var closeButton : UIButton!
    @IBOutlet var areYouLabel : UILabel!
    @IBOutlet var dietRequirementTable : UITableView!
    
    
    let types = ["Vegetarian","Vegan","Pescatarian","None of the above"]
    
    var selectedPath = 4;
    
    //variable created for constant class
    let profile = Biographical();
 
    //For SettingsTab bar
    var settingsControl : Bool?
    
    
    var activeDietValue:String = ""
    
    //Deafult Value setting
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To hide close button when app. loads normaly from Profile view.
        closeButton.hidden = true

        //Setup Default value when loading from settings Page:
        //For Diet:
        if (settingsControl != nil) {
            
            //Close Button whn app. loads from settings view.
            closeButton.hidden = false
            
        activeDietValue = DataHandler.getActiveBiographical().dietaryMethod!
        selectedPath = types.indexOf(activeDietValue)!
        }

        areYouLabel.font = Constants.GENERAL_LABEL
        dietRequirementTable.setContentOffset(CGPoint(x: 0, y: 5), animated: false)
        
        //To set Border color for GenderView
        //categoryView?.layer.borderColor = UIColor .lightGrayColor().CGColor
        //categoryView?.layer.borderWidth = 1
        
    }
    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func closeAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = types[indexPath.row];
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = item;
        cell.textLabel?.font = Constants.STANDARD_FONT
        if (selectedPath == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPath = indexPath.row;
        tableView.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //IBAction for NextButton Clicked in Step2 VC. Saving all datas into an ProfileClass.
    @IBAction func step2NextButtonClicked (sender : AnyObject){
        //Saving Values to the Varible Declared for ProfileStep2 constant class.
        if (selectedPath == 4){
            let alert = UIAlertController(title: "", message: "Select your dietary needs", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
            return
            
        }
        
        DataHandler.updateProfileDiet(types[selectedPath])
        
        //if from Settings Tab bar View.
        if ((settingsControl) != nil){
            self.navigationController?.popViewControllerAnimated(true)
        }
        else{
        self.performSegueWithIdentifier("step2Identifier", sender: nil)
        }

        
    }
    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func BackAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
