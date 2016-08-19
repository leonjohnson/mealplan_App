//
//  Calories&MacrosViewController.swift
//  DailyMeals
//
//  Created by Jithu on 3/17/16.
//  Copyright © 2016 Meals. All rights reserved.
//
//TO DO COMMENDTS (Add proper comments for all method)
import UIKit

class CaloriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var fromController = NSString()
    
    @IBOutlet var caloriesListTable : UITableView!
    @IBOutlet var namelabel : UILabel!
    @IBOutlet var caloriesCountLabel : UILabel!
    @IBOutlet var showMealButton : UIButton!
    @IBOutlet var closeButton : UIButton!
    @IBOutlet var percentToggle: UISegmentedControl!
    
    var thisWeek:Week?
    var nextWeek:Week?
    var settingsControl : Bool? //For SettingsTab bar
    
    var showPercentOnly: Bool?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let futureWeeks = DataHandler.getFutureWeeks()
        
        print("future weeks : \(futureWeeks)")
        
        
        thisWeek = futureWeeks[0]
        nextWeek = futureWeeks[1]
        
        print("Week 1: \(thisWeek)")
        print("Week 2: \(thisWeek)")
        
        
        showPercentOnly = true
        
        
        /*
         
         Check if the week exists. If not, create a week, set calories, and set its meals.
         If the week does exist, retrieve it.
         
         
         */
        
        self.view.backgroundColor = UIColor.groupTableViewBackgroundColor()
        caloriesListTable.delegate = self
        
        // For hiding back button if view loads from TabBar controller:
        if (fromController != "step4Identifier"){
            showMealButton.hidden = true
            closeButton.hidden = true
        }
        
        let attributes = [NSFontAttributeName:Constants.STANDARD_FONT]
        let newAttributes = [NSFontAttributeName:Constants.GENERAL_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE]
        percentToggle.setTitleTextAttributes(attributes, forState: .Normal)
        percentToggle.setTitleTextAttributes(newAttributes, forState: .Selected)
        
        
        //Format the number:
        let largeNumber = thisWeek?.calorieAllowance
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        
        caloriesCountLabel.attributedText = NSMutableAttributedString(string:numberFormatter.stringFromNumber(largeNumber!)! + " calories", attributes:[NSFontAttributeName:Constants.GENERAL_LABEL, NSForegroundColorAttributeName:Constants.MP_BLUE])
        
        
        
      
        // To display Regestered Users name on Meal Plan's page
        // namelabel.text = DataHandler.getActiveUser().name + ", you need"
        
    }
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        caloriesListTable.reloadData()
        
        //To display Regestered Users name on Meal Plan's page
        namelabel.attributedText = NSAttributedString(string:DataHandler.getActiveUser().name.capitalizedString + ", you need ", attributes:[NSFontAttributeName:Constants.GENERAL_LABEL, NSForegroundColorAttributeName:Constants.MP_BLUE])
        
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    //Table Delagte & DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? CaloriesTableViewCell
        if(cell == nil)
        {
            /**
             Dynamic cell creation .
             It Should be changed base on the future scenario
             */
            let macroAttributes = [NSFontAttributeName: Constants.MACRO_LABEL, NSForegroundColorAttributeName:Constants.MP_BLACK]
            let numberAttributes = [NSFontAttributeName: Constants.MACRO_LABEL, NSForegroundColorAttributeName:Constants.MP_GREY]
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,reuseIdentifier:"CellIdentifier")
            
            
            var macroName = ""
            var macroValue = ""
            let macroPercent:Int?
            
            
            switch indexPath.row {
            case 0:
                macroName = (thisWeek?.macroAllocation[0].name)! //carbs
                macroValue = String(Int((thisWeek?.macroAllocation[0].value)!))+"g"
                let a = (thisWeek?.macroAllocation[0].value)! * 4 / Double((thisWeek?.calorieAllowance)!)
                macroPercent = Int(a * 100)
            case 1:
                macroName = (thisWeek?.macroAllocation[1].name)!//proteins
                macroValue = String(Int((thisWeek?.macroAllocation[1].value)!))+"g"
                let a = (thisWeek?.macroAllocation[1].value)! * 4 / Double((thisWeek?.calorieAllowance)!)
                macroPercent = Int(a * 100)
            case 2:
                macroName = (thisWeek?.macroAllocation[2].name)!//fats
                macroValue = String(Int((thisWeek?.macroAllocation[2].value)!))+"g"
                let a = (thisWeek?.macroAllocation[2].value)! * 9 / Double((thisWeek?.calorieAllowance)!)
                macroPercent = Int(a * 100)
            default:
                macroName = "Fats"
                let a = (thisWeek?.macroAllocation[0].value)! * 9 / Double((thisWeek?.calorieAllowance)!)
                macroPercent = Int(a * 100)
            }
            //Dynamic descriptionLabel
            let  descriptionLabel = UILabel()
            descriptionLabel.frame=CGRectMake(15, 18, tableView.frame.width-150, 20)
            descriptionLabel.attributedText = NSMutableAttributedString(string:macroName, attributes:macroAttributes)
            cell.addSubview(descriptionLabel)
            
            //Dynamic gramValueLabel
            let gramValueLabel = UILabel()
            gramValueLabel.frame=CGRectMake( tableView.frame.width-150, 18, 50, 20)
            gramValueLabel.attributedText = NSMutableAttributedString(string:String(macroValue), attributes:numberAttributes)
            cell.addSubview(gramValueLabel)
            gramValueLabel.hidden = showPercentOnly!
            
            //Dynamic percentageValueLabel
            let percentageValueLabel = UILabel()
            //percentageValueLabel.frame=CGRectMake(tableView.frame.width-75,18,50, 20)
            percentageValueLabel.frame = CGRectMake( tableView.frame.width-150, 18, 50, 20)
            percentageValueLabel.attributedText = NSMutableAttributedString(string:String(macroPercent!)+"%", attributes:numberAttributes)
            cell.addSubview(percentageValueLabel)
            percentageValueLabel.hidden = !(showPercentOnly!)

        }
        return cell
        
    }
    
    @IBAction func mealPalnButtonClick(sender: AnyObject){
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let destination = storyboard.instantiateViewControllerWithIdentifier("loggedinTabBar") as! TabBarController
        navigationController?.pushViewController(destination, animated: true)
    
    }
    
//    //Method for Navigating back to previous ViewController.
//    @IBAction func BackAction(sender: AnyObject) {
//        self.navigationController?.popViewControllerAnimated(true)
//    }
    
    @IBAction func closeButtonAction (sender : AnyObject){
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    
    @IBAction func changeUnitOfMacroMeasurement(segmentedControl:UISegmentedControl)
    {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0: // month
            print("changed to %")
            showPercentOnly = true
        case 1: // calender quarter
            print("changed to grams")
            showPercentOnly = false
        default:
            break;
        }
        
        caloriesListTable.reloadData()
    }

    
}
