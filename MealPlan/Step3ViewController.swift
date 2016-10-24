//
//  Step3ViewController.swift
//  DailyMeals
//
//  Created by Jithu on 3/14/16.
//  Copyright © 2016 Meals. All rights reserved.
//
//TO DO COMMENDTS (Add proper comments for all method)
import UIKit

class Step3ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    //var fromController = NSString()
    
    @IBOutlet var backButton : UIButton!
    @IBOutlet var likeFoodListTable : UITableView!
    @IBOutlet var likeFoodLabel : UILabel!
    @IBOutlet weak var likeSearchBar: UISearchBar!
    @IBOutlet var step3NextButton : mpButton!
    @IBOutlet var closeButton : UIButton!
    
    //variable created for constant class
    let profile = DataHandler.getLikeFoods()
    
    //Deafult Value setting
    var likeFoodValue = NSMutableArray()

    
    var localData = DataHandler.readFoodsData("");
    var filterdData:[Food]?
    var resultSearchController = UISearchController()
  
    //For SettingsTab bar
    var settingsControl : Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //To hide close button when app. loads normaly from Profile view.
        closeButton.hidden = true
        
        
        if (settingsControl != nil){
            
            //Close Button whn app. loads from settings view.
            closeButton.hidden = false
            
            let arrayOfObjects = Array(DataHandler.getLikeFoods().foods);
            
            for item in arrayOfObjects{
                likeFoodValue.addObject(item)
            }
          
            
        }
        
        filterdData = localData
        likeFoodListTable.delegate = self
        
        //For Multiselecting the cells in Table
        self.likeFoodListTable.allowsMultipleSelection = true
        
        
        //Attributing likeFoodLabel style fro two font
        let attrsA = [NSFontAttributeName: Constants.FOOD_LABEL_FONT, NSForegroundColorAttributeName:Constants.FOOD_LABEL_COLOR]
        let a = NSMutableAttributedString(string:Constants.THE_FOODS_STRING, attributes:attrsA)
        let attrsB =  [NSFontAttributeName: Constants.FOOD_LABEL_FONT_BOLD, NSForegroundColorAttributeName: Constants.FOOD_LABEL_COLOR]
        let b = NSAttributedString(string:Constants.LIKE_STRING, attributes:attrsB)
        
        a.appendAttributedString(b)
        //likeFoodLabel.attributedText = a
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func closeAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    //MealPlanListTable Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return filterdData!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("step3CellIdentifier", forIndexPath: indexPath) as! Step3TableViewCell
        cell.textLabel?.text = filterdData![indexPath.row].name
        cell.textLabel?.font = Constants.STANDARD_FONT
        
        if(likeFoodValue.containsObject(filterdData![indexPath.row])){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.None
        }  
        return cell
    }
    
    //Selecting Multiple Cells
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if(likeFoodValue.containsObject(filterdData![indexPath.row])){
            likeFoodValue.removeObject(filterdData![indexPath.row])
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }else{
            likeFoodValue.addObject(filterdData![indexPath.row])
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        likeSearchBar.resignFirstResponder()

    }
    
    //DeSelecting Multiple Cells
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        likeSearchBar.resignFirstResponder()
    }
    
    
    
    
    //SearchBar Delegates
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == ""){
            filterdData = localData
            likeSearchBar.resignFirstResponder()
        }else{
            filterdData = localData.filter({
                
                if($0.name.lowercaseString.containsString(searchText.lowercaseString)){
                    return true
                }
                return false
            });
        }
        likeFoodListTable.reloadData();
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        self.likeSearchBar.endEditing(true)
    }


    
    
    //IBAction for NextButton Clicked in Step3 VC. Saving all datas into an ProfileClass.
    @IBAction func step3NextButtonClicked (sender : AnyObject){
        //Saving Values to the Varible Declared for ProfileStep3 constant class.
        // create the alert
//        if (likeFoodValue.count == 0){
//            let alert = UIAlertController(title: "", message: "Select like foods", preferredStyle: UIAlertControllerStyle.Alert)
//            
//            // add an action (button)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
//            
//            // show the alert
//            self.presentViewController(alert, animated: true, completion: nil)
//            return
//
//        }
        
        DataHandler.updateLikeFoods(likeFoodValue)
        
        //if from Settings Tab bar View.
        if ((settingsControl) != nil){
            self.navigationController?.popViewControllerAnimated(true)
        }else{
        self.performSegueWithIdentifier("step3Identifier", sender: nil)
        }


    }
    
    
    //Method for Navigating back to previous ViewController.
    @IBAction func BackAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
}
