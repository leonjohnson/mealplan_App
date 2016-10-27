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
        closeButton.isHidden = true

        //Setup Default value when loading from settings Page:
        //For Diet:
        if (settingsControl != nil) {
            
            //Close Button whn app. loads from settings view.
            closeButton.isHidden = false
            
        activeDietValue = DataHandler.getActiveBiographical().dietaryRequirement!
        selectedPath = types.index(of: activeDietValue)!
        }

        areYouLabel.font = Constants.GENERAL_LABEL
        dietRequirementTable.setContentOffset(CGPoint(x: 0, y: 5), animated: false)
        
        //To set Border color for GenderView
        //categoryView?.layer.borderColor = UIColor .lightGrayColor().CGColor
        //categoryView?.layer.borderWidth = 1
        
    }
    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func closeAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = types[indexPath.row];
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = item;
        cell.textLabel?.font = Constants.STANDARD_FONT
        if (selectedPath == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPath = indexPath.row;
        tableView.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //IBAction for NextButton Clicked in Step2 VC. Saving all datas into an ProfileClass.
    @IBAction func step2NextButtonClicked (_ sender : AnyObject){
        //Saving Values to the Varible Declared for ProfileStep2 constant class.
        if (selectedPath == 4){
            let alert = UIAlertController(title: "", message: "Select your dietary needs", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        
        DataHandler.updateProfileDiet(types[selectedPath])
        
        //if from Settings Tab bar View.
        if ((settingsControl) != nil){
            self.navigationController?.popViewController(animated: true)
        }
        else{
        self.performSegue(withIdentifier: "step2Identifier", sender: nil)
        }

        
    }
    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func BackAction(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
}
