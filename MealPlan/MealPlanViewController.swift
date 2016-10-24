/*
 Show the date and back and forth buttons
 Load tomorrow when flick forward
 
 */

import UIKit
import RealmSwift

class MealPlanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //For SettingsTab bar
    var settingsControl : Bool?
    
    //@IBOutlet var workOutIcon: UIView!
    @IBOutlet var mealPlanListTable : UITableView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var bkgrd: UIView!
    
    @IBOutlet weak var mealPlanDate: UILabel!
    @IBOutlet weak var backDateButton: UIButton!
    @IBOutlet weak var nextDateButton: UIButton!
    
    var alertController : UIAlertController?
    
    
    
    var dragger:DragToTable?
    var meals :[Meal] = [Meal]()
    var thisWeek: Week = Week()
    var nextWeek: Week = Week()
    
    var dateCount:Int = 0
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        
        thisWeek = DataHandler.getFutureWeeks()[0]
        
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let date1 = calendar.startOfDayForDate(thisWeek.start_date)
        let date2 = calendar.startOfDayForDate(NSDate())
        let flags = NSCalendarUnit.Day
        let components = calendar.components(flags, fromDate: date1, toDate: date2, options: [])
        
        dateCount = components.day
        
        let dateForthisMealPlan = setDate()
        //meals = Array(data.meals)
        
        meals = Array(thisWeek.dailyMeals[dateCount].meals)
        mealPlanListTable.reloadData();
        mealPlanDate.text = dateForthisMealPlan // Monday June 30, 2014 10:42:21am PS
        mealPlanDate.attributedText? = NSAttributedString(string:mealPlanDate.text!, attributes:[NSFontAttributeName:Constants.MEAL_PLAN_DATE, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        
        // Setup the notifications
        //handleNotifivarion()
        //enableLocalNotification()
        //DataStructure.createMealPlans(thisWeek)
        
        //DataHandler.macrosCorrect()
        /*
        alertController = UIAlertController(title: "Title",
                                            message: "Message",
                                            preferredStyle: .ActionSheet)
        
        let tooEarlyAction : UIAlertAction = UIAlertAction(title: "Too early for this",
                                       style: .Default,
                                       handler: {
                                        (paramAction:UIAlertAction!) in
                                        /* do stuff */
        })
        
        let dislikeAction : UIAlertAction = UIAlertAction(title: "Dislike this",
                                       style: .Default,
                                       handler: {
                                        (paramAction:UIAlertAction!) in
                                        /* do stuff */
        })
        
        let cancelAction : UIAlertAction = UIAlertAction(title: "Dislike this",
                                                          style: .Cancel,
                                                          handler: {
                                                            (paramAction:UIAlertAction!) in
                                                            /* do stuff */
        })
        
        alertController?.addAction(tooEarlyAction)
        alertController?.addAction(dislikeAction)
        */
        
        
    }
    
    func setDate() -> (String?) {
        
        /*
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let date1 = calendar.startOfDayForDate(thisWeek.start_date)
        let date2 = calendar.startOfDayForDate(NSDate())
        let flags = NSCalendarUnit.Day
        let components = calendar.components(flags, fromDate: date1, toDate: date2, options: [])
        //let difference = components.day  // This will return the number of day(s) between dates, so I can get today's meal
        */
        
        let components = NSDateComponents()
        
        var index : Int = 0
        if dateCount > 6 && dateCount < 15 {
            index = dateCount - 7
        } else {
            index = dateCount
        }
        components.setValue(index, forComponent: NSCalendarUnit.Day);
        
        
        let dateForthisMealPlan = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: thisWeek.start_date, options: NSCalendarOptions(rawValue: 0))
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        formatter.timeStyle = .NoStyle
        //mealPlanDate.text = formatter.stringFromDate(dateForthisMealPlan!) // Monday June 30, 2014 10:42:21am PS
        
        return formatter.stringFromDate(dateForthisMealPlan!)
    }
    
    @IBAction func changeMealPlanDisplayed(sender: UIButton){
        var index : Int?
        dateCount = dateCount + sender.tag
        
        //Update the mealPlan selected
        if dateCount > 6 && dateCount < 15 {
            //this is week 2
            thisWeek = DataHandler.getFutureWeeks()[1]
            index = dateCount - 7
        }
        
        if (dateCount >= 0) && (dateCount <= 6) {
            //this is week 1
            thisWeek = DataHandler.getFutureWeeks()[0]
            index = dateCount
        }
        
        let dateForthisMealPlan = setDate()
        print("dateForthisMealPlan = \(dateForthisMealPlan)")
        print("dateCount = \(dateCount)")
        
        
        
        //Update the buttons
        if dateCount == 0 {
            backDateButton.userInteractionEnabled = false
            backDateButton.alpha = 0.5
        } else {
            backDateButton.userInteractionEnabled = true
            backDateButton.alpha = 1.0
        }
        
        if (dateCount == 13) && (thisWeek == DataHandler.getFutureWeeks()[1]){
            nextDateButton.userInteractionEnabled = false
            nextDateButton.alpha = 0.5
        } else {
            nextDateButton.userInteractionEnabled = true
            nextDateButton.alpha = 1.0
        }
        
        if dateCount < 0{
            backDateButton.userInteractionEnabled = false
            backDateButton.alpha = 0.5
            return
        }
        
        //Update the UI
        
        mealPlanDate.text = dateForthisMealPlan
        mealPlanDate.attributedText? = NSAttributedString(string:mealPlanDate.text!, attributes:[NSFontAttributeName:Constants.MEAL_PLAN_DATE, NSForegroundColorAttributeName:Constants.MP_WHITE])
        meals = Array(thisWeek.dailyMeals[index!].meals)
        mealPlanListTable.reloadData();
    }
    
    
    
    
    
    
    func handleNotification()
    {
        let notifications =  UIApplication.sharedApplication().scheduledLocalNotifications
        if(notifications?.count > 0)
        {
            // Cancel existing one
            fireNotification();
        }else
        {
            fireNotification();
        }
    }
    
    //For local Notification Alert:
    func enableLocalNotification()
    {
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge , .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    
    func fireNotification(){
        let localNotification = UILocalNotification();
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 60*60*24*7 );
        localNotification.alertTitle = "Share How "
        
        localNotification.alertBody = "Wow its a week again ";
        localNotification.timeZone = NSTimeZone.defaultTimeZone();
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification);
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        
        // ENABLE TO MOVE TO START PAGE
        Config.setBoolValue(Config.HAS_PROFILE,status: true)
        
        super.viewDidLoad()
        mealPlanListTable.delegate = self
        
        //self.workOutIcon.hidden = true
        
        
        
        //Code commented for Tempraory time based on client request.[code for view to drag to each meal plans header]
        //        dragger = DragToTable.activate(workOutIcon, table: mealPlanListTable, view: self.view, listen: { (indexPath) -> Void in
        //
        //            let item =  self.objects[indexPath.section]
        //
        //            if(item.foodItems.last?.food!.pk != 0){
        //
        //                let work = DataHandler.getOrCreateFood(0)
        //
        //                DataHandler.addFoodItemToMeal(item, foodItem:DataHandler.createFoodItem(work, numberServing: 1) )
        //            }
        //        })
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //Constants.LOCALISATION_NEEDED
        
        var stringWithName = DataHandler.getActiveUser().name
        
        if stringWithName.uppercaseString.characters.last == "S"{
            stringWithName = stringWithName + "' meal plan"
        } else{
            stringWithName = stringWithName + "'s meal plan"
        }
        nameLabel.attributedText? = NSAttributedString(string:stringWithName, attributes:[NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_WHITE])
    }
    
    
    
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 70
    }
    
    //MealPlanListTable Delegate Methods
    
    func insertNewObject(sender: AnyObject) {
        
        // Here goes the add button
        
    }
    
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return meals.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (meals[section].foodItems).count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Constants.TABLE_ROW_HEIGHT
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let foodItem : FoodItem = meals[indexPath.section].foodItems[indexPath.row]
        let label =  cell.viewWithTag(102) as? UILabel
        label?.attributedText = NSAttributedString(string: foodItem.food!.name, attributes:[NSFontAttributeName:Constants.MEAL_PLAN_FOODITEM_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        
        if(foodItem.food!.pk == 0){
            cell.backgroundColor =  UIColor(
                red:0.73,
                green:0.76,
                blue:1.0,
                alpha:1.0)
            
            let label2 =  cell.viewWithTag(103) as? UILabel
            label2?.text =  "";
            
            let label3 =  cell.viewWithTag(101) as? UILabel
            label3?.text =  ""
            
        } else {
            cell.backgroundColor = UIColor.clearColor();
            let label2 =  cell.viewWithTag(103) as? UILabel
            
            let q = ServingSize.getServingQuantityAsNumber((foodItem.food?.servingSize)!)
            let servingQuantityAsNumber = roundToPlaces(q, decimalPlaces: 2)
            
            var ending = foodItem.food!.servingSize!.name
            switch ending {
            case Constants.grams:
                ending = "g"
            case Constants.ml:
                ending = "ml"
            case Constants.slice:
                if foodItem.numberServing > 1{
                    ending = " slices"
                } else {
                    ending = " slice"
                }
            case Constants.item:
                ending = " " + (foodItem.food?.name)! + "s"
            default:
                ending = " " + ending
            
            }
            
            let amount = Int(roundToPlaces((foodItem.numberServing * servingQuantityAsNumber), decimalPlaces: 0))
            
            
            
            
            label2?.attributedText = NSAttributedString(string: amount.description + ending, attributes:[NSFontAttributeName:Constants.MEAL_PLAN_SERVINGSIZE_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE]);
            
            let label3 =  cell.viewWithTag(101) as? UILabel
            label3?.attributedText = NSAttributedString(string: Int(foodItem.getTotalCal()).description, attributes:[NSFontAttributeName:Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_WHITE])
            
        }
        
        //cell seprator line programztically:
        let sep = UIView(frame:CGRectMake(0, 1, cell.frame.size.width, 0.5) )
        sep.backgroundColor = UIColor.whiteColor()
        cell.addSubview(sep)
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let fitem = meals[indexPath.section].foodItems[indexPath.row];
            DataHandler.removeFoodItemFromMeal(meals[indexPath.section], index: indexPath.row)
            DataHandler.removeFoodItem(fitem);
            
            /*
            self.presentViewController(alertController!, animated: true, completion: {
                
            })
            */
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData();
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let vheadView = UIView()
        
        vheadView.backgroundColor = UIColor.clearColor()
        
        let  headerCell = UILabel()
        headerCell.frame=CGRectMake(10, 10, tableView.frame.width-30, 20)
        vheadView.addSubview(headerCell)
        headerCell.attributedText = NSAttributedString(string: meals[section].name, attributes: [NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        
        
        //create label inside header view
        let calorieCountLabel = UILabel()
        
        calorieCountLabel.frame = CGRectMake(10, 10, tableView.frame.width-30, 20)
        calorieCountLabel.textAlignment = NSTextAlignment.Right
        calorieCountLabel.textColor = UIColor.whiteColor()
        calorieCountLabel.font = UIFont.systemFontOfSize(17)
        var totalCaloriesString = ""
        if meals[section].totalCalories() > 0 {
            totalCaloriesString = String(Int(meals[section].totalCalories()))
        } else {
            totalCaloriesString = "0"
        }
        
        //totalCaloriesString = Int(meals[section].totalCalories())
        calorieCountLabel.attributedText = NSAttributedString(string: totalCaloriesString + " kcal", attributes: [NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_WHITE])
        
        
        vheadView.addSubview(calorieCountLabel)
        
        //create button inside header view
        let addItemButton = UIButton()
        addItemButton.frame = CGRectMake(10, 25, self.view.frame.size.width - 100, 35)
        //addItemButton.setTitle("Add item + ", forState: UIControlState.Normal)
        addItemButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        
        addItemButton.setAttributedTitle(NSAttributedString(string:"Add item +", attributes:[NSFontAttributeName:Constants.MEAL_PLAN_SUBTITLE, NSForegroundColorAttributeName:Constants.MP_WHITE]), forState: UIControlState.Normal)
        
        
        addItemButton.titleLabel?.textColor = UIColor.whiteColor()
        addItemButton.titleLabel?.textAlignment = NSTextAlignment.Left
        vheadView.addSubview(addItemButton)
        addItemButton.addTarget(self, action: #selector(MealPlanViewController.findFoodSearchAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        //addItemButton.addTarget(self, action: "findFoodSearchAction:", forControlEvents: UIControlEvents.TouchUpInside)
        addItemButton.tag = section
        
        //let sep = UIView(frame:CGRectMake(0, 55, self.view.frame.size.width, 1) )
        //sep.backgroundColor = UIColor.whiteColor()
        //vheadView.addSubview(sep)
        
        return vheadView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    
    
    //IBAction for AddItemButton on Header view
    
    func findFoodSearchAction(sender: UIButton){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let scene = storyboard.instantiateViewControllerWithIdentifier("foodSearchList") as! FoodSearchViewController
        scene.meal = meals[sender.tag]
        
        if((self.navigationController) != nil){
            self.navigationController?.pushViewController(scene, animated: true);
        }else{
            self.presentViewController(scene, animated: true, completion: nil)
        }
        
    }
    // MARK: - Segues
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if let indexPath = self.mealPlanListTable.indexPathForSelectedRow {
            
            let object =   meals[indexPath.section].foodItems[indexPath.row]
            if(object.food!.pk == 0){
                self.mealPlanListTable.deselectRowAtIndexPath(indexPath, animated: true)
                return false
            }
        }
        return true
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.mealPlanListTable.indexPathForSelectedRow {
                self.mealPlanListTable.deselectRowAtIndexPath(indexPath, animated: true)
                let object =   meals[indexPath.section].foodItems[indexPath.row]
                
                
                let controller = segue.destinationViewController as! DetailViewController
                controller.meal = meals[indexPath.section]
                controller.detailItem = object
                //controller.hideAddButton = true
                //   controller.masterView = self
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                // self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }
    
    
    func roundToPlaces(value: Double, decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return round(value * divisor) / divisor
    }
    
    
    
    
}
